-- Joern (an Nils): BSN_KA wird beim Befuellen von W305_loaded_variables
-- nicht mitgenommen, weil sie nicht den Typ CONSTANT hat. Prueft, ob
-- das ein echtes Datenproblem in THM_DWH_FST ist (dann muesste Thorsten/
-- das Team es dort korrigieren) oder nur in SVS41 durch unseren Kopier-
-- vorgang falsch angekommen ist.

SELECT 'SVS41WH_FST' AS schema, variable_id, variable_name, variable_type, variable_data_type
FROM SVS41WH_FST.FST_VOR_INPUT_KM_TABLE
WHERE UPPER(variable_name) = 'BSN_KA'
UNION ALL
SELECT 'THM_DWH_FST', variable_id, variable_name, variable_type, variable_data_type
FROM THM_DWH_FST.FST_VOR_INPUT_KM_TABLE
WHERE UPPER(variable_name) = 'BSN_KA';
