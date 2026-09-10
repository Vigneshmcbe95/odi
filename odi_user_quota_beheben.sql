-- Vergibt odi_bsg_default unbegrenztes Kontingent auf STAT_DWH_SCR
-- (Tablespace von SSC41WH_FST) -- behebt ORA-00942 bei CREATE TABLE,
-- falls die Ursache fehlende Quota war.
-- Muss von einem DBA-Account ausgefuehrt werden.

ALTER USER odi_bsg_default QUOTA UNLIMITED ON STAT_DWH_SCR;
