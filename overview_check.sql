-- Uebersicht als Tabelle (kein DBMS_OUTPUT) -- direkt exportierbar.
-- Reiner Lesezugriff -- keine Aenderung an der DB.
--
-- ANLEITUNG:
--   1. Unten bei tables_to_check die Tabellenliste eintragen (eine pro Zeile).
--   2. Die drei Schema-Namen (v_source1, v_source2, v_target) unten anpassen.
--   3. Ausfuehren, Ergebnis-Grid exportieren (Rechtsklick -> Export / Save as CSV).

WITH
params AS (
  SELECT
    'QUELLE_1_SCHEMA' AS v_source1,   -- <<< HIER ersetzen, z.B. 'PSD1_DWH_FST'
    'QUELLE_2_SCHEMA' AS v_source2,   -- <<< HIER ersetzen, z.B. 'THM_DWH_STAT_FST'
    'SVS41WH_STAT_BA_TRS' AS v_target -- <<< HIER ersetzen
  FROM dual
),
tables_to_check (table_name) AS (
  SELECT 'TABELLE1' FROM dual UNION ALL
  SELECT 'TABELLE2' FROM dual UNION ALL
  SELECT 'TABELLE3' FROM dual
  -- <<< HIER weitere Tabellennamen als eigene Zeile ergaenzen:
  -- SELECT 'TABELLEN' FROM dual UNION ALL
)
SELECT
  t.table_name,

  CASE WHEN s1.table_name IS NOT NULL THEN 'JA' ELSE 'NEIN' END AS in_quelle_1,
  CASE WHEN s2.table_name IS NOT NULL THEN 'JA' ELSE 'NEIN' END AS in_quelle_2,
  CASE WHEN tg.table_name IS NOT NULL THEN 'JA' ELSE 'NEIN' END AS in_ziel,

  COALESCE(tg.partitioned, s1.partitioned, s2.partitioned) AS partitioniert,

  CASE WHEN tg_idx.idx_cnt > 0 THEN 'JA (' || tg_idx.idx_cnt || ')' ELSE 'NEIN' END AS indiziert_im_ziel,
  CASE WHEN tg_pk.pk_cnt  > 0 THEN 'JA' ELSE 'NEIN' END AS primary_key_im_ziel,

  tg_part.part_cnt AS anzahl_partitionen_ziel

FROM tables_to_check t
CROSS JOIN params p

LEFT JOIN dba_tables s1
       ON s1.owner = p.v_source1 AND s1.table_name = t.table_name
LEFT JOIN dba_tables s2
       ON s2.owner = p.v_source2 AND s2.table_name = t.table_name
LEFT JOIN dba_tables tg
       ON tg.owner = p.v_target AND tg.table_name = t.table_name

LEFT JOIN (
  SELECT owner, table_name, COUNT(*) AS idx_cnt
  FROM dba_indexes
  GROUP BY owner, table_name
) tg_idx
       ON tg_idx.owner = p.v_target AND tg_idx.table_name = t.table_name

LEFT JOIN (
  SELECT owner, table_name, COUNT(*) AS pk_cnt
  FROM dba_constraints
  WHERE constraint_type = 'P'
  GROUP BY owner, table_name
) tg_pk
       ON tg_pk.owner = p.v_target AND tg_pk.table_name = t.table_name

LEFT JOIN (
  SELECT table_owner, table_name, COUNT(*) AS part_cnt
  FROM dba_tab_partitions
  GROUP BY table_owner, table_name
) tg_part
       ON tg_part.table_owner = p.v_target AND tg_part.table_name = t.table_name

ORDER BY t.table_name;
