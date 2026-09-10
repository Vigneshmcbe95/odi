-- Rein lesend: prueft die zwei wahrscheinlichsten Ursachen fuer
-- ORA-00942 trotz vorhandener Tabelle SSC41WH_FST.W334_LOADED_VARIABLES.

-- 1) Hat der Laufzeit-User (odi_bsg_default) ueberhaupt Rechte auf
--    diese Tabelle? Ohne GRANT meldet Oracle "table or view does not
--    exist" statt eines Rechte-Fehlers -- das sieht identisch aus wie
--    eine fehlende Tabelle.
SELECT grantee, privilege, owner AS table_schema, table_name
FROM dba_tab_privs
WHERE table_name = 'W334_LOADED_VARIABLES'
      AND owner = 'SSC41WH_FST'
ORDER BY grantee, privilege;

-- 2) Existiert ein Synonym fuer diese Tabelle, ueber das
--    odi_bsg_default (oder ein anderer Verbindungsuser) normalerweise
--    zugreift? Falls kein Synonym existiert und der User nicht direkt
--    auf SSC41WH_FST verbunden ist, findet er die Tabelle nicht.
SELECT owner, synonym_name, table_owner, table_name
FROM dba_synonyms
WHERE table_name = 'W334_LOADED_VARIABLES';
