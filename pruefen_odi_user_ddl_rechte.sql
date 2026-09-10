-- Rein lesend: prueft, ob odi_bsg_default die noetigen Rechte hat,
-- um Tabellen in SSC41WH_FST anzulegen/zu droppen (das Mapping macht
-- selbst DROP TABLE + CREATE TABLE fuer W334_LOADED_VARIABLES bei
-- jedem Lauf -- kein reines SELECT/INSERT-Rechteproblem).

-- 1) Hat odi_bsg_default die System-Rechte, Tabellen in einem
--    FREMDEN Schema anzulegen/zu droppen?
SELECT grantee, privilege
FROM dba_sys_privs
WHERE grantee = 'ODI_BSG_DEFAULT'
      AND privilege IN ('CREATE ANY TABLE', 'DROP ANY TABLE', 'ALTER ANY TABLE')
ORDER BY privilege;

-- 2) Hat odi_bsg_default ueberhaupt eine Quota (Platzkontingent) auf
--    der Tablespace, in der SSC41WH_FST-Objekte liegen? Ohne Quota
--    schlaegt CREATE TABLE fehl, selbst mit CREATE ANY TABLE.
SELECT tablespace_name
FROM dba_tables
WHERE owner = 'SSC41WH_FST' AND table_name != 'W334_LOADED_VARIABLES'
      AND rownum = 1;

SELECT username, tablespace_name, max_bytes, bytes
FROM dba_ts_quotas
WHERE username = 'ODI_BSG_DEFAULT';

-- 3) Ist odi_bsg_default vielleicht selbst der Owner/hat eine Rolle,
--    die diese Rechte indirekt mitbringt? (Rollen werden von
--    dba_sys_privs NICHT erfasst, nur direkte Grants)
SELECT grantee, granted_role
FROM dba_role_privs
WHERE grantee = 'ODI_BSG_DEFAULT';
