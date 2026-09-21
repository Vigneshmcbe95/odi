-- ORA-01476 im W302-Job: fehlende Variable FBW_QUELLE in
-- SSC41WH_FST.W302_loaded_variables -- zweite fehlende Variable in
-- dieser Tabelle nach W302_FOERDERART. Starker Hinweis: das komplette
-- _000_SET_LOCAL_VARIABLES-Package fuer W302 ist nie gelaufen, nicht
-- nur einzelne Zeilen fehlen. VOR diesem Fix in Designer pruefen, ob
-- PCK_DWH_W302_000_SET_LOCAL_VARIABLES existiert -- falls ja, DAS
-- zuerst laufen lassen statt Variable fuer Variable nachzuziehen.

-- 1) Aktueller Stand der Tabelle (zeigt auf einen Blick, wie viele
--    Variablen insgesamt fehlen).
SELECT var_name, var_data_varchar2, var_data_number
FROM SSC41WH_FST.W302_loaded_variables
ORDER BY var_name;

-- 2) Gezielt nach FBW_QUELLE suchen.
SELECT *
FROM SSC41WH_FST.W302_loaded_variables
WHERE UPPER(var_name) = 'FBW_QUELLE';

-- 3) Vergleich mit SCR_DWH_FST.
SELECT var_name, var_data_varchar2, var_data_number
FROM SCR_DWH_FST.W302_loaded_variables
WHERE UPPER(var_name) = 'FBW_QUELLE';

-- 4) Falls kein _000-Package existiert/greift: fehlende Zeile aus
--    SCR_DWH_FST nachziehen (Workaround, kein Ersatz fuer das Package).
INSERT INTO SSC41WH_FST.W302_loaded_variables
  (var_name, var_data_varchar2, var_data_number)
SELECT var_name, var_data_varchar2, var_data_number
FROM SCR_DWH_FST.W302_loaded_variables
WHERE UPPER(var_name) = 'FBW_QUELLE'
      AND NOT EXISTS (
        SELECT 1 FROM SSC41WH_FST.W302_loaded_variables t
        WHERE UPPER(t.var_name) = 'FBW_QUELLE'
      );

COMMIT;

SELECT * FROM SSC41WH_FST.W302_loaded_variables WHERE UPPER(var_name) = 'FBW_QUELLE';
