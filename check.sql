SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 200

-- Reiner Existenz-Check -- KEIN CREATE, KEIN ALTER, keine Aenderung an der DB.
-- Prueft fuer jede Tabelle aus der vollen Sollliste (siehe Datei "check" --
-- 101 Tabellen fuer SVS41M_STAT_FST laut FST_Tabellen.txt), ob sie
--   a) bereits im Zielschema SVS41M_STAT_FST existiert, und
--   b) in der Quelle SVS43M_STAT_FST existiert (zum Klonen verfuegbar).
-- Gibt fuer jede Tabelle den Status aus. Keine Tabelle wird angelegt/geaendert.

DECLARE
  v_tgt_schema VARCHAR2(128) := 'SVS41M_STAT_FST';
  v_src_schema VARCHAR2(128) := 'SVS43M_STAT_FST';

  TYPE t_table_list IS TABLE OF VARCHAR2(128);
  v_tables t_table_list := t_table_list(
    'TF_FST_BD_KERN','TF_FST_DIM_BST','TF_FST_DIM_LST','TF_FST_EGG','TF_FST_GS_KERN',
    'TF_FST_KGS','TF_FST_KOH_VERBL','TF_FST_MN_ABM','TF_FST_MN_AGH','TF_FST_MN_APS_BETRIEB',
    'TF_FST_MN_APS_BETRIEB_2','TF_FST_MN_APS_BETRIEB_3','TF_FST_MN_APS_PRAEMIE','TF_FST_MN_APS_ZUSCHUSS',
    'TF_FST_MN_AUW','TF_FST_MN_BEB','TF_FST_MN_BNF','TF_FST_MN_BOM','TF_FST_MN_BVB','TF_FST_MN_EMM',
    'TF_FST_MN_FBW','TF_FST_MN_FFSGB2','TF_FST_MN_FIM','TF_FST_MN_GAFA','TF_FST_MN_IRM','TF_FST_MN_ISM',
    'TF_FST_MN_KEL','TF_FST_MN_KERN','TF_FST_MN_LES','TF_FST_MN_MABE','TF_FST_MN_PSA','TF_FST_MN_P37',
    'TF_FST_RE_KERN','TF_FST_TN_ABM','TF_FST_TN_AFLJP','TF_FST_TN_AGH','TF_FST_TN_AH','TF_FST_TN_ASA',
    'TF_FST_TN_AUW','TF_FST_TN_BEB','TF_FST_TN_BEH','TF_FST_TN_BNF','TF_FST_TN_BNF_KORR','TF_FST_TN_BOM',
    'TF_FST_TN_BVB','TF_FST_TN_EGF','TF_FST_TN_EGS','TF_FST_TN_EMM','TF_FST_TN_ESFLZA','TF_FST_TN_ESG',
    'TF_FST_TN_EVL','TF_FST_TN_EXG','TF_FST_TN_FAV','TF_FST_TN_FBW','TF_FST_TN_FF','TF_FST_TN_FFSGB2',
    'TF_FST_TN_FIM','TF_FST_TN_GABE','TF_FST_TN_GAFA','TF_FST_TN_IRM','TF_FST_TN_ISM','TF_FST_TN_KEL',
    'TF_FST_TN_KERN','TF_FST_TN_LES','TF_FST_TN_MABE','TF_FST_TN_MIGHIN','TF_FST_TN_PB','TF_FST_TN_PSA',
    'TF_FST_TN_P37','TF_FST_TN_REHAEF','TF_FST_TN_REHAPRO','TF_FST_TN_SOT','TF_FST_TN_SWL','TF_FST_TN_TAM',
    'TF_FST_TN_VB','TF_FST_TN_VGS','TF_FST_TN_5P','TF_FST_TR_ABM','TF_FST_TR_AFLJP','TF_FST_TR_EMM',
    'TF_FST_TR_FF','TF_FST_TR_ISM','TF_FST_TR_KERN','TF_FST_TR_PSA','TF_FST_TR_P37','TF_FST_TR_SWL',
    'TF_FST_TR_VGS','TF_REHA_SB_VORGAENGE','TG_FST_HOCH_TLN','TG_FST_P48PRS','TT_DM_FST_GEBKONS_STAT',
    'TT_FST_FESTSCHR_AL','TT_FST_FESTSCHR_BGS','TT_FST_FESTSCHR_GS','TT_FST_FESTSCHR_MN','TT_FST_FESTSCHR_PRS',
    'TT_FST_FESTSCHR_RE','TT_FST_FESTSCHR_TN','TT_FST_LST_EIN','TT_FST_RE_ERSTE_FOERD','TT_FST_REGZENS'
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
