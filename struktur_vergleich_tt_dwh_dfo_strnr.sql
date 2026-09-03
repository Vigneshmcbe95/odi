-- Einfacher, rein lesender Struktur-Vergleich NUR fuer
-- SVS41WH_STAT_BA_TRS.TT_DWH_DFO_STRNR gegen die Quelle. Zeigt alle
-- Spalten aus Quelle und Ziel nebeneinander -- wo eine Seite leer ist,
-- existiert die Spalte dort nicht.
--
-- >>> HIER FUELLEN <<<
WITH quelle AS (
  SELECT column_name, data_type, data_length, nullable
  FROM dba_tab_columns
  WHERE owner = 'PSD1_DWH_STAT_BA_TRS'
        AND table_name = 'TT_DWH_DFO_STRNR'
),
ziel AS (
  SELECT column_name, data_type, data_length, nullable
  FROM dba_tab_columns
  WHERE owner = 'SVS41WH_STAT_BA_TRS'
        AND table_name = 'TT_DWH_DFO_STRNR'
)
SELECT NVL(q.column_name, z.column_name) AS spalte,
       q.data_type AS quelle_typ, q.data_length AS quelle_laenge, q.nullable AS quelle_nullable,
       z.data_type AS ziel_typ, z.data_length AS ziel_laenge, z.nullable AS ziel_nullable
FROM quelle q
     FULL JOIN ziel z ON z.column_name = q.column_name
ORDER BY 1;
