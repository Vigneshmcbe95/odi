SET FEEDBACK ON
SET SERVEROUTPUT ON

-- Vollladung SVS41WL_FST, Quelle PSD1_DWL_FST.
-- Basiert auf dataload_generisch_alle_schemas.sql, mit Quelle/Ziel
-- fest eingetragen.
--
-- Die 5 Tabellen mit LAENGE_ZU_KLEIN (TL_DWL_AUWM, TL_DWL_BVBM,
-- TL_DWL_KNGS, TL_DWL_KPBT, TL_DWL_BVBT) sind NICHT mehr ausgeschlossen
-- -- die betroffenen Spalten wurden per svs41wl_fst_spalten_anpassen.sql
-- auf die Quell-Laenge vergroessert.
--
-- TL_DWL_SOZT (SZT_ED: Quelle DATE vs. Ziel TIMESTAMP(6) -- TYP_MISMATCH,
-- kein Laengenproblem) bleibt weiterhin ausgeschlossen, bis bestaetigt
-- ist, dass die implizite DATE->TIMESTAMP-Konvertierung beim Insert
-- keine Probleme macht.

declare
v_sql varchar2(32000);
v_ddl varchar2(32000);
v_errmsg varchar2(4000);
v_rowcnt integer;
v_insert_cols varchar2(32000);
v_select_cols varchar2(32000);
v_part_count integer;
v_interval varchar2(1000);

v_execute boolean := true;

v_source_user varchar2(30) := 'PSD1_DWL_FST';
v_target_user varchar2(30) := 'SVS41WL_FST';

v_table_count integer := 0;

begin

  execute immediate 'alter session enable parallel ddl';
  execute immediate 'alter session enable parallel dml';
  execute immediate 'alter session enable parallel query';
  execute immediate 'alter session set parallel_degree_limit = 16';
  execute immediate 'alter session set parallel_degree_policy = auto';

  for c in (
         select v_source_user source_owner
               , v_target_user target_owner
               , t.table_name
               , listagg(tc.column_name,', ') within group (order by tc.column_id) attr_list
          from dba_tables t
               join dba_tab_columns tc on t.owner = tc.owner and t.table_name = tc.table_name
          where t.owner = v_target_user
                -- Tabelle muss auch in der Quelle existieren
                and t.table_name in (
                                    select s.table_name
                                    from dba_tables s
                                    where s.owner = v_source_user
                                    )
                -- bekannte Sicherungs-/Alt-Tabellen ausschliessen
                and t.table_name not like '%OLD'
                and t.table_name not like '%SAV'
                and t.table_name not like '%SICH'
                -- explizit ausgeschlossen: TYP_MISMATCH, kein Laengenproblem
                -- (siehe Kommentar oben, struktur_vergleich_ergebnis_svs41wl_fst.csv)
                and t.table_name not in (
                                    'TL_DWL_SOZT'
                                    )
                -- nur Spalten, die auch in der Quelle existieren
                and tc.column_name in (
                                    select tc2.column_name
                                    from dba_tab_columns tc2
                                    where tc2.owner = v_source_user
                                          and tc2.table_name = t.table_name
                                    )
          group by t.table_name
          order by 1
    ) loop

        v_table_count := v_table_count + 1;

        begin

          dbms_output.put_line('=========================================================================');
          dbms_output.put_line('00 :: '||c.target_owner||'.'||c.table_name);

          v_ddl := 'TRUNCATE TABLE '||c.target_owner||'.'||c.table_name;
          dbms_output.put_line('01 :: '||v_ddl);

          if v_execute then
            execute immediate v_ddl;
          end if;

          -- Ziel-only Spalten, die in der Quelle fehlen aber NOT NULL
          -- sind (z.B. META_INS_DT), NOT NULL aufheben statt Werte zu
          -- erfinden -- Kopie bleibt 1:1 wie in der Quelle.
          for m in (
                select tc.column_name
                from dba_tab_columns tc
                where tc.owner = c.target_owner
                      and tc.table_name = c.table_name
                      and tc.nullable = 'N'
                      and tc.column_name not in (
                                    select tc2.column_name
                                    from dba_tab_columns tc2
                                    where tc2.owner = c.source_owner
                                          and tc2.table_name = c.table_name
                                    )
            ) loop
              begin
                execute immediate 'ALTER TABLE '||c.target_owner||'.'||c.table_name||
                                   ' MODIFY ('||m.column_name||' NULL)';
                dbms_output.put_line('    -> '||m.column_name||' fehlt in Quelle, NOT NULL im Ziel aufgehoben.');
              exception
                when others then
                  dbms_output.put_line('    -> Konnte NOT NULL auf '||m.column_name||' nicht aufheben: '||SQLERRM);
              end;
          end loop;

          v_insert_cols := c.attr_list;
          v_select_cols := c.attr_list;

          v_sql := 'INSERT /*+ APPEND PARALLEL*/ INTO '||c.target_owner||'.'||c.table_name||' ('||v_insert_cols||') '||
                   'SELECT '||v_select_cols||' FROM '||c.source_owner||'.'||c.table_name;
          dbms_output.put_line('02 :: '||v_sql);

          -- Partitionierte Zieltabelle: bei INTERVAL-Partitionierung
          -- SET INTERVAL() vor dem Laden aufheben, danach reaktivieren
          -- (verhindert ORA-14757/ORA-14760).
          v_part_count := 0;
          v_interval := null;
          select count(*) into v_part_count
          from dba_tab_partitions
          where table_owner = c.target_owner and table_name = c.table_name;

          if v_part_count > 0 then
            select interval into v_interval
            from dba_part_tables
            where owner = c.target_owner and table_name = c.table_name;
            if v_interval is not null then
              execute immediate 'ALTER TABLE '||c.target_owner||'.'||c.table_name||' SET INTERVAL()';
              dbms_output.put_line('    -> INTERVAL-Partitionierung erkannt, SET INTERVAL() vor dem Laden aufgehoben.');
            end if;
          end if;

          if v_execute then
            execute immediate v_sql;
            v_rowcnt := sql%rowcount;
            dbms_output.put_line('===');
            dbms_output.put_line('03 :: '||c.target_owner||'.'||c.table_name||' Inserted '||to_char(v_rowcnt)||' rows.');
            commit;

            if v_part_count > 0 and v_interval is not null then
              execute immediate 'ALTER TABLE '||c.target_owner||'.'||c.table_name||' SET INTERVAL(1)';
              dbms_output.put_line('    -> SET INTERVAL(1) nach dem Laden wieder aktiviert.');
            end if;

            insert into UBI_RUEMMELIN.ladeprotokoll (ziel_schema, tabelle, status, zeilen, meldung)
            values (c.target_owner, c.table_name, 'OK', v_rowcnt,
                    case when v_part_count > 0 then 'Partitioniert ('||v_part_count||' Partitionen)' end);
            commit;
          end if;

        exception
          when others then
            v_errmsg := dbms_utility.format_error_stack;
            dbms_output.put_line('FEHLER bei '||c.target_owner||'.'||c.table_name||' - '||v_errmsg);

            -- ORA-14400: Quelldaten enthalten Werte ausserhalb aller
            -- vorhandenen Partitionsgrenzen (z.B. Datum/Periode neuer
            -- als die letzte definierte Partition). Loesung: eine
            -- MAXVALUE-Auffangpartition anlegen (funktioniert unabhaengig
            -- vom Partitionsschluessel-Typ) und den Insert einmal erneut
            -- versuchen.
            if v_errmsg like '%ORA-14400%' then
              begin
                execute immediate 'ALTER TABLE '||c.target_owner||'.'||c.table_name||
                                   ' ADD PARTITION P_MAXVALUE_AUTO VALUES LESS THAN (MAXVALUE)';
                dbms_output.put_line('    -> ORA-14400: MAXVALUE-Auffangpartition angelegt, Insert wird wiederholt.');

                execute immediate v_sql;
                v_rowcnt := sql%rowcount;
                commit;
                dbms_output.put_line('03 (Wiederholung) :: '||c.target_owner||'.'||c.table_name||' Inserted '||to_char(v_rowcnt)||' rows.');

                insert into UBI_RUEMMELIN.ladeprotokoll (ziel_schema, tabelle, status, zeilen, meldung)
                values (c.target_owner, c.table_name, 'OK', v_rowcnt,
                        'Nach ORA-14400 mit MAXVALUE-Auffangpartition erfolgreich nachgeladen');
                commit;

              exception
                when others then
                  v_errmsg := dbms_utility.format_error_stack;
                  dbms_output.put_line('    -> Auch nach MAXVALUE-Partition fehlgeschlagen: '||v_errmsg);
                  insert into UBI_RUEMMELIN.ladeprotokoll (ziel_schema, tabelle, status, meldung)
                  values (c.target_owner, c.table_name, 'FEHLER',
                          'ORA-14400, MAXVALUE-Partition-Versuch ebenfalls fehlgeschlagen: '||v_errmsg);
                  commit;
              end;
            else
              insert into UBI_RUEMMELIN.ladeprotokoll (ziel_schema, tabelle, status, meldung)
              values (c.target_owner, c.table_name, 'FEHLER', v_errmsg);
              commit;
            end if;
        end;

    end loop;

  if v_table_count = 0 then
    dbms_output.put_line('WARNUNG: keine passenden Tabellen gefunden (Quelle='||
                          v_source_user||', Ziel='||v_target_user||').');
    insert into UBI_RUEMMELIN.ladeprotokoll (ziel_schema, tabelle, status, meldung)
    values (v_target_user, '(keine Tabelle)', 'WARNUNG',
            'Keine gemeinsamen Tabellen zwischen Quelle '||v_source_user||
            ' und Ziel '||v_target_user||' gefunden -- Schema-/Namensangabe pruefen.');
    commit;
  end if;

  dbms_output.put_line('Kopiervorgang abgeschlossen fuer '||v_target_user||'.');

end;
/
