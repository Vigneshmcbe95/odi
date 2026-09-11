-- Rein lesend: prueft ALLE Objekttypen (nicht nur Tabellen) mit
-- diesem Namen in SVS41WH_BA_TRS -- ein Name kann nur einmal pro
-- Schema vergeben sein, egal ob Tabelle, View, Synonym, Sequence etc.
-- Erklaert ORA-00955 trotz "Tabelle existiert nicht laut dba_tables".
SELECT owner, object_name, object_type, status, created
FROM dba_objects
WHERE owner = 'SVS41WH_BA_TRS'
      AND object_name = 'TD_DWH_BETRIEBSKUNDE';
