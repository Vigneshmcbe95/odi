SET FEEDBACK ON
SET SERVEROUTPUT ON

-- Einmalig ausfuehren: vergroessert im Ziel (SVS41WL_FST) die Spalten,
-- die laut struktur_vergleich_ergebnis_svs41wl_fst.csv zu klein fuer
-- die Quelle (PSD1_DWL_FST) sind, auf die tatsaechliche Quell-Laenge.
-- Nach diesem Skript koennen die 6 vorher ausgeschlossenen Tabellen in
-- dataload_svs41wl_fst.sql wieder mitgeladen werden (Ausschlussliste
-- dort dann entfernen).
--
-- TL_DWL_SOZT.SZT_ED ist bewusst NICHT enthalten -- das ist kein
-- Laengenproblem, sondern ein Datentyp-Unterschied (DATE vs.
-- TIMESTAMP(6)). Oracle konvertiert DATE->TIMESTAMP beim Insert
-- automatisch, ein ALTER ist dafuer nicht noetig. Falls der Ladelauf
-- dort trotzdem fehlschlaegt, bitte melden -- dann separat pruefen.

declare
v_errmsg varchar2(4000);

  procedure widen(p_table varchar2, p_column varchar2, p_new_length integer) is
  begin
    execute immediate 'ALTER TABLE SVS41WL_FST.'||p_table||
                       ' MODIFY ('||p_column||' VARCHAR2('||p_new_length||'))';
    dbms_output.put_line('OK    :: SVS41WL_FST.'||p_table||'.'||p_column||' -> VARCHAR2('||p_new_length||')');
  exception
    when others then
      dbms_output.put_line('FEHLER:: SVS41WL_FST.'||p_table||'.'||p_column||' -- '||SQLERRM);
  end;

begin

  widen('TL_DWL_AUWM', 'RAM_OS_OS',     255);
  widen('TL_DWL_BVBM', 'BVM_OS_OS',     255);
  widen('TL_DWL_KNGS', 'KGS_OS_OS',     255);
  widen('TL_DWL_KPBT', 'KBT_OS_OS',     255);

  widen('TL_DWL_BVBT', 'BVT_ZIELGRP_1', 2);
  widen('TL_DWL_BVBT', 'BVT_ZIELGRP_2', 2);
  widen('TL_DWL_BVBT', 'BVT_ZIELGRP_3', 2);

  dbms_output.put_line('=========================================================================');
  dbms_output.put_line('Fertig. Vor dem naechsten Ladelauf pruefen mit struktur_vergleich_quelle_ziel_generisch.sql,');
  dbms_output.put_line('ob noch LAENGE_ZU_KLEIN-Zeilen fuer diese Tabellen erscheinen.');

end;
/
