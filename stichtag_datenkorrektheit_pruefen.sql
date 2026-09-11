-- Rein lesend: prueft die Historisierungs-Grundregeln nach einem
-- erfolgreichen ETL-Lauf.
--
-- >>> HIER FUELLEN (Schema, Tabelle, Schluesselspalte, Stichtag) <<<

-- 1) Gibt es ueberhaupt Zeilen mit dem gerade gelaufenen Stichtag?
SELECT COUNT(*) AS anzahl_neue_zeilen
FROM SVS41WH_FST.W334_TH_DWH_PERSB_BUDGET
WHERE gueltig_von = TO_DATE('20260413','YYYYMMDD');

-- 2) Gibt es Zeilen mit widerspruechlichem Gueltig-von/Gueltig-bis
--    (von > bis -- darf nie vorkommen)?
SELECT COUNT(*) AS fehlerhafte_zeitraeume
FROM SVS41WH_FST.W334_TH_DWH_PERSB_BUDGET
WHERE gueltig_von > gueltig_bis;

-- 3) Gibt es Duplikate -- mehrere gleichzeitig "aktuelle" Versionen
--    (Gueltig_bis = 31.12.9999) fuer denselben fachlichen Schluessel?
--    <SCHLUESSEL_SPALTE> durch die echte ID-Spalte der Tabelle ersetzen
--    (z.B. PSB_ID o.ae. -- Spaltenname aus DBA_TAB_COLUMNS pruefen,
--    falls unklar).
SELECT <SCHLUESSEL_SPALTE>, COUNT(*) AS anzahl_aktueller_versionen
FROM SVS41WH_FST.W334_TH_DWH_PERSB_BUDGET
WHERE gueltig_bis = TO_DATE('31.12.9999','DD.MM.YYYY')
GROUP BY <SCHLUESSEL_SPALTE>
HAVING COUNT(*) > 1;

-- 4) Wurden alte Versionen korrekt geschlossen? Pro Schluessel sollte
-- nach Abfrage 3 maximal EINE Zeile mit Gueltig_bis = 31.12.9999 uebrig
-- bleiben -- 0 Zeilen aus Abfrage 3 = alles korrekt.
