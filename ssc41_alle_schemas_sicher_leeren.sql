SET FEEDBACK ON
SET SERVEROUTPUT ON

-- Leert ALLE Tabellen in ALLEN SSC41*-Schemas (Scratch/temporaer), um
-- Tablespace-Platz freizugeben -- Fix fuer ORA-01652 auf STAT_DWH_SCR.
-- Sicher, weil SSC* reine Arbeitstabellen sind und beim naechsten
-- Ladelauf sowieso neu befuellt werden. KEIN DROP der Tabellen selbst
-- (Struktur bleibt erhalten) -- nur TRUNCATE mit DROP STORAGE, damit
-- der belegte Platz tatsaechlich an die Tablespace zurueckgegeben wird
-- (nicht nur die Zeilen geloescht, sondern die Extents freigegeben).
--
-- Deckt alle Schemas ab, die mit SSC41 beginnen (SSC41WH_FST,
-- SSC41M_STAT_FST, SSC41WH_STAT_FST, SSC41LL_FST, etc.) -- nicht nur
-- SSC41WH_FST.
--
-- WICHTIG (Lehre aus 2026-09-22): *_LOADED_VARIABLES-Tabellen sind
-- KEIN normaler Scratch-Inhalt -- sie werden von einem eigenen
-- _000_SET_LOCAL_VARIABLES-Job pro Ordner befuellt und NICHT beim
-- naechsten Ladelauf automatisch neu erzeugt. Ein blindes Truncate
-- hat W301/W302/W304/W310 gleichzeitig kaputtgemacht (ORA-01476).
-- Deshalb hier explizit ausgenommen.

declare
v_geleert   integer := 0;
v_fehler    integer := 0;
begin

  for t in (
        select owner, table_name
        from dba_tables
        where owner like 'SSC41%'
              and table_name not like '%LOADED_VARIABLES%'
        order by owner, table_name
    ) loop

      begin
        execute immediate 'TRUNCATE TABLE '||t.owner||'.'||t.table_name||' DROP STORAGE';
        dbms_output.put_line('OK :: '||t.owner||'.'||t.table_name||' geleert.');
        v_geleert := v_geleert + 1;
      exception
        when others then
          dbms_output.put_line('FEHLER :: '||t.owner||'.'||t.table_name||' -- '||SQLERRM);
          v_fehler := v_fehler + 1;
      end;

    end loop;

  dbms_output.put_line('=========================================================================');
  dbms_output.put_line('Fertig. Geleert: '||v_geleert||', Fehlgeschlagen: '||v_fehler);

end;
/

-- Papierkorb leeren -- gibt zusaetzlichen Platz frei, den TRUNCATE
-- allein nicht immer vollstaendig zurueckgibt (alte gedroppte Objekte
-- aus frueheren Skriptlaeufen).
PURGE RECYCLEBIN;

-- Kontrolle: freien Platz in der betroffenen Tablespace pruefen.
SELECT tablespace_name,
       ROUND(SUM(bytes) / 1024 / 1024, 0) AS frei_mb
FROM dba_free_space
WHERE tablespace_name = 'STAT_DWH_SCR'
GROUP BY tablespace_name;
