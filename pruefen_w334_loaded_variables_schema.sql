-- Rein lesend: findet heraus, in welchem Schema
-- W334_LOADED_VARIABLES existieren sollte.

-- 1) Gibt es diese Tabelle ueberhaupt schon irgendwo (z.B. in der
--    Quelle oder in einem anderen Sandbox-Schema)?
SELECT owner, table_name
FROM dba_tables
WHERE table_name = 'W334_LOADED_VARIABLES'
ORDER BY owner;

-- 2) Gibt es das gleiche Muster (_LOADED_VARIABLES) fuer ANDERE
--    Ordner/Wxxx-Nummern schon in SVS41-Schemata? Das zeigt, in
--    welchem der SVS41-Zielschemata dieser Tabellentyp ueblicherweise
--    liegt.
SELECT owner, table_name
FROM dba_tables
WHERE table_name LIKE '%LOADED_VARIABLES%'
      AND owner LIKE 'SVS41%'
ORDER BY owner, table_name;

-- 3) Zum Vergleich: das gleiche Muster in den 43er-Referenz-Schemata
--    (falls B05/41 dort eine Vorlage hat)
SELECT owner, table_name
FROM dba_tables
WHERE table_name LIKE '%LOADED_VARIABLES%'
      AND owner LIKE 'SVS43%'
ORDER BY owner, table_name;
