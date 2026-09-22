SET FEEDBACK ON
SET SERVEROUTPUT ON

-- Einfaches Kopier-Template fuer EINE Wxxx_LOADED_VARIABLES-Tabelle.
-- Nur die drei Variablen unten (v_source_owner, v_target_owner,
-- v_table_name) pro Tabelle anpassen und ausfuehren. Keine
-- SQL*Plus-Substitutionsvariablen (&...) -- manche SQL-Clients fragen
-- sonst bei jedem Vorkommen einzeln nach oder werfen Syntaxfehler.

declare
  v_source_owner varchar2(30) := 'SSC45WH_FST';
  v_target_owner varchar2(30) := 'SSC41WH_FST';
  v_table_name   varchar2(30) := 'W305_LOADED_VARIABLES';
  v_anzahl       integer;
begin

  execute immediate
    'INSERT INTO '||v_target_owner||'.'||v_table_name||
    ' (var_name, var_data_varchar2, var_data_number) '||
    'SELECT s.var_name, s.var_data_varchar2, s.var_data_number '||
    'FROM '||v_source_owner||'.'||v_table_name||' s '||
    'WHERE NOT EXISTS (SELECT 1 FROM '||v_target_owner||'.'||v_table_name||' t '||
    'WHERE UPPER(t.var_name) = UPPER(s.var_name))';

  commit;

  execute immediate
    'SELECT COUNT(*) FROM '||v_target_owner||'.'||v_table_name
    into v_anzahl;

  dbms_output.put_line('Fertig. '||v_target_owner||'.'||v_table_name||' hat jetzt '||v_anzahl||' Zeilen.');

exception
  when others then
    dbms_output.put_line('FEHLER :: '||SQLERRM);
end;
/
