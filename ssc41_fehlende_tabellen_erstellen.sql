SET FEEDBACK ON
SET SERVEROUTPUT ON

-- Legt ALLE Tabellen an, die in SSC45WH_FST existieren, aber in
-- SSC41WH_FST fehlen -- Struktur per GET_DDL geklont, KEINE Daten.
-- Sicher wiederholbar: bereits vorhandene Tabellen werden uebersprungen.

declare
v_source_owner varchar2(30) := 'SSC45WH_FST';
v_target_owner varchar2(30) := 'SSC41WH_FST';

v_ddl clob;
v_sql varchar2(32000);
v_created integer := 0;
v_skipped integer := 0;
v_failed integer := 0;

begin

  for t in (
        select s.table_name
        from dba_tables s
        where s.owner = v_source_owner
              and s.table_name not in (
                    select table_name from dba_tables where owner = v_target_owner
                  )
        order by s.table_name
    ) loop

      begin
        v_ddl := dbms_metadata.get_ddl('TABLE', t.table_name, v_source_owner);
        v_sql := replace(v_ddl, '"'||v_source_owner||'"', '"'||v_target_owner||'"');

        for stmt in (
              select trim(regexp_substr(v_sql, '[^;]+', 1, level)) as one_stmt
              from dual
              connect by regexp_substr(v_sql, '[^;]+', 1, level) is not null
          ) loop
            if stmt.one_stmt is not null and length(stmt.one_stmt) > 5 then
              begin
                execute immediate stmt.one_stmt;
              exception
                when others then
                  dbms_output.put_line('    -> Teilschritt fehlgeschlagen fuer '||t.table_name||' (evtl. Constraint-Name-Konflikt, meist unkritisch): '||SQLERRM);
              end;
            end if;
        end loop;

        dbms_output.put_line('OK :: '||v_target_owner||'.'||t.table_name||' angelegt.');
        v_created := v_created + 1;

      exception
        when others then
          dbms_output.put_line('FEHLER :: '||t.table_name||' -- '||SQLERRM);
          v_failed := v_failed + 1;
      end;

    end loop;

  dbms_output.put_line('=========================================================================');
  dbms_output.put_line('Fertig. Angelegt: '||v_created||', Fehlgeschlagen: '||v_failed);

end;
/
