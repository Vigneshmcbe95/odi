-- Prüfung ANO1_DWL_FST: komplett leere Spalten (z. B. KMN_ID in TL_DWL_BNFA)
-- Voraussetzung: aktuelle Statistiken auf ANO1_DWL_FST

-- 1. Spalten, die in befüllten Tabellen vollständig NULL sind
SELECT table_name, column_name, num_nulls, num_distinct
FROM   all_tab_columns c
JOIN   all_tables t USING (owner, table_name)
WHERE  owner = 'ANO1_DWL_FST'
AND    t.num_rows > 0
AND    c.num_nulls = t.num_rows
ORDER  BY table_name, column_name;

-- 2. Schnellprüfung der Schlüsselspalten in TL_DWL_BNFA
SELECT COUNT(*) total, COUNT(KMN_ID) kmn, COUNT(BNF_ID) bnf
FROM   ANO1_DWL_FST.TL_DWL_BNFA;

-- 3. Statistiken aktualisieren, falls Abfrage 1 keine Zeilen liefert (Rechte erforderlich)
-- EXEC DBMS_STATS.GATHER_SCHEMA_STATS('ANO1_DWL_FST');

-- 4. KMN_ID je Monat prüfen (Mapping filtert auf META_MON_ID = #GLOBAL.GV_MON_ID)
SELECT META_MON_ID, COUNT(*) total, COUNT(KMN_ID) kmn
FROM   ANO1_DWL_FST.TL_DWL_BNFA
GROUP  BY META_MON_ID
ORDER  BY META_MON_ID DESC;
