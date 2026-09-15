-- Entfernt alte, bereits geloeschte Tabellenversionen (BIN$...$0), die
-- noch im Recycle Bin liegen und in dba_tab_columns/dba_tables als
-- Altlast auftauchen -- rein aufraeumend, betrifft keine echten,
-- aktuell genutzten Objekte.
--
-- Muss als der jeweilige Objekt-Owner (z.B. SSC41WH_FST selbst) oder
-- mit SYSDBA/entsprechenden Rechten ausgefuehrt werden -- leert den
-- kompletten Recycle Bin der aktuellen Session/des Users.
PURGE RECYCLEBIN;
