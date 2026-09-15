-- Rein lesend: zaehlt und listet alle Tabellen, die in SSC45WH_FST
-- existieren, aber in SSC41WH_FST fehlen.

-- 1) Anzahl
SELECT COUNT(*) AS anzahl_fehlende_tabellen
FROM dba_tables s
WHERE s.owner = 'SSC45WH_FST'
      AND s.table_name NOT IN (
            SELECT table_name FROM dba_tables WHERE owner = 'SSC41WH_FST'
          );

-- 2) Liste der fehlenden Tabellennamen
SELECT s.table_name
FROM dba_tables s
WHERE s.owner = 'SSC45WH_FST'
      AND s.table_name NOT IN (
            SELECT table_name FROM dba_tables WHERE owner = 'SSC41WH_FST'
          )
ORDER BY s.table_name;
