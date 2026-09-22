-- ORA-12801 (Fehler in parallelem Abfrage-Server) beim W309-SET-LOCAL-
-- VARIABLES-Lauf, Variable DBA_BA, Quelle SVS41WH_UEB_DIM.TD_DWH_BERAUSB_B.
-- Keine tiefere "Caused by"-Zeile sichtbar -- Verdacht: SVS41WH_UEB_DIM
-- besteht komplett aus Synonymen auf THM_DWH_UEB_DIM (siehe
-- synonyme_erstellen_svs41wh_ueb_dim.sql, 1537 Synonyme erstellt).
-- Pruefen, ob genau dieses Synonym/diese Tabelle gueltig ist.

-- 1) Existiert das Objekt, welcher Typ (TABLE oder SYNONYM), Status?
SELECT owner, object_name, object_type, status
FROM dba_objects
WHERE owner = 'SVS41WH_UEB_DIM'
      AND object_name = 'TD_DWH_BERAUSB_B';

-- 2) Falls SYNONYM -- worauf zeigt es genau?
SELECT owner, synonym_name, table_owner, table_name, db_link
FROM dba_synonyms
WHERE owner = 'SVS41WH_UEB_DIM'
      AND synonym_name = 'TD_DWH_BERAUSB_B';

-- 3) Ist das Zielobjekt (aus Schritt 2) selbst gueltig und vorhanden?
--    <owner>/<table_name> aus Schritt 2 hier eintragen:
-- SELECT owner, object_name, object_type, status
-- FROM dba_objects
-- WHERE owner = '<table_owner_aus_schritt_2>'
--       AND object_name = '<table_name_aus_schritt_2>';

-- 4) Testweise OHNE Parallel-Hint direkt selektieren -- zeigt den
--    echten Fehler, falls die ORA-12801-Huelle den wirklichen Fehler
--    verschluckt hat.
SELECT dba_id
FROM SVS41WH_UEB_DIM.TD_DWH_BERAUSB_B
WHERE dba_ba_schl = 'BA';

-- 5) Falls Schritt 4 funktioniert (kein Fehler) -- Parallelitaet ist
--    der Ausloeser, nicht die Daten/Struktur. Pruefen, ob die Tabelle/
--    das Zielobjekt einen PARALLEL-Grad gesetzt hat, der auf dieser
--    kleinen Sandbox-DB nicht bedienbar ist:
-- SELECT table_name, degree, instances
-- FROM dba_tables
-- WHERE table_name = '<table_name_aus_schritt_2>'
--       AND owner = '<table_owner_aus_schritt_2>';
