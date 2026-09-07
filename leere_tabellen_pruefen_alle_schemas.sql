SET FEEDBACK ON
SET SERVEROUTPUT ON SIZE UNLIMITED

-- Prueft fuer alle angegebenen Schemata JEDE Tabelle: hat sie
-- mindestens eine Zeile, oder ist sie leer (0 Zeilen)? Schreibt NICHTS
-- in die Datenbank -- reine Pruefung, Ausgabe nur ueber DBMS_OUTPUT.
--
-- Ausgabe pro Schema (eine Zeile):
--   SCHEMA: Anzahl Tabellen gesamt, Anzahl leer
--   Leere Tabellen: alle leeren Tabellennamen, komma-getrennt, in
--   einer Zeile
--
-- >>> HIER FUELLEN (Liste der zu pruefenden Schemata) <<<
declare
  type t_schemas is table of varchar2(30);
  v_schemas t_schemas := t_schemas(
    'SVS41WH_FST',
    'SVS41WH_STAT_FST',
    'SVS41M_STAT_FST',
    'SVS41WH_BA_TRS',
    'SVS41WH_STAT_BA_TRS',
    'SVS41WL_FST',
    'SVS41LL_FST',
    'SVS41WH_UEB_DIM'
  );

  v_rowcnt integer;
  v_anzahl_tabellen integer;
  v_anzahl_leer integer;
  v_leere_liste varchar2(32000);

begin

  for i in 1 .. v_schemas.count loop

    v_anzahl_tabellen := 0;
    v_anzahl_leer := 0;
    v_leere_liste := null;

    for t in (
          select table_name
          from dba_tables
          where owner = v_schemas(i)
          order by table_name
      ) loop

        v_anzahl_tabellen := v_anzahl_tabellen + 1;

        begin
          -- Schnelltest: bricht beim ersten Treffer ab (ROWNUM=1),
          -- muss nicht die ganze Tabelle zaehlen.
          execute immediate
            'SELECT COUNT(*) FROM (SELECT 1 FROM '||v_schemas(i)||'.'||t.table_name||
            ' WHERE ROWNUM = 1)'
            into v_rowcnt;

          if v_rowcnt = 0 then
            v_anzahl_leer := v_anzahl_leer + 1;
            if v_leere_liste is null then
              v_leere_liste := t.table_name;
            else
              v_leere_liste := v_leere_liste || ', ' || t.table_name;
            end if;
          end if;

        exception
          when others then
            dbms_output.put_line('    -> Konnte '||v_schemas(i)||'.'||t.table_name||' nicht pruefen: '||SQLERRM);
        end;

      end loop;

    dbms_output.put_line('=========================================================================');
    dbms_output.put_line(v_schemas(i)||': '||v_anzahl_tabellen||' Tabellen, '||v_anzahl_leer||' davon leer.');
    if v_anzahl_leer > 0 then
      dbms_output.put_line('Leere Tabellen: '||v_leere_liste);
    end if;

  end loop;

end;
/
