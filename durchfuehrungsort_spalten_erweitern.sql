SET FEEDBACK ON
SET SERVEROUTPUT ON

-- Vergroessert ALLE betroffenen *_DURCHFUEHRUNGSORT_STRHSNR- und
-- *_DURCHFUEHRUNGSORT_PLZ-Spalten in SSC41WH_FST/SVS41WH_FST auf die
-- Laenge des 45er-Referenzschemas -- in einem Lauf, statt Spalte fuer
-- Spalte einzeln ueber ORA-12899 zu stolpern.

declare
v_geaendert integer := 0;
v_fehler integer := 0;

begin

  for c in (
        select z.owner, z.table_name, z.column_name,
               z.data_length as ziel_laenge, r.data_length as referenz_laenge
        from dba_tab_columns z
             join dba_tab_columns r
               on r.owner = replace(z.owner, '41', '45')
                  and r.table_name = z.table_name
                  and r.column_name = z.column_name
        where z.owner in ('SSC41WH_FST', 'SVS41WH_FST')
              and (z.column_name like '%DURCHFUEHRUNGSORT_STRHSNR'
                   or z.column_name like '%DURCHFUEHRUNGSORT_PLZ')
              and z.data_length < r.data_length
    ) loop

      begin
        execute immediate 'ALTER TABLE '||c.owner||'.'||c.table_name||
                           ' MODIFY ('||c.column_name||' VARCHAR2('||c.referenz_laenge||'))';
        dbms_output.put_line('OK :: '||c.owner||'.'||c.table_name||'.'||c.column_name||
                              ' von '||c.ziel_laenge||' auf '||c.referenz_laenge||' erweitert.');
        v_geaendert := v_geaendert + 1;
      exception
        when others then
          dbms_output.put_line('FEHLER :: '||c.owner||'.'||c.table_name||'.'||c.column_name||' -- '||SQLERRM);
          v_fehler := v_fehler + 1;
      end;

    end loop;

  dbms_output.put_line('=========================================================================');
  dbms_output.put_line('Fertig. Erweitert: '||v_geaendert||', Fehlgeschlagen: '||v_fehler);

end;
/
