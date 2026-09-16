-- 1) Existiert MMZ_ID ueberhaupt in SVS41WH_FST.TH_DWH_TEILNAHME_MAT?
SELECT owner, table_name, column_name, data_type, data_length
FROM dba_tab_columns
WHERE owner = 'SVS41WH_FST'
      AND table_name = 'TH_DWH_TEILNAHME_MAT'
      AND column_name = 'MMZ_ID';

-- 2) Ist SVS41WH_FST.TH_DWH_TEILNAHME_MAT eine echte Tabelle oder ein
--    Synonym?
SELECT owner, object_name, object_type
FROM dba_objects
WHERE owner = 'SVS41WH_FST'
      AND object_name = 'TH_DWH_TEILNAHME_MAT';

-- 3) Referenzschema (z.B. SVS45WH_FST oder SVS43WH_FST) zum
--    Vergleich, falls die Spalte in SVS41 wirklich fehlt.
SELECT owner, table_name, column_name, data_type, data_length
FROM dba_tab_columns
WHERE owner IN ('SVS43WH_FST','SVS44WH_FST','SVS45WH_FST')
      AND table_name = 'TH_DWH_TEILNAHME_MAT'
      AND column_name = 'MMZ_ID';
