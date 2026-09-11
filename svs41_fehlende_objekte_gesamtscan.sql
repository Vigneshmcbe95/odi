-- Rein lesend: findet ALLE Tabellen UND Views, die im 43er-Referenz-
-- Schema existieren, aber im entsprechenden 41er (B05) Zielschema
-- fehlen -- statt einzelne fehlende Objekte einzeln zu entdecken,
-- wenn wieder ein Job fehlschlaegt.
--
-- Schema-Zuordnung 43 -> 41 unten anpassen, falls weitere
-- Zielschemata dazukommen.

WITH schema_paare AS (
  SELECT 'SVS43WH_FST'          AS quelle, 'SVS41WH_FST'          AS ziel FROM dual UNION ALL
  SELECT 'SVS43WH_BA_TRS',            'SVS41WH_BA_TRS'            FROM dual UNION ALL
  SELECT 'SVS43WH_STAT_FST',          'SVS41WH_STAT_FST'          FROM dual UNION ALL
  SELECT 'SVS43WH_STAT_BA_TRS',       'SVS41WH_STAT_BA_TRS'       FROM dual UNION ALL
  SELECT 'SVS43M_STAT_FST',           'SVS41M_STAT_FST'           FROM dual
)
-- 1) Fehlende TABELLEN
SELECT sp.ziel AS ziel_schema, 'TABELLE' AS objekt_typ, t.table_name AS objekt_name
FROM schema_paare sp
     JOIN dba_tables t ON t.owner = sp.quelle
WHERE t.table_name NOT IN (
        SELECT table_name FROM dba_tables WHERE owner = sp.ziel
      )
      AND t.table_name NOT LIKE '%OLD'
      AND t.table_name NOT LIKE '%SAV'
      AND t.table_name NOT LIKE '%SICH'

UNION ALL

-- 2) Fehlende VIEWS
SELECT sp.ziel, 'VIEW', v.view_name
FROM schema_paare sp
     JOIN dba_views v ON v.owner = sp.quelle
WHERE v.view_name NOT IN (
        SELECT view_name FROM dba_views WHERE owner = sp.ziel
      )

ORDER BY 1, 2, 3;
