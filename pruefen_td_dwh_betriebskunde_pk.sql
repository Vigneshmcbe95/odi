-- Rein lesend: prueft, ob die Tabelle jetzt eine Primary-Key-
-- Constraint hat (auch wenn das ALTER TABLE ... ADD PRIMARY KEY
-- Statement mit ORA-00955 fehlgeschlagen ist -- moeglicherweise
-- existiert die Constraint schon von einem frueheren Teilversuch).
SELECT constraint_name, constraint_type, status
FROM dba_constraints
WHERE owner = 'SVS41WH_BA_TRS'
      AND table_name = 'TD_DWH_BETRIEBSKUNDE';

-- Spaltenanzahl zur Kontrolle -- sollte mit der Quelle uebereinstimmen
SELECT COUNT(*) AS anzahl_spalten
FROM dba_tab_columns
WHERE owner = 'SVS41WH_BA_TRS'
      AND table_name = 'TD_DWH_BETRIEBSKUNDE';
