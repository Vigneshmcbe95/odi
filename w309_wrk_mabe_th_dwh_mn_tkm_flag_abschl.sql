-- Behebt ORA-00904 fuer FLAG_ABSCHL auf
-- SSC41WH_FST.W309_WRK_MABE_TH_DWH_MN_TKM.

-- 1) Existiert die Tabelle ueberhaupt, und hat sie FLAG_ABSCHL?
SELECT owner, table_name, column_name, data_type, data_length
FROM dba_tab_columns
WHERE owner = 'SSC41WH_FST'
      AND table_name = 'W309_WRK_MABE_TH_DWH_MN_TKM';

-- 2) Referenzschema zum Vergleich (Typ/Laenge von FLAG_ABSCHL)
SELECT owner, table_name, column_name, data_type, data_length
FROM dba_tab_columns
WHERE owner = 'SSC45WH_FST'
      AND table_name = 'W309_WRK_MABE_TH_DWH_MN_TKM'
      AND column_name = 'FLAG_ABSCHL';

-- 3a) Falls die Tabelle existiert, nur Spalte fehlt: Spalte hinzufuegen
--     (Typ/Laenge ggf. an Ergebnis aus Abfrage 2 anpassen -- 'N'/'J'-
--     Flag sieht nach VARCHAR2(1) aus)
-- ALTER TABLE SSC41WH_FST.W309_WRK_MABE_TH_DWH_MN_TKM
--   ADD (FLAG_ABSCHL VARCHAR2(1));

-- 3b) Falls die Tabelle komplett fehlt: aus SSC45WH_FST klonen
--     (Struktur, keine Daten -- Scratch-Tabelle)
declare
v_source_owner varchar2(30) := 'SSC45WH_FST';
v_target_owner varchar2(30) := 'SSC41WH_FST';
v_table_name   varchar2(30) := 'W309_WRK_MABE_TH_DWH_MN_TKM';
v_exists integer;
v_ddl clob;
v_sql varchar2(32000);
begin
  select count(*) into v_exists from dba_tables
  where owner = v_target_owner and table_name = v_table_name;

  if v_exists > 0 then
    dbms_output.put_line('Tabelle existiert bereits -- nur ALTER TABLE (3a) noetig, falls Spalte fehlt.');
  else
    v_ddl := dbms_metadata.get_ddl('TABLE', v_table_name, v_source_owner);
    v_sql := replace(v_ddl, '"'||v_source_owner||'"', '"'||v_target_owner||'"');
    for stmt in (
          select trim(regexp_substr(v_sql, '[^;]+', 1, level)) as one_stmt
          from dual connect by regexp_substr(v_sql, '[^;]+', 1, level) is not null
      ) loop
        if stmt.one_stmt is not null and length(stmt.one_stmt) > 5 then
          begin
            execute immediate stmt.one_stmt;
          exception
            when others then dbms_output.put_line('Teilschritt fehlgeschlagen: '||SQLERRM);
          end;
        end if;
    end loop;
    dbms_output.put_line('Tabelle '||v_target_owner||'.'||v_table_name||' neu angelegt.');
  end if;
end;
/
