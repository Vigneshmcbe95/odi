-- Behebt ORA-00942 fuer W334_LOADED_VARIABLES (und vermeidet das
-- gleiche Problem bei jeder anderen Tabelle, die von einem Mapping
-- selbst per DROP TABLE + CREATE TABLE neu angelegt wird).
--
-- Ursache: odi_bsg_default kann zwar SELECT/INSERT auf bereits
-- bestehende, manuell angelegte Tabellen bekommen (siehe
-- w334_loaded_variables_grant.sql), aber das Mapping selbst droppt
-- und erstellt die Tabelle bei JEDEM Lauf neu (Schritte 30/40 im ODI
-- Operator) -- dafuer reichen einzelne Objekt-Grants nicht, es braucht
-- System-Rechte, die in JEDEM Zielschema Tabellen anlegen/loeschen
-- duerfen, plus Speicherkontingent (Quota) auf der betroffenen
-- Tablespace.
--
-- Muss von einem DBA-Account ausgefuehrt werden (nicht von
-- odi_bsg_default selbst).

GRANT CREATE ANY TABLE TO odi_bsg_default;
GRANT DROP ANY TABLE TO odi_bsg_default;
GRANT ALTER ANY TABLE TO odi_bsg_default;
GRANT INSERT ANY TABLE TO odi_bsg_default;
GRANT SELECT ANY TABLE TO odi_bsg_default;
GRANT UPDATE ANY TABLE TO odi_bsg_default;
GRANT DELETE ANY TABLE TO odi_bsg_default;

-- Unbegrenztes Kontingent auf der Tablespace, in der SSC41WH_FST
-- liegt (Tablespace-Name aus pruefen_odi_user_ddl_rechte.sql,
-- Abfrage 2, uebernehmen und hier eintragen):
--
-- ALTER USER odi_bsg_default QUOTA UNLIMITED ON <TABLESPACE_NAME>;
