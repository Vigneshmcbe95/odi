-- Zeigt alle LADEPROTOKOLL-Eintraege ab einer bestimmten Uhrzeit bis
-- jetzt -- praktisch um nur den letzten Ladelauf zu sehen, ohne alte
-- Eintraege von frueheren Laeufen dazwischen.
--
-- >>> HIER FUELLEN (Uhrzeit anpassen) <<<
SELECT log_zeit, ziel_schema, tabelle, status, zeilen, meldung
FROM UBI_RUEMMELIN.ladeprotokoll
WHERE log_zeit >= TO_TIMESTAMP('2026-09-03 11:05:00', 'YYYY-MM-DD HH24:MI:SS')
ORDER BY log_zeit DESC;
