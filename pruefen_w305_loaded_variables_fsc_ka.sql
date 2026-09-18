-- ORA-01476 (Divisor ist Null) beim W305-Mapping -- die verwendete
-- 1/COUNT(*)-Existenzpruefung schlaegt fehl, weil kein Datensatz mit
-- var_name = 'FSC_KA' in SSC41WH_FST.W305_loaded_variables existiert.
-- Kein Schema-/Tabellenfehler wie bei den vorherigen Faellen, sondern
-- ein fehlender DATENSATZ (Laufzeitvariable). Vor jedem Fix pruefen,
-- was diese Tabelle eigentlich befuellt.

-- 1) Existiert die Tabelle ueberhaupt und was steht aktuell drin?
SELECT var_name, var_data_number, var_data_char
FROM SSC41WH_FST.W305_loaded_variables
ORDER BY var_name;

-- 2) Gezielt nach FSC_KA suchen (Gross-/Kleinschreibung pruefen --
--    das Mapping nutzt UPPER(), also sollte var_name in Grossbuchstaben
--    gespeichert sein).
SELECT *
FROM SSC41WH_FST.W305_loaded_variables
WHERE UPPER(var_name) = 'FSC_KA';

-- 3) Vergleich mit Referenzschema SCR_DWH_FST, falls dort die gleiche
--    Tabelle mit Beispieldaten existiert (zeigt, was FSC_KA normalerweise
--    fuer einen Wert/Datentyp hat).
SELECT var_name, var_data_number, var_data_char
FROM SCR_DWH_FST.W305_loaded_variables
WHERE UPPER(var_name) = 'FSC_KA';

-- 4) Welches ODI-Objekt/Mapping befuellt W305_loaded_variables normalerweise?
--    (Manuell in ODI Studio/Operator nachsehen: im Package W305, welcher
--    Schritt VOR diesem Mapping schreibt in diese Tabelle -- pruefen, ob
--    dieser Schritt im aktuellen Lauf erfolgreich war oder uebersprungen
--    wurde.)
