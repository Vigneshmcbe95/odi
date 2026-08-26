SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET LONG 100000
SET LINESIZE 200

-- Erstellt NUR die unten gelistete, gezielte Tabellenmenge (inkl. Primary
-- Keys und Indizes) in SVS41M_STAT_FST, geklont aus SVS43M_STAT_FST
-- (nicht das ganze Schema).
--
-- WICHTIG (Ursache des ORA-00922 bei Tabellen mit Primary Key):
-- DBMS_METADATA.GET_DDL('TABLE', ...) liefert bei Tabellen mit Primary Key
-- NICHT nur das CREATE TABLE, sondern zusaetzlich ein separates
-- "ALTER TABLE ... ADD PRIMARY KEY ... USING INDEX ENABLE" -- beides in
-- einem CLOB, durch ';' getrennt. Fix: SQLTERMINATOR bleibt AN, der CLOB
-- wird an jedem ';' in einzelne Anweisungen zerlegt, jede wird EINZELN
-- ausgefuehrt. Zusaetzlich werden separate Indizes (nicht Teil eines
-- Primary/Unique Key) fuer dieselben Tabellen mitgeklont.

DECLARE
  v_src_schema VARCHAR2(128) := 'SVS43M_STAT_FST';
  v_tgt_schema VARCHAR2(128) := 'SVS41M_STAT_FST';

  v_ddl          CLOB;
  v_exists_cnt   PLS_INTEGER;

  v_created_cnt  PLS_INTEGER := 0;
  v_skipped_cnt  PLS_INTEGER := 0;
  v_failed_cnt   PLS_INTEGER := 0;

  v_idx_created_cnt PLS_INTEGER := 0;
  v_idx_skipped_cnt PLS_INTEGER := 0;
  v_idx_failed_cnt  PLS_INTEGER := 0;

  -- Nur diese Tabellen werden angelegt -- strikt begrenzt
  TYPE t_table_list IS TABLE OF VARCHAR2(128);
  v_tables t_table_list := t_table_list(
    'TF_FST_KGS',
    'TF_FST_KOH_VERBL',
    'TT_DM_FST_GEBKONS_STAT',
    'TT_FST_FESTSCHR_BGS',
    'TT_FST_LST_EIN',
    'TT_FST_REGZENS'
  );

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
  FOR i IN 1 .. v_tables.COUNT LOOP

    SELECT COUNT(*) INTO v_exists_cnt
    FROM all_tables
    WHERE owner = v_src_schema AND table_name = v_tables(i);

    IF v_exists_cnt = 0 THEN
      DBMS_OUTPUT.PUT_LINE('WARNUNG (nicht in Quelle gefunden): ' || v_tables(i));
      CONTINUE;
    END IF;

    SELECT COUNT(*) INTO v_exists_cnt
    FROM all_tables
    WHERE owner = v_tgt_schema AND table_name = v_tables(i);

    IF v_exists_cnt > 0 THEN
      DBMS_OUTPUT.PUT_LINE('SKIP (existiert bereits): ' || v_tables(i));
      v_skipped_cnt := v_skipped_cnt + 1;
      CONTINUE;
    END IF;

    DBMS_OUTPUT.PUT_LINE('=================================================');
    DBMS_OUTPUT.PUT_LINE('Erstelle: ' || v_tables(i));

    BEGIN
      v_ddl := DBMS_METADATA.GET_DDL('TABLE', v_tables(i), v_src_schema);
      v_ddl := REPLACE(v_ddl, v_src_schema, v_tgt_schema);

      run_statements(v_ddl, v_tables(i), v_created_cnt, v_failed_cnt);

    EXCEPTION
      WHEN OTHERS THEN
        v_failed_cnt := v_failed_cnt + 1;
        DBMS_OUTPUT.PUT_LINE('FEHLER (GET_DDL) :: ' || v_tables(i) || ' - ' || SQLERRM);
        IF v_ddl IS NOT NULL THEN
          print_clob(v_ddl);
        END IF;
    END;

  END LOOP;

  -- ===== Durchlauf 2: Indizes, die NICHT zu einem Primary/Unique Key gehoeren =====
  -- (nur fuer die oben gelisteten Tabellen -- pro Tabelle einzeln abgefragt,
  --  da ein lokal deklarierter Collection-Typ (v_tables) nicht per TABLE()
  --  in einer SQL-Anweisung verwendet werden darf: PLS-00642)
  FOR i IN 1 .. v_tables.COUNT LOOP

    FOR ix IN (
      SELECT DISTINCT idx.index_name
      FROM dba_indexes idx
      WHERE idx.owner = v_src_schema
        AND idx.table_owner = v_src_schema
        AND idx.table_name = v_tables(i)
        AND EXISTS (SELECT 1 FROM dba_tables tt WHERE tt.owner = v_tgt_schema AND tt.table_name = idx.table_name)
        AND NOT EXISTS (
          SELECT 1 FROM dba_constraints c
          WHERE c.owner = v_src_schema
            AND c.index_name = idx.index_name
            AND c.constraint_type IN ('P', 'U')
        )
      ORDER BY idx.index_name
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
