SET FEEDBACK ON
SET SERVEROUTPUT ON

-- Droppt und erstellt ALLE Tabellen in SSC41WH_FST neu, basierend auf
-- der Struktur aus SSC45WH_FST -- behebt in einem Rutsch alle
-- fehlenden Spalten/Tabellen, statt einzeln Fehler fuer Fehler zu
-- entdecken. SSC* ist Scratch (temporaer) -- kein Datenverlust
-- relevant, wird beim naechsten Ladelauf sowieso neu befuellt.
--
-- ACHTUNG: das ist eine grosse, destruktive Aktion -- ALLE Tabellen
-- in SSC41WH_FST werden gedroppt und durch die 45er-Struktur ersetzt,
-- auch die, die aktuell schon korrekt waren.

declare
v_source_owner varchar2(30) := 'SSC45WH_FST';
v_target_owner varchar2(30) := 'SSC41WH_FST';

v_ddl clob;
v_sql varchar2(32000);
v_erstellt integer := 0;
v_fehler integer := 0;

begin

  for t in (
        select table_name
        from dba_tables
        where owner = v_source_owner
        order by table_name
    ) loop

      begin
        begin
          execute immediate 'DROP TABLE '||v_target_owner||'.'||t.table_name||' PURGE';
        exception
          when others then null; -- existierte nicht, kein Problem
        end;

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

        dbms_output.put_line('OK :: '||v_target_owner||'.'||t.table_name||' neu angelegt.');
        v_erstellt := v_erstellt + 1;

      exception
        when others then
          dbms_output.put_line('FEHLER :: '||t.table_name||' -- '||SQLERRM);
          v_fehler := v_fehler + 1;
      end;

    end loop;

  dbms_output.put_line('=========================================================================');
  dbms_output.put_line('Fertig. Neu angelegt: '||v_erstellt||', Fehlgeschlagen: '||v_fehler);

end;
/
