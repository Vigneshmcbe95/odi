-- Kompletter Spaltenvergleich Quelle vs. Ziel fuer TF_FST_MN_FIM, ohne
-- automatischen Filter (der urspruengliche Filter behandelte unbeschraenkte
-- NUMBER-Spalten in der Quelle - data_precision IS NULL, bis zu 38 Stellen -
-- faelschlich als Praezision 0 und fand deshalb nie einen Unterschied).
-- Bitte das komplette Ergebnis pruefen: gesucht wird eine Spalte, bei der
-- die Quelle mehr Stellen/Laenge zulaesst als das Ziel.
SELECT
    s.column_name,
    s.data_type          AS quelle_typ,
    s.data_length        AS quelle_laenge,
    s.data_precision      AS quelle_precision,
    s.data_scale           AS quelle_scale,
    s.nullable             AS quelle_nullable,
    t.data_type            AS ziel_typ,
    t.data_length           AS ziel_laenge,
    t.data_precision          AS ziel_precision,
    t.data_scale               AS ziel_scale,
    t.nullable                  AS ziel_nullable
FROM dba_tab_columns s
JOIN dba_tab_columns t
  ON t.owner = 'SVS41M_STAT_FST'
 AND t.table_name = s.table_name
 AND t.column_name = s.column_name
WHERE s.owner = 'PSD1_DM_STAT_FST'
  AND s.table_name = 'TF_FST_MN_FIM'
ORDER BY s.column_name;

-- Zusaetzlich pruefen: Spalten, die in der Quelle existieren, aber im Ziel
-- FEHLEN (dann wuerde v_col_names sie ausschliessen - kein Absturzgrund,
-- aber gut zur Vollstaendigkeitspruefung) bzw. umgekehrt.
SELECT column_name FROM dba_tab_columns
WHERE owner = 'PSD1_DM_STAT_FST' AND table_name = 'TF_FST_MN_FIM'
MINUS
SELECT column_name FROM dba_tab_columns
WHERE owner = 'SVS41M_STAT_FST' AND table_name = 'TF_FST_MN_FIM';
