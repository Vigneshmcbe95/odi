-- Behebt ORA-12899: Spalte HDZ_DURCHFUEHRUNGSORT_PLZ ist zu klein
-- (VARCHAR2(15)), tatsaechliche Werte sind bis zu 16 Zeichen lang.

-- 1) Zum Vergleich: Groesse im Referenzschema (falls vorhanden)
SELECT owner, table_name, column_name, data_length
FROM dba_tab_columns
WHERE table_name = 'W346_WRK_HIST_TN_DFZ_TRS'
      AND column_name = 'HDZ_DURCHFUEHRUNGSORT_PLZ'
ORDER BY owner;

-- 2) Spalte vergroessern
ALTER TABLE SSC41WH_FST.W346_WRK_HIST_TN_DFZ_TRS
  MODIFY (HDZ_DURCHFUEHRUNGSORT_PLZ VARCHAR2(30));
