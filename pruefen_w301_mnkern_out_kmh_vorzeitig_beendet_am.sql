-- ORA-00904 im W301-Job: SSC41WH_FST.W301_MNKERN_OUT (Alias H) fehlt die
-- Spalte KMH_VORZEITIG_BEENDET_AM. Scratch-Tabelle -- eigentlich schon
-- durch ssc41wh_fst_alle_tabellen_neu_klonen_scr_dwh_fst.sql abgedeckt,
-- falls dieses Skript bereits gelaufen ist. Hier isoliert pruefen.

-- 1) Existiert die Spalte im Ziel ueberhaupt?
SELECT column_name, data_type, data_length
FROM dba_tab_columns
WHERE owner = 'SSC41WH_FST'
      AND table_name = 'W301_MNKERN_OUT'
      AND column_name = 'KMH_VORZEITIG_BEENDET_AM';

-- 2) Alle Spalten der Zieltabelle zum Vergleich.
SELECT column_name, data_type, data_length
FROM dba_tab_columns
WHERE owner = 'SSC41WH_FST'
      AND table_name = 'W301_MNKERN_OUT'
ORDER BY column_id;

-- 3) Referenz SCR_DWH_FST -- hat die Tabelle dort die Spalte?
SELECT column_name, data_type, data_length
FROM dba_tab_columns
WHERE owner = 'SCR_DWH_FST'
      AND table_name = 'W301_MNKERN_OUT'
      AND column_name = 'KMH_VORZEITIG_BEENDET_AM';

-- 4) Falls die Spalte in SCR_DWH_FST existiert und nur im Ziel fehlt --
--    gezielter Spalten-Add (persistente Erweiterung, kein Datenverlust):
-- ALTER TABLE SSC41WH_FST.W301_MNKERN_OUT
--   ADD (KMH_VORZEITIG_BEENDET_AM DATE);
-- (Datentyp vor Ausfuehrung gegen Abfrage 3 prüfen -- ggf. abweichend.)
