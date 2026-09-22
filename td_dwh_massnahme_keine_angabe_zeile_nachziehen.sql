-- Fehlende Platzhalterzeile KMD_ID=-1 (KMD_COSACHNT_SCHL='KEINE ANGABE')
-- in SVS41WH_FST.TD_DWH_MASSNAHME nachziehen -- war der Grund, warum
-- KMD_KA in W310_loaded_variables leer blieb (0 Treffer statt der
-- erwarteten Platzhalter-ID). Quelle: THM_DWH_FST (bestaetigt vorhanden).
--
-- Persistente Tabelle -- kein Drop/Truncate, nur die eine fehlende
-- Zeile gezielt ergaenzen.

INSERT INTO SVS41WH_FST.TD_DWH_MASSNAHME
SELECT *
FROM THM_DWH_FST.TD_DWH_MASSNAHME
WHERE kmd_id = -1
      AND NOT EXISTS (
        SELECT 1 FROM SVS41WH_FST.TD_DWH_MASSNAHME t
        WHERE t.kmd_id = -1
      );

COMMIT;

-- Kontrolle: KMD_KA-Query sollte jetzt eine Zeile liefern.
SELECT kmd_id
FROM SVS41WH_FST.TD_DWH_MASSNAHME
WHERE UPPER(kmd_cosachnt_schl) LIKE 'KEINE ANGABE%';
