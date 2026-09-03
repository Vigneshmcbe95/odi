-- Rein lesend: zeigt den tatsaechlichen Wertebereich (MIN/MAX/Anzahl
-- distinct Werte) von MON_ID in der QUELLE fuer TL_DWL_50PA -- Vergleich
-- mit den aktuell im Ziel vorhandenen Partitionsgrenzen
-- (svs41wl_fst_50pa_partitionen_pruefen.sql), um zu sehen, ob der
-- Partitions-Aufbau tatsaechlich vorzeitig abgebrochen ist.
SELECT MIN(mon_id) AS kleinster_wert,
       MAX(mon_id) AS groesster_wert,
       COUNT(DISTINCT mon_id) AS anzahl_distinct_werte,
       COUNT(*) AS gesamt_zeilen
FROM PSD1_DWL_FST.TL_DWL_50PA;
