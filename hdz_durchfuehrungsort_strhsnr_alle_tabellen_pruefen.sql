-- Behebt ORA-12899 auf W346_TH_DWH_TN_DFZ_TRS (gleiche Spalte, andere
-- Tabelle als vorher -- W346_WRK_HIST_TN_DFZ_TRS und W346_TH_DWH_TN_DFZ_TRS
-- teilen sich offenbar dieselbe zu kleine Spaltendefinition).

ALTER TABLE SSC41WH_FST.W346_TH_DWH_TN_DFZ_TRS
  MODIFY (HDZ_DURCHFUEHRUNGSORT_STRHSNR VARCHAR2(50));

-- Rein lesend: findet ALLE Tabellen in SSC41WH_FST/SVS41WH_FST, die
-- eine Spalte HDZ_DURCHFUEHRUNGSORT_STRHSNR haben, die kleiner ist
-- als die gleichnamige Spalte im Referenzschema (SSC45WH_FST) --
-- statt das Problem Tabelle fuer Tabelle einzeln zu entdecken.
SELECT z.owner, z.table_name, z.data_length AS ziel_laenge,
       r.data_length AS referenz_laenge
FROM dba_tab_columns z
     JOIN dba_tab_columns r
       ON r.owner = 'SSC45WH_FST'
          AND r.table_name = z.table_name
          AND r.column_name = z.column_name
WHERE z.owner IN ('SSC41WH_FST', 'SVS41WH_FST')
      AND z.column_name = 'HDZ_DURCHFUEHRUNGSORT_STRHSNR'
      AND z.data_length < r.data_length
ORDER BY z.owner, z.table_name;
