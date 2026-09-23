-- ORA-00904 im W327-Job: TL_DWL_FBWT.TNF_DKZID fehlt.
--
-- WICHTIG: SVS41WL_FST.TL_DWL_FBWT ist ein SYNONYM, keine echte Tabelle
-- (siehe synonyme_erstellen_svs41wl_fst.sql -- SVS41WL_FST zeigt per
-- Synonym auf PSD1_DWL_FST, keine eigene Tabellenkopie noetig laut
-- Thorsten). Die echte Tabelle mit echter Struktur ist also
-- PSD1_DWL_FST.TL_DWL_FBWT -- dort muss geprueft/ergaenzt werden, NICHT
-- auf dem Synonym in SVS41WL_FST (ALTER TABLE auf ein Synonym schlaegt
-- fehl bzw. macht keinen Sinn).

-- 1) Bestaetigen, dass es wirklich ein Synonym ist.
SELECT owner, synonym_name, table_owner, table_name
FROM dba_synonyms
WHERE owner = 'SVS41WL_FST'
      AND synonym_name = 'TL_DWL_FBWT';

-- 2) Existiert die Spalte auf der ECHTEN Tabelle PSD1_DWL_FST?
SELECT column_name, data_type, data_length
FROM dba_tab_columns
WHERE owner = 'PSD1_DWL_FST'
      AND table_name = 'TL_DWL_FBWT'
      AND column_name = 'TNF_DKZID';

-- 3) Alle Spalten der echten Tabelle zum Vergleich.
SELECT column_name, data_type, data_length
FROM dba_tab_columns
WHERE owner = 'PSD1_DWL_FST'
      AND table_name = 'TL_DWL_FBWT'
ORDER BY column_id;

-- 4) Falls die Spalte in PSD1_DWL_FST wirklich fehlt -- HIER (auf der
--    echten Tabelle, nicht dem Synonym) ergaenzen:
-- ALTER TABLE PSD1_DWL_FST.TL_DWL_FBWT
--   ADD (TNF_DKZID VARCHAR2(...));
--
-- Falls die Spalte in PSD1_DWL_FST existiert, aber der Zugriff ueber
-- das Synonym trotzdem fehlschlaegt -- Grant-Problem pruefen (SELECT-
-- Recht auf die neue Spalte/Tabelle fuer SVS41WL_FST fehlt evtl.):
-- GRANT SELECT ON PSD1_DWL_FST.TL_DWL_FBWT TO SVS41WL_FST;
