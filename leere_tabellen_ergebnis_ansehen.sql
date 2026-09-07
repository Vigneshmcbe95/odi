-- Zeigt das Ergebnis des letzten Laufs von
-- leere_tabellen_pruefen_alle_schemas.sql -- eine Zeile pro Schema:
-- Anzahl Tabellen gesamt, Anzahl leer, und alle leeren Tabellennamen
-- in einer Zelle (komma-getrennt).
SELECT pruef_zeit, schema_name, anzahl_tabellen, anzahl_leer, leere_tabellen
FROM UBI_RUEMMELIN.LEERE_TABELLEN_ERGEBNIS
ORDER BY pruef_zeit DESC, schema_name;
