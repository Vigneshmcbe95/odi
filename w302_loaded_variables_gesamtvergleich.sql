-- Gesamtvergleich statt Variable-fuer-Variable: zeigt auf einen Blick,
-- welche Variablen in SCR_DWH_FST.W302_loaded_variables existieren,
-- aber in SSC41WH_FST.W302_loaded_variables fehlen. Bereits bekannt
-- fehlend: W302_FOERDERART, FBW_QUELLE, FART_PB, FART_REF, TNS_B_AH,
-- TNS_B_PB, TNS_B_REF -- vermutlich nur ein Bruchteil der echten Luecke.
--
-- VOR jedem weiteren Fix: in Designer pruefen, ob
-- PCK_DWH_W302_000_SET_LOCAL_VARIABLES existiert -- falls ja, DAS
-- einmal laufen lassen statt hier einzeln nachzuziehen.

-- 1) Wie viele Variablen hat SSC41 aktuell ueberhaupt (roher Ist-Stand)?
SELECT COUNT(*) AS anzahl_ssc41 FROM SSC41WH_FST.W302_loaded_variables;

-- 2) Wie viele hat die Referenz SCR_DWH_FST?
SELECT COUNT(*) AS anzahl_scr FROM SCR_DWH_FST.W302_loaded_variables;

-- 3) Welche Variablen fehlen komplett in SSC41 (Liste)?
SELECT scr.var_name
FROM SCR_DWH_FST.W302_loaded_variables scr
WHERE NOT EXISTS (
        SELECT 1 FROM SSC41WH_FST.W302_loaded_variables ssc
        WHERE UPPER(ssc.var_name) = UPPER(scr.var_name)
      )
ORDER BY scr.var_name;

-- 4) Falls _000-Package nicht existiert/nicht greift: ALLE fehlenden
--    Variablen in einem Rutsch aus SCR_DWH_FST nachziehen (Workaround).
INSERT INTO SSC41WH_FST.W302_loaded_variables
  (var_name, var_data_varchar2, var_data_number)
SELECT scr.var_name, scr.var_data_varchar2, scr.var_data_number
FROM SCR_DWH_FST.W302_loaded_variables scr
WHERE NOT EXISTS (
        SELECT 1 FROM SSC41WH_FST.W302_loaded_variables ssc
        WHERE UPPER(ssc.var_name) = UPPER(scr.var_name)
      );

COMMIT;

-- 5) Kontrolle nach dem Nachziehen -- sollte jetzt 0 Zeilen liefern.
SELECT scr.var_name
FROM SCR_DWH_FST.W302_loaded_variables scr
WHERE NOT EXISTS (
        SELECT 1 FROM SSC41WH_FST.W302_loaded_variables ssc
        WHERE UPPER(ssc.var_name) = UPPER(scr.var_name)
      );
