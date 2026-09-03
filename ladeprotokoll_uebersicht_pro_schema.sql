-- Rein lesend: Zusammenfassung pro Zielschema -- wie viele OK-/FEHLER-/
-- WARNUNG-Eintraege es in LADEPROTOKOLL gibt. Damit auf einen Blick
-- pruefbar, welche Schemas komplett fehlerfrei geladen wurden und
-- welche noch FEHLER-Eintraege haben.

-- 1) Zusammenfassung: Anzahl OK/FEHLER/WARNUNG je Schema
SELECT ziel_schema,
       COUNT(*) AS gesamt_eintraege,
       SUM(CASE WHEN status = 'OK' THEN 1 ELSE 0 END) AS anzahl_ok,
       SUM(CASE WHEN status = 'FEHLER' THEN 1 ELSE 0 END) AS anzahl_fehler,
       SUM(CASE WHEN status = 'WARNUNG' THEN 1 ELSE 0 END) AS anzahl_warnung
FROM UBI_RUEMMELIN.ladeprotokoll
GROUP BY ziel_schema
ORDER BY anzahl_fehler DESC, ziel_schema;

-- 2) Details: alle FEHLER-Zeilen (Tabelle + Fehlermeldung), damit man
--    direkt sieht, WAS in welchen Schemas noch offen ist -- ohne die
--    ganze LADEPROTOKOLL-Tabelle durchsuchen zu muessen.
SELECT log_zeit, ziel_schema, tabelle, meldung
FROM UBI_RUEMMELIN.ladeprotokoll
WHERE status = 'FEHLER'
ORDER BY ziel_schema, tabelle;
