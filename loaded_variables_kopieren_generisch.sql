SET FEEDBACK ON

-- Einfaches Kopier-Template fuer EINE Wxxx_LOADED_VARIABLES-Tabelle.
-- Nur die drei Variablen unten pro Tabelle anpassen und ausfuehren.

define v_source_owner = 'SSC41WH_FST'
define v_target_owner = 'SSC45WH_FST'
define v_table_name   = 'W301_LOADED_VARIABLES'

INSERT INTO &v_target_owner..&v_table_name
  (var_name, var_data_varchar2, var_data_number)
SELECT s.var_name, s.var_data_varchar2, s.var_data_number
FROM &v_source_owner..&v_table_name s
WHERE NOT EXISTS (
        SELECT 1 FROM &v_target_owner..&v_table_name t
        WHERE UPPER(t.var_name) = UPPER(s.var_name)
      );

COMMIT;

-- Kontrolle:
SELECT COUNT(*) AS anzahl_ziel FROM &v_target_owner..&v_table_name;
