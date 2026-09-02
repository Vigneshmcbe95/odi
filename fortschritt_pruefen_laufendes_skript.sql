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

-- 3) GEZIELT die Session finden, die tatsaechlich mit dem Zielschema
--    arbeitet (TRUNCATE, Spaltenabfrage oder INSERT -- irgendein
--    Schritt der Schleife). Wichtig: dieses Diagnose-Skript selbst
--    NICHT mit auflisten (sonst matcht es sich selbst, weil der
--    Schemaname im eigenen WHERE-Text vorkommt) -- daher der
--    Ausschluss von Abfragen, die "V$SESSION" enthalten.
SELECT s.sid, s.serial#, s.status, s.last_call_et, sq.sql_text
FROM v$session s
JOIN v$sql sq ON s.sql_id = sq.sql_id
WHERE UPPER(sq.sql_text) LIKE '%SVS41M_STAT_FST%'
  AND UPPER(sq.sql_text) NOT LIKE '%V$SESSION%'
ORDER BY s.last_call_et;

-- 4) Wird die Session durch eine andere Sperre blockiert?
SELECT blocking_session, sid, serial#, wait_class, seconds_in_wait
FROM v$session
WHERE blocking_session IS NOT NULL;
