-- ODI-17511 beim Refresh der Variable PRJ_THM_DWH_FST.V_GET_FOERDERART_W301.
-- Gleiches Muster wie ORA-01476/FSC_KA im W305-Mapping: die Variable liest
-- aus einer Ordner-eigenen "loaded_variables"-Tabelle, die vermutlich von
-- einem _000_SET_LOCAL_VARIABLES-Package befuellt wird. Vor jedem Fix
-- pruefen, ob dieses Package fuer W301 existiert und schon gelaufen ist
-- (Designer -> W301_FST_KERN_MN -> Packages).

-- 1) Was steht aktuell in der Tabelle?
SELECT var_name, var_data_varchar2, var_data_number
FROM SSC41WH_FST.W301_loaded_variables
ORDER BY var_name;

-- 2) Gezielt nach W301_FOERDERART suchen (Gross-/Kleinschreibung beachten --
--    die Variable nutzt UPPER()).
SELECT *
FROM SSC41WH_FST.W301_loaded_variables
WHERE UPPER(var_name) = 'W301_FOERDERART';

-- 3) Vergleich mit Referenzschema SCR_DWH_FST, falls dort vorhanden.
SELECT var_name, var_data_varchar2, var_data_number
FROM SCR_DWH_FST.W301_loaded_variables
WHERE UPPER(var_name) = 'W301_FOERDERART';
