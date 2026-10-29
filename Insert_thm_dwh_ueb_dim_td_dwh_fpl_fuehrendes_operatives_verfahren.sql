--
-- Dimension 'DIM_FPL_fuehrendes_operatives_verfahren' (td_dwh_fpl_fuehrendes_operatives_verfahren)
--
-- Spalten:
-- fov_id            Fuehrendes-os-ID          
-- fov_ba_schl       Fuehrendes-os-FPL         
-- fov_sort          Sortierschlüssel          
-- fov_bez_lang      Bezeichnung               
-- fov_bez_kurz      Kurzbezeichnung           
-- fov_guelt_von_dat Beginndatum der Gültigkeit
-- fov_guelt_bis_dat Endedatum der Gültigkeit  
-- fov_erstel_dat    Erstelldatum              
-- fov_update_dat    Änderungsdatum            
-- fos_korr_dat      Korrekturdatum            
--
-- 6 Zeilen einzufügen.
INSERT ALL
	INTO td_dwh_fpl_fuehrendes_operatives_verfahren
	(fov_id, fov_ba_schl, fov_sort, fov_bez_lang                     , fov_bez_kurz             , fov_guelt_von_dat                  , fov_guelt_bis_dat, fov_erstel_dat                     , fov_update_dat, fos_korr_dat)
	VALUES
	(1     , '101'      , 1       , 'Förderplattform'                , 'FPL'                    , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-23', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_fuehrendes_operatives_verfahren
	(fov_id, fov_ba_schl, fov_sort, fov_bez_lang                     , fov_bez_kurz             , fov_guelt_von_dat                  , fov_guelt_bis_dat, fov_erstel_dat                     , fov_update_dat, fos_korr_dat)
	VALUES
	(2     , '102'      , 2       , 'COSACH - aus COSACH-FPL Fassade', 'COSACH - FPL Fassade'   , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-23', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_fuehrendes_operatives_verfahren
	(fov_id, fov_ba_schl, fov_sort, fov_bez_lang                     , fov_bez_kurz             , fov_guelt_von_dat                  , fov_guelt_bis_dat, fov_erstel_dat                     , fov_update_dat, fos_korr_dat)
	VALUES
	(9996  , '9996'     , 9996    , 'Trifft nicht zu'                , 'Trifft nicht zu'        , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-23', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_fuehrendes_operatives_verfahren
	(fov_id, fov_ba_schl, fov_sort, fov_bez_lang                     , fov_bez_kurz             , fov_guelt_von_dat                  , fov_guelt_bis_dat, fov_erstel_dat                     , fov_update_dat, fos_korr_dat)
	VALUES
	(9997  , '9997'     , 9997    , 'Keine Angabe'                   , 'Keine Angabe'           , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-23', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_fuehrendes_operatives_verfahren
	(fov_id, fov_ba_schl, fov_sort, fov_bez_lang                     , fov_bez_kurz             , fov_guelt_von_dat                  , fov_guelt_bis_dat, fov_erstel_dat                     , fov_update_dat, fos_korr_dat)
	VALUES
	(9998  , '9998'     , 9998    , 'Fehler im Ursprungswert'        , 'Fehler im Ursprungswert', TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-23', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_fuehrendes_operatives_verfahren
	(fov_id, fov_ba_schl, fov_sort, fov_bez_lang                     , fov_bez_kurz             , fov_guelt_von_dat                  , fov_guelt_bis_dat, fov_erstel_dat                     , fov_update_dat, fos_korr_dat)
	VALUES
	(9999  , '9999'     , 9999    , 'Keine Zuordnung möglich'        , 'Keine Zuordnung möglich', TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-23', 'YYYY-MM-DD'), NULL          , NULL        )
SELECT * FROM dual;

