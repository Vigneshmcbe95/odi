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
      END;
    END IF;

  END LOOP;

  DBMS_OUTPUT.PUT_LINE('=========================================================================');
  DBMS_OUTPUT.PUT_LINE('Alle Tabellen verarbeitet.');
END;
/
