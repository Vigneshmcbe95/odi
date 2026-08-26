SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 200

-- Reiner Existenz-Check -- KEIN CREATE, KEIN ALTER, keine Aenderung an der DB.
-- Prueft fuer jede Tabelle in der Liste unten, ob sie IRGENDWO in der
-- Datenbank existiert (alle Schemata), und gibt jeden Fundort aus.
-- Existiert eine Tabelle nirgends, wird sie als "NOT FOUND" markiert.

DECLARE
  TYPE t_table_list IS TABLE OF VARCHAR2(128);
  v_tables t_table_list := t_table_list(
    'TF_FST_KGS',
    'TF_FST_KOH_VERBL',
    'TT_DM_FST_GEBKONS_STAT',
    'TT_FST_FESTSCHR_BGS',
    'TT_FST_LST_EIN',
    'TT_FST_REGZENS'
  );

  v_found_cnt PLS_INTEGER;
BEGIN
  FOR i IN 1 .. v_tables.COUNT LOOP

    v_found_cnt := 0;

    DBMS_OUTPUT.PUT_LINE('=================================================');
    DBMS_OUTPUT.PUT_LINE('Pruefe: ' || v_tables(i));

    FOR r IN (
      SELECT owner, table_name
      FROM dba_tables
      WHERE table_name = v_tables(i)
      ORDER BY owner
    ) LOOP
      DBMS_OUTPUT.PUT_LINE('  GEFUNDEN in Schema: ' || r.owner || '.' || r.table_name);
      v_found_cnt := v_found_cnt + 1;
    END LOOP;

    IF v_found_cnt = 0 THEN
      DBMS_OUTPUT.PUT_LINE('  NOT FOUND: ' || v_tables(i) || ' existiert in keinem Schema.');
    END IF;

  END LOOP;

  DBMS_OUTPUT.PUT_LINE('=================================================');
  DBMS_OUTPUT.PUT_LINE('Pruefung abgeschlossen (nur Lesezugriff, keine Aenderung).');
END;
/
