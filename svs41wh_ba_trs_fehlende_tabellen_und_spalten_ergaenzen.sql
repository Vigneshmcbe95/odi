SET FEEDBACK ON
SET SERVEROUTPUT ON

-- Ergaenzt SVS41WH_BA_TRS gegen THM_DWH_BA_TRS, OHNE je etwas zu
-- droppen -- persistentes Schema, kein Datenverlust-Risiko:
-- 1) Tabellen, die komplett fehlen, werden neu angelegt (leer).
-- 2) Tabellen, die existieren, aber einzelne Spalten fehlen (wie
--    TH_DWH_MASSNAHME_AGH_TAET_TRS.HTX_GUELT_BIS_DAT), bekommen die
--    fehlenden Spalten per ALTER TABLE ADD ergaenzt -- bestehende
--    Daten bleiben unberuehrt.

declare
v_source_owner varchar2(30) := 'THM_DWH_BA_TRS';
v_target_owner varchar2(30) := 'SVS41WH_BA_TRS';

v_ddl clob;
v_sql varchar2(32000);
v_tabellen_neu integer := 0;
v_spalten_ergaenzt integer := 0;
v_fehler integer := 0;
v_exists integer;
begin

  for t in (
        select table_name
        from dba_tables
        where owner = v_source_owner
        order by table_name
    ) loop

      select count(*) into v_exists
      from dba_tables
      where owner = v_target_owner and table_name = t.table_name;

      if v_exists = 0 then
        -- Tabelle fehlt komplett -- neu anlegen.
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
                    dbms_output.put_line('    -> Teilschritt fehlgeschlagen fuer '||t.table_name||': '||SQLERRM);
                end;
              end if;
          end loop;

          dbms_output.put_line('NEU :: '||v_target_owner||'.'||t.table_name||' angelegt (war komplett fehlend).');
          v_tabellen_neu := v_tabellen_neu + 1;

        exception
          when others then
            dbms_output.put_line('FEHLER (neu) :: '||t.table_name||' -- '||SQLERRM);
            v_fehler := v_fehler + 1;
        end;

      else
        -- Tabelle existiert -- fehlende Spalten einzeln ergaenzen.
        for c in (
              select tc.column_name, tc.data_type, tc.data_length,
                     tc.data_precision, tc.data_scale
              from dba_tab_columns tc
              where tc.owner = v_source_owner
                    and tc.table_name = t.table_name
                    and tc.column_name not in (
                          select column_name
                          from dba_tab_columns
                          where owner = v_target_owner
                                and table_name = t.table_name
                        )
          ) loop

            begin
              if c.data_type in ('VARCHAR2','CHAR','NVARCHAR2','NCHAR') then
                execute immediate 'ALTER TABLE '||v_target_owner||'.'||t.table_name||
                  ' ADD ('||c.column_name||' '||c.data_type||'('||c.data_length||'))';
              elsif c.data_type = 'NUMBER' and c.data_precision is not null then
                execute immediate 'ALTER TABLE '||v_target_owner||'.'||t.table_name||
                  ' ADD ('||c.column_name||' NUMBER('||c.data_precision||','||NVL(c.data_scale,0)||'))';
              else
                execute immediate 'ALTER TABLE '||v_target_owner||'.'||t.table_name||
                  ' ADD ('||c.column_name||' '||c.data_type||')';
              end if;

              dbms_output.put_line('SPALTE :: '||v_target_owner||'.'||t.table_name||'.'||c.column_name||' ergaenzt.');
              v_spalten_ergaenzt := v_spalten_ergaenzt + 1;

            exception
              when others then
                dbms_output.put_line('FEHLER (Spalte) :: '||t.table_name||'.'||c.column_name||' -- '||SQLERRM);
                v_fehler := v_fehler + 1;
            end;

        end loop;

      end if;

    end loop;

  dbms_output.put_line('=========================================================================');
  dbms_output.put_line('Fertig. Neue Tabellen: '||v_tabellen_neu||', Ergaenzte Spalten: '||v_spalten_ergaenzt||', Fehlgeschlagen: '||v_fehler);

end;
/
