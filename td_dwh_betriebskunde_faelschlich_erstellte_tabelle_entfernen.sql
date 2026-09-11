-- Entfernt die faelschlich angelegte TABELLE (die den Synonym-Konflikt
-- verursachte) -- das Design hier ist Synonym auf PSD1, keine echte
-- Tabelle. Nur ausfuehren, falls dba_objects zeigt, dass zwischenzeitlich
-- doch ein Tabellen-Objekt (nicht nur das Synonym) unter diesem Namen
-- entstanden ist.
--
-- Vorher pruefen mit pruefen_alle_objekttypen_td_dwh_betriebskunde.sql,
-- ob OBJECT_TYPE = 'TABLE' zusaetzlich zum Synonym existiert.

-- DROP TABLE SVS41WH_BA_TRS.TD_DWH_BETRIEBSKUNDE;
