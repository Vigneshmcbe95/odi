SET FEEDBACK ON

-- Generischer, rein lesender Struktur-Vergleich Quelle <-> Ziel.
-- Fuer JEDES Schema-Paar wiederverwendbar -- veraendert NICHTS,
-- nur SELECT. Vor dem (Neu-)Laden einer Tabelle ausfuehren, um alle
-- Struktur-Abweichungen auf einen Blick zu sehen, statt sie erst
-- ueber ORA-01400 / ORA-12899 im Ladeskript zu entdecken.
--
-- Keine SQL*Plus-Substitutionsvariablen (&...) -- manche SQL-Clients
-- (z.B. VS-Code-SQL-Erweiterungen) fragen dann bei JEDEM Vorkommen
-- einzeln nach statt einmal zu substituieren. Stattdessen werden die
-- zwei Werte unten EINMAL in v_schemas eingetragen und ueber einen
-- JOIN im ganzen Skript wiederverwendet.
--
-- >>> HIER FUELLEN (nur diese eine Zeile) <<<
WITH v_schemas AS (
  SELECT 'PSD1_DWH_FST' AS v_source_user, 'SVS41WH_FST' AS v_target_user FROM dual
)

-- Ergebnis-Spalten (eine Zeile pro Abweichung):
--   QUELLE_SCHEMA / ZIEL_SCHEMA -- betroffenes Schema-Paar
--   TABELLE                    -- betroffene Tabelle
--   SPALTE                     -- betroffene Spalte
--   PROBLEM                    -- Art der Abweichung, siehe unten
--   QUELLE_TYP / QUELLE_LAENGE -- Datentyp/Laenge auf der Quellseite
--   ZIEL_TYP   / ZIEL_LAENGE   -- Datentyp/Laenge auf der Zielseite
--   QUELLE_NULLABLE / ZIEL_NULLABLE -- 'Y'=darf NULL sein, 'N'=NOT NULL
--
-- PROBLEM-Werte:
--   ZIEL_ONLY_NOT_NULL  -- Spalte existiert nur im Ziel, ist dort NOT
--                          NULL -- reine 1:1-Kopie schlaegt fehl
--                          (ORA-01400), bis NOT NULL aufgehoben wird.
--   QUELLE_ONLY         -- Spalte existiert nur in der Quelle -- wird
--                          beim Laden ignoriert (informativ).
--   TYP_MISMATCH        -- gemeinsame Spalte, unterschiedlicher
--                          Datentyp (z.B. VARCHAR2 vs. NUMBER).
--   LAENGE_ZU_KLEIN     -- gemeinsame Spalte, Ziel-Laenge kleiner als
--                          Quelle -- schlaegt bei laengeren Werten
--                          fehl (ORA-12899).

SELECT quelle_schema QUELLE_SCHEMA, ziel_schema ZIEL_SCHEMA,
       table_name TABELLE, column_name SPALTE, problem PROBLEM,
       quelle_typ QUELLE_TYP, quelle_laenge QUELLE_LAENGE, quelle_nullable QUELLE_NULLABLE,
       ziel_typ ZIEL_TYP, ziel_laenge ZIEL_LAENGE, ziel_nullable ZIEL_NULLABLE
FROM (

  -- 1) Nur im Ziel vorhanden UND dort NOT NULL
  SELECT v.v_source_user quelle_schema, v.v_target_user ziel_schema,
         tc_t.table_name, tc_t.column_name,
         'ZIEL_ONLY_NOT_NULL' problem,
         null quelle_typ, null quelle_laenge, null quelle_nullable,
         tc_t.data_type ziel_typ,
         case when tc_t.char_length > 0 then tc_t.char_length else tc_t.data_length end ziel_laenge,
         tc_t.nullable ziel_nullable
  FROM v_schemas v
       JOIN dba_tab_columns tc_t ON tc_t.owner = upper(v.v_target_user)
  WHERE tc_t.nullable = 'N'
        AND tc_t.table_name IN (
              SELECT table_name FROM dba_tables WHERE owner = upper(v.v_source_user)
              INTERSECT
              SELECT table_name FROM dba_tables WHERE owner = upper(v.v_target_user)
            )
        AND tc_t.column_name NOT IN (
              SELECT tc_s.column_name FROM dba_tab_columns tc_s
              WHERE tc_s.owner = upper(v.v_source_user)
                    AND tc_s.table_name = tc_t.table_name
            )

  UNION ALL

  -- 2) Nur in der Quelle vorhanden (informativ, wird beim Laden ignoriert)
  SELECT v.v_source_user quelle_schema, v.v_target_user ziel_schema,
         tc_s.table_name, tc_s.column_name,
         'QUELLE_ONLY' problem,
         tc_s.data_type quelle_typ,
         case when tc_s.char_length > 0 then tc_s.char_length else tc_s.data_length end quelle_laenge,
         tc_s.nullable quelle_nullable,
         null ziel_typ, null ziel_laenge, null ziel_nullable
  FROM v_schemas v
       JOIN dba_tab_columns tc_s ON tc_s.owner = upper(v.v_source_user)
  WHERE tc_s.table_name IN (
              SELECT table_name FROM dba_tables WHERE owner = upper(v.v_source_user)
              INTERSECT
              SELECT table_name FROM dba_tables WHERE owner = upper(v.v_target_user)
            )
        AND tc_s.column_name NOT IN (
              SELECT tc_t.column_name FROM dba_tab_columns tc_t
              WHERE tc_t.owner = upper(v.v_target_user)
                    AND tc_t.table_name = tc_s.table_name
            )

  UNION ALL

  -- 3) Gemeinsame Spalten: abweichender Datentyp
  SELECT v.v_source_user quelle_schema, v.v_target_user ziel_schema,
         tc_s.table_name, tc_s.column_name,
         'TYP_MISMATCH' problem,
         tc_s.data_type quelle_typ,
         case when tc_s.char_length > 0 then tc_s.char_length else tc_s.data_length end quelle_laenge,
         tc_s.nullable quelle_nullable,
         tc_t.data_type ziel_typ,
         case when tc_t.char_length > 0 then tc_t.char_length else tc_t.data_length end ziel_laenge,
         tc_t.nullable ziel_nullable
  FROM v_schemas v
       JOIN dba_tab_columns tc_s ON tc_s.owner = upper(v.v_source_user)
       JOIN dba_tab_columns tc_t
         ON tc_t.owner = upper(v.v_target_user)
            AND tc_t.table_name = tc_s.table_name
            AND tc_t.column_name = tc_s.column_name
  WHERE tc_s.data_type != tc_t.data_type

  UNION ALL

  -- 4) Gemeinsame Spalten: Ziel-Laenge kleiner als Quelle
  SELECT v.v_source_user quelle_schema, v.v_target_user ziel_schema,
         tc_s.table_name, tc_s.column_name,
         'LAENGE_ZU_KLEIN' problem,
         tc_s.data_type quelle_typ,
         case when tc_s.char_length > 0 then tc_s.char_length else tc_s.data_length end quelle_laenge,
         tc_s.nullable quelle_nullable,
         tc_t.data_type ziel_typ,
         case when tc_t.char_length > 0 then tc_t.char_length else tc_t.data_length end ziel_laenge,
         tc_t.nullable ziel_nullable
  FROM v_schemas v
       JOIN dba_tab_columns tc_s ON tc_s.owner = upper(v.v_source_user)
       JOIN dba_tab_columns tc_t
         ON tc_t.owner = upper(v.v_target_user)
            AND tc_t.table_name = tc_s.table_name
            AND tc_t.column_name = tc_s.column_name
  WHERE tc_s.data_type = tc_t.data_type
        AND (
              (tc_t.char_length > 0 AND tc_s.char_length > tc_t.char_length)
              OR (tc_t.char_length = 0 AND tc_s.data_length > tc_t.data_length)
            )

)
ORDER BY table_name,
         CASE problem
           WHEN 'ZIEL_ONLY_NOT_NULL' THEN 1
           WHEN 'LAENGE_ZU_KLEIN' THEN 2
           WHEN 'TYP_MISMATCH' THEN 3
           WHEN 'QUELLE_ONLY' THEN 4
         END,
         column_name;
