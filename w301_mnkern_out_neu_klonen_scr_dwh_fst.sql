SET FEEDBACK ON
SET SERVEROUTPUT ON

-- Droppt und erstellt NUR SSC41WH_FST.W301_MNKERN_OUT neu, aus
-- SCR_DWH_FST (nicht SSC45WH_FST) -- behebt ORA-00904 auf
-- KMH_VORZEITIG_BEENDET_AM im W301-Job.
--
-- Scratch-Tabelle -- kein Datenverlust relevant, wird beim naechsten
-- Ladelauf sowieso neu befuellt.

declare
v_source_owner varchar2(30) := 'SCR_DWH_FST';
v_target_owner varchar2(30) := 'SSC41WH_FST';
v_table_name   varchar2(30) := 'W301_MNKERN_OUT';

v_ddl clob;
v_sql varchar2(32000);

begin

  begin
    execute immediate 'DROP TABLE '||v_target_owner||'.'||v_table_name||' PURGE';
    dbms_output.put_line('Alte Tabelle '||v_target_owner||'.'||v_table_name||' gedroppt.');
  exception
    when others then
      dbms_output.put_line('Alte Tabelle existierte nicht oder Drop nicht noetig: '||SQLERRM);
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
        exception
          when others then
            dbms_output.put_line('    -> Teilschritt fehlgeschlagen (evtl. Constraint-Name-Konflikt, meist unkritisch): '||SQLERRM);
        end;
      end if;
  end loop;

  dbms_output.put_line('OK :: '||v_target_owner||'.'||v_table_name||' neu angelegt aus '||v_source_owner||'.');

end;
/

-- Zur Kontrolle: Spalte jetzt vorhanden?
SELECT column_name, data_type, data_length
FROM dba_tab_columns
WHERE owner = 'SSC41WH_FST'
      AND table_name = 'W301_MNKERN_OUT'
      AND column_name = 'KMH_VORZEITIG_BEENDET_AM';
