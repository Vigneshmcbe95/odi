SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET LONG 100000
SET LINESIZE 200

-- Skript: Tabellenstrukturen (inkl. Primary Keys und Indizes) von
-- SSC43WH_FST nach SSC41WH_FST anlegen.
--
-- WICHTIG (Ursache des ORA-00922 bei Tabellen mit Primary Key):
-- DBMS_METADATA.GET_DDL('TABLE', ...) liefert bei Tabellen mit Primary Key
-- NICHT nur das CREATE TABLE, sondern zusaetzlich ein separates
-- "ALTER TABLE ... ADD PRIMARY KEY ... USING INDEX ENABLE" -- beides in
-- einem CLOB, durch ';' getrennt. Die fruehere Loesung (SQLTERMINATOR=FALSE)
-- entfernte genau diese Trennzeichen und verschmolz beide Anweisungen zu
-- einer ungueltigen Anweisung.
-- Fix: SQLTERMINATOR bleibt AN (Standard), der CLOB wird an jedem ';' in
-- einzelne Anweisungen zerlegt, und jede Anweisung wird EINZELN ausgefuehrt.
-- Zusaetzlich: separate Indizes (nicht Teil eines Primary/Unique Key)
-- werden in einem zweiten Durchlauf ebenfalls geklont.

DECLARE
  v_src_schema VARCHAR2(128) := 'SSC43WH_FST';
  v_tgt_schema VARCHAR2(128) := 'SSC41WH_FST';

  v_ddl          CLOB;
  v_exists_cnt   PLS_INTEGER;

  v_created_cnt  PLS_INTEGER := 0;
  v_skipped_cnt  PLS_INTEGER := 0;
  v_failed_cnt   PLS_INTEGER := 0;

  v_idx_created_cnt PLS_INTEGER := 0;
  v_idx_skipped_cnt PLS_INTEGER := 0;
  v_idx_failed_cnt  PLS_INTEGER := 0;

  PROCEDURE print_clob(p_clob CLOB) IS
    v_len   PLS_INTEGER := DBMS_LOB.GETLENGTH(p_clob);
    v_pos   PLS_INTEGER := 1;
    v_chunk PLS_INTEGER := 250;
  BEGIN
    WHILE v_pos <= v_len LOOP
      DBMS_OUTPUT.PUT_LINE(DBMS_LOB.SUBSTR(p_clob, v_chunk, v_pos));
      v_pos := v_pos + v_chunk;
    END LOOP;
  END print_clob;

  -- Zerlegt einen CLOB mit mehreren ';'-getrennten Anweisungen und fuehrt
  -- jede einzeln aus (ein Fehler stoppt nicht die naechste Anweisung).
  PROCEDURE run_statements(p_ddl CLOB, p_label VARCHAR2,
                            p_ok_cnt IN OUT PLS_INTEGER,
                            p_fail_cnt IN OUT PLS_INTEGER) IS
    v_len     PLS_INTEGER := DBMS_LOB.GETLENGTH(p_ddl);
    v_start   PLS_INTEGER := 1;
    v_semipos PLS_INTEGER;
    v_stmt    VARCHAR2(32000);
  BEGIN
    LOOP
      v_semipos := DBMS_LOB.INSTR(p_ddl, ';', v_start);
      EXIT WHEN v_semipos = 0;

      v_stmt := TRIM(DBMS_LOB.SUBSTR(p_ddl, v_semipos - v_start, v_start));
      v_start := v_semipos + 1;

      IF v_stmt IS NOT NULL THEN
        BEGIN
          EXECUTE IMMEDIATE v_stmt;
          DBMS_OUTPUT.PUT_LINE('  OK :: ' || SUBSTR(v_stmt, 1, 90));
          p_ok_cnt := p_ok_cnt + 1;
        EXCEPTION
          WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('  TEILFEHLER (' || p_label || '): ' || SQLERRM);
            DBMS_OUTPUT.PUT_LINE('  Anweisung: ' || v_stmt);
            p_fail_cnt := p_fail_cnt + 1;
        END;
      END IF;
    END LOOP;

    IF v_start <= v_len THEN
      v_stmt := TRIM(DBMS_LOB.SUBSTR(p_ddl, v_len - v_start + 1, v_start));
      IF v_stmt IS NOT NULL THEN
        BEGIN
          EXECUTE IMMEDIATE v_stmt;
          DBMS_OUTPUT.PUT_LINE('  OK :: ' || SUBSTR(v_stmt, 1, 90));
          p_ok_cnt := p_ok_cnt + 1;
        EXCEPTION
          WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('  TEILFEHLER (' || p_label || '): ' || SQLERRM);
            DBMS_OUTPUT.PUT_LINE('  Anweisung: ' || v_stmt);
            p_fail_cnt := p_fail_cnt + 1;
        END;
      END IF;
    END IF;
  END run_statements;

BEGIN
  DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM, 'STORAGE', FALSE);
  DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM, 'SEGMENT_ATTRIBUTES', FALSE);
  DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM, 'TABLESPACE', FALSE);
  DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM, 'SQLTERMINATOR', TRUE);  -- bewusst AN
  DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM, 'PRETTY', TRUE);
  -- CONSTRAINTS bleibt auf Standard (TRUE) -- Primary/Unique Keys werden mitgeklont

  -- ===== Durchlauf 1: Tabellen (inkl. Primary/Unique Key Constraints) =====
  FOR t IN (
    SELECT table_name
    FROM all_tables
    WHERE owner = v_src_schema
      AND (iot_type IS NULL OR iot_type != 'IOT_OVERFLOW')
      AND nested = 'NO'
      AND secondary = 'N'
    ORDER BY table_name
  ) LOOP

    SELECT COUNT(*) INTO v_exists_cnt
    FROM all_tables
    WHERE owner = v_tgt_schema AND table_name = t.table_name;

    IF v_exists_cnt > 0 THEN
      DBMS_OUTPUT.PUT_LINE('SKIP (existiert bereits): ' || t.table_name);
      v_skipped_cnt := v_skipped_cnt + 1;
      CONTINUE;
    END IF;

    DBMS_OUTPUT.PUT_LINE('=================================================');
    DBMS_OUTPUT.PUT_LINE('Erstelle: ' || t.table_name);

    BEGIN
      v_ddl := DBMS_METADATA.GET_DDL('TABLE', t.table_name, v_src_schema);
      v_ddl := REPLACE(v_ddl, v_src_schema, v_tgt_schema);

      run_statements(v_ddl, t.table_name, v_created_cnt, v_failed_cnt);

    EXCEPTION
      WHEN OTHERS THEN
        v_failed_cnt := v_failed_cnt + 1;
        DBMS_OUTPUT.PUT_LINE('FEHLER (GET_DDL) :: ' || t.table_name || ' - ' || SQLERRM);
        IF v_ddl IS NOT NULL THEN
          print_clob(v_ddl);
        END IF;
    END;

  END LOOP;

  -- ===== Durchlauf 2: Indizes, die NICHT zu einem Primary/Unique Key gehoeren =====
  FOR ix IN (
    SELECT DISTINCT i.index_name, i.table_name
    FROM dba_indexes i
    WHERE i.owner = v_src_schema
      AND i.table_owner = v_src_schema
      AND EXISTS (SELECT 1 FROM dba_tables tt WHERE tt.owner = v_tgt_schema AND tt.table_name = i.table_name)
      AND NOT EXISTS (
        SELECT 1 FROM dba_constraints c
        WHERE c.owner = v_src_schema
          AND c.index_name = i.index_name
          AND c.constraint_type IN ('P', 'U')
      )
    ORDER BY i.table_name, i.index_name
  ) LOOP

    SELECT COUNT(*) INTO v_exists_cnt
    FROM dba_indexes
    WHERE owner = v_tgt_schema AND index_name = ix.index_name;

    IF v_exists_cnt > 0 THEN
      DBMS_OUTPUT.PUT_LINE('SKIP INDEX (existiert bereits): ' || ix.index_name);
      v_idx_skipped_cnt := v_idx_skipped_cnt + 1;
      CONTINUE;
    END IF;

    BEGIN
      v_ddl := DBMS_METADATA.GET_DDL('INDEX', ix.index_name, v_src_schema);
      v_ddl := REPLACE(v_ddl, v_src_schema, v_tgt_schema);

      run_statements(v_ddl, ix.index_name, v_idx_created_cnt, v_idx_failed_cnt);

    EXCEPTION
      WHEN OTHERS THEN
        v_idx_failed_cnt := v_idx_failed_cnt + 1;
        DBMS_OUTPUT.PUT_LINE('FEHLER (INDEX) :: ' || ix.index_name || ' - ' || SQLERRM);
    END;

  END LOOP;

  DBMS_OUTPUT.PUT_LINE('=================================================');
  DBMS_OUTPUT.PUT_LINE('Tabellen  -- erfolgreiche Anweisungen: ' || v_created_cnt
                        || ', uebersprungen (Tabelle existierte bereits): ' || v_skipped_cnt
                        || ', fehlgeschlagene Anweisungen: ' || v_failed_cnt);
  DBMS_OUTPUT.PUT_LINE('Indizes   -- erstellt: ' || v_idx_created_cnt
                        || ', uebersprungen: ' || v_idx_skipped_cnt
                        || ', fehlgeschlagen: ' || v_idx_failed_cnt);
END;
/
