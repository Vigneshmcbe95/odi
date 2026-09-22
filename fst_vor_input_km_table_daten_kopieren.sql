SET FEEDBACK ON
SET SERVEROUTPUT ON

-- Der eigentliche fehlende Teil von fst_vor_input_km_table_erstellen_
-- und_laden.sql: die STRUKTUR wurde damals aus SVS43WH_FST geklont,
-- aber NIE mit Daten befuellt. Deshalb liefern seitdem ALLE
-- _000_SET_LOCAL_VARIABLES-Jobs keine Variablen -- sie lesen ihre
-- Definitionen aus genau dieser Tabelle, finden nichts.
--
-- QUELLE: bestaetigt ueber ODI Designer-Modell-Metadaten (Populated By
-- auf W304_LOADED_VARIABLES zeigt auf MF_FST_THM.THM_DWH_FST.
-- FST_VOR_INPUT_KM_TABLE) -- die offizielle Quelle ist THM_DWH_FST.
--
-- WICHTIG -- FIX (Lehre vom ersten Lauf): urspruengliche Version hatte
-- KEINE Duplikatpruefung und wurde versehentlich 2x ausgefuehrt --
-- Zeilen haben sich dadurch verdreifacht (934 -> 1868 -> 2802). Diese
-- Version macht DELETE + INSERT statt reinem INSERT, damit ein
-- erneuter Lauf immer den exakten Stand von THM_DWH_FST spiegelt,
-- egal wie oft das Skript ausgefuehrt wird. DELETE statt TRUNCATE,
-- weil TRUNCATE in diesem Umfeld fehlgeschlagen ist (vermutlich
-- Fremdschluessel-Referenz oder fehlendes TRUNCATE-Recht) -- bei
-- Fehlschlag sprang die Exception vor dem INSERT raus, Tabelle blieb
-- unveraendert bei den bereits vorhandenen Duplikaten.

declare
v_source_owner varchar2(30) := 'THM_DWH_FST';
v_target_owner varchar2(30) := 'SVS41WH_FST';
v_table_name   varchar2(30) := 'FST_VOR_INPUT_KM_TABLE';
v_vorher       integer;
v_nachher      integer;
begin

  execute immediate 'SELECT COUNT(*) FROM '||v_target_owner||'.'||v_table_name
    into v_vorher;
  dbms_output.put_line('Vorher: '||v_target_owner||'.'||v_table_name||' hat '||v_vorher||' Zeilen.');

  execute immediate 'DELETE FROM '||v_target_owner||'.'||v_table_name;

  execute immediate
    'INSERT INTO '||v_target_owner||'.'||v_table_name||' '||
    'SELECT * FROM '||v_source_owner||'.'||v_table_name;

  commit;

  execute immediate 'SELECT COUNT(*) FROM '||v_target_owner||'.'||v_table_name
    into v_nachher;
  dbms_output.put_line('Nachher: '||v_target_owner||'.'||v_table_name||' hat '||v_nachher||' Zeilen (exakter Spiegel von '||v_source_owner||').');

exception
  when others then
    dbms_output.put_line('FEHLER :: '||SQLERRM);
end;
/

-- Kontrolle: Zeilenzahl SVS41 vs. THM_DWH_FST -- sollte jetzt identisch sein.
SELECT 'SVS41WH_FST' AS schema, COUNT(*) AS anzahl FROM SVS41WH_FST.FST_VOR_INPUT_KM_TABLE
UNION ALL
SELECT 'THM_DWH_FST', COUNT(*) FROM THM_DWH_FST.FST_VOR_INPUT_KM_TABLE;
