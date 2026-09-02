-- Fortschritt eines laufenden Datenladen-Skripts pruefen (in einer
-- ZWEITEN, separaten Verbindung ausfuehren -- nicht in der Session,
-- die das Skript selbst ausfuehrt).
--
-- Hintergrund: DBMS_OUTPUT-Text wird in den meisten GUI-Tools erst
-- NACH dem kompletten Lauf angezeigt, nicht live Zeile fuer Zeile.
-- Kein sichtbares Ergebnis waehrend der Laufzeit heisst also nicht,
-- dass nichts passiert -- diese Abfragen zeigen den echten Stand.

-- 1) Ist die Session ueberhaupt aktiv, oder haengt sie fest?
--    last_call_et = Sekunden seit letzter Aktivitaet dieser Session.
--    Steigt der Wert immer weiter ohne zurueckzusetzen -> moeglicherweise blockiert.
SELECT sid, serial#, status, sql_id, event, seconds_in_wait, last_call_et
FROM v$session
WHERE username = USER
ORDER BY last_call_et DESC;

-- 2) Kommen tatsaechlich Daten an? Zeilenanzahl auf einer bereits
--    verarbeiteten Zieltabelle pruefen (mehrfach im Abstand pruefen).
-- SELECT COUNT(*) FROM SVS41M_STAT_FST.TF_FST_MN_FIM;

-- 3) GEZIELT die Session finden, die tatsaechlich das INSERT ins
--    Zielschema ausfuehrt -- nicht alle Sessions des gleichen
--    (evtl. gemeinsam genutzten) DB-Users, sondern nur die, deren
--    aktuelle Anweisung wirklich "INSERT" und den Zielschema-Namen
--    enthaelt. Das vermeidet, versehentlich die interne Abfrage des
--    SQL-Tools selbst (z.B. mit "ora_rowid") zu erwischen.
SELECT s.sid, s.serial#, s.status, s.last_call_et, sq.sql_text
FROM v$session s
JOIN v$sql sq ON s.sql_id = sq.sql_id
WHERE UPPER(sq.sql_text) LIKE '%INSERT%SVS41M_STAT_FST%'
ORDER BY s.last_call_et;

-- 4) Wird die Session durch eine andere Sperre blockiert?
SELECT blocking_session, sid, serial#, wait_class, seconds_in_wait
FROM v$session
WHERE blocking_session IS NOT NULL;
