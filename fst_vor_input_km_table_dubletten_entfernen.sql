-- Das Kopierskript wurde 2x ausgefuehrt und hat KEINE Duplikatpruefung
-- -- SVS41WH_FST.FST_VOR_INPUT_KM_TABLE hat sich dadurch von 934 auf
-- 2802 Zeilen verdreifacht (echte Daten + 2 Kopien). Entfernt die
-- Duplikate, behaelt pro VARIABLE_ID nur eine Zeile.

-- 1) Ist-Stand vorher.
SELECT COUNT(*) AS gesamt, COUNT(DISTINCT variable_id) AS eindeutig
FROM SVS41WH_FST.FST_VOR_INPUT_KM_TABLE;

-- 2) Duplikate loeschen -- behaelt die Zeile mit der kleinsten ROWID
--    pro VARIABLE_ID, loescht den Rest.
DELETE FROM SVS41WH_FST.FST_VOR_INPUT_KM_TABLE a
WHERE a.rowid > (
    SELECT MIN(b.rowid)
    FROM SVS41WH_FST.FST_VOR_INPUT_KM_TABLE b
    WHERE b.variable_id = a.variable_id
);

COMMIT;

-- 3) Kontrolle nachher -- gesamt sollte jetzt gleich eindeutig sein.
SELECT COUNT(*) AS gesamt, COUNT(DISTINCT variable_id) AS eindeutig
FROM SVS41WH_FST.FST_VOR_INPUT_KM_TABLE;
