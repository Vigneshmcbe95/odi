SET FEEDBACK ON
SET SERVEROUTPUT ON

-- Scratch-Schema Datenladen: SSC41WH_FST
-- Quelle: SCR_DWH_FST (Basisschema, nicht der 43er-Sandbox-Peer)
-- Ziel ist leer, daher KEIN TRUNCATE/DROP, nur INSERT.
-- Cap: max. 1000 Zeilen pro Tabelle. Nur Spalten, die in Quelle UND Ziel
-- existieren (vermeidet ORA-00904 bei abweichender Tabellenstruktur).

declare
v_sql varchar(32000);

v_source_user varchar(30) := 'SCR_DWH_FST';
v_target_user varchar(30) := 'SSC41WH_FST';

begin
  execute immediate 'alter session enable parallel dml';
  execute immediate 'alter session enable parallel query';
  execute immediate 'alter session set parallel_degree_limit = 16';
  execute immediate 'alter session set parallel_degree_policy = auto';

  for c in (
         select t.owner source_owner
               , v_target_user target_owner
               , t.table_name
               , listagg(tc.column_name, ', ') within group (order by tc.column_id) attr_list
          from dba_tables t
               join dba_tab_columns tc on t.owner = tc.owner and t.table_name = tc.table_name
          where t.owner = v_source_user
                and t.table_name in (
                                    select s.table_name
                                    from dba_tables s
                                    where s.owner = v_target_user
                                    )
                and tc.column_name in (
                                    select tc2.column_name
                                    from dba_tab_columns tc2
                                    where tc2.owner = v_target_user
                                          and tc2.table_name = t.table_name
                                    )
          group by t.owner, v_target_user, t.table_name
          order by 1, 2, 3
    ) loop

        dbms_output.put_line('=========================================================================');
        dbms_output.put_line('00 :: ' || c.target_owner || '.' || c.table_name);

        v_sql := 'INSERT /*+ APPEND PARALLEL*/ INTO ' || c.target_owner || '.' || c.table_name ||
                 ' (' || c.attr_list || ') ' ||
                 'SELECT ' || c.attr_list || ' FROM ' || c.source_owner || '.' || c.table_name ||
                 ' FETCH FIRST 1000 ROWS ONLY';

        dbms_output.put_line('01 :: ' || v_sql);

        execute immediate v_sql;
        dbms_output.put_line('02 :: ' || c.target_owner || '.' || c.table_name ||
                              ' -> ' || to_char(sql%rowcount) || ' Zeilen eingefuegt.');
        commit;

    end loop;

  dbms_output.put_line('=========================================================================');
  dbms_output.put_line('Kopiervorgang abgeschlossen.');

end;
/
