SET FEEDBACK ON
SET SERVEROUTPUT ON

-- Generisches Datenladen-Skript -- fuer JEDES Schema-Paar wiederverwendbar.
-- Einfach v_source_user und v_target_user unten eintragen, Rest laeuft
-- automatisch:
--   * Tabellenliste kommt NICHT aus einer festen Liste, sondern direkt
--     aus dba_tables des ZIELSCHEMAS (v_target_user) -- jede Tabelle,
--     die im Ziel existiert UND unter demselben Namen auch in der
--     Quelle existiert, wird geladen.
--   * Spaltenliste = Schnittmenge Quelle/Ziel (verhindert ORA-00904 bei
--     abweichender Tabellenstruktur). Daten werden 1:1 wie in der
--     Quelle uebernommen -- keine erfundenen Werte.
--   * Ziel-Spalten, die es in der Quelle nicht gibt und die NOT NULL
--     sind (z.B. META_INS_DT), wuerden eine reine 1:1-Kopie verhindern
--     (ORA-01400) -- das Skript hebt NOT NULL auf diesen Ziel-Spalten
--     automatisch auf, statt einen Wert zu erfinden.
--   * Vollladung -- KEIN Zeilenlimit. Achtung: bei sehr grossen Tabellen
--     ggf. ORA-01652 (TEMP voll) moeglich -- falls das auftritt, Grad
--     der Parallelitaet reduzieren oder TEMP-Tablespace vergroessern.
--   * Partitionierte Zieltabellen werden automatisch erkannt. Bei
--     INTERVAL-Partitionierung wird SET INTERVAL() vor dem Laden
--     aufgehoben und danach wieder aktiviert (verhindert
--     ORA-14757/ORA-14760). Es werden KEINE Partitionen manuell
--     angelegt/gedroppt -- die Struktur kommt bereits 1:1 aus dem
--     GET_DDL-Klon, Oracle ordnet jede Zeile automatisch zu.
--   * Pro Tabelle eigener BEGIN/EXCEPTION-Block -- ein Fehler stoppt
--     nicht den gesamten Lauf, nur die betroffene Tabelle.
--   * Live-Fortschritt ueber UBI_RUEMMELIN.LADEPROTOKOLL -- nach jeder
--     Tabelle wird sofort eine Zeile geschrieben und committet (siehe
--     ladeprotokoll_live_ansehen.sql). Vorher einmalig
--     ladeprotokoll_tabelle_erstellen.sql ausfuehren, falls noch nicht
--     geschehen.
--   * SQLERRM vor Verwendung in einer INSERT-Anweisung in eine Variable
--     geschrieben (darf nicht direkt in statischem SQL stehen -- sonst
--     ORA-00984 / ORA-00911).
--
-- Optional: Tabellen, die bekanntlich Sicherungstabellen sind oder eine
-- abweichende Struktur haben, unten in v_exclude_list eintragen (Komma-
-- getrennt, GROSSBUCHSTABEN, mit Anfuehrungszeichen) -- siehe
-- Beispielzeile weiter unten (aus SVS41WH_FST uebernommen).

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

-- >>> HIER FUELLEN <<<
v_source_user varchar2(30) := '';   -- z.B. 'PSD1_DWH_STAT_FST' / 'THM_...' / etc.
v_target_user varchar2(30) := '';   -- z.B. 'SVS41WH_STAT_FST'

v_table_count integer := 0;

begin

  if v_source_user is null or v_target_user is null
     or v_source_user = '' or v_target_user = '' then
    insert into UBI_RUEMMELIN.ladeprotokoll (ziel_schema, tabelle, status, meldung)
    values ('(unbekannt)', '(unbekannt)', 'FEHLER',
            'v_source_user / v_target_user sind noch leer -- bitte im Skript eintragen.');
    commit;
    raise_application_error(-20001,
      'v_source_user / v_target_user sind noch leer -- bitte im Skript eintragen.');
  end if;

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
                -- optional: hier gezielt einzelne Tabellen ausschliessen,
                -- Beispiel (auskommentiert):
                -- and t.table_name not in ('TD_DWH_MASSNAHME_MGBB_TBD')
                --
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
          -- sind, wuerden die 1:1-Kopie (source as-is) verhindern
          -- (ORA-01400), z.B. SVS41WL_FST.TL_DWL_* / META_INS_DT.
          -- Statt Werte zu erfinden: NOT NULL auf dieser Ziel-Spalte
          -- aufheben, damit die Kopie unveraendert 1:1 (source=target)
          -- funktioniert -- Spalte bleibt dann fuer diese Zeilen leer.
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

          -- Partitionierte Zieltabelle? Bei INTERVAL-Partitionierung muss
          -- SET INTERVAL() vor dem Laden aufgehoben werden (sonst
          -- ORA-14757/ORA-14760 bei Oracle's automatischer Partitions-
          -- anlage waehrend paralleler INSERTs), nach dem Laden wieder
          -- aktiviert (SET INTERVAL(1)). Bereits vorhandene Partitionen
          -- werden NICHT neu angelegt/gedroppt -- Oracle ordnet jede
          -- Zeile automatisch ihrer Partition zu (Struktur kommt 1:1
          -- aus dem GET_DDL-Klon der Tabelle).
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

            -- Nur zuruecksetzen, wenn vorher auch aktiviert (symmetrisch
            -- zur Aufhebung oben -- sonst ORA-14757 bei reinen RANGE-
            -- Tabellen, die nie interval-partitioniert waren).
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
            -- SQLERRM allein zeigt bei parallelen Ausfuehrungen oft nur
            -- ORA-12801 ("error signaled in parallel query server") --
            -- die eigentliche Ursache steckt im Fehler-Stack.
            -- FORMAT_ERROR_STACK liefert den kompletten Stack inkl. der
            -- echten Ursache (z.B. ORA-01652, ORA-00904, ...).
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
