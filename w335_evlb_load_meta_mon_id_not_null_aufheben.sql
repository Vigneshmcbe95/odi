-- Behebt ORA-01400: META_MON_ID wird von diesem Mapping nicht befuellt
-- (fehlt in der INSERT-Spaltenliste), ist aber NOT NULL. Gleiches
-- Muster wie bei W334_LOADED_VARIABLES/META_INS_DT: NOT NULL auf
-- dieser Ziel-Spalte aufheben, statt einen Wert zu erfinden --
-- Scratch-Tabelle, unkritisch.

-- 1) Aktuellen Zustand pruefen
SELECT owner, table_name, column_name, nullable
FROM dba_tab_columns
WHERE owner = 'SSC41WH_FST'
      AND table_name = 'W335_EVLB_LOAD'
      AND column_name = 'META_MON_ID';

-- 2) NOT NULL aufheben
ALTER TABLE SSC41WH_FST.W335_EVLB_LOAD
  MODIFY (META_MON_ID NULL);
