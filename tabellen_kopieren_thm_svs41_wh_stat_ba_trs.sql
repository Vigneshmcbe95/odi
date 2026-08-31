SET FEEDBACK ON
SET SERVEROUTPUT ON SIZE UNLIMITED

-- Retargeted von tabellen_kopieren_xro_thm_dwh_stat_ba_trs.sql
-- Quelle bleibt XRO_DWH_STAT_BA_TRS, Ziel neu: SVS41WH_STAT_BA_TRS
-- Cap: max. 1000 Zeilen pro Tabelle. Nur Spalten, die in Quelle UND Ziel
-- existieren (vermeidet ORA-00904 bei abweichender Tabellenstruktur).

declare
v_sql varchar(32000);
v_ddl varchar(32000);

v_execute boolean := true;

v_source_user varchar(20) := 'THM_DWH_STAT_BA_TRS';
v_target_user varchar(20) := 'SVS41WH_STAT_BA_TRS';

begin
  execute immediate 'alter session enable parallel ddl';
  execute immediate 'alter session enable parallel dml';
  execute immediate 'alter session enable parallel query';
  execute immediate 'alter session set parallel_degree_limit = 16';
  execute immediate 'alter session set parallel_degree_policy = auto';

  for c in (
         select t.owner source_owner
               , v_target_user target_owner
               , t.table_name
               , listagg(tc.column_name,', ') within group (order by tc.column_id) attr_list
          from dba_tables t
               join dba_tab_columns tc on t.owner = tc.owner and t.table_name = tc.table_name
          where t.owner = v_source_user
                and t.table_name in (
                                    select s.table_name
                                    from dba_tables s
                                    where s.owner = v_target_user
                                    )
                and t.table_name like 'TT_DWH_DFO_STRNR'
                -- nur Spalten, die auch im Zielschema existieren
                and tc.column_name in (
                                    select tc2.column_name
                                    from dba_tab_columns tc2
                                    where tc2.owner = v_target_user
                                          and tc2.table_name = t.table_name
                                    )
          group by t.owner, v_target_user, t.table_name
          order by 1,2,3
    ) loop



        begin
          v_ddl := 'TRUNCATE TABLE '||c.target_owner||'.'||c.table_name;

          if v_execute then
            execute immediate v_ddl;
          end if;

          v_sql := 'INSERT /*+ APPEND PARALLEL*/ INTO '||c.target_owner||'.'||c.table_name||' ('||c.attr_list||') '||
                   'SELECT '||c.attr_list||' FROM '||c.source_owner||'.'||c.table_name||
                   ' FETCH FIRST 1000 ROWS ONLY';

          if v_execute then
            execute immediate v_sql;
            dbms_output.put_line('03 :: '||c.target_owner||'.'||c.table_name||' Inserted '||to_char(sql%rowcount)||' rows.');
            commit;
          end if;

        exception
          when others then
            dbms_output.put_line('FEHLER bei '||c.target_owner||'.'||c.table_name||' - '||SQLERRM);
        end;

    end loop;
end;
/
