-- Fuegt die fehlenden Spalten MMZ_ID und TMM_ID zu
-- SVS41WH_FST.TH_DWH_TEILNAHME_MAT hinzu -- beide existieren bereits
-- im Referenzschema SVS45WH_FST, fehlen aber in SVS41WH_FST. Kein
-- DROP/CREATE, da diese Tabelle persistent ist und bereits echte
-- Daten aus frueheren erfolgreichen Laeufen enthalten kann.

-- 1) Exakte Definitionen aus dem Referenzschema pruefen (Typ/Laenge)
SELECT column_name, data_type, data_length, nullable
FROM dba_tab_columns
WHERE owner = 'SVS45WH_FST'
      AND table_name = 'TH_DWH_TEILNAHME_MAT'
      AND column_name IN ('MMZ_ID', 'TMM_ID');

-- 2) Beide Spalten hinzufuegen (beides NUMBER, laut Referenzschema)
ALTER TABLE SVS41WH_FST.TH_DWH_TEILNAHME_MAT
  ADD (MMZ_ID NUMBER, TMM_ID NUMBER);
