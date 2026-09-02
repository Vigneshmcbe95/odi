SET FEEDBACK ON
SET SERVEROUTPUT ON SIZE UNLIMITED

-- Ziel: SVS41M_STAT_FST, Quelle: THM_DM_STAT_FST
-- Vereinfacht: kein manuelles ADD PARTITION/SET INTERVAL mehr -- die
-- urspruengliche Monats-Partitionslogik brach auf vielen Tabellen mit
-- ORA-06502/ORA-14760. Stattdessen einfacher INSERT mit Zeilenlimit,
-- gleiches Muster wie bei den Scratch-Schemata: Partitionen, die beim
-- Klonen der Struktur bereits uebernommen wurden, werden von Oracle
-- automatisch beim INSERT getroffen. Fehlt eine Partition wirklich,
-- kommt ein klarer ORA-14400 fuer genau diese Tabelle statt eines
-- verwirrenden Fehlers in der Monats-Arithmetik.
-- Cap: max. 1000 Zeilen pro Tabelle. Nur Spalten, die in Quelle UND Ziel
-- existieren (vermeidet ORA-00904 bei abweichender Tabellenstruktur).

declare
v_sql varchar(32000);
v_errmsg varchar2(4000);

v_source_user varchar(30) := 'THM_DM_STAT_FST';
v_target_user varchar(30) := 'SVS41M_STAT_FST';

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
                and t.table_name not like 'FST_DM_VOR_INPUT%'
                and t.table_name not like 'TT_DM_FST_META'
                and t.table_name not like 'TE%'
                and t.table_name not like 'TP_FST%'
                and t.table_name not like 'TG_FST_FF%'
                and t.table_name not like 'TG_FST_TRG%'
                and t.table_name not like 'TF_FST_AFOEAN%'
                and t.table_name not like 'TF_FST_%BAK'
                and t.table_name not like 'TF_FST_%OLD'
                and t.table_name not like 'TF_FST_%SAV'
                and t.table_name not like 'TF_FST_%SICH'
                and t.table_name not like 'TF_FST_%TEMP'
                and tc.column_name in (
                                    select tc2.column_name
                                    from dba_tab_columns tc2
                                    where tc2.owner = v_target_user
                                          and tc2.table_name = t.table_name
                                    )
          group by t.owner, v_target_user, t.table_name
          order by 1, 2, 3
    ) loop

        begin
          v_sql := 'INSERT /*+ APPEND PARALLEL*/ INTO ' || c.target_owner || '.' || c.table_name ||
                   ' (' || c.attr_list || ') ' ||
                   'SELECT ' || c.attr_list || ' FROM ' || c.source_owner || '.' || c.table_name ||
                   ' FETCH FIRST 1000 ROWS ONLY';

          execute immediate v_sql;
          dbms_output.put_line('03 :: ' || c.target_owner || '.' || c.table_name ||
                                ' -> ' || to_char(sql%rowcount) || ' Zeilen eingefuegt.');

          -- Live-Protokoll: sofort committen, damit eine zweite Session
          -- den Fortschritt live sehen kann (DBMS_OUTPUT allein wird
          -- von den meisten SQL-Tools erst am Ende des Laufs angezeigt).
          insert into ladeprotokoll (ziel_schema, tabelle, status, zeilen)
          values (c.target_owner, c.table_name, 'OK', sql%rowcount);
          commit;

        exception
          when others then
            v_errmsg := SQLERRM;
            dbms_output.put_line('FEHLER bei ' || c.target_owner || '.' || c.table_name || ' - ' || v_errmsg);
            insert into ladeprotokoll (ziel_schema, tabelle, status, meldung)
            values (c.target_owner, c.table_name, 'FEHLER', v_errmsg);
            commit;
        end;

    end loop;

  dbms_output.put_line('Kopiervorgang abgeschlossen.');

end;
/
