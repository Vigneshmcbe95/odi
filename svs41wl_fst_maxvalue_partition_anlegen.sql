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

begin

  -- Kein Vorab-Check auf bereits vorhandene MAXVALUE-Partition -- die
  -- HIGH_VALUE-Spalte in dba_tab_partitions ist vom Typ LONG und kann
  -- nicht in einem SQL-Vergleich (CASE/WHERE) verwendet werden
  -- (ORA-00997: illegal use of LONG datatype). Einfacher und robuster:
  -- einfach versuchen, die Partition anzulegen -- existiert bereits
  -- eine MAXVALUE-Partition, schlaegt ADD PARTITION mit einer eigenen,
  -- klaren Fehlermeldung fehl (z.B. ORA-14074), die einfach ignoriert
  -- werden kann.
  for t in (
        select distinct table_name
        from dba_tab_partitions
        where table_owner = v_target_user
        order by table_name
    ) loop

      begin
        execute immediate 'ALTER TABLE '||v_target_user||'.'||t.table_name||
                           ' ADD PARTITION P_MAXVALUE_AUTO VALUES LESS THAN (MAXVALUE)';
        dbms_output.put_line('OK    :: '||v_target_user||'.'||t.table_name||' -- MAXVALUE-Auffangpartition angelegt.');
      exception
        when others then
          v_errmsg := SQLERRM;
          dbms_output.put_line('UEBERSPRUNGEN :: '||v_target_user||'.'||t.table_name||
                                ' -- vermutlich bereits vorhanden oder anderer Partitionstyp: '||v_errmsg);
      end;

    end loop;

  dbms_output.put_line('=========================================================================');
  dbms_output.put_line('Fertig. Ladelauf jetzt erneut ausfuehren -- ORA-14400 sollte nicht mehr auftreten.');

end;
/
