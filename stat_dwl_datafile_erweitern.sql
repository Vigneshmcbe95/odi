-- SCHRITT 1 (lesend): zeigt den genauen Dateinamen/Pfad, aktuelle
-- Groesse und AUTOEXTEND-Status jeder Datendatei in STAT_DWL.
-- Braucht DBA-Rechte (ALTER DATABASE) fuer Schritt 2 -- falls das mit
-- ORA-01031 fehlschlaegt, braucht es jemanden mit DBA-Rolle.
SELECT file_name, tablespace_name,
       ROUND(bytes / 1024 / 1024, 0) AS aktuelle_groesse_mb,
       autoextensible,
       ROUND(maxbytes / 1024 / 1024, 0) AS max_groesse_mb
FROM dba_data_files
WHERE tablespace_name = 'STAT_DWL';

-- SCHRITT 2: den bei SCHRITT 1 angezeigten file_name unten einsetzen
-- und ausfuehren (AUTOEXTEND EIN, ohne Obergrenze). Dieser Schritt
-- braucht DBA-Rechte.
--
-- >>> HIER file_name AUS SCHRITT 1 EINTRAGEN <<<
-- ALTER DATABASE DATAFILE '<file_name_aus_schritt_1>'
--   AUTOEXTEND ON NEXT 1G MAXSIZE UNLIMITED;

-- SCHRITT 3 (lesend, nach Schritt 2 erneut ausfuehren): bestaetigt,
-- dass AUTOEXTEND jetzt aktiv ist und keine Obergrenze mehr hat.
SELECT file_name, tablespace_name,
       ROUND(bytes / 1024 / 1024, 0) AS aktuelle_groesse_mb,
       autoextensible,
       ROUND(maxbytes / 1024 / 1024, 0) AS max_groesse_mb
FROM dba_data_files
WHERE tablespace_name = 'STAT_DWL';
