-- Prueft, ob FLAG_ABSCHL auf TH_DWH_MASSNAHME_TKM existiert (im Ziel
-- und im Referenzschema) -- Tabellenname ggf. anpassen, sobald das
-- eigentliche Ziel aus der INSERT-Zeile bekannt ist.
SELECT owner, table_name, column_name, data_type, data_length
FROM dba_tab_columns
WHERE table_name = 'TH_DWH_MASSNAHME_TKM'
      AND column_name = 'FLAG_ABSCHL'
ORDER BY owner;

-- Falls FLAG_ABSCHL ueberhaupt nirgends existiert (auch nicht in
-- SVS45WH_FST): dann komplett schemaweit suchen, wo diese Spalte
-- normalerweise vorkommt, um das richtige Zielobjekt zu identifizieren.
SELECT owner, table_name, data_type, data_length
FROM dba_tab_columns
WHERE column_name = 'FLAG_ABSCHL'
ORDER BY owner, table_name;
