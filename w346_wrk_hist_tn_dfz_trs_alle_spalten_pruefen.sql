-- Rein lesend: vergleicht ALLE Spalten von W346_WRK_HIST_TN_DFZ_TRS
-- zwischen SSC41WH_FST (Ziel) und SSC45WH_FST (Referenz) auf einmal --
-- statt Spalte fuer Spalte einzeln ueber ORA-12899 zu stolpern.
SELECT z.column_name,
       z.data_type AS ziel_typ, z.data_length AS ziel_laenge,
       r.data_type AS referenz_typ, r.data_length AS referenz_laenge
FROM dba_tab_columns z
     LEFT JOIN dba_tab_columns r
       ON r.owner = 'SSC45WH_FST'
          AND r.table_name = 'W346_WRK_HIST_TN_DFZ_TRS'
          AND r.column_name = z.column_name
WHERE z.owner = 'SSC41WH_FST'
      AND z.table_name = 'W346_WRK_HIST_TN_DFZ_TRS'
      AND (r.data_length IS NULL OR z.data_length < r.data_length)
ORDER BY z.column_id;
