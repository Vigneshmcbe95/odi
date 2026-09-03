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
--     abweichender Tabellenstruktur).
--   * Vollladung -- KEIN Zeilenlimit. Achtung: bei sehr grossen Tabellen
--     ggf. ORA-01652 (TEMP voll) moeglich -- falls das auftritt, Grad
--     der Parallelitaet reduzieren oder TEMP-Tablespace vergroessern.
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

          v_sql := 'INSERT /*+ APPEND PARALLEL*/ INTO '||c.target_owner||'.'||c.table_name||' ('||c.attr_list||') '||
                   'SELECT '||c.attr_list||' FROM '||c.source_owner||'.'||c.table_name;
          dbms_output.put_line('02 :: '||v_sql);

          if v_execute then
            execute immediate v_sql;
            v_rowcnt := sql%rowcount;
            dbms_output.put_line('===');
            dbms_output.put_line('03 :: '||c.target_owner||'.'||c.table_name||' Inserted '||to_char(v_rowcnt)||' rows.');
            commit;

            insert into UBI_RUEMMELIN.ladeprotokoll (ziel_schema, tabelle, status, zeilen)
            values (c.target_owner, c.table_name, 'OK', v_rowcnt);
            commit;
          end if;

        exception
          when others then
            v_errmsg := SQLERRM;
            dbms_output.put_line('FEHLER bei '||c.target_owner||'.'||c.table_name||' - '||v_errmsg);
            insert into UBI_RUEMMELIN.ladeprotokoll (ziel_schema, tabelle, status, meldung)
            values (c.target_owner, c.table_name, 'FEHLER', v_errmsg);
            commit;
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
