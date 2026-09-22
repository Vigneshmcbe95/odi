SET FEEDBACK ON
SET SERVEROUTPUT ON

-- Leert NUR SSC41WH_FST (nicht alle SSC41*-Schemas) -- fuer einen
-- isolierten Test, ohne Jörns/Michaels parallele Aufraeumaktion auf
-- den anderen SSC41-Schemas zu stoeren. TRUNCATE mit DROP STORAGE,
-- damit der Platz tatsaechlich an die Tablespace zurueckgegeben wird.
-- Sicher, da SSC* Scratch/temporaer ist -- Struktur bleibt erhalten,
-- wird beim naechsten Ladelauf sowieso neu befuellt.

declare
v_geleert   integer := 0;
v_fehler    integer := 0;
begin

  for t in (
        select table_name
        from dba_tables
        where owner = 'SSC41WH_FST'
        order by table_name
    ) loop

      begin
        execute immediate 'TRUNCATE TABLE SSC41WH_FST.'||t.table_name||' DROP STORAGE';
        dbms_output.put_line('OK :: SSC41WH_FST.'||t.table_name||' geleert.');
        v_geleert := v_geleert + 1;
      exception
        when others then
          dbms_output.put_line('FEHLER :: SSC41WH_FST.'||t.table_name||' -- '||SQLERRM);
          v_fehler := v_fehler + 1;
      end;

    end loop;

  dbms_output.put_line('=========================================================================');
  dbms_output.put_line('Fertig. Geleert: '||v_geleert||', Fehlgeschlagen: '||v_fehler);

end;
/

-- Kontrolle: freien Platz in STAT_DWH_SCR pruefen.
SELECT tablespace_name,
       ROUND(SUM(bytes) / 1024 / 1024, 0) AS frei_mb
FROM dba_free_space
WHERE tablespace_name = 'STAT_DWH_SCR'
GROUP BY tablespace_name;
