-- Fuegt die fehlende Spalte MMZ_ID zu SVS41WH_FST.TH_DWH_TEILNAHME_MAT
-- hinzu -- existiert bereits im Referenzschema SVS45WH_FST. Kein
-- DROP/CREATE, da diese Tabelle persistent ist und bereits echte
-- Daten aus frueheren erfolgreichen Laeufen enthalten kann.

-- 1) Exakte Definition aus dem Referenzschema pruefen (Typ/Laenge)
SELECT data_type, data_length, nullable
FROM dba_tab_columns
WHERE owner = 'SVS45WH_FST'
      AND table_name = 'TH_DWH_TEILNAHME_MAT'
      AND column_name = 'MMZ_ID';

-- 2) Spalte hinzufuegen (Typ/Laenge ggf. an Ergebnis aus Abfrage 1
--    anpassen -- MMZ_ID sieht nach einer ID-Spalte aus, daher NUMBER
--    angenommen)
ALTER TABLE SVS41WH_FST.TH_DWH_TEILNAHME_MAT
  ADD (MMZ_ID NUMBER);
