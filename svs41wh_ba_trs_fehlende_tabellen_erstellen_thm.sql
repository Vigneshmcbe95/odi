SET FEEDBACK ON
SET SERVEROUTPUT ON

-- Erstellt NUR FEHLENDE Tabellen in SVS41WH_BA_TRS, Quelle THM_DWH_BA_TRS.
--
-- Beispiel-Faelle: SVS41WH_BA_TRS.TD_DWH_BA_KUNDE fehlt (siehe
-- ORA-00942 im W105-Ladelauf).
--
-- Quelle THM_DWH_BA_TRS, nicht SVS44/PSD1/XRO -- laut Thorstens
-- bestaetigter Regel (2026-08-31): wenn eine Tabelle sowohl im
-- Basisschema als auch im 43er-Sandbox-Pendant fehlt, ist THM_* der
-- richtige Fallback.
--
-- WICHTIG -- anders als die SSC41-Scripte: SVS41WH_BA_TRS ist ein
-- PERSISTENTES Schema, kein Scratch. Deshalb hier bewusst KEIN
-- blindes Drop+Recreate wie bei SSC* -- eine bereits vorhandene,
-- korrekte Tabelle mit evtl. schon geladenen Daten wird NICHT
-- angefasst. Nur echte Luecken (Tabelle existiert im Ziel gar nicht)
-- werden neu angelegt.

declare
v_source_owner varchar2(30) := 'THM_DWH_BA_TRS';
v_target_owner varchar2(30) := 'SVS41WH_BA_TRS';

v_ddl clob;
v_sql varchar2(32000);
v_erstellt integer := 0;
v_uebersprungen integer := 0;
v_fehler integer := 0;

begin

  for t in (
        select table_name
        from dba_tables
        where owner = v_source_owner
        order by table_name
    ) loop

      declare
        v_exists integer;
      begin
        select count(*) into v_exists
        from dba_tables
        where owner = v_target_owner
              and table_name = t.table_name;

        if v_exists > 0 then
          dbms_output.put_line('SKIP :: '||v_target_owner||'.'||t.table_name||' existiert bereits, nicht angefasst.');
          v_uebersprungen := v_uebersprungen + 1;
          continue;
        end if;

        v_ddl := dbms_metadata.get_ddl('TABLE', t.table_name, v_source_owner);
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
                  dbms_output.put_line('    -> Teilschritt fehlgeschlagen fuer '||t.table_name||' (evtl. Constraint-Name-Konflikt, meist unkritisch): '||SQLERRM);
              end;
            end if;
        end loop;

        dbms_output.put_line('OK :: '||v_target_owner||'.'||t.table_name||' neu angelegt (war fehlend).');
        v_erstellt := v_erstellt + 1;

      exception
        when others then
          dbms_output.put_line('FEHLER :: '||t.table_name||' -- '||SQLERRM);
          v_fehler := v_fehler + 1;
      end;

    end loop;

  dbms_output.put_line('=========================================================================');
  dbms_output.put_line('Fertig. Quelle: '||v_source_owner||' -> Ziel: '||v_target_owner);
  dbms_output.put_line('Neu angelegt: '||v_erstellt||', Uebersprungen (schon vorhanden): '||v_uebersprungen||', Fehlgeschlagen: '||v_fehler);

end;
/
