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
