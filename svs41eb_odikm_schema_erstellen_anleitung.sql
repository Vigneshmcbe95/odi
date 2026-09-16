-- SVS41EB_ODIKM existiert (im Gegensatz zu SVS43EB_ODIKM,
-- SVS44EB_ODIKM, SVS45EB_ODIKM) NICHT als eigenes Schema fuer B05.
-- Jede andere Sandbox hat ihre EIGENE Kopie dieser Tabellen -- das
-- deutet darauf hin, dass sie sandboxspezifische Konfiguration
-- enthalten (z.B. Ladeparameter), keine geteilten Referenzdaten.
-- Ein Synonym auf THM_UEB_ODIKM waere daher vermutlich NICHT korrekt.
--
-- SCHRITT 1 (braucht DBA-Rechte -- nicht selbst ausfuehren ohne
-- Ruecksprache, da CREATE USER Tablespace-Zuordnung/Policy betrifft):
--
-- CREATE USER SVS41EB_ODIKM IDENTIFIED BY <PASSWORT>
--   DEFAULT TABLESPACE <PASSENDE_TABLESPACE>
--   QUOTA UNLIMITED ON <PASSENDE_TABLESPACE>;
-- GRANT CREATE SESSION, CREATE TABLE, CREATE VIEW, CREATE SYNONYM TO SVS41EB_ODIKM;
--
-- SCHRITT 2: Struktur + Daten der 4 benoetigten Tabellen aus einer
-- funktionierenden Nachbar-Sandbox klonen (hier SVS43EB_ODIKM als
-- Quelle, ggf. anpassen).
declare
v_source_owner varchar2(30) := 'SVS43EB_ODIKM';
v_target_owner varchar2(30) := 'SVS41EB_ODIKM';

v_tables sys.odcivarchar2list := sys.odcivarchar2list(
  'LFST_UPD5D_MN_LADETAB',
  'GFST_STPARAM_HIST5D',
  'PROT_KM_USING',
  'LFST_Z5DEX_MN_LADETAB'
);

v_ddl clob;
v_sql varchar2(32000);
v_exists integer;

begin
  for i in 1 .. v_tables.count loop

    select count(*) into v_exists
    from dba_tables
    where owner = v_target_owner and table_name = v_tables(i);

    if v_exists > 0 then
      dbms_output.put_line(v_target_owner||'.'||v_tables(i)||' existiert bereits -- uebersprungen.');
    else
      begin
        v_ddl := dbms_metadata.get_ddl('TABLE', v_tables(i), v_source_owner);
        v_sql := replace(v_ddl, '"'||v_source_owner||'"', '"'||v_target_owner||'"');

        for stmt in (
              select trim(regexp_substr(v_sql, '[^;]+', 1, level)) as one_stmt
              from dual
              connect by regexp_substr(v_sql, '[^;]+', 1, level) is not null
          ) loop
            if stmt.one_stmt is not null and length(stmt.one_stmt) > 5 then
              begin
                execute immediate stmt.one_stmt;
              exception
                when others then
                  dbms_output.put_line('    -> Teilschritt fehlgeschlagen: '||SQLERRM);
              end;
            end if;
        end loop;

        dbms_output.put_line('OK :: '||v_target_owner||'.'||v_tables(i)||' angelegt.');

        -- Daten mitkopieren -- diese Tabellen sind klein
        -- (Konfiguration/Parameter), volle Kopie ist unproblematisch.
        execute immediate 'INSERT INTO '||v_target_owner||'.'||v_tables(i)||
                           ' SELECT * FROM '||v_source_owner||'.'||v_tables(i);
        dbms_output.put_line('    -> Daten kopiert: '||SQL%ROWCOUNT||' Zeilen.');
        commit;

      exception
        when others then
          dbms_output.put_line('FEHLER bei '||v_tables(i)||': '||SQLERRM);
      end;
    end if;

  end loop;
end;
/
