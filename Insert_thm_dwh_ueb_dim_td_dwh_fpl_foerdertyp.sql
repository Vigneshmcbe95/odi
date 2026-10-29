--
-- Dimension 'DIM_FPL_Fördertyp' (td_dwh_fpl_foerdertyp)
--
-- Spalten:
-- fot_id            Fördertyp-ID              
-- fot_ba_schl       Fördertyp FPL             
-- fot_sort          Sortierschlüssel          
-- fot_bez_lang      Bezeichnung               
-- fot_bez_kurz      Kurzbezeichnung           
-- fot_guelt_von_dat Beginndatum der Gültigkeit
-- fot_guelt_bis_dat Endedatum der Gültigkeit  
-- fot_erstel_dat    Erstelldatum              
-- fot_update_dat    Änderungsdatum            
-- fot_korr_dat      Korrekturdatum            
--
-- 5 Zeilen einzufügen.
INSERT ALL
	INTO td_dwh_fpl_foerdertyp
	(fot_id, fot_ba_schl, fot_sort, fot_bez_lang                       , fot_bez_kurz, fot_guelt_von_dat                  , fot_guelt_bis_dat, fot_erstel_dat                     , fot_update_dat, fot_korr_dat)
	VALUES
	(1     , 'EZ-AG'    , 1       , 'Entgeltzuschüsse für Arbeitgeber ', NULL        , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-08-24', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_foerdertyp
	(fot_id, fot_ba_schl, fot_sort, fot_bez_lang                       , fot_bez_kurz, fot_guelt_von_dat                  , fot_guelt_bis_dat, fot_erstel_dat                     , fot_update_dat, fot_korr_dat)
	VALUES
	(9996  , '9996'     , 9996    , 'Trifft nicht zu'                  , NULL        , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-08-24', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_foerdertyp
	(fot_id, fot_ba_schl, fot_sort, fot_bez_lang                       , fot_bez_kurz, fot_guelt_von_dat                  , fot_guelt_bis_dat, fot_erstel_dat                     , fot_update_dat, fot_korr_dat)
	VALUES
	(9997  , '9997'     , 9997    , 'Keine Angabe'                     , NULL        , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-08-24', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_foerdertyp
	(fot_id, fot_ba_schl, fot_sort, fot_bez_lang                       , fot_bez_kurz, fot_guelt_von_dat                  , fot_guelt_bis_dat, fot_erstel_dat                     , fot_update_dat, fot_korr_dat)
	VALUES
	(9998  , '9998'     , 9998    , 'Fehler im Ursprungswert'          , NULL        , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-08-24', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_foerdertyp
	(fot_id, fot_ba_schl, fot_sort, fot_bez_lang                       , fot_bez_kurz, fot_guelt_von_dat                  , fot_guelt_bis_dat, fot_erstel_dat                     , fot_update_dat, fot_korr_dat)
	VALUES
	(9999  , '9999'     , 9999    , 'Keine Zuordnung möglich'          , NULL        , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-08-24', 'YYYY-MM-DD'), NULL          , NULL        )
SELECT * FROM dual;

