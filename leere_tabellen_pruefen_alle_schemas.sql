SET FEEDBACK ON
SET SERVEROUTPUT ON

-- Prueft fuer alle angegebenen Schemata JEDE Tabelle: hat sie
-- mindestens eine Zeile, oder ist sie leer (0 Zeilen)? Ergebnis wird
-- in eine Ergebnistabelle geschrieben -- danach mit
-- leere_tabellen_ergebnis_ansehen.sql auslesen.
--
-- Ausgabe pro Schema (eine Zeile):
--   SCHEMA               -- das geprueft Schema
--   ANZAHL_TABELLEN       -- wie viele Tabellen insgesamt geprueft wurden
--   ANZAHL_LEER            -- wie viele davon 0 Zeilen haben
--   LEERE_TABELLEN         -- alle leeren Tabellennamen, komma-getrennt,
--                            in EINER Zelle (CLOB, da bei vielen leeren
--                            Tabellen ueber 4000 Zeichen moeglich sind)
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
  v_leere_liste clob;

begin

  -- Ergebnistabelle einmalig anlegen, falls noch nicht vorhanden.
  begin
    execute immediate '
      CREATE TABLE UBI_RUEMMELIN.LEERE_TABELLEN_ERGEBNIS (
        pruef_zeit       TIMESTAMP DEFAULT SYSTIMESTAMP,
        schema_name      VARCHAR2(30),
        anzahl_tabellen  NUMBER,
        anzahl_leer      NUMBER,
        leere_tabellen   CLOB
      )';
  exception
    when others then null; -- existiert schon
  end;

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

    insert into UBI_RUEMMELIN.LEERE_TABELLEN_ERGEBNIS
      (schema_name, anzahl_tabellen, anzahl_leer, leere_tabellen)
    values
      (v_schemas(i), v_anzahl_tabellen, v_anzahl_leer, v_leere_liste);
    commit;

    dbms_output.put_line(v_schemas(i)||': '||v_anzahl_tabellen||' Tabellen, '||v_anzahl_leer||' davon leer.');

  end loop;

  dbms_output.put_line('Fertig. Ergebnis ansehen mit: leere_tabellen_ergebnis_ansehen.sql');

end;
/
