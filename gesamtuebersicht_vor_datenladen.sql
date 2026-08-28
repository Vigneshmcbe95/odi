-- Gesamtuebersicht ALLER 13 Zielschemata (B05/Sandbox 41), vor Beginn des
-- Datenladens. Reiner Lesezugriff -- keine Aenderung an der DB.
--
-- Ergebnis ist EINE Tabelle (Result-Grid) -> direkt als CSV exportieren
-- (Rechtsklick auf Ergebnis -> Export/Save as CSV).
--
-- Deckt sowohl Schemata mit bekannter Tabellenliste (Ziel spiegelt die
-- Liste bereits, taucht also automatisch auf) als auch Schemata ohne
-- Liste ab (komplette Quelle wurde geklont -- Quelle taucht automatisch
-- auf, auch wenn im Ziel noch nicht angelegt).

WITH
schema_pairs (target_schema, source_schema) AS (
  SELECT 'SSC41LL_FST',         'SSC43LL_FST'         FROM dual UNION ALL
  SELECT 'SSC41M_STAT_FST',     'SSC43M_STAT_FST'     FROM dual UNION ALL
  SELECT 'SSC41WH_FST',         'SSC43WH_FST'         FROM dual UNION ALL
  SELECT 'SSC41WH_STAT_FST',    'SSC43WH_STAT_FST'    FROM dual UNION ALL
  SELECT 'SVS41LL_FST',         'SVS43LL_FST'         FROM dual UNION ALL
  SELECT 'SVS41M_STAT_FST',     'SVS43M_STAT_FST'     FROM dual UNION ALL
  SELECT 'SVS41WH_BA_TRS',      'SVS43WH_BA_TRS'      FROM dual UNION ALL
  SELECT 'SVS41WH_FST',         'SVS43WH_FST'         FROM dual UNION ALL
  SELECT 'SVS41WH_STAT_BA_TRS', 'SVS43WH_STAT_BA_TRS' FROM dual UNION ALL
  SELECT 'SVS41WH_STAT_FST',    'SVS43WH_STAT_FST'    FROM dual UNION ALL
  SELECT 'SVS41WH_UEB_DIM',     'SVS43WH_UEB_DIM'     FROM dual UNION ALL
  SELECT 'SVS41WL_FST',         'SVS43WL_FST'         FROM dual UNION ALL
  SELECT 'SVS41EB_ODIKM',       'SVS43EB_ODIKM'       FROM dual
),
all_relevant_tables AS (
  -- Tabellen, die im Ziel bereits existieren
  SELECT sp.target_schema, sp.source_schema, t.table_name
  FROM schema_pairs sp
  JOIN dba_tables t ON t.owner = sp.target_schema
  UNION
  -- Tabellen, die (noch) nur in der Quelle existieren
  SELECT sp.target_schema, sp.source_schema, t.table_name
  FROM schema_pairs sp
  JOIN dba_tables t ON t.owner = sp.source_schema
)
SELECT
  art.target_schema        AS ziel_schema,
  art.source_schema         AS quell_schema_43,
  art.table_name,

  CASE WHEN src.table_name IS NOT NULL THEN 'JA' ELSE 'NEIN' END AS existiert_in_quelle,
  CASE WHEN tgt.table_name IS NOT NULL THEN 'JA' ELSE 'NEIN' END AS existiert_im_ziel,

  src.partitioned                                     AS partitioniert_quelle,
  tgt.partitioned                                     AS partitioniert_ziel,
  CASE WHEN src.table_name IS NOT NULL AND tgt.table_name IS NOT NULL
            AND NVL(src.partitioned,'X') != NVL(tgt.partitioned,'X')
       THEN 'ABWEICHUNG' ELSE '' END                  AS partition_abweichung,

  NVL(src_idx.idx_cnt, 0)                             AS indizes_quelle,
  NVL(tgt_idx.idx_cnt, 0)                             AS indizes_ziel,
  CASE WHEN src.table_name IS NOT NULL AND tgt.table_name IS NOT NULL
            AND NVL(src_idx.idx_cnt,0) != NVL(tgt_idx.idx_cnt,0)
       THEN 'ABWEICHUNG' ELSE '' END                  AS index_abweichung,

  CASE WHEN src_pk.pk_cnt > 0 THEN 'JA' ELSE 'NEIN' END AS primary_key_quelle,
  CASE WHEN tgt_pk.pk_cnt > 0 THEN 'JA' ELSE 'NEIN' END AS primary_key_ziel

FROM all_relevant_tables art

LEFT JOIN dba_tables src
       ON src.owner = art.source_schema AND src.table_name = art.table_name
LEFT JOIN dba_tables tgt
       ON tgt.owner = art.target_schema AND tgt.table_name = art.table_name

LEFT JOIN (
  SELECT owner, table_name, COUNT(*) AS idx_cnt
  FROM dba_indexes
  GROUP BY owner, table_name
) src_idx
       ON src_idx.owner = art.source_schema AND src_idx.table_name = art.table_name

LEFT JOIN (
  SELECT owner, table_name, COUNT(*) AS idx_cnt
  FROM dba_indexes
  GROUP BY owner, table_name
) tgt_idx
       ON tgt_idx.owner = art.target_schema AND tgt_idx.table_name = art.table_name

LEFT JOIN (
  SELECT owner, table_name, COUNT(*) AS pk_cnt
  FROM dba_constraints
  WHERE constraint_type = 'P'
  GROUP BY owner, table_name
) src_pk
       ON src_pk.owner = art.source_schema AND src_pk.table_name = art.table_name

LEFT JOIN (
  SELECT owner, table_name, COUNT(*) AS pk_cnt
  FROM dba_constraints
  WHERE constraint_type = 'P'
  GROUP BY owner, table_name
) tgt_pk
       ON tgt_pk.owner = art.target_schema AND tgt_pk.table_name = art.table_name

ORDER BY art.target_schema, art.table_name;
