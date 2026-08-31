SET FEEDBACK ON
SET SERVEROUTPUT ON SIZE UNLIMITED

-- Retargeted von tabellen_kopieren_psd1_svs44_dwh.sql
-- Quelle bleibt PSD1_DWH_FST, Ziel neu: SVS41WH_FST
-- Cap: max. 1000 Zeilen pro Tabelle. Nur Spalten, die in Quelle UND Ziel
-- existieren (vermeidet ORA-00904 bei abweichender Tabellenstruktur).

declare
v_sql varchar(32000);
v_ddl varchar(32000);

v_execute boolean := true;

v_source_user varchar(20) := 'PSD1_DWH_FST';
v_target_user varchar(20) := 'SVS41WH_FST';

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
                and t.table_name not like 'FST_VOR_INPUT%'
                and t.table_name not like 'TD%AFOE%'
                and t.table_name not like 'TD%AFTLN%'
                and t.table_name not like 'TH_DWH_AFTLN_%'
                and t.table_name not like 'TH_DWH_MODUL_MNBEZ_BH_ALT%'
                and t.table_name not like '%OLD'
                and t.table_name not like '%SAV'
                and t.table_name not like '%SICH'
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

    end loop;
end;
/
