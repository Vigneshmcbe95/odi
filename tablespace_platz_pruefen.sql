-- Rein lesend: zeigt fuer eine Tablespace den aktuellen Speicherstand
-- (belegt/frei/max) und ob AUTOEXTEND aktiv ist -- Grundlage, um
-- ORA-01688 (unable to extend ... in tablespace ...) zu loesen.
--
-- Keine SQL*Plus-Substitutionsvariablen (&...) -- manche SQL-Clients
-- fragen sonst bei jedem Vorkommen einzeln nach. Wert stattdessen
-- unten EINMAL eintragen.
--
-- >>> HIER FUELLEN (nur diese eine Zeile) <<<
WITH v_ts AS (SELECT 'STAT_DWL' AS v_tablespace FROM dual)

-- 1) Gesamt belegt vs. frei in der Tablespace
SELECT df.tablespace_name,
       ROUND(df.bytes_mb, 0) AS gesamt_mb,
       ROUND(NVL(fs.free_mb, 0), 0) AS frei_mb,
       ROUND(df.bytes_mb - NVL(fs.free_mb, 0), 0) AS belegt_mb,
       ROUND(100 * NVL(fs.free_mb, 0) / df.bytes_mb, 1) AS frei_prozent
FROM v_ts v
     JOIN (SELECT tablespace_name, SUM(bytes) / 1024 / 1024 bytes_mb
           FROM dba_data_files
           GROUP BY tablespace_name) df
       ON df.tablespace_name = upper(v.v_tablespace)
     LEFT JOIN (SELECT tablespace_name, SUM(bytes) / 1024 / 1024 free_mb
                FROM dba_free_space
                GROUP BY tablespace_name) fs
       ON fs.tablespace_name = df.tablespace_name;

-- 2) Jede Datendatei einzeln: aktuelle Groesse, AUTOEXTEND an/aus, Max-Groesse
WITH v_ts AS (SELECT 'STAT_DWL' AS v_tablespace FROM dual)
SELECT df.file_name,
       ROUND(df.bytes / 1024 / 1024, 0) AS aktuelle_groesse_mb,
       df.autoextensible,
       ROUND(df.maxbytes / 1024 / 1024, 0) AS max_groesse_mb
FROM v_ts v
     JOIN dba_data_files df ON df.tablespace_name = upper(v.v_tablespace);

