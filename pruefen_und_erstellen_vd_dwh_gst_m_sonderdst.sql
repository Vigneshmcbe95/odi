-- 1) Rein lesend: wo existiert diese View bereits (zum Vergleich/als
--    Quelle fuer den Klon)?
SELECT owner, view_name
FROM dba_views
WHERE view_name = 'VD_DWH_GST_M_SONDERDST'
ORDER BY owner;

-- 2) Falls sie z.B. in SVS43WH_FST (oder THM_DWH_FST) existiert:
--    View-Definition per GET_DDL holen und in SVS41WH_FST anlegen.
--    <QUELLE_HIER_EINTRAGEN> mit dem tatsaechlichen Owner aus Abfrage 1
--    ersetzen.
declare
v_source_owner varchar2(30) := '<QUELLE_HIER_EINTRAGEN>';  -- z.B. 'SVS43WH_FST' oder 'THM_DWH_FST'
v_target_owner varchar2(30) := 'SVS41WH_FST';
v_view_name    varchar2(30) := 'VD_DWH_GST_M_SONDERDST';

v_ddl clob;
v_sql varchar2(32000);
v_exists integer;

begin
  select count(*) into v_exists
  from dba_views
  where owner = v_target_owner and view_name = v_view_name;

  if v_exists > 0 then
    dbms_output.put_line('View existiert bereits in '||v_target_owner||'.');
    return;
  end if;

  v_ddl := dbms_metadata.get_ddl('VIEW', v_view_name, v_source_owner);
  v_sql := replace(v_ddl, '"'||v_source_owner||'"', '"'||v_target_owner||'"');

  -- CREATE VIEW Statement -- trailenden Terminator entfernen, falls vorhanden
  v_sql := rtrim(v_sql);
  if substr(v_sql, -1) = ';' then
    v_sql := substr(v_sql, 1, length(v_sql) - 1);
  end if;

  execute immediate v_sql;
  dbms_output.put_line('View '||v_target_owner||'.'||v_view_name||' angelegt.');

exception
  when others then
    dbms_output.put_line('FEHLER: '||SQLERRM);
end;
/
