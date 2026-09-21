-- Kopiert NUR die fehlende Zeile W302_FOERDERART von SCR_DWH_FST nach
-- SSC41WH_FST.W302_loaded_variables -- Workaround, falls
-- PCK_DWH_W302_000_SET_LOCAL_VARIABLES nicht existiert oder aus anderem
-- Grund diese Zeile nicht selbst erzeugt.
--
-- WICHTIG: Falls es das _000_SET_LOCAL_VARIABLES-Package fuer W302 gibt,
-- lieber DAS zuerst laufen lassen -- das ist die eigentlich vorgesehene
-- Quelle fuer diese Zeile, kein manueller Fix.

INSERT INTO SSC41WH_FST.W302_loaded_variables
  (var_name, var_data_varchar2, var_data_number)
SELECT var_name, var_data_varchar2, var_data_number
FROM SCR_DWH_FST.W302_loaded_variables
WHERE UPPER(var_name) = 'W302_FOERDERART'
      AND NOT EXISTS (
        SELECT 1 FROM SSC41WH_FST.W302_loaded_variables t
        WHERE UPPER(t.var_name) = 'W302_FOERDERART'
      );

COMMIT;

-- Kontrolle:
SELECT * FROM SSC41WH_FST.W302_loaded_variables WHERE UPPER(var_name) = 'W302_FOERDERART';
