-- Rein lesend: findet ALLE Tabellen in SSC41WH_FST/SVS41WH_FST, bei
-- denen eine *_DURCHFUEHRUNGSORT_STRHSNR- oder *_DURCHFUEHRUNGSORT_PLZ-
-- Spalte (Praefix variiert je Tabelle: HDZ_, HMD_, TDZ_, ...) kleiner
-- ist als die gleichnamige Spalte im 45er-Referenzschema.

SELECT z.owner, z.table_name, z.column_name,
       z.data_length AS ziel_laenge, r.data_length AS referenz_laenge
FROM dba_tab_columns z
     JOIN dba_tab_columns r
       ON r.owner = REPLACE(z.owner, '41', '45')
          AND r.table_name = z.table_name
          AND r.column_name = z.column_name
WHERE z.owner IN ('SSC41WH_FST', 'SVS41WH_FST')
      AND (z.column_name LIKE '%DURCHFUEHRUNGSORT_STRHSNR'
           OR z.column_name LIKE '%DURCHFUEHRUNGSORT_PLZ')
      AND z.data_length < r.data_length
ORDER BY z.owner, z.table_name, z.column_name;

-- Anzahl betroffener Spalten insgesamt
SELECT COUNT(*) AS anzahl_betroffener_spalten
FROM dba_tab_columns z
     JOIN dba_tab_columns r
       ON r.owner = REPLACE(z.owner, '41', '45')
          AND r.table_name = z.table_name
          AND r.column_name = z.column_name
WHERE z.owner IN ('SSC41WH_FST', 'SVS41WH_FST')
      AND (z.column_name LIKE '%DURCHFUEHRUNGSORT_STRHSNR'
           OR z.column_name LIKE '%DURCHFUEHRUNGSORT_PLZ')
      AND z.data_length < r.data_length;
