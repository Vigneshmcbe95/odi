SET FEEDBACK ON
SET SERVEROUTPUT ON

-- Kopierskript: SSC43M_STAT_FST -> SSC41M_STAT_FST
-- Ziel ist leer, daher KEIN TRUNCATE/DROP, nur INSERT
-- Cap: max. 1000 Zeilen pro Tabelle (Test-/Entwicklungsdaten, keine Vollladung)
-- Hintergrund: Vollladung fuehrte bei grossen Tabellen (Mio. Zeilen) zu
-- ORA-01652 (TEMP-Tablespace STAT_DM_SCR voll) -- daher bewusst begrenzt.

declare
v_sql varchar(32000);

v_source_user varchar(20) := 'SSC43M_STAT_FST';
v_target_user varchar(20) := 'SSC41M_STAT_FST';

begin
  -- Session fuer parallele Verarbeitung vorbereiten
  execute immediate 'alter session enable parallel dml';
  execute immediate 'alter session enable parallel query';
  execute immediate 'alter session set parallel_degree_limit = 16';
  execute immediate 'alter session set parallel_degree_policy = auto';

  -- Nur Tabellen verarbeiten, die in Quelle UND Ziel bereits existieren
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
          group by t.owner, v_target_user, t.table_name
          order by 1, 2, 3
    ) loop

        dbms_output.put_line('=========================================================================');
        dbms_output.put_line('00 :: ' || c.target_owner || '.' || c.table_name);

        -- Max. 1000 Zeilen aus Quelltabelle in Zieltabelle einfuegen (kein Loeschen vorher!)
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
