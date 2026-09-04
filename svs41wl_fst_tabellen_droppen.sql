SET FEEDBACK ON
SET SERVEROUTPUT ON

-- Entfernt ALLE Tabellen im Schema SVS41WL_FST -- Vorbereitung, um sie
-- durch Synonyme auf PSD1 zu ersetzen (laut Thorsten: fuer dieses
-- Schema werden keine echten Ladetabellen mit Testdaten benoetigt,
-- Synonyme reichen). Tabelle und Synonym koennen nicht denselben Namen
-- im selben Schema haben -- die Tabellen muessen also zuerst weg.
--
-- VOR dem Ausfuehren: kurz pruefen, ob nicht doch jemand anderes
-- (Kollege/anderes ODI-Mapping/UC4-Job) gerade auf diese Tabellen als
-- ECHTE Tabellen zugreift -- Sandbox wird parallel genutzt.

declare
v_errmsg varchar2(4000);
v_count integer := 0;

begin

  for t in (
        select table_name
        from dba_tables
        where owner = 'SVS41WL_FST'
        order by table_name
    ) loop

      begin
        execute immediate 'DROP TABLE SVS41WL_FST.'||t.table_name||' PURGE';
        dbms_output.put_line('OK    :: SVS41WL_FST.'||t.table_name||' geloescht.');
        v_count := v_count + 1;
      exception
        when others then
          v_errmsg := SQLERRM;
          dbms_output.put_line('FEHLER:: SVS41WL_FST.'||t.table_name||' -- '||v_errmsg);
      end;

    end loop;

  dbms_output.put_line('=========================================================================');
  dbms_output.put_line(v_count||' Tabellen in SVS41WL_FST geloescht. Naechster Schritt: Synonyme anlegen.');

end;
/
