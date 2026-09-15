-- Rein lesend: findet ALLE Tabellen in JEDEM SVS41*-Schema, die
-- HDZ_DURCHFUEHRUNGSORT_STRHSNR oder HDZ_DURCHFUEHRUNGSORT_PLZ
-- besitzen, mit aktueller Spaltenlaenge.

SELECT owner, table_name, column_name, data_length
FROM dba_tab_columns
WHERE owner LIKE 'SVS41%'
      AND column_name IN ('HDZ_DURCHFUEHRUNGSORT_STRHSNR', 'HDZ_DURCHFUEHRUNGSORT_PLZ')
ORDER BY owner, table_name, column_name;

-- Anzahl betroffener Tabellen (je Spalte getrennt gezaehlt)
SELECT column_name, COUNT(*) AS anzahl_tabellen
FROM dba_tab_columns
WHERE owner LIKE 'SVS41%'
      AND column_name IN ('HDZ_DURCHFUEHRUNGSORT_STRHSNR', 'HDZ_DURCHFUEHRUNGSORT_PLZ')
GROUP BY column_name;
