SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 200

-- Reiner Existenz-Check -- KEIN CREATE, KEIN ALTER, keine Aenderung an der DB.
-- Prueft fuer jede Tabelle aus der Sollliste fuer SVS41WH_BA_TRS
-- (laut FST_Tabellen.txt / Datei "check"), ob sie
--   a) bereits im Zielschema SVS41WH_BA_TRS existiert, und
--   b) in der Quelle SVS43WH_BA_TRS existiert (zum Klonen verfuegbar).
-- Gibt fuer jede Tabelle den Status aus. Keine Tabelle wird angelegt/geaendert.

DECLARE
  v_tgt_schema VARCHAR2(128) := 'SVS41WH_BA_TRS';
  v_src_schema VARCHAR2(128) := 'SVS43WH_BA_TRS';

  TYPE t_table_list IS TABLE OF VARCHAR2(128);
  v_tables t_table_list := t_table_list(
    'TD_DWH_BETRIEB',
    'TD_DWH_TRAEGER',
    'TE_FST_AMDL_KURSNET_TRS',
    'TH_DWH_COLIBRI_WBK_TRS',
    'TH_DWH_MASSNAHME_AGH_TAET_TRS',
    'TH_DWH_MASSNAHME_AUW_TRS',
    'TH_DWH_MASSNAHME_BNF_TRS',
    'TH_DWH_MASSNAHME_DFO_TRS',
    'TH_DWH_MASSNAHME_EGF_TRS',
    'TH_DWH_MASSNAHME_FBW_SO_TRS',
    'TH_DWH_MASSNAHME_TRS',
    'TH_DWH_MASSNAHME_VRTG',
    'TH_DWH_TRAEGERBETRIEB_TRS',
    'TH_DWH_TRAEGER_FBW_TRS',
    'TH_DWH_TRAEGER_INIT_TRS',
    'TH_DWH_TRAEGER_TRS'
  );

  v_in_target PLS_INTEGER;
  v_in_source PLS_INTEGER;

  v_ok_cnt      PLS_INTEGER := 0;
  v_missing_cnt PLS_INTEGER := 0;
  v_nosrc_cnt   PLS_INTEGER := 0;

BEGIN
  FOR i IN 1 .. v_tables.COUNT LOOP

    SELECT COUNT(*) INTO v_in_target
    FROM dba_tables
    WHERE owner = v_tgt_schema AND table_name = v_tables(i);

    SELECT COUNT(*) INTO v_in_source
    FROM dba_tables
    WHERE owner = v_src_schema AND table_name = v_tables(i);

    IF v_in_target > 0 THEN
      DBMS_OUTPUT.PUT_LINE('OK (existiert bereits im Ziel):      ' || v_tgt_schema || '.' || v_tables(i));
      v_ok_cnt := v_ok_cnt + 1;
    ELSIF v_in_source > 0 THEN
      DBMS_OUTPUT.PUT_LINE('FEHLT IM ZIEL (in Quelle vorhanden): ' || v_tables(i));
      v_missing_cnt := v_missing_cnt + 1;
    ELSE
      DBMS_OUTPUT.PUT_LINE('NICHT GEFUNDEN (weder Ziel noch Quelle): ' || v_tables(i));
      v_nosrc_cnt := v_nosrc_cnt + 1;
    END IF;

  END LOOP;

  DBMS_OUTPUT.PUT_LINE('=================================================');
  DBMS_OUTPUT.PUT_LINE('Geprueft: ' || v_tables.COUNT
                        || '  |  Im Ziel vorhanden: ' || v_ok_cnt
                        || '  |  Fehlt im Ziel (Quelle vorhanden): ' || v_missing_cnt
                        || '  |  Nirgends gefunden: ' || v_nosrc_cnt);
  DBMS_OUTPUT.PUT_LINE('(Reiner Lesezugriff -- keine Tabelle wurde angelegt oder geaendert.)');
END;
/
