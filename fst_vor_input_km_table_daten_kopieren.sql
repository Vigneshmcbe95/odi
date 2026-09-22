SET FEEDBACK ON
SET SERVEROUTPUT ON

-- Der eigentliche fehlende Teil von fst_vor_input_km_table_erstellen_
-- und_laden.sql (2026-09-10): die STRUKTUR wurde damals aus SVS43WH_FST
-- geklont, aber NIE mit Daten befuellt. Deshalb liefern seitdem ALLE
-- _000_SET_LOCAL_VARIABLES-Jobs (W301/302/304/305/310, vermutlich auch
-- weitere) keine Variablen -- sie lesen ihre Definitionen aus genau
-- dieser Tabelle, finden nichts, truncaten ihre Ziel-loaded_variables-
-- Tabelle und befuellen sie nicht neu.
--
-- Kopiert die fehlenden Daten von SVS43WH_FST nach SVS41WH_FST.

declare
v_source_owner varchar2(30) := 'SVS43WH_FST';
v_target_owner varchar2(30) := 'SVS41WH_FST';
v_table_name   varchar2(30) := 'FST_VOR_INPUT_KM_TABLE';
v_vorher       integer;
v_nachher      integer;
begin

  execute immediate 'SELECT COUNT(*) FROM '||v_target_owner||'.'||v_table_name
    into v_vorher;
  dbms_output.put_line('Vorher: '||v_target_owner||'.'||v_table_name||' hat '||v_vorher||' Zeilen.');

  execute immediate
    'INSERT INTO '||v_target_owner||'.'||v_table_name||' '||
    'SELECT * FROM '||v_source_owner||'.'||v_table_name;

  commit;

  execute immediate 'SELECT COUNT(*) FROM '||v_target_owner||'.'||v_table_name
    into v_nachher;
  dbms_output.put_line('Nachher: '||v_target_owner||'.'||v_table_name||' hat '||v_nachher||' Zeilen.');

exception
  when others then
    dbms_output.put_line('FEHLER :: '||SQLERRM);
end;
/

-- Kontrolle: Zeilenzahl SVS41 vs. SVS43 zum Vergleich.
SELECT 'SVS41WH_FST' AS schema, COUNT(*) AS anzahl FROM SVS41WH_FST.FST_VOR_INPUT_KM_TABLE
UNION ALL
SELECT 'SVS43WH_FST', COUNT(*) FROM SVS43WH_FST.FST_VOR_INPUT_KM_TABLE;
