SET FEEDBACK ON
SET SERVEROUTPUT ON

-- Ladeskript NUR fuer SVS41WH_STAT_BA_TRS.TT_DWH_DFO_STRNR (einzelne
-- Tabelle). Spaltenliste = Schnittmenge Quelle/Ziel (1:1-Kopie, keine
-- erfundenen Werte). NOT NULL auf reinen Ziel-Spalten (z.B.
-- META_INS_DT) wird automatisch aufgehoben, falls noetig.
--
-- >>> HIER FUELLEN <<<
declare
v_source_owner varchar2(30) := '';               -- z.B. 'PSD1_DWH_STAT_BA_TRS'
v_target_owner varchar2(30) := 'SVS41WH_STAT_BA_TRS';
v_table_name   varchar2(30) := 'TT_DWH_DFO_STRNR';

v_sql varchar2(32000);
v_ddl varchar2(32000);
v_errmsg varchar2(4000);
v_rowcnt integer;
v_attr_list varchar2(32000);

begin

  if v_source_owner is null or v_source_owner = '' then
    raise_application_error(-20001, 'v_source_owner ist noch leer -- bitte eintragen.');
  end if;

  -- Spaltenliste = Schnittmenge Quelle/Ziel
  select listagg(tc.column_name, ', ') within group (order by tc.column_id)
  into v_attr_list
  from dba_tab_columns tc
  where tc.owner = v_target_owner
        and tc.table_name = v_table_name
        and tc.column_name in (
              select tc2.column_name from dba_tab_columns tc2
              where tc2.owner = v_source_owner and tc2.table_name = v_table_name
            );

  dbms_output.put_line('Spalten: '||v_attr_list);

  if v_attr_list is null then
    raise_application_error(-20002,
      'Keine gemeinsamen Spalten zwischen Quelle und Ziel gefunden -- '||
      'Struktur pruefen (siehe struktur_vergleich_quelle_ziel_generisch.sql).');
  end if;

  -- Ziel-only NOT NULL Spalten (z.B. META_INS_DT) aufheben, damit die
  -- 1:1-Kopie nicht an ORA-01400 scheitert.
  for m in (
        select tc.column_name
        from dba_tab_columns tc
        where tc.owner = v_target_owner
              and tc.table_name = v_table_name
              and tc.nullable = 'N'
              and tc.column_name not in (
                    select tc2.column_name from dba_tab_columns tc2
                    where tc2.owner = v_source_owner and tc2.table_name = v_table_name
                  )
    ) loop
      begin
        execute immediate 'ALTER TABLE '||v_target_owner||'.'||v_table_name||
                           ' MODIFY ('||m.column_name||' NULL)';
        dbms_output.put_line('    -> '||m.column_name||' fehlt in Quelle, NOT NULL im Ziel aufgehoben.');
      exception
        when others then
          dbms_output.put_line('    -> Konnte NOT NULL auf '||m.column_name||' nicht aufheben: '||SQLERRM);
      end;
  end loop;

  v_ddl := 'TRUNCATE TABLE '||v_target_owner||'.'||v_table_name;
  execute immediate v_ddl;

  v_sql := 'INSERT /*+ APPEND PARALLEL*/ INTO '||v_target_owner||'.'||v_table_name||' ('||v_attr_list||') '||
           'SELECT '||v_attr_list||' FROM '||v_source_owner||'.'||v_table_name;
  dbms_output.put_line(v_sql);

  execute immediate v_sql;
  v_rowcnt := sql%rowcount;
  commit;

  dbms_output.put_line('Fertig: '||v_rowcnt||' Zeilen geladen in '||v_target_owner||'.'||v_table_name);

  insert into UBI_RUEMMELIN.ladeprotokoll (ziel_schema, tabelle, status, zeilen)
  values (v_target_owner, v_table_name, 'OK', v_rowcnt);
  commit;

exception
  when others then
    v_errmsg := dbms_utility.format_error_stack;
    dbms_output.put_line('FEHLER: '||v_errmsg);
    insert into UBI_RUEMMELIN.ladeprotokoll (ziel_schema, tabelle, status, meldung)
    values (v_target_owner, v_table_name, 'FEHLER', v_errmsg);
    commit;
end;
/
