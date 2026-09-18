-- ORA-00942 beim Insert in SSC41WH_FST.W105_TMP_HIST_GUELTIG.
-- Quelle im Statement: SVS41WH_FST.TV_DWH_COSACH_NT_KUNDE.
-- Eines der beiden fehlt in B05 -- pruefen, welches.

SELECT owner, object_name, object_type, status
FROM dba_objects
WHERE owner = 'SSC41WH_FST'
      AND object_name = 'W105_TMP_HIST_GUELTIG';

SELECT owner, object_name, object_type, status
FROM dba_objects
WHERE owner = 'SVS41WH_FST'
      AND object_name = 'TV_DWH_COSACH_NT_KUNDE';

-- Referenz fuer den Zielschema-Fall (Scratch): SCR_DWH_FST
SELECT owner, object_name, object_type, status
FROM dba_objects
WHERE owner = 'SCR_DWH_FST'
      AND object_name = 'W105_TMP_HIST_GUELTIG';

-- Referenz fuer den Quellschema-Fall (persistent): THM_DWH_FST
SELECT owner, object_name, object_type, status
FROM dba_objects
WHERE owner = 'THM_DWH_FST'
      AND object_name = 'TV_DWH_COSACH_NT_KUNDE';
