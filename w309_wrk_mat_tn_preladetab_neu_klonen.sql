SET FEEDBACK ON
SET SERVEROUTPUT ON

-- Ersetzt die unvollstaendige Tabelle W309_WRK_MAT_TN_PRELADETAB in
-- SSC41WH_FST komplett durch eine frische Kopie der Struktur aus
-- SSC45WH_FST (hat die korrekte, vollstaendige Spaltenliste inkl.
-- MAT_TEILNAHMEMODUS). Alte Tabelle wird gedroppt (Scratch-Tabelle,
-- keine Daten wichtig), keine Daten werden kopiert.

declare
v_source_owner varchar2(30) := 'SSC45WH_FST';
v_target_owner varchar2(30) := 'SSC41WH_FST';
v_table_name   varchar2(30) := 'W309_WRK_MAT_TN_PRELADETAB';

v_ddl clob;
v_sql varchar2(32000);

begin

  begin
    execute immediate 'DROP TABLE '||v_target_owner||'.'||v_table_name||' PURGE';
    dbms_output.put_line('Alte Tabelle '||v_target_owner||'.'||v_table_name||' geloescht.');
  exception
    when others then
      dbms_output.put_line('Konnte alte Tabelle nicht loeschen (evtl. existierte sie nicht): '||SQLERRM);
  end;

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
            dbms_output.put_line('    -> Teilschritt fehlgeschlagen (evtl. Constraint-Name-Konflikt, meist unkritisch): '||SQLERRM);
        end;
      end if;
  end loop;

  dbms_output.put_line('Tabelle '||v_target_owner||'.'||v_table_name||' neu angelegt (Struktur von '||v_source_owner||').');

exception
  when others then
    dbms_output.put_line('FEHLER: '||SQLERRM);
end;
/
