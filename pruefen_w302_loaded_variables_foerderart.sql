-- ODI-17511 beim Refresh der Variable PRJ_THM_DWH_FST.V_GET_FOERDERART_W302.
-- Gleiches Muster wie bei V_GET_FOERDERART_W301 und FSC_KA im W305-Mapping:
-- die Variable liest aus einer Ordner-eigenen "loaded_variables"-Tabelle,
-- vermutlich befuellt von einem _000_SET_LOCAL_VARIABLES-Package. Vor
-- jedem DB-Fix pruefen, ob dieses Package fuer W302 existiert und schon
-- gelaufen ist (Designer -> W302-Ordner -> Packages).

-- 1) Was steht aktuell in der Tabelle?
SELECT var_name, var_data_varchar2, var_data_number
FROM SSC41WH_FST.W302_loaded_variables
ORDER BY var_name;

-- 2) Gezielt nach W302_FOERDERART suchen (Gross-/Kleinschreibung beachten --
--    die Variable nutzt vermutlich UPPER()).
SELECT *
FROM SSC41WH_FST.W302_loaded_variables
WHERE UPPER(var_name) = 'W302_FOERDERART';

-- 3) Vergleich mit Referenzschema SCR_DWH_FST, falls dort vorhanden.
SELECT var_name, var_data_varchar2, var_data_number
FROM SCR_DWH_FST.W302_loaded_variables
WHERE UPPER(var_name) = 'W302_FOERDERART';
