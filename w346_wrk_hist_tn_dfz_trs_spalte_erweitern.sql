-- Behebt ORA-12899: Spalte HDZ_DURCHFUEHRUNGSORT_STRHSNR ist zu klein
-- (VARCHAR2(30)), tatsaechliche Werte sind bis zu 31 Zeichen lang.

-- 1) Zum Vergleich: wie gross ist die Spalte im Referenzschema (z.B.
--    SSC45WH_FST), falls dort die gleiche Tabelle existiert?
SELECT owner, table_name, column_name, data_length
FROM dba_tab_columns
WHERE table_name = 'W346_WRK_HIST_TN_DFZ_TRS'
      AND column_name = 'HDZ_DURCHFUEHRUNGSORT_STRHSNR'
ORDER BY owner;

-- 2) Spalte vergroessern (Ziel-Laenge ggf. an Ergebnis aus Abfrage 1
--    anpassen -- hier grosszuegig auf 50 gesetzt, um kuenftige aehnlich
--    lange Werte ebenfalls abzudecken).
ALTER TABLE SSC41WH_FST.W346_WRK_HIST_TN_DFZ_TRS
  MODIFY (HDZ_DURCHFUEHRUNGSORT_STRHSNR VARCHAR2(50));
