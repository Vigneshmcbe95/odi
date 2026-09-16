-- Prueft, ob die Zieltabelle selbst die Spalte MAT_TEILNAHMEMODUS
-- ueberhaupt hat -- der Fehler ORA-00904 nennt nur den Spaltennamen,
-- nicht ob er auf der INSERT- oder SELECT-Seite fehlt.
SELECT owner, table_name, column_name, data_type, data_length
FROM dba_tab_columns
WHERE owner = 'SSC41WH_FST'
      AND table_name = 'W309_WRK_MAT_TN_PRELADETAB'
      AND column_name = 'MAT_TEILNAHMEMODUS';

-- Zum Vergleich: alle Spalten der Zieltabelle, um zu sehen, ob es die
-- Spalte vielleicht unter leicht anderem Namen gibt (Tippfehler,
-- Abweichung).
SELECT column_name, data_type, data_length
FROM dba_tab_columns
WHERE owner = 'SSC41WH_FST'
      AND table_name = 'W309_WRK_MAT_TN_PRELADETAB'
ORDER BY column_id;
