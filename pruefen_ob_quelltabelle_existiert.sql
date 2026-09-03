-- Prueft, ob die Quelltabelle ueberhaupt existiert, und falls ja,
-- welche Spalten sie tatsaechlich hat.
SELECT owner, table_name
FROM dba_tables
WHERE table_name = 'TT_DWH_DFO_STRNR';

-- Falls die Tabelle existiert: alle ihre Spalten anzeigen (egal unter
-- welchem Schema/Owner).
SELECT owner, column_name, data_type, data_length, nullable
FROM dba_tab_columns
WHERE table_name = 'TT_DWH_DFO_STRNR'
ORDER BY owner, column_id;
