-- Rein lesend: prueft, welche der drei beteiligten Tabellen fehlt.
SELECT 'ZIEL' AS rolle, owner, table_name
FROM dba_tables
WHERE owner = 'SSC41WH_FST' AND table_name = 'W301_TMP_TRG_VORH'

UNION ALL

SELECT 'QUELLE_1', owner, table_name
FROM dba_tables
WHERE owner = 'SSC41WH_FST' AND table_name = 'W301_WRK_LOAD_MN_KERN_9189'

UNION ALL

SELECT 'QUELLE_2', owner, table_name
FROM dba_tables
WHERE owner = 'SVS41WH_BA_TRS' AND table_name = 'TD_DWH_TRAEGER';

-- Falls eine Zeile fehlt, wo existiert diese Tabelle stattdessen?
SELECT owner, table_name
FROM dba_tables
WHERE table_name IN ('W301_TMP_TRG_VORH', 'W301_WRK_LOAD_MN_KERN_9189', 'TD_DWH_TRAEGER')
ORDER BY table_name, owner;
