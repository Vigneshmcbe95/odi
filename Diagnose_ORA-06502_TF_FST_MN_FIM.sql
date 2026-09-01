-- Vergleicht Spaltendefinitionen zwischen Quelle und Ziel fuer TF_FST_MN_FIM,
-- um die Spalte zu finden, die den ORA-06502 (numeric or value error) beim
-- INSERT ... SELECT verursacht (zu kleine Praezision/Laenge im Ziel).
SELECT
    s.column_name,
    s.data_type          AS quelle_typ,
    s.data_length        AS quelle_laenge,
    s.data_precision      AS quelle_precision,
    s.data_scale          AS quelle_scale,
    t.data_type          AS ziel_typ,
    t.data_length         AS ziel_laenge,
    t.data_precision       AS ziel_precision,
    t.data_scale           AS ziel_scale
FROM dba_tab_columns s
JOIN dba_tab_columns t
  ON t.owner = 'SVS41M_STAT_FST'
 AND t.table_name = s.table_name
 AND t.column_name = s.column_name
WHERE s.owner = 'PSD1_DM_STAT_FST'
  AND s.table_name = 'TF_FST_MN_FIM'
  AND (
       NVL(s.data_precision, 0) > NVL(t.data_precision, 999)
    OR NVL(s.data_length, 0)    > NVL(t.data_length, 999999)
    OR NVL(s.data_scale, 0)     > NVL(t.data_scale, 999)
  )
ORDER BY s.column_name;

-- Falls die obige Abfrage nichts findet (Typen sehen gleich aus), pruefe
-- stattdessen den tatsaechlichen Datenwert, der nicht passt - z.B. per
-- Bisektion der MON_ID-Werte oder direktem Vergleich MAX()/MIN() je
-- numerischer Spalte zwischen Quelle und Ziel-Praezision.
