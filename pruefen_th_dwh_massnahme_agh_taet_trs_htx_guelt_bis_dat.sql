-- ORA-00904 im W312-Job: SVS41WH_BA_TRS.TH_DWH_MASSNAHME_AGH_TAET_TRS
-- fehlt die Spalte HTX_GUELT_BIS_DAT.

-- 1) Existiert die Spalte im Ziel ueberhaupt?
SELECT column_name, data_type, data_length
FROM dba_tab_columns
WHERE owner = 'SVS41WH_BA_TRS'
      AND table_name = 'TH_DWH_MASSNAHME_AGH_TAET_TRS'
      AND column_name = 'HTX_GUELT_BIS_DAT';

-- 2) Alle Spalten der Zieltabelle zum Vergleich.
SELECT column_name, data_type, data_length
FROM dba_tab_columns
WHERE owner = 'SVS41WH_BA_TRS'
      AND table_name = 'TH_DWH_MASSNAHME_AGH_TAET_TRS'
ORDER BY column_id;

-- 3) Referenz THM_DWH_BA_TRS -- hat die Tabelle dort die Spalte, und
--    mit welchem Datentyp?
SELECT column_name, data_type, data_length
FROM dba_tab_columns
WHERE owner = 'THM_DWH_BA_TRS'
      AND table_name = 'TH_DWH_MASSNAHME_AGH_TAET_TRS'
      AND column_name = 'HTX_GUELT_BIS_DAT';

-- 4) Falls Schritt 3 die Spalte findet -- persistente Tabelle, daher
--    nur Spalte ergaenzen, kein Drop/Recreate (Datentyp aus Schritt 3
--    uebernehmen, hier als Platzhalter DATE angenommen):
-- ALTER TABLE SVS41WH_BA_TRS.TH_DWH_MASSNAHME_AGH_TAET_TRS
--   ADD (HTX_GUELT_BIS_DAT DATE);
