-- KMD_KA fehlt in W310_loaded_variables, obwohl korrekt als
-- GET_COL_INHALT typisiert (kein Typ-Filter-Problem wie bei BSN_KA).
-- Ursache muss in der eigentlichen Wert-Query liegen (SELECT/FROM/
-- WHERE aus FST_VOR_INPUT_KM_TABLE) -- liefert sie in B05 null Zeilen?

-- 1) Die gespeicherte Query fuer KMD_KA ansehen.
SELECT variable_id, variable_name,
       col_inhalt_in_select, col_inhalt_in_from, col_inhalt_in_where
FROM SVS41WH_FST.FST_VOR_INPUT_KM_TABLE
WHERE UPPER(variable_name) = 'KMD_KA';

-- 2) Nachdem Schritt 1 den Text gezeigt hat: die zusammengesetzte
--    Query manuell nachbauen und direkt testen (Platzhalter LS_THM_*
--    durch das jeweils passende B05-Schema ersetzen, siehe
--    get_replace_lschema-Logik: LS_THM_DWH_FST -> SVS41WH_FST,
--    LS_THM_DWH_BA_TRS -> SVS41WH_BA_TRS, LS_THM_DWH_UEB_DIM ->
--    SVS41WH_UEB_DIM, alles andere bleibt echtes THM_*).
--
-- Beispiel-Geruest (Werte aus Schritt 1 einsetzen):
-- SELECT <col_inhalt_in_select>
-- FROM <col_inhalt_in_from, Schema ersetzt>
-- <col_inhalt_in_where>;
