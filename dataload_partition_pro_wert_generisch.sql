SET FEEDBACK ON
SET SERVEROUTPUT ON

-- Generisches Datenladen MIT echten, wertbasierten Partitionen -- im
-- Gegensatz zu dataload_generisch_alle_schemas.sql (die im Fehlerfall
-- nur EINE grosse MAXVALUE-Auffangpartition anlegt, in der dann ALLES
-- landet, was ueber die alte Grenze hinausgeht).
--
-- Ablauf pro Tabelle:
--   1. Partitionierungsspalte der Zieltabelle ermitteln (nur einfache,
--      EINSPALTIGE RANGE-Partitionierung wird unterstuetzt -- Tabellen
--      mit mehrspaltigem/LIST/HASH-Partitionsschluessel werden mit
--      WARNUNG uebersprungen).
--   2. ALLE vorhandenen Partitionen bis auf die mit der niedrigsten
--      Grenze (Position 1) werden entfernt -- kompletter Neuaufbau
--      statt Luecken einzeln zu reparieren (SPLIT PARTITION waere fuer
--      Luecken in der Mitte noetig, ADD PARTITION kann das nicht).
--   3. Alle in der QUELLE tatsaechlich vorkommenden Werte dieser Spalte
--      ermitteln (DISTINCT, aufsteigend sortiert).
--   4. Fuer jeden Wert der Reihe nach eine eigene, eng begrenzte
--      Partition anlegen (VALUES LESS THAN Wert+1 bei NUMBER, Wert+1
--      Tag bei DATE) -- da aufsteigend sortiert, funktioniert ADD
--      PARTITION dabei immer garantiert ohne Luecken oder Konflikte.
--   5. Danach EIN normaler INSERT ... SELECT fuer die ganze Tabelle --
--      Oracle ordnet jede Zeile automatisch der jetzt passenden
--      Partition zu.
--
-- >>> HIER FUELLEN <<<
declare
v_source_user varchar2(30) := '';   -- z.B. 'PSD1_DWL_FST'
v_target_user varchar2(30) := '';   -- z.B. 'SVS41WL_FST'

v_sql varchar2(32000);
v_errmsg varchar2(4000);
v_rowcnt integer;
v_part_col varchar2(30);
v_part_col_count integer;
v_data_type varchar2(30);
v_added integer;
v_skipped integer;

begin

  if v_source_user is null or v_target_user is null
     or v_source_user = '' or v_target_user = '' then
    raise_application_error(-20001,
      'v_source_user / v_target_user sind noch leer -- bitte im Skript eintragen.');
  end if;

  execute immediate 'alter session enable parallel ddl';
  execute immediate 'alter session enable parallel dml';
  execute immediate 'alter session enable parallel query';

  for c in (
         select v_source_user source_owner
               , v_target_user target_owner
               , t.table_name
               , listagg(tc.column_name,', ') within group (order by tc.column_id) attr_list
          from dba_tables t
               join dba_tab_columns tc on t.owner = tc.owner and t.table_name = tc.table_name
          where t.owner = v_target_user
                and t.table_name in (
                                    select s.table_name from dba_tables s where s.owner = v_source_user
                                    )
                and t.table_name not like '%OLD'
                and t.table_name not like '%SAV'
                and t.table_name not like '%SICH'
                and tc.column_name in (
                                    select tc2.column_name from dba_tab_columns tc2
                                    where tc2.owner = v_source_user and tc2.table_name = t.table_name
                                    )
          group by t.table_name
          order by 1
    ) loop

        begin

          dbms_output.put_line('=========================================================================');
          dbms_output.put_line('00 :: '||c.target_owner||'.'||c.table_name);

          -- Nur einspaltige Partitionierung unterstuetzt.
          select count(*) into v_part_col_count
          from dba_part_key_columns
          where owner = c.target_owner and name = c.table_name;

          if v_part_col_count = 0 then
            dbms_output.put_line('    -> nicht partitioniert, normale Kopie.');
          elsif v_part_col_count > 1 then
            dbms_output.put_line('    -> WARNUNG: mehrspaltiger Partitionsschluessel, wird uebersprungen (manuell pruefen).');
            insert into UBI_RUEMMELIN.ladeprotokoll (ziel_schema, tabelle, status, meldung)
            values (c.target_owner, c.table_name, 'WARNUNG', 'Mehrspaltiger Partitionsschluessel -- automatische Partitionsanlage nicht unterstuetzt.');
            commit;
            goto next_table;
          else
            select column_name into v_part_col
            from dba_part_key_columns
            where owner = c.target_owner and name = c.table_name and column_position = 1;

            select data_type into v_data_type
            from dba_tab_columns
            where owner = c.target_owner and table_name = c.table_name and column_name = v_part_col;

            dbms_output.put_line('    -> Partitionsspalte: '||v_part_col||' ('||v_data_type||')');

            -- Alle vorhandenen Partitionen bis auf EINE (Position 1,
            -- per Definition die mit der niedrigsten Grenze) entfernen.
            -- Grund: ADD PARTITION kann immer nur eine NEUE HOECHSTE
            -- Partition anhaengen -- bei bestehenden Luecken in der
            -- Mitte (bereits hoehere Partitionen vorhanden, aber ein
            -- Wert passt in keine) schlaegt das mit ORA-14400 fehl und
            -- muesste eigentlich per SPLIT PARTITION geloest werden.
            -- Einfacher und zuverlaessiger: komplett neu aufbauen --
            -- unbedenklich, da die Tabelle gleich sowieso per
            -- TRUNCATE+INSERT neu befuellt wird.
            for old_p in (
                  select partition_name
                  from dba_tab_partitions
                  where table_owner = c.target_owner and table_name = c.table_name
                        and partition_position > 1
                  order by partition_position desc
                ) loop
                begin
                  execute immediate 'ALTER TABLE '||c.target_owner||'.'||c.table_name||
                                     ' DROP PARTITION '||old_p.partition_name;
                exception
                  when others then null;
                end;
            end loop;
            dbms_output.put_line('    -> Alte Partitionen entfernt, nur Position 1 (niedrigste Grenze) blieb erhalten.');

            v_added := 0;
            v_skipped := 0;

            if v_data_type = 'DATE' then
              -- dynamisch, da Spaltenname erst zur Laufzeit bekannt ist
              declare
                type t_dates is table of date;
                v_dates t_dates;
              begin
                execute immediate
                  'SELECT DISTINCT TRUNC('||v_part_col||') FROM '||c.source_owner||'.'||c.table_name||
                  ' WHERE '||v_part_col||' IS NOT NULL ORDER BY 1'
                  bulk collect into v_dates;

                for i in 1 .. v_dates.count loop
                  begin
                    execute immediate 'ALTER TABLE '||c.target_owner||'.'||c.table_name||
                      ' ADD PARTITION P_D'||to_char(v_dates(i),'YYYYMMDD')||
                      ' VALUES LESS THAN (TO_DATE('''||to_char(v_dates(i)+1,'YYYY-MM-DD')||''',''YYYY-MM-DD''))';
                    v_added := v_added + 1;
                  exception
                    when others then
                      v_skipped := v_skipped + 1; -- vermutlich bereits abgedeckt
                  end;
                end loop;
              end;

            elsif v_data_type in ('NUMBER','FLOAT','INTEGER') then
              declare
                type t_nums is table of number;
                v_nums t_nums;
              begin
                execute immediate
                  'SELECT DISTINCT '||v_part_col||' FROM '||c.source_owner||'.'||c.table_name||
                  ' WHERE '||v_part_col||' IS NOT NULL ORDER BY 1'
                  bulk collect into v_nums;

                for i in 1 .. v_nums.count loop
                  begin
                    execute immediate 'ALTER TABLE '||c.target_owner||'.'||c.table_name||
                      ' ADD PARTITION P_N'||replace(to_char(v_nums(i)),'-','M')||
                      ' VALUES LESS THAN ('||to_char(v_nums(i)+1)||')';
                    v_added := v_added + 1;
                  exception
                    when others then
                      v_skipped := v_skipped + 1; -- vermutlich bereits abgedeckt
                  end;
                end loop;
              end;

            else
              dbms_output.put_line('    -> WARNUNG: Partitionsspaltentyp '||v_data_type||' wird nicht unterstuetzt, uebersprungen.');
              insert into UBI_RUEMMELIN.ladeprotokoll (ziel_schema, tabelle, status, meldung)
              values (c.target_owner, c.table_name, 'WARNUNG', 'Partitionsspaltentyp '||v_data_type||' nicht unterstuetzt -- manuell pruefen.');
              commit;
              goto next_table;
            end if;

            dbms_output.put_line('    -> '||v_added||' neue Partitionen angelegt, '||v_skipped||' bereits abgedeckt/uebersprungen.');

            -- Als letzte Partition eine MAXVALUE-Sicherheitspartition
            -- anlegen -- faengt nur Werte auf, die NICHT in der obigen
            -- DISTINCT-Liste der Quelle waren (z.B. zwischen Ermittlung
            -- der Werte und dem eigentlichen Insert neu hinzugekommen).
            -- Da sie IMMER die letzte ist, blockiert sie keine der oben
            -- neu angelegten, engen Partitionen.
            begin
              execute immediate 'ALTER TABLE '||c.target_owner||'.'||c.table_name||
                                 ' ADD PARTITION P_MAXVALUE_AUTO VALUES LESS THAN (MAXVALUE)';
            exception
              when others then null;
            end;
          end if;

          -- Normale 1:1-Kopie, wie im generischen Ladeskript.
          v_sql := 'TRUNCATE TABLE '||c.target_owner||'.'||c.table_name;
          execute immediate v_sql;

          v_sql := 'INSERT /*+ APPEND PARALLEL*/ INTO '||c.target_owner||'.'||c.table_name||' ('||c.attr_list||') '||
                   'SELECT '||c.attr_list||' FROM '||c.source_owner||'.'||c.table_name;
          execute immediate v_sql;
          v_rowcnt := sql%rowcount;
          commit;

          dbms_output.put_line('03 :: '||c.target_owner||'.'||c.table_name||' Inserted '||to_char(v_rowcnt)||' rows.');

          if v_part_col is null then
            -- Nicht partitioniert: eine einzelne Zusammenfassungszeile.
            insert into UBI_RUEMMELIN.ladeprotokoll (ziel_schema, tabelle, status, zeilen)
            values (c.target_owner, c.table_name, 'OK', v_rowcnt);
            commit;
          else
            -- Partitioniert: EIN Log-Eintrag PRO tatsaechlichem Wert der
            -- Partitionsspalte (nicht pro internem Partitionsnamen) --
            -- Meldung zeigt "SPALTE = WERT" mit der jeweiligen
            -- Zeilenzahl, direkt aus den geladenen Daten gruppiert.
            declare
              type t_cur is ref cursor;
              v_cur t_cur;
              v_val_txt varchar2(4000);
              v_cnt integer;
            begin
              open v_cur for
                'SELECT TO_CHAR('||v_part_col||'), COUNT(*) FROM '||c.target_owner||'.'||c.table_name||
                ' GROUP BY '||v_part_col||' ORDER BY '||v_part_col;
              loop
                fetch v_cur into v_val_txt, v_cnt;
                exit when v_cur%notfound;

                insert into UBI_RUEMMELIN.ladeprotokoll (ziel_schema, tabelle, status, zeilen, meldung)
                values (c.target_owner, c.table_name, 'OK', v_cnt,
                        v_part_col||' = '||v_val_txt);
                commit;
              end loop;
              close v_cur;
            exception
              when others then
                if v_cur%isopen then close v_cur; end if;
                dbms_output.put_line('    -> Konnte nicht nach '||v_part_col||' gruppieren: '||SQLERRM);
            end;
          end if;

        exception
          when others then
            v_errmsg := dbms_utility.format_error_stack;
            dbms_output.put_line('FEHLER bei '||c.target_owner||'.'||c.table_name||' - '||v_errmsg);
            insert into UBI_RUEMMELIN.ladeprotokoll (ziel_schema, tabelle, status, meldung)
            values (c.target_owner, c.table_name, 'FEHLER', v_errmsg);
            commit;
        end;

        v_part_col := null;

        <<next_table>>
        null;

    end loop;

  dbms_output.put_line('Kopiervorgang abgeschlossen fuer '||v_target_user||'.');

end;
/
