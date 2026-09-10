SET FEEDBACK ON
SET SERVEROUTPUT ON

-- FST_VOR_INPUT_KM_TABLE fehlt in SVS41WH_FST -- existiert bereits in
-- SVS43WH_FST (und anderen Sandboxen). Einfaches Skript: Struktur per
-- GET_DDL aus 43 klonen, dann Daten 1:1 kopieren.

declare
v_source_owner varchar2(30) := 'SVS43WH_FST';
v_target_owner varchar2(30) := 'SVS41WH_FST';
v_table_name   varchar2(30) := 'FST_VOR_INPUT_KM_TABLE';

v_ddl clob;
v_sql varchar2(32000);
v_rowcnt integer;
v_exists integer;

begin

  select count(*) into v_exists
  from dba_tables
  where owner = v_target_owner and table_name = v_table_name;

  if v_exists > 0 then
    dbms_output.put_line('Tabelle existiert bereits in '||v_target_owner||' -- ueberspringe Anlage.');
  else
    dbms_lob.createtemporary(v_ddl, true);
    v_ddl := dbms_metadata.get_ddl('TABLE', v_table_name, v_source_owner);

    -- Schema im DDL auf das Zielschema umbiegen
    v_sql := replace(v_ddl, '"'||v_source_owner||'"', '"'||v_target_owner||'"');

    -- GET_DDL liefert ggf. mehrere Statements (CREATE TABLE + ALTER
    -- TABLE ... ADD PRIMARY KEY) getrennt durch ';' -- einzeln ausfuehren.
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
              dbms_output.put_line('FEHLER bei Statement: '||SQLERRM);
          end;
        end if;
    end loop;

    dbms_output.put_line('Tabelle '||v_target_owner||'.'||v_table_name||' angelegt.');
  end if;

  -- Daten 1:1 kopieren (Spaltenliste = Schnittmenge, falls doch
  -- Abweichungen bestehen)
  v_sql := 'TRUNCATE TABLE '||v_target_owner||'.'||v_table_name;
  execute immediate v_sql;

  v_sql := 'INSERT INTO '||v_target_owner||'.'||v_table_name||
           ' SELECT * FROM '||v_source_owner||'.'||v_table_name;
  execute immediate v_sql;
  v_rowcnt := sql%rowcount;
  commit;

  dbms_output.put_line('Fertig: '||v_rowcnt||' Zeilen kopiert nach '||v_target_owner||'.'||v_table_name);

exception
  when others then
    dbms_output.put_line('FEHLER: '||SQLERRM);
end;
/
