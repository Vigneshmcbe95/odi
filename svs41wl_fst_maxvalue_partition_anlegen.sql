SET FEEDBACK ON
SET SERVEROUTPUT ON

-- Einmalig ausfuehren: legt auf ALLEN partitionierten Tabellen im
-- Zielschema, die noch KEINE MAXVALUE-Auffangpartition haben, eine
-- solche an. Loest ORA-14400 (inserted partition key does not map to
-- any partition) dauerhaft, statt es bei jedem Ladelauf erneut per
-- try/retry zu loesen -- einfacher und zuverlaessiger als der
-- automatische Retry im Ladeskript.
--
-- Nach diesem Skript nimmt jede betroffene Tabelle Zeilen mit JEDEM
-- Partitionsschluessel-Wert an (auch zukuenftige/neue Werte landen
-- automatisch in der MAXVALUE-Partition).
--
-- >>> HIER FUELLEN <<<
declare
v_target_user varchar2(30) := 'SVS41WL_FST';

v_errmsg varchar2(4000);
v_has_maxvalue integer;
v_high_value long;

begin

  for t in (
        select distinct table_name
        from dba_tab_partitions
        where table_owner = v_target_user
        order by table_name
    ) loop

      -- Pruefen, ob bereits eine MAXVALUE-Partition existiert (letzte
      -- Partition nach PARTITION_POSITION, high_value = 'MAXVALUE').
      v_has_maxvalue := 0;
      begin
        select case when high_value = 'MAXVALUE' then 1 else 0 end
        into v_has_maxvalue
        from (
              select high_value
              from dba_tab_partitions
              where table_owner = v_target_user
                    and table_name = t.table_name
              order by partition_position desc
             )
        where rownum = 1;
      exception
        when others then v_has_maxvalue := 0;
      end;

      if v_has_maxvalue = 0 then
        begin
          execute immediate 'ALTER TABLE '||v_target_user||'.'||t.table_name||
                             ' ADD PARTITION P_MAXVALUE_AUTO VALUES LESS THAN (MAXVALUE)';
          dbms_output.put_line('OK    :: '||v_target_user||'.'||t.table_name||' -- MAXVALUE-Auffangpartition angelegt.');
        exception
          when others then
            v_errmsg := SQLERRM;
            dbms_output.put_line('FEHLER:: '||v_target_user||'.'||t.table_name||' -- '||v_errmsg);
        end;
      else
        dbms_output.put_line('OK    :: '||v_target_user||'.'||t.table_name||' -- hat bereits eine MAXVALUE-Partition, uebersprungen.');
      end if;

    end loop;

  dbms_output.put_line('=========================================================================');
  dbms_output.put_line('Fertig. Ladelauf jetzt erneut ausfuehren -- ORA-14400 sollte nicht mehr auftreten.');

end;
/
