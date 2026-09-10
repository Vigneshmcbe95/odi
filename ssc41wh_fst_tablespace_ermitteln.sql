-- Rein lesend: zeigt, in welcher Tablespace die Objekte von
-- SSC41WH_FST tatsaechlich liegen -- diesen Namen fuer die
-- QUOTA-Vergabe an odi_bsg_default verwenden.
SELECT DISTINCT tablespace_name
FROM dba_tables
WHERE owner = 'SSC41WH_FST';

-- Aktuelle Quota von odi_bsg_default auf dieser Tablespace pruefen
-- (leer/keine Zeile = kein Kontingent vorhanden -- das ist die
-- wahrscheinliche Ursache).
SELECT username, tablespace_name, max_bytes, bytes
FROM dba_ts_quotas
WHERE username = 'ODI_BSG_DEFAULT';
