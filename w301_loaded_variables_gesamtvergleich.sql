-- Gleiches Muster wie bei W302: W301_loaded_variables fehlt vermutlich
-- nicht nur W301_FOERDERART, sondern mehrere Variablen (jetzt auch
-- AAM_KA aufgetreten). Gesamtvergleich statt Variable-fuer-Variable.
--
-- VOR jedem weiteren Fix: in Designer pruefen, ob
-- PCK_DWH_W301_000_SET_LOCAL_VARIABLES existiert -- falls ja, DAS
-- einmal laufen lassen statt hier einzeln nachzuziehen.

-- 1) Ist-Stand SSC41.
SELECT COUNT(*) AS anzahl_ssc41 FROM SSC41WH_FST.W301_loaded_variables;

-- 2) Referenz SCR_DWH_FST.
SELECT COUNT(*) AS anzahl_scr FROM SCR_DWH_FST.W301_loaded_variables;

-- 3) Welche Variablen fehlen komplett in SSC41?
SELECT scr.var_name
FROM SCR_DWH_FST.W301_loaded_variables scr
WHERE NOT EXISTS (
        SELECT 1 FROM SSC41WH_FST.W301_loaded_variables ssc
        WHERE UPPER(ssc.var_name) = UPPER(scr.var_name)
      )
ORDER BY scr.var_name;

-- 4) Falls _000-Package nicht existiert/nicht greift: ALLE fehlenden
--    Variablen in einem Rutsch aus SCR_DWH_FST nachziehen (Workaround).
INSERT INTO SSC41WH_FST.W301_loaded_variables
  (var_name, var_data_varchar2, var_data_number)
SELECT scr.var_name, scr.var_data_varchar2, scr.var_data_number
FROM SCR_DWH_FST.W301_loaded_variables scr
WHERE NOT EXISTS (
        SELECT 1 FROM SSC41WH_FST.W301_loaded_variables ssc
        WHERE UPPER(ssc.var_name) = UPPER(scr.var_name)
      );

COMMIT;

-- 5) Kontrolle -- sollte jetzt 0 Zeilen liefern.
SELECT scr.var_name
FROM SCR_DWH_FST.W301_loaded_variables scr
WHERE NOT EXISTS (
        SELECT 1 FROM SSC41WH_FST.W301_loaded_variables ssc
        WHERE UPPER(ssc.var_name) = UPPER(scr.var_name)
      );
