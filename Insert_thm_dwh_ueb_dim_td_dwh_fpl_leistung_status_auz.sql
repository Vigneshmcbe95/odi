--
-- Dimension 'DIM_FPL_Leistung_status_Auz' (td_dwh_fpl_leistung_status_auz)
--
-- Spalten:
-- lsz_id                 Leistungstatus-Auz-ID     
-- lsz_ba_schl            Leistungstatus-Auz-FPL    
-- lsz_sort               Sortierschlüssel          
-- lsz_bez_lang           Bezeichnung               
-- lsz_bez_kurz           Kurzbezeichnung           
-- lsz_guelt_von_dat      Beginndatum der Gültigkeit
-- lsz_guelt_bis_dat      Endedatum der Gültigkeit  
-- lsz_erstel_dat         Erstelldatum              
-- lsz_update_dat         Änderungsdatum            
-- lstg_stat_auz_korr_dat Korrekturdatum            
--
-- 8 Zeilen einzufügen.
INSERT ALL
	INTO td_dwh_fpl_leistung_status_auz
	(lsz_id, lsz_ba_schl, lsz_sort, lsz_bez_lang             , lsz_bez_kurz             , lsz_guelt_von_dat                  , lsz_guelt_bis_dat, lsz_erstel_dat                     , lsz_update_dat, lstg_stat_auz_korr_dat)
	VALUES
	(1     , 'BE'       , 1       , 'bewilligt'              , NULL                     , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-23', 'YYYY-MM-DD'), NULL          , NULL                  )
	INTO td_dwh_fpl_leistung_status_auz
	(lsz_id, lsz_ba_schl, lsz_sort, lsz_bez_lang             , lsz_bez_kurz             , lsz_guelt_von_dat                  , lsz_guelt_bis_dat, lsz_erstel_dat                     , lsz_update_dat, lstg_stat_auz_korr_dat)
	VALUES
	(2     , 'AB'       , 2       , 'abgelehnt'              , NULL                     , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-23', 'YYYY-MM-DD'), NULL          , NULL                  )
	INTO td_dwh_fpl_leistung_status_auz
	(lsz_id, lsz_ba_schl, lsz_sort, lsz_bez_lang             , lsz_bez_kurz             , lsz_guelt_von_dat                  , lsz_guelt_bis_dat, lsz_erstel_dat                     , lsz_update_dat, lstg_stat_auz_korr_dat)
	VALUES
	(3     , 'VE'       , 3       , 'versagt'                , NULL                     , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-23', 'YYYY-MM-DD'), NULL          , NULL                  )
	INTO td_dwh_fpl_leistung_status_auz
	(lsz_id, lsz_ba_schl, lsz_sort, lsz_bez_lang             , lsz_bez_kurz             , lsz_guelt_von_dat                  , lsz_guelt_bis_dat, lsz_erstel_dat                     , lsz_update_dat, lstg_stat_auz_korr_dat)
	VALUES
	(4     , 'ZU'       , 4       , 'Anliegen zurückgezogen' , NULL                     , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-23', 'YYYY-MM-DD'), NULL          , NULL                  )
	INTO td_dwh_fpl_leistung_status_auz
	(lsz_id, lsz_ba_schl, lsz_sort, lsz_bez_lang             , lsz_bez_kurz             , lsz_guelt_von_dat                  , lsz_guelt_bis_dat, lsz_erstel_dat                     , lsz_update_dat, lstg_stat_auz_korr_dat)
	VALUES
	(9996  , '9996'     , 9996    , 'Trifft nicht zu'        , 'Trifft nicht zu'        , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-23', 'YYYY-MM-DD'), NULL          , NULL                  )
	INTO td_dwh_fpl_leistung_status_auz
	(lsz_id, lsz_ba_schl, lsz_sort, lsz_bez_lang             , lsz_bez_kurz             , lsz_guelt_von_dat                  , lsz_guelt_bis_dat, lsz_erstel_dat                     , lsz_update_dat, lstg_stat_auz_korr_dat)
	VALUES
	(9997  , '9997'     , 9997    , 'Keine Angabe'           , 'Keine Angabe'           , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-23', 'YYYY-MM-DD'), NULL          , NULL                  )
	INTO td_dwh_fpl_leistung_status_auz
	(lsz_id, lsz_ba_schl, lsz_sort, lsz_bez_lang             , lsz_bez_kurz             , lsz_guelt_von_dat                  , lsz_guelt_bis_dat, lsz_erstel_dat                     , lsz_update_dat, lstg_stat_auz_korr_dat)
	VALUES
	(9998  , '9998'     , 9998    , 'Fehler im Ursprungswert', 'Fehler im Ursprungswert', TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-23', 'YYYY-MM-DD'), NULL          , NULL                  )
	INTO td_dwh_fpl_leistung_status_auz
	(lsz_id, lsz_ba_schl, lsz_sort, lsz_bez_lang             , lsz_bez_kurz             , lsz_guelt_von_dat                  , lsz_guelt_bis_dat, lsz_erstel_dat                     , lsz_update_dat, lstg_stat_auz_korr_dat)
	VALUES
	(9999  , '9999'     , 9999    , 'Keine Zuordnung möglich', 'Keine Zuordnung möglich', TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-23', 'YYYY-MM-DD'), NULL          , NULL                  )
SELECT * FROM dual;

