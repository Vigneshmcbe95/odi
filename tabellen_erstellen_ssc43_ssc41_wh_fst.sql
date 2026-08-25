SET SERVEROUTPUT ON

-- Skript: Tabellenstrukturen von SSC43WH_FST nach SSC41WH_FST anlegen
-- Ziel-Schema ist aktuell leer -- Struktur wird 1:1 vom bestehenden
-- Schema 43 uebernommen (DBMS_METADATA.GET_DDL), nur der Schema-Name
-- wird im generierten DDL-Text umgesetzt.
--
-- Speicher-/Tablespace-Klauseln werden bewusst entfernt: das Zielschema
-- hat sein eigenes Standard-Tablespace, und Storage-Angaben sollen laut
-- Konvention ohnehin nie hartcodiert werden (nur Partitionierung bleibt
-- explizit erhalten).

DECLARE
  v_ddl     CLOB;
  v_exists  NUMBER;
  v_len     NUMBER;
  v_pos     NUMBER;
  v_chunk   NUMBER := 2000;

  -- Gibt eine CLOB in mehreren Zeilen aus (dbms_output.put_line begrenzt
  -- die Zeilenlaenge, daher Aufteilung in handhabbare Stuecke)
  PROCEDURE print_clob(p_clob CLOB) IS
    v_len  NUMBER := DBMS_LOB.GETLENGTH(p_clob);
    v_pos  NUMBER := 1;
  BEGIN
    WHILE v_pos <= v_len LOOP
      DBMS_OUTPUT.PUT_LINE(DBMS_LOB.SUBSTR(p_clob, v_chunk, v_pos));
      v_pos := v_pos + v_chunk;
    END LOOP;
  END;
BEGIN
  DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM, 'STORAGE', FALSE);
  DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM, 'SEGMENT_ATTRIBUTES', FALSE);
  DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM, 'TABLESPACE', FALSE);

  FOR t IN (
    SELECT table_name
    FROM dba_tables
    WHERE owner = 'SSC43WH_FST'
    ORDER BY table_name
  ) LOOP

    DBMS_OUTPUT.PUT_LINE('=========================================================================');

    -- Pruefen, ob die Tabelle im Zielschema schon existiert
    SELECT COUNT(*) INTO v_exists
    FROM dba_tables
    WHERE owner = 'SSC41WH_FST'
          AND table_name = t.table_name;

    IF v_exists > 0 THEN
      DBMS_OUTPUT.PUT_LINE('UEBERSPRUNGEN :: ' || t.table_name || ' existiert bereits im Zielschema.');
    ELSE
      -- DDL fuer diese Tabelle erzeugen und Schema-Namen auf Ziel umsetzen
      v_ddl := DBMS_METADATA.GET_DDL('TABLE', t.table_name, 'SSC43WH_FST');
      v_ddl := REPLACE(v_ddl, 'SSC43WH_FST', 'SSC41WH_FST');

      DBMS_OUTPUT.PUT_LINE('Erstelle Tabelle: SSC41WH_FST.' || t.table_name);

      BEGIN
        EXECUTE IMMEDIATE v_ddl;
        DBMS_OUTPUT.PUT_LINE('OK :: ' || t.table_name || ' erstellt.');
      EXCEPTION
        WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE('FEHLER :: ' || t.table_name || ' -> ' || SQLERRM);
          DBMS_OUTPUT.PUT_LINE('--- generiertes DDL zur Fehlersuche ---');
          print_clob(v_ddl);
          DBMS_OUTPUT.PUT_LINE('--- Ende DDL ---');
      END;
    END IF;

  END LOOP;

  DBMS_OUTPUT.PUT_LINE('=========================================================================');
  DBMS_OUTPUT.PUT_LINE('Alle Tabellen verarbeitet.');
END;
/
