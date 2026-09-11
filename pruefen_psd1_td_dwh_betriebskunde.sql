-- Rein lesend: prueft die Quelle des Synonyms selbst.

-- 1) Existiert PSD1_DWH_BA_TRS.TD_DWH_BETRIEBSKUNDE ueberhaupt?
SELECT owner, table_name
FROM dba_tables
WHERE owner = 'PSD1_DWH_BA_TRS'
      AND table_name = 'TD_DWH_BETRIEBSKUNDE';

-- 2) Falls ja: hat odi_bsg_default SELECT-Recht darauf? (0 Zeilen =
--    genau das erklaert den ORA-00942 trotz vorhandenem Synonym.)
SELECT grantee, privilege
FROM dba_tab_privs
WHERE table_name = 'TD_DWH_BETRIEBSKUNDE'
      AND owner = 'PSD1_DWH_BA_TRS'
      AND grantee = 'ODI_BSG_DEFAULT';
