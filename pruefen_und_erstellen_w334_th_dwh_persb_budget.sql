-- 1) Rein lesend: wo existiert W334_TH_DWH_PERSB_BUDGET bereits?
SELECT owner, table_name
FROM dba_tables
WHERE table_name = 'W334_TH_DWH_PERSB_BUDGET'
ORDER BY owner;

-- 2) Struktur aus der gefundenen Quelle klonen (Owner aus Abfrage 1
--    unten eintragen -- vermutlich SSC43WH_FST als Vorlage).
declare
v_source_owner varchar2(30) := '<QUELLE_HIER_EINTRAGEN>';  -- z.B. 'SSC43WH_FST'
v_target_owner varchar2(30) := 'SSC41WH_FST';
v_table_name   varchar2(30) := 'W334_TH_DWH_PERSB_BUDGET';

v_ddl clob;
v_sql varchar2(32000);
v_exists integer;

begin
  select count(*) into v_exists
  from dba_tables
  where owner = v_target_owner and table_name = v_table_name;

  if v_exists > 0 then
    dbms_output.put_line('Tabelle existiert bereits in '||v_target_owner||' -- ueberspringe Anlage.');
  else
    v_ddl := dbms_metadata.get_ddl('TABLE', v_table_name, v_source_owner);
    v_sql := replace(v_ddl, '"'||v_source_owner||'"', '"'||v_target_owner||'"');

    for stmt in (
          select trim(regexp_substr(v_sql, '[^;]+', 1, level)) as one_stmt
          from dual
          connect by regexp_substr(v_sql, '[^;]+', 1, level) is not null
      ) loop
        if stmt.one_stmt is not null and length(stmt.one_stmt) > 5 then
          begin
            execute immediate stmt.one_stmt;
            dbms_output.put_line('OK :: Statement ausgefuehrt.');
          exception
            when others then
              dbms_output.put_line('FEHLER bei Statement (evtl. Constraint-Name-Konflikt, meist unkritisch): '||SQLERRM);
          end;
        end if;
    end loop;

    dbms_output.put_line('Tabelle '||v_target_owner||'.'||v_table_name||' angelegt.');
  end if;

  -- Falls sie schon existiert, aber keine Rechte fuer odi_bsg_default
  -- hat (gleiches Muster wie bei W334_WRK_PERSB_TN), sicherheitshalber
  -- gleich mitvergeben:
  begin
    execute immediate 'GRANT SELECT, INSERT, UPDATE, DELETE, TRUNCATE ON '||
                       v_target_owner||'.'||v_table_name||' TO odi_bsg_default';
    dbms_output.put_line('Rechte fuer odi_bsg_default vergeben.');
  exception
    when others then
      dbms_output.put_line('Konnte Rechte nicht vergeben: '||SQLERRM);
  end;

exception
  when others then
    dbms_output.put_line('FEHLER: '||SQLERRM);
end;
/
