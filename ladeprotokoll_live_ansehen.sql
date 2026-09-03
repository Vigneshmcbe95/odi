-- In einer ZWEITEN, separaten Verbindung ausfuehren, waehrend das
-- Datenladen-Skript in der ersten Verbindung laeuft. Einfach diese
-- Abfrage alle paar Sekunden erneut ausfuehren (oder das Tool im
-- Auto-Refresh-Modus laufen lassen, falls verfuegbar) -- neue Zeilen
-- erscheinen sofort nach jedem Commit der laufenden Session.

SELECT log_zeit, ziel_schema, tabelle, status, zeilen, meldung
FROM UBI_RUEMMELIN.ladeprotokoll
ORDER BY log_zeit DESC;
