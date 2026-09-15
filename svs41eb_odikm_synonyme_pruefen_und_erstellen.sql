-- Der alte HIST5D-Modul-Code (W309, Legacy) referenziert
-- SVS41EB_ODIKM Tabellen fest im SQL-Text (nicht ueber Kontext/
-- logisches Schema aufgeloest). SVS41EB_ODIKM wurde fuer B05 aber
-- bewusst NICHT mit eigenen Tabellen aufgebaut -- der Kontext zeigt
-- stattdessen direkt auf THM_UEB_ODIKM. Fix: Synonyme in
-- SVS41EB_ODIKM anlegen, die auf THM_UEB_ODIKM zeigen -- gleiches
-- Muster wie bei SVS41WH_UEB_DIM.

-- 1) Rein lesend: existiert das Schema SVS41EB_ODIKM ueberhaupt, und
--    welche der vom Fehler benoetigten Tabellen fehlen dort?
SELECT tab.table_name,
       CASE WHEN EXISTS (
         SELECT 1 FROM dba_tables t WHERE t.owner = 'SVS41EB_ODIKM' AND t.table_name = tab.table_name
       ) THEN 'VORHANDEN (Tabelle)'
       WHEN EXISTS (
         SELECT 1 FROM dba_synonyms s WHERE s.owner = 'SVS41EB_ODIKM' AND s.synonym_name = tab.table_name
       ) THEN 'VORHANDEN (Synonym)'
       ELSE 'FEHLT'
       END AS status,
       CASE WHEN EXISTS (
         SELECT 1 FROM dba_tables t WHERE t.owner = 'THM_UEB_ODIKM' AND t.table_name = tab.table_name
       ) THEN 'JA' ELSE 'NEIN' END AS existiert_in_thm_ueb_odikm
FROM (
      SELECT 'LFST_UPD5D_MN_LADETAB' AS table_name FROM dual UNION ALL
      SELECT 'GFST_STPARAM_HIST5D' FROM dual UNION ALL
      SELECT 'PROT_KM_USING' FROM dual UNION ALL
      SELECT 'LFST_Z5DEX_MN_LADETAB' FROM dual
     ) tab;

-- 2) Fehlende Synonyme anlegen (nur die, die laut Abfrage 1 "FEHLT"
--    zeigen und in THM_UEB_ODIKM tatsaechlich existieren).
declare
  procedure syn_anlegen(p_name varchar2) is
    v_exists integer;
  begin
    select count(*) into v_exists from dba_synonyms
    where owner = 'SVS41EB_ODIKM' and synonym_name = p_name;
    if v_exists > 0 then
      dbms_output.put_line('Synonym '||p_name||' existiert bereits -- uebersprungen.');
      return;
    end if;
    execute immediate 'CREATE SYNONYM SVS41EB_ODIKM.'||p_name||' FOR THM_UEB_ODIKM.'||p_name;
    execute immediate 'GRANT SELECT ON THM_UEB_ODIKM.'||p_name||' TO SVS41EB_ODIKM';
    dbms_output.put_line('Synonym '||p_name||' -> THM_UEB_ODIKM angelegt.');
  exception
    when others then
      dbms_output.put_line('FEHLER bei '||p_name||': '||SQLERRM);
  end;
begin
  syn_anlegen('LFST_UPD5D_MN_LADETAB');
  syn_anlegen('GFST_STPARAM_HIST5D');
  syn_anlegen('PROT_KM_USING');
  syn_anlegen('LFST_Z5DEX_MN_LADETAB');
end;
/
