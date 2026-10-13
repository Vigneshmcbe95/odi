-- W401 / PRC_A199_FST_TESTAUTOMAT: Prüfung fehlender Tabellen auf der B05

-- 1. Status aller vom Testautomaten benötigten Tabellen
WITH needed AS (
  SELECT 'SVS41LL_FST' owner, 'TT_FST_SZENARIO' name FROM dual UNION ALL
  SELECT 'SVS41LL_FST', 'TT_FST_REL_SF' FROM dual UNION ALL
  SELECT 'SVS41LL_FST', 'TT_FST_FALL' FROM dual UNION ALL
  SELECT 'SVS41LL_FST', 'TT_FST_ERGEBNIS' FROM dual UNION ALL
  SELECT 'SVS41LL_FST', 'TT_FST_AUFTRAG' FROM dual UNION ALL
  SELECT 'SSC41LL_FST', 'A102_PRE_TESTFALL' FROM dual
)
SELECT n.owner, n.name,
       NVL(o.object_type, '--- FEHLT / KEIN RECHT ---') status
FROM   needed n
LEFT   JOIN all_objects o
       ON o.owner = n.owner AND o.object_name = n.name
ORDER  BY status DESC, n.name;

-- 2. TT_FST-Tabellen unter allen Ownern
SELECT owner, object_name, object_type, last_ddl_time
FROM   all_objects
WHERE  object_name LIKE 'TT\_FST%' ESCAPE '\'
ORDER  BY object_name, owner;

-- 3. Ohne Rechtefilter (nur mit DBA-Rechten)
SELECT owner, table_name, num_rows
FROM   dba_tables
WHERE  table_name LIKE 'TT\_FST%' ESCAPE '\'
ORDER  BY table_name, owner;

-- 4. Rechte des ODI-Users (als DS_ESTAT-User ausführen)
SELECT table_schema, table_name, privilege
FROM   all_tab_privs
WHERE  table_name LIKE 'TT\_FST%' ESCAPE '\'
ORDER  BY table_name;

-- 5. Fehlende Tabellen in SVS41LL_FST gegenüber einem Vergleichsschema
SELECT table_name AS fehlt_in_SVS41LL_FST
FROM   all_tables
WHERE  owner = '<VERGLEICHS_OWNER>'
MINUS
SELECT table_name
FROM   all_tables
WHERE  owner = 'SVS41LL_FST'
ORDER  BY 1;

-- 6. Synonyme mit diesen Namen (inkl. PUBLIC und DB-Links); table_owner = zentrales Schema
SELECT owner, synonym_name, table_owner, table_name, db_link
FROM   all_synonyms
WHERE  synonym_name IN ('TT_FST_SZENARIO','TT_FST_REL_SF','TT_FST_FALL',
                        'TT_FST_ERGEBNIS','TT_FST_AUFTRAG')
ORDER  BY synonym_name, owner;

-- 7. Die drei Tabellen exakt in allen SVS-Schemata (Tabelle, View oder Synonym)
SELECT owner, object_name, object_type, status, last_ddl_time
FROM   all_objects
WHERE  object_name IN ('TT_FST_SZENARIO','TT_FST_REL_SF','TT_FST_FALL')
AND    owner LIKE 'SVS%'
ORDER  BY owner, object_name;

-- 8. Ohne Rechtefilter (nur mit DBA-Rechten)
SELECT owner, object_name, object_type, status
FROM   dba_objects
WHERE  object_name IN ('TT_FST_SZENARIO','TT_FST_REL_SF','TT_FST_FALL')
ORDER  BY owner, object_name;

-- 9. Vergleich: Objekttyp der funktionierenden Tabellen
SELECT owner, object_name, object_type
FROM   all_objects
WHERE  object_name IN ('TT_FST_ERGEBNIS','TT_FST_AUFTRAG')
ORDER  BY owner, object_name;
