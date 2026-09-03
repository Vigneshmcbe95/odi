SET FEEDBACK ON
SET SERVEROUTPUT ON

-- Einmalig je Zielschema ausfuehren: hebt NOT NULL auf META_INS_DT
-- (und aehnlichen META_*-Spalten) auf ALLEN Tabellen des Schemas auf,
-- bei denen diese Spalte aktuell NOT NULL ist. Grund: diese Spalte
-- existiert nur im Ziel, nicht in der Quelle -- eine reine 1:1-Kopie
-- (source as-is) kann sie nie befuellen, daher schlaegt der Insert mit
-- ORA-01400 fehl, solange NOT NULL aktiv ist.
--
-- Wird das im Ladeskript selbst pro Tabelle versucht, schlaegt es bei
-- manchen Tabellen still fehl (z.B. fehlendes ALTER-Recht, Spalte Teil
-- eines Constraints) -- dieses Skript macht es einmal fuer ALLE
-- Tabellen auf einmal UND zeigt bei jedem Fehlschlag den echten Grund,
-- statt es bei jedem Ladelauf erneut zu versuchen.
--
-- >>> HIER FUELLEN <<<
declare
v_target_user varchar2(30) := 'SVS41WL_FST';
v_meta_spalte varchar2(30) := 'META_INS_DT';

v_errmsg varchar2(4000);
v_count integer := 0;
v_ok integer := 0;
v_fehler integer := 0;

begin

  for t in (
        select table_name
        from dba_tab_columns
        where owner = v_target_user
              and column_name = v_meta_spalte
              and nullable = 'N'
        order by table_name
    ) loop

      v_count := v_count + 1;

      begin
        execute immediate 'ALTER TABLE '||v_target_user||'.'||t.table_name||
                           ' MODIFY ('||v_meta_spalte||' NULL)';
        dbms_output.put_line('OK    :: '||v_target_user||'.'||t.table_name||' -- '||v_meta_spalte||' erlaubt jetzt NULL.');
        v_ok := v_ok + 1;

      exception
        when others then
          v_errmsg := SQLERRM;
          dbms_output.put_line('FEHLER:: '||v_target_user||'.'||t.table_name||' -- '||v_errmsg);
          v_fehler := v_fehler + 1;
      end;

    end loop;

  dbms_output.put_line('=========================================================================');
  dbms_output.put_line('Gefunden: '||v_count||' Tabellen mit '||v_meta_spalte||' NOT NULL in '||v_target_user);
  dbms_output.put_line('Erfolgreich aufgehoben: '||v_ok);
  dbms_output.put_line('Fehlgeschlagen: '||v_fehler||' (Grund siehe FEHLER-Zeilen oben)');

end;
/
