-- Einmalig ausfuehren: Protokolltabelle fuer Live-Fortschrittsanzeige.
-- Jeder Datenladen-Lauf schreibt hier nach jeder verarbeiteten Tabelle
-- eine Zeile hinein UND committet sofort -- dadurch in einer zweiten
-- Session live sichtbar (DBMS_OUTPUT allein wird von den meisten
-- SQL-Tools erst nach Ende des gesamten Laufs angezeigt, nicht live).

CREATE TABLE LADEPROTOKOLL (
  log_zeit       TIMESTAMP DEFAULT SYSTIMESTAMP,
  ziel_schema    VARCHAR2(30),
  tabelle        VARCHAR2(30),
  status         VARCHAR2(20),
  zeilen         NUMBER,
  meldung        VARCHAR2(4000)
);
