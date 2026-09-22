-- Testet die KMD_KA-Wert-Query direkt gegen B05, um zu bestaetigen,
-- ob sie tatsaechlich 0 Zeilen liefert (Vermutung: die spezielle
-- "KEINE ANGABE"-Platzhalterzeile fehlt in SVS41WH_FST.TD_DWH_MASSNAHME).
--
-- LS_THM_DWH_FST. wurde per get_replace_lschema-Logik zu SVS41WH_FST.
-- aufgeloest (fuer B05/Sandbox 41).

-- 1) Die eigentliche Wert-Query, so wie der Job sie ausfuehren wuerde.
SELECT kmd_id
FROM SVS41WH_FST.TD_DWH_MASSNAHME
WHERE UPPER(kmd_cosachnt_schl) LIKE 'KEINE ANGABE%';

-- 2) Zum Vergleich: gibt es die Platzhalterzeile in der echten
--    THM_DWH_FST (Referenz/Produktion)?
SELECT kmd_id, kmd_cosachnt_schl
FROM THM_DWH_FST.TD_DWH_MASSNAHME
WHERE UPPER(kmd_cosachnt_schl) LIKE 'KEINE ANGABE%';

-- 3) Falls Schritt 2 eine Zeile findet und Schritt 1 nicht -- die
--    fehlende Zeile pruefen/nachziehen (NICHT blind kopieren, da
--    KMD_ID evtl. an andere Tabellen/Constraints gebunden ist --
--    erst Struktur/Bedeutung der Zeile in Schritt 2 ansehen).
