-- Rein lesend: umfassende Speicher-/Platzpruefung VOR dem Erweitern
-- einer Tablespace. Zeigt: alle Tablespaces mit Belegung/Frei-Prozent,
-- alle Datendateien mit AUTOEXTEND-Status, und (falls verwendet)
-- ASM-Diskgruppen-Speicher. Aendert nichts an der DB.

-- 1) Alle Tablespaces: Groesse, belegt, frei, Frei-Prozent -- zeigt auf
--    einen Blick, welche Tablespaces insgesamt knapp werden.
SELECT df.tablespace_name,
       ROUND(df.bytes_mb, 0) AS gesamt_mb,
       ROUND(NVL(fs.free_mb, 0), 0) AS frei_mb,
       ROUND(df.bytes_mb - NVL(fs.free_mb, 0), 0) AS belegt_mb,
       ROUND(100 * NVL(fs.free_mb, 0) / df.bytes_mb, 1) AS frei_prozent
FROM (SELECT tablespace_name, SUM(bytes) / 1024 / 1024 bytes_mb
      FROM dba_data_files
      GROUP BY tablespace_name) df
     LEFT JOIN (SELECT tablespace_name, SUM(bytes) / 1024 / 1024 free_mb
                FROM dba_free_space
                GROUP BY tablespace_name) fs
       ON fs.tablespace_name = df.tablespace_name
ORDER BY frei_prozent ASC NULLS FIRST;

-- 2) Alle Datendateien: aktuelle Groesse, AUTOEXTEND an/aus, Max-Groesse
--    -- zeigt, welche Dateien schon an ihrer Obergrenze sind oder gar
--    kein AUTOEXTEND haben (wie STAT_DWL aktuell).
SELECT file_name, tablespace_name,
       ROUND(bytes / 1024 / 1024, 0) AS aktuelle_groesse_mb,
       autoextensible,
       ROUND(maxbytes / 1024 / 1024, 0) AS max_groesse_mb,
       ROUND(user_bytes / 1024 / 1024, 0) AS nutzbare_groesse_mb
FROM dba_data_files
ORDER BY tablespace_name, file_name;

-- 3) TEMP-Tablespaces separat (anderer Katalog: dba_temp_files) --
--    relevant, da parallele/grosse Ladevorgaenge oft TEMP statt einer
--    normalen Tablespace fuellen (ORA-01652).
SELECT file_name, tablespace_name,
       ROUND(bytes / 1024 / 1024, 0) AS aktuelle_groesse_mb,
       autoextensible,
       ROUND(maxbytes / 1024 / 1024, 0) AS max_groesse_mb
FROM dba_temp_files
ORDER BY tablespace_name, file_name;

-- 4) Falls die Datenbank ASM (Automatic Storage Management) verwendet:
--    zeigt den tatsaechlichen Speicherplatz auf Diskgruppen-Ebene --
--    das ist die "echte" Obergrenze, unabhaengig von MAXSIZE in
--    dba_data_files. Wirft einen Fehler, falls kein ASM verwendet wird
--    (dann einfach ignorieren -- dann greift stattdessen der normale
--    Server-/VM-Festplattenplatz, der NICHT per SQL abfragbar ist --
--    dafuer braucht es Zugriff auf das Betriebssystem, z.B. "df -h").
SELECT name AS diskgroup,
       ROUND(total_mb, 0) AS gesamt_mb,
       ROUND(free_mb, 0) AS frei_mb,
       ROUND(100 * free_mb / total_mb, 1) AS frei_prozent
FROM v$asm_diskgroup;
