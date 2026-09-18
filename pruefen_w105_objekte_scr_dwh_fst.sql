-- ORA-00942 beim Insert in SSC41WH_FST.W105_TMP_BAK_LOAD.
-- Statement liest aus SSC41WH_FST.W105_WRK_LOAD_COSACHNT_KUNDE und
-- SVS41WH_BA_TRS.TD_DWH_BA_KUNDE -- eines der drei Objekte fehlt in B05.
--
-- Laut Thorsten (Chat mit Joern, 2026-09-18): Tabellen aus SVN/SVS44
-- sind nicht immer aktuell/passend zu R01 -- die richtige Referenz ist
-- SCR_DWH_FST. Dieses Skript prueft zuerst, welches der drei Objekte
-- in B05 fehlt, und vergleicht dann gegen SCR_DWH_FST statt SVS44.

-- 1) Existiert das Zielobjekt selbst?
SELECT owner, object_name, object_type, status
FROM dba_objects
WHERE owner = 'SSC41WH_FST'
      AND object_name = 'W105_TMP_BAK_LOAD';

-- 2) Existiert die Quelltabelle (Arbeitstabelle aus vorherigem Schritt)?
SELECT owner, object_name, object_type, status
FROM dba_objects
WHERE owner = 'SSC41WH_FST'
      AND object_name = 'W105_WRK_LOAD_COSACHNT_KUNDE';

-- 3) Existiert die zweite Quelltabelle?
SELECT owner, object_name, object_type, status
FROM dba_objects
WHERE owner = 'SVS41WH_BA_TRS'
      AND object_name = 'TD_DWH_BA_KUNDE';

-- 4) Referenzstruktur in SCR_DWH_FST nachschlagen (statt SVS44/SVN) --
--    fuer jedes der drei Objekte, das oben als fehlend markiert ist.
SELECT owner, object_name, object_type, status
FROM dba_objects
WHERE owner = 'SCR_DWH_FST'
      AND object_name IN ('W105_TMP_BAK_LOAD', 'W105_WRK_LOAD_COSACHNT_KUNDE');

SELECT owner, object_name, object_type, status
FROM dba_objects
WHERE object_name = 'TD_DWH_BA_KUNDE';
