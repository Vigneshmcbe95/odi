-- 1) Ist SVS41WL_FST.TL_DWL_MATT ueberhaupt ein Synonym (wie es fuer
--    das ganze Schema sein sollte), oder eine echte Tabelle?
SELECT owner, object_name, object_type
FROM dba_objects
WHERE owner = 'SVS41WL_FST'
      AND object_name = 'TL_DWL_MATT';

-- 2) Falls Synonym: worauf zeigt es?
SELECT owner, synonym_name, table_owner, table_name
FROM dba_synonyms
WHERE owner = 'SVS41WL_FST'
      AND synonym_name = 'TL_DWL_MATT';

-- 3) Existiert MAT_TEILNAHMEMODUS in der echten Quelle
--    (PSD1_DWL_FST.TL_DWL_MATT)?
SELECT owner, table_name, column_name, data_type, data_length
FROM dba_tab_columns
WHERE owner = 'PSD1_DWL_FST'
      AND table_name = 'TL_DWL_MATT'
      AND column_name = 'MAT_TEILNAHMEMODUS';

-- 4) Falls SVS41WL_FST.TL_DWL_MATT tatsaechlich eine ECHTE Tabelle
--    ist (kein Synonym) -- vergleich der Spalten gegen die Quelle:
SELECT column_name
FROM dba_tab_columns
WHERE owner = 'PSD1_DWL_FST' AND table_name = 'TL_DWL_MATT'
MINUS
SELECT column_name
FROM dba_tab_columns
WHERE owner = 'SVS41WL_FST' AND table_name = 'TL_DWL_MATT';
