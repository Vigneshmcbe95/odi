SET FEEDBACK ON
SET SERVEROUTPUT ON

-- Kopiert fuer ALLE Ordner W301 bis W320 die fehlenden Zeilen in
-- Wxxx_LOADED_VARIABLES von SSC43WH_FST nach SSC41WH_FST -- Fix fuer
-- den Truncate-Unfall vom 2026-09-22 (hat W301/W302/W304/W310
-- gleichzeitig geleert, vermutlich auch weitere Ordner dazwischen).
--
-- Ueberspringt automatisch jeden Ordner, dessen Wxxx_LOADED_VARIABLES-
-- Tabelle in SSC41 oder SSC43 gar nicht existiert (nicht jeder Ordner
-- hat zwingend eine eigene Variablen-Tabelle).

declare
v_kopiert   integer := 0;
v_uebersprungen integer := 0;
v_fehler    integer := 0;
v_sql       varchar2(4000);
v_table_ssc41 varchar2(30);
v_table_ssc43 varchar2(30);
v_exists_41 integer;
v_exists_43 integer;
begin

  for i in 301..320 loop

    v_table_ssc41 := 'W'||i||'_LOADED_VARIABLES';
    v_table_ssc43 := v_table_ssc41;

    select count(*) into v_exists_41
    from dba_tables
    where owner = 'SSC41WH_FST' and table_name = v_table_ssc41;

    select count(*) into v_exists_43
    from dba_tables
    where owner = 'SSC43WH_FST' and table_name = v_table_ssc43;

    if v_exists_41 = 0 or v_exists_43 = 0 then
      dbms_output.put_line('SKIP :: W'||i||' -- Tabelle existiert nicht in SSC41 und/oder SSC43 (SSC41:'||v_exists_41||' SSC43:'||v_exists_43||').');
      v_uebersprungen := v_uebersprungen + 1;
    else
      begin
        v_sql := 'INSERT INTO SSC41WH_FST.'||v_table_ssc41||
                 ' (var_name, var_data_varchar2, var_data_number) '||
                 'SELECT s43.var_name, s43.var_data_varchar2, s43.var_data_number '||
                 'FROM SSC43WH_FST.'||v_table_ssc43||' s43 '||
                 'WHERE NOT EXISTS (SELECT 1 FROM SSC41WH_FST.'||v_table_ssc41||' s41 '||
                 'WHERE UPPER(s41.var_name) = UPPER(s43.var_name))';
        execute immediate v_sql;
        commit;
        dbms_output.put_line('OK :: W'||i||' -- '||SQL%ROWCOUNT||' fehlende Zeilen aus SSC43 nachgezogen.');
        v_kopiert := v_kopiert + 1;
      exception
        when others then
          dbms_output.put_line('FEHLER :: W'||i||' -- '||SQLERRM);
          v_fehler := v_fehler + 1;
      end;
    end if;

  end loop;

  dbms_output.put_line('=========================================================================');
  dbms_output.put_line('Fertig. Kopiert: '||v_kopiert||', Uebersprungen: '||v_uebersprungen||', Fehlgeschlagen: '||v_fehler);

end;
/

-- Kontrolle: aktuelle Zeilenzahl je Ordner in SSC41 vs. SSC43.
declare
v_c41 integer;
v_c43 integer;
begin
  for i in 301..320 loop
    begin
      execute immediate 'SELECT COUNT(*) FROM SSC41WH_FST.W'||i||'_LOADED_VARIABLES' into v_c41;
      execute immediate 'SELECT COUNT(*) FROM SSC43WH_FST.W'||i||'_LOADED_VARIABLES' into v_c43;
      dbms_output.put_line('W'||i||' :: SSC41='||v_c41||'  SSC43='||v_c43);
    exception
      when others then
        dbms_output.put_line('W'||i||' :: Tabelle nicht vorhanden, uebersprungen.');
    end;
  end loop;
end;
/
