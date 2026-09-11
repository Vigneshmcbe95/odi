-- Behebt ORA-00942 beim TRUNCATE von SSC41WH_FST.W334_WRK_PERSB_TN --
-- Tabelle existiert, odi_bsg_default hatte keine Rechte darauf.
GRANT SELECT, INSERT, UPDATE, DELETE ON SSC41WH_FST.W334_WRK_PERSB_TN TO odi_bsg_default;

-- TRUNCATE separat noetig (eigenes Objekt-Recht seit Oracle 18c,
-- sonst reicht die System-Rolle DROP ANY TABLE aus
-- odi_user_ddl_rechte_beheben.sql):
GRANT TRUNCATE ON SSC41WH_FST.W334_WRK_PERSB_TN TO odi_bsg_default;
