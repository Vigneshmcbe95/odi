-- SSC41WH_FST.W310_loaded_variables hat nur noch 1 Zeile (vermutlich
-- durch das Truncate-Skript fuer ORA-01652 versehentlich mitgeleert),
-- SSC43WH_FST.W310_loaded_variables hat die vollstaendigen 1142 Zeilen.
-- Kopiert alle fehlenden Zeilen von SSC43 nach SSC41 (nicht SCR_DWH_FST
-- -- SSC43 ist hier die bessere/vollstaendigere Quelle).

-- 1) Ist-Stand vorher.
SELECT COUNT(*) AS anzahl_vorher FROM SSC41WH_FST.W310_loaded_variables;

-- 2) Kopieren -- nur Zeilen, die in SSC41 noch fehlen (falls die eine
--    verbliebene Zeile bereits existiert, wird sie nicht dupliziert).
INSERT INTO SSC41WH_FST.W310_loaded_variables
  (var_name, var_data_varchar2, var_data_number)
SELECT s43.var_name, s43.var_data_varchar2, s43.var_data_number
FROM SSC43WH_FST.W310_loaded_variables s43
WHERE NOT EXISTS (
        SELECT 1 FROM SSC41WH_FST.W310_loaded_variables s41
        WHERE UPPER(s41.var_name) = UPPER(s43.var_name)
      );

COMMIT;

-- 3) Kontrolle nachher -- sollte jetzt nah an 1142 liegen.
SELECT COUNT(*) AS anzahl_nachher FROM SSC41WH_FST.W310_loaded_variables;

-- 4) Gezielt pruefen, ob die zuletzt fehlenden Variablen jetzt da sind.
SELECT var_name, var_data_number, var_data_varchar2
FROM SSC41WH_FST.W310_loaded_variables
WHERE UPPER(var_name) IN ('STS_KA', 'GEM_KA', 'SGB_TRG_KA');
