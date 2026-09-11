-- Schritt 1: existiert die Tabelle ueberhaupt und wie viele Spalten hat sie?
SELECT COUNT(*) AS anzahl_spalten
FROM dba_tab_columns
WHERE owner = 'SVS41WH_BA_TRS'
      AND table_name = 'TD_DWH_BETRIEBSKUNDE';

-- Schritt 2: alle Constraints auf dieser Tabelle, egal welcher Typ
SELECT constraint_name, constraint_type, status
FROM dba_constraints
WHERE owner = 'SVS41WH_BA_TRS'
      AND table_name = 'TD_DWH_BETRIEBSKUNDE';

-- Schritt 3: welche PK-Constraint hat die QUELL-Tabelle (SVS43), die
-- schon existierende Constraint hier, die den Konflikt verursacht?
SELECT constraint_name, constraint_type
FROM dba_constraints
WHERE owner = 'SVS43WH_BA_TRS'
      AND table_name = 'TD_DWH_BETRIEBSKUNDE'
      AND constraint_type = 'P';
