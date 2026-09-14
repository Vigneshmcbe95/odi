-- Rein lesend: prueft, welche der beiden beteiligten Tabellen fehlt --
-- Ziel (SSC41WH_FST.W346_TH_DWH_MN_DFO_TRS) oder Quelle
-- (SVS41WH_BA_TRS.TH_DWH_MASSNAHME_DFO_TRS).

SELECT 'ZIEL' AS rolle, owner, table_name
FROM dba_tables
WHERE owner = 'SSC41WH_FST' AND table_name = 'W346_TH_DWH_MN_DFO_TRS'

UNION ALL

SELECT 'QUELLE', owner, table_name
FROM dba_tables
WHERE owner = 'SVS41WH_BA_TRS' AND table_name = 'TH_DWH_MASSNAHME_DFO_TRS';

-- Falls eine der beiden Zeilen NICHT zurueckkommt, existiert diese
-- Tabelle nicht im erwarteten Schema -- dort weitersuchen, wo sie
-- stattdessen liegt:
SELECT owner, table_name
FROM dba_tables
WHERE table_name IN ('W346_TH_DWH_MN_DFO_TRS', 'TH_DWH_MASSNAHME_DFO_TRS')
ORDER BY table_name, owner;
