-- ORA-01476 im W310_TH_DWH_TEILNAHME_INS-Job. Acht moegliche Variablen
-- im Spiel: AFT_KA, KMD_KA, KMA_LES, TNS_KA, WEG_KA, SGS_KA, STS_KA,
-- FAA_KA. Gleiches Muster wie BSN_KA bei W305 (Joern-Korrektur): nicht
-- zwingend komplett fehlend, evtl. auch nur falscher VARIABLE_TYPE
-- (muss vermutlich CONSTANT sein, sonst wird die Zeile beim Befuellen
-- von W310_loaded_variables uebersprungen).

-- 1) Welche der acht Variablen fehlen komplett in W310_loaded_variables?
SELECT 'AFT_KA' AS var_name, COUNT(*) AS anzahl FROM SSC41WH_FST.W310_loaded_variables WHERE UPPER(var_name)='AFT_KA'
UNION ALL SELECT 'KMD_KA', COUNT(*) FROM SSC41WH_FST.W310_loaded_variables WHERE UPPER(var_name)='KMD_KA'
UNION ALL SELECT 'KMA_LES', COUNT(*) FROM SSC41WH_FST.W310_loaded_variables WHERE UPPER(var_name)='KMA_LES'
UNION ALL SELECT 'TNS_KA', COUNT(*) FROM SSC41WH_FST.W310_loaded_variables WHERE UPPER(var_name)='TNS_KA'
UNION ALL SELECT 'WEG_KA', COUNT(*) FROM SSC41WH_FST.W310_loaded_variables WHERE UPPER(var_name)='WEG_KA'
UNION ALL SELECT 'SGS_KA', COUNT(*) FROM SSC41WH_FST.W310_loaded_variables WHERE UPPER(var_name)='SGS_KA'
UNION ALL SELECT 'STS_KA', COUNT(*) FROM SSC41WH_FST.W310_loaded_variables WHERE UPPER(var_name)='STS_KA'
UNION ALL SELECT 'FAA_KA', COUNT(*) FROM SSC41WH_FST.W310_loaded_variables WHERE UPPER(var_name)='FAA_KA';

-- 2) Fuer die fehlenden: existieren sie im Quellkonfig
--    FST_VOR_INPUT_KM_TABLE (SVS41) ueberhaupt, und mit welchem
--    VARIABLE_TYPE? Zeigt, ob es ein Typ-Filter-Problem ist (wie bei
--    BSN_KA/W305) oder die Variable komplett in der Config fehlt.
SELECT variable_id, variable_name, variable_type, variable_data_type, variable_script_kurz
FROM SVS41WH_FST.FST_VOR_INPUT_KM_TABLE
WHERE UPPER(variable_name) IN ('AFT_KA','KMD_KA','KMA_LES','TNS_KA','WEG_KA','SGS_KA','STS_KA','FAA_KA')
      AND (UPPER(variable_script_kurz) = 'W310' OR UPPER(variable_script_kurz) = 'ALL')
ORDER BY variable_name;
