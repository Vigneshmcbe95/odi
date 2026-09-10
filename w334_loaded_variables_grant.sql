-- Behebt ORA-00942 fuer SSC41WH_FST.W334_LOADED_VARIABLES: Tabelle
-- existiert, aber odi_bsg_default hatte keine Rechte darauf.
GRANT SELECT, INSERT, UPDATE, DELETE ON SSC41WH_FST.W334_LOADED_VARIABLES TO odi_bsg_default;
