--
-- Dimension 'DIM_FPL_Förderungs_status' (td_dwh_fpl_foerderung_status)
--
-- Spalten:
-- foe_id            Foerderungsstatus-ID      
-- foe_ba_schl       Foerderungsstatus-FPL     
-- foe_sort          Sortierschlüssel          
-- foe_bez_lang      Bezeichnung               
-- foe_bez_kurz      Kurzbezeichnung           
-- foe_guelt_von_dat Beginndatum der Gültigkeit
-- foe_guelt_bis_dat Endedatum der Gültigkeit  
-- foe_erstel_dat    Erstelldatum              
-- foe_update_dat    Änderungsdatum            
-- foerd_korr_dat    Korrekturdatum            
--
-- 11 Zeilen einzufügen.
INSERT ALL
	INTO td_dwh_fpl_foerderung_status
	(foe_id, foe_ba_schl, foe_sort, foe_bez_lang                , foe_bez_kurz                , foe_guelt_von_dat                  , foe_guelt_bis_dat, foe_erstel_dat                     , foe_update_dat, foerd_korr_dat)
	VALUES
	(1     , 'GBE'      , 1       , 'dem Grunde nach bewilligt' , 'dem Grunde nach bewilligt' , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-23', 'YYYY-MM-DD'), NULL          , NULL          )
	INTO td_dwh_fpl_foerderung_status
	(foe_id, foe_ba_schl, foe_sort, foe_bez_lang                , foe_bez_kurz                , foe_guelt_von_dat                  , foe_guelt_bis_dat, foe_erstel_dat                     , foe_update_dat, foerd_korr_dat)
	VALUES
	(2     , 'GAB'      , 2       , 'dem Grunde nach abgelehnt ', 'dem Grunde nach abgelehnt ', TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-23', 'YYYY-MM-DD'), NULL          , NULL          )
	INTO td_dwh_fpl_foerderung_status
	(foe_id, foe_ba_schl, foe_sort, foe_bez_lang                , foe_bez_kurz                , foe_guelt_von_dat                  , foe_guelt_bis_dat, foe_erstel_dat                     , foe_update_dat, foerd_korr_dat)
	VALUES
	(3     , 'GVE'      , 3       , 'dem Grunde nach versagt'   , 'dem Grunde nach versagt'   , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-23', 'YYYY-MM-DD'), NULL          , NULL          )
	INTO td_dwh_fpl_foerderung_status
	(foe_id, foe_ba_schl, foe_sort, foe_bez_lang                , foe_bez_kurz                , foe_guelt_von_dat                  , foe_guelt_bis_dat, foe_erstel_dat                     , foe_update_dat, foerd_korr_dat)
	VALUES
	(4     , 'ZU'       , 4       , 'Anliegen zurückgezogen'    , 'Anliegen zurückgezogen'    , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-23', 'YYYY-MM-DD'), NULL          , NULL          )
	INTO td_dwh_fpl_foerderung_status
	(foe_id, foe_ba_schl, foe_sort, foe_bez_lang                , foe_bez_kurz                , foe_guelt_von_dat                  , foe_guelt_bis_dat, foe_erstel_dat                     , foe_update_dat, foerd_korr_dat)
	VALUES
	(5     , 'BE'       , 5       , 'bewilligt'                 , 'bewilligt'                 , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-23', 'YYYY-MM-DD'), NULL          , NULL          )
	INTO td_dwh_fpl_foerderung_status
	(foe_id, foe_ba_schl, foe_sort, foe_bez_lang                , foe_bez_kurz                , foe_guelt_von_dat                  , foe_guelt_bis_dat, foe_erstel_dat                     , foe_update_dat, foerd_korr_dat)
	VALUES
	(6     , 'AB'       , 6       , 'abgelehnt'                 , 'abgelehnt'                 , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-23', 'YYYY-MM-DD'), NULL          , NULL          )
	INTO td_dwh_fpl_foerderung_status
	(foe_id, foe_ba_schl, foe_sort, foe_bez_lang                , foe_bez_kurz                , foe_guelt_von_dat                  , foe_guelt_bis_dat, foe_erstel_dat                     , foe_update_dat, foerd_korr_dat)
	VALUES
	(7     , 'VE'       , 7       , 'versagt'                   , 'versagt'                   , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-23', 'YYYY-MM-DD'), NULL          , NULL          )
	INTO td_dwh_fpl_foerderung_status
	(foe_id, foe_ba_schl, foe_sort, foe_bez_lang                , foe_bez_kurz                , foe_guelt_von_dat                  , foe_guelt_bis_dat, foe_erstel_dat                     , foe_update_dat, foerd_korr_dat)
	VALUES
	(9996  , '9996'     , 9996    , 'Trifft nicht zu'           , 'Trifft nicht zu'           , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-23', 'YYYY-MM-DD'), NULL          , NULL          )
	INTO td_dwh_fpl_foerderung_status
	(foe_id, foe_ba_schl, foe_sort, foe_bez_lang                , foe_bez_kurz                , foe_guelt_von_dat                  , foe_guelt_bis_dat, foe_erstel_dat                     , foe_update_dat, foerd_korr_dat)
	VALUES
	(9997  , '9997'     , 9997    , 'Keine Angabe'              , 'Keine Angabe'              , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-23', 'YYYY-MM-DD'), NULL          , NULL          )
	INTO td_dwh_fpl_foerderung_status
	(foe_id, foe_ba_schl, foe_sort, foe_bez_lang                , foe_bez_kurz                , foe_guelt_von_dat                  , foe_guelt_bis_dat, foe_erstel_dat                     , foe_update_dat, foerd_korr_dat)
	VALUES
	(9998  , '9998'     , 9998    , 'Fehler im Ursprungswert'   , 'Fehler im Ursprungswert'   , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-23', 'YYYY-MM-DD'), NULL          , NULL          )
	INTO td_dwh_fpl_foerderung_status
	(foe_id, foe_ba_schl, foe_sort, foe_bez_lang                , foe_bez_kurz                , foe_guelt_von_dat                  , foe_guelt_bis_dat, foe_erstel_dat                     , foe_update_dat, foerd_korr_dat)
	VALUES
	(9999  , '9999'     , 9999    , 'Keine Zuordnung möglich'   , 'Keine Zuordnung möglich'   , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-23', 'YYYY-MM-DD'), NULL          , NULL          )
SELECT * FROM dual;

