-- ORA-01476 im W103-Job (W103_TMP_HIST_TRAEGER). Acht moegliche
-- Variablen im Spiel: ORT_KA, TAT_KA, TAT_KZM, TFL_KA, TFL_KZM,
-- A93_KA, A93_KZM, TBR_KZM. Gleiches Muster wie bei W301/W302/W305/
-- W310 -- W103_loaded_variables vermutlich (teilweise) leer, weil die
-- zentrale Konfigurationstabelle FST_VOR_INPUT_KM_TABLE erst kuerzlich
-- nachgezogen wurde und der W103_000_SET_LOCAL_VARIABLES-Job seitdem
-- noch nicht (erfolgreich) gelaufen ist.

-- 1) Welche der acht Variablen fehlen komplett in W103_loaded_variables?
SELECT 'ORT_KA' AS var_name, COUNT(*) AS anzahl FROM SSC41WH_FST.W103_loaded_variables WHERE UPPER(var_name)='ORT_KA'
UNION ALL SELECT 'TAT_KA', COUNT(*) FROM SSC41WH_FST.W103_loaded_variables WHERE UPPER(var_name)='TAT_KA'
UNION ALL SELECT 'TAT_KZM', COUNT(*) FROM SSC41WH_FST.W103_loaded_variables WHERE UPPER(var_name)='TAT_KZM'
UNION ALL SELECT 'TFL_KA', COUNT(*) FROM SSC41WH_FST.W103_loaded_variables WHERE UPPER(var_name)='TFL_KA'
UNION ALL SELECT 'TFL_KZM', COUNT(*) FROM SSC41WH_FST.W103_loaded_variables WHERE UPPER(var_name)='TFL_KZM'
UNION ALL SELECT 'A93_KA', COUNT(*) FROM SSC41WH_FST.W103_loaded_variables WHERE UPPER(var_name)='A93_KA'
UNION ALL SELECT 'A93_KZM', COUNT(*) FROM SSC41WH_FST.W103_loaded_variables WHERE UPPER(var_name)='A93_KZM'
UNION ALL SELECT 'TBR_KZM', COUNT(*) FROM SSC41WH_FST.W103_loaded_variables WHERE UPPER(var_name)='TBR_KZM';

-- 2) Fuer die fehlenden: existieren sie im Quellkonfig
--    FST_VOR_INPUT_KM_TABLE (SVS41), und mit welchem VARIABLE_TYPE?
SELECT variable_id, variable_name, variable_type, variable_data_type, variable_script_kurz
FROM SVS41WH_FST.FST_VOR_INPUT_KM_TABLE
WHERE UPPER(variable_name) IN ('ORT_KA','TAT_KA','TAT_KZM','TFL_KA','TFL_KZM','A93_KA','A93_KZM','TBR_KZM')
      AND (UPPER(variable_script_kurz) = 'W103' OR UPPER(variable_script_kurz) = 'ALL')
ORDER BY variable_name;

-- 3) Gesamtvergleich: fehlt W103_loaded_variables komplett/teilweise
--    gegen die Referenz (SCR_DWH_FST)?
SELECT COUNT(*) AS anzahl_ssc41 FROM SSC41WH_FST.W103_loaded_variables;
SELECT COUNT(*) AS anzahl_scr FROM SCR_DWH_FST.W103_loaded_variables;

-- 4) Falls das _000_SET_LOCAL_VARIABLES-Package fuer W103 nicht
--    existiert/nicht greift: alle fehlenden Variablen aus SCR_DWH_FST
--    nachziehen (Workaround, kein Ersatz fuer den Job).
INSERT INTO SSC41WH_FST.W103_loaded_variables
  (var_name, var_data_varchar2, var_data_number)
SELECT scr.var_name, scr.var_data_varchar2, scr.var_data_number
FROM SCR_DWH_FST.W103_loaded_variables scr
WHERE NOT EXISTS (
        SELECT 1 FROM SSC41WH_FST.W103_loaded_variables ssc
        WHERE UPPER(ssc.var_name) = UPPER(scr.var_name)
      );

COMMIT;
