-- ORA-01652: Temp-Segment kann nicht in Tablespace STAT_DWH_SCR erweitert
-- werden -- beim W302-Job (grosser paralleler UNION ALL). Kein Struktur-
-- fehler wie die letzten Faelle, sondern ein Speicherplatzproblem.

-- SCHRITT 0 (lesend): ist STAT_DWH_SCR ueberhaupt eine TEMPORARY- oder
-- eine normale PERMANENT-Tablespace? Bestimmt, ob unten TEMPFILE oder
-- DATAFILE verwendet werden muss.
SELECT tablespace_name, contents, extent_management, allocation_type
FROM dba_tablespaces
WHERE tablespace_name = 'STAT_DWH_SCR';

-- SCHRITT 1a (lesend, falls PERMANENT): aktuelle Groesse/AUTOEXTEND je Datei.
SELECT file_name, tablespace_name,
       ROUND(bytes / 1024 / 1024, 0) AS aktuelle_groesse_mb,
       autoextensible,
       ROUND(maxbytes / 1024 / 1024, 0) AS max_groesse_mb
FROM dba_data_files
WHERE tablespace_name = 'STAT_DWH_SCR';

-- SCHRITT 1b (lesend, falls TEMPORARY): aktuelle Groesse/AUTOEXTEND je Tempfile.
SELECT file_name, tablespace_name,
       ROUND(bytes / 1024 / 1024, 0) AS aktuelle_groesse_mb,
       autoextensible,
       ROUND(maxbytes / 1024 / 1024, 0) AS max_groesse_mb
FROM dba_temp_files
WHERE tablespace_name = 'STAT_DWH_SCR';

-- SCHRITT 2: freien Platz pruefen (nur relevant fuer PERMANENT --
-- TEMPORARY-Tablespaces zeigen hier meist nichts, da Extents dynamisch
-- belegt/freigegeben werden).
SELECT tablespace_name,
       ROUND(SUM(bytes) / 1024 / 1024, 0) AS frei_mb
FROM dba_free_space
WHERE tablespace_name = 'STAT_DWH_SCR'
GROUP BY tablespace_name;

-- SCHRITT 3: den bei SCHRITT 1a/1b angezeigten file_name unten einsetzen
-- und die passende Variante ausfuehren. Braucht DBA-Rechte (ALTER
-- DATABASE) -- bei ORA-01031 braucht es jemanden mit DBA-Rolle.
--
-- >>> Variante A -- STAT_DWH_SCR ist PERMANENT <<<
-- ALTER DATABASE DATAFILE '<file_name_aus_schritt_1a>'
--   AUTOEXTEND ON NEXT 1G MAXSIZE UNLIMITED;
--
-- >>> Variante B -- STAT_DWH_SCR ist TEMPORARY <<<
-- ALTER DATABASE TEMPFILE '<file_name_aus_schritt_1b>'
--   AUTOEXTEND ON NEXT 1G MAXSIZE UNLIMITED;
--
-- Alternative, falls kein AUTOEXTEND gewuenscht/moeglich ist -- Datei
-- einmalig manuell vergroessern:
-- ALTER DATABASE DATAFILE '<file_name>' RESIZE 5G;   -- PERMANENT
-- ALTER DATABASE TEMPFILE '<file_name>' RESIZE 5G;   -- TEMPORARY

-- SCHRITT 4 (lesend, nach Schritt 3 erneut ausfuehren): bestaetigt die
-- neue Groesse/AUTOEXTEND-Status.
SELECT file_name, tablespace_name,
       ROUND(bytes / 1024 / 1024, 0) AS aktuelle_groesse_mb,
       autoextensible,
       ROUND(maxbytes / 1024 / 1024, 0) AS max_groesse_mb
FROM dba_data_files
WHERE tablespace_name = 'STAT_DWH_SCR'
UNION ALL
SELECT file_name, tablespace_name,
       ROUND(bytes / 1024 / 1024, 0),
       autoextensible,
       ROUND(maxbytes / 1024 / 1024, 0)
FROM dba_temp_files
WHERE tablespace_name = 'STAT_DWH_SCR';
