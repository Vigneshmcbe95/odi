-- ORA-00904 im W327-Job: SVS41WL_FST.TL_DWL_FBWT fehlt die Spalte
-- TNF_DKZID.

-- 1) Existiert die Spalte im Ziel ueberhaupt?
SELECT column_name, data_type, data_length
FROM dba_tab_columns
WHERE owner = 'SVS41WL_FST'
      AND table_name = 'TL_DWL_FBWT'
      AND column_name = 'TNF_DKZID';

-- 2) Alle Spalten der Zieltabelle zum Vergleich.
SELECT column_name, data_type, data_length
FROM dba_tab_columns
WHERE owner = 'SVS41WL_FST'
      AND table_name = 'TL_DWL_FBWT'
ORDER BY column_id;

-- 3) Referenz -- hat THM_DWH_FST (oder das passende WL-Referenzschema)
--    die Tabelle mit der Spalte? SVS41WL_FST ist eine WL (Wirkungslos/
--    Vorlade?)-Schema-Familie, nicht WH -- ggf. anderes Referenzschema
--    noetig als bei den bisherigen Faellen. Erstmal breit suchen:
SELECT owner, table_name, column_name, data_type, data_length
FROM dba_tab_columns
WHERE table_name = 'TL_DWL_FBWT'
      AND column_name = 'TNF_DKZID'
ORDER BY owner;

-- 4) Falls Schritt 3 eine passende Referenz findet -- Spalte gezielt
--    ergaenzen (Datentyp aus Schritt 3 uebernehmen, hier Platzhalter):
-- ALTER TABLE SVS41WL_FST.TL_DWL_FBWT
--   ADD (TNF_DKZID VARCHAR2(...));
