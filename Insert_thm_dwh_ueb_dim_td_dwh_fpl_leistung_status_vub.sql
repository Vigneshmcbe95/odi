--
-- Dimension 'DIM_FPL_Leistung_status_VuB' (td_dwh_fpl_leistung_status_vub)
--
-- Spalten:
-- lsv_id            Leistungstatus-VuB-ID     
-- lsv_shl           Leistungstatus-VuB-FPL    
-- lsv_sort          Sortierschlüssel          
-- lsv_bez           Bezeichnung               
-- lsv_bez_kurz      Kurzbezeichnung           
-- lsv_guelt_von_dat Beginndatum der Gültigkeit
-- lsv_guelt_bis_dat Endedatum der Gültigkeit  
-- lsv_erstel_dat    Erstelldatum              
-- lsv_update_dat    Änderungsdatum            
-- lsv_korr_dat      Korrekturdatum            
--
-- 8 Zeilen einzufügen.
INSERT ALL
	INTO td_dwh_fpl_leistung_status_vub
	(lsv_id, lsv_shl, lsv_sort, lsv_bez                    , lsv_bez_kurz             , lsv_guelt_von_dat                  , lsv_guelt_bis_dat, lsv_erstel_dat                     , lsv_update_dat, lsv_korr_dat)
	VALUES
	(1     , 'GBE'  , 1       , 'dem Grunde nach bewilligt', NULL                     , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-23', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_leistung_status_vub
	(lsv_id, lsv_shl, lsv_sort, lsv_bez                    , lsv_bez_kurz             , lsv_guelt_von_dat                  , lsv_guelt_bis_dat, lsv_erstel_dat                     , lsv_update_dat, lsv_korr_dat)
	VALUES
	(2     , 'GAB'  , 2       , 'dem Grunde nach abgelehnt', NULL                     , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-23', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_leistung_status_vub
	(lsv_id, lsv_shl, lsv_sort, lsv_bez                    , lsv_bez_kurz             , lsv_guelt_von_dat                  , lsv_guelt_bis_dat, lsv_erstel_dat                     , lsv_update_dat, lsv_korr_dat)
	VALUES
	(3     , 'GVE'  , 3       , 'dem Grunde nach versagt'  , NULL                     , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-23', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_leistung_status_vub
	(lsv_id, lsv_shl, lsv_sort, lsv_bez                    , lsv_bez_kurz             , lsv_guelt_von_dat                  , lsv_guelt_bis_dat, lsv_erstel_dat                     , lsv_update_dat, lsv_korr_dat)
	VALUES
	(4     , 'ZU'   , 4       , 'Anliegen zurückgezogen'   , NULL                     , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-23', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_leistung_status_vub
	(lsv_id, lsv_shl, lsv_sort, lsv_bez                    , lsv_bez_kurz             , lsv_guelt_von_dat                  , lsv_guelt_bis_dat, lsv_erstel_dat                     , lsv_update_dat, lsv_korr_dat)
	VALUES
	(9996  , '9996' , 9996    , 'Trifft nicht zu'          , 'Trifft nicht zu'        , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-23', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_leistung_status_vub
	(lsv_id, lsv_shl, lsv_sort, lsv_bez                    , lsv_bez_kurz             , lsv_guelt_von_dat                  , lsv_guelt_bis_dat, lsv_erstel_dat                     , lsv_update_dat, lsv_korr_dat)
	VALUES
	(9997  , '9997' , 9997    , 'Keine Angabe'             , 'Keine Angabe'           , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-23', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_leistung_status_vub
	(lsv_id, lsv_shl, lsv_sort, lsv_bez                    , lsv_bez_kurz             , lsv_guelt_von_dat                  , lsv_guelt_bis_dat, lsv_erstel_dat                     , lsv_update_dat, lsv_korr_dat)
	VALUES
	(9998  , '9998' , 9998    , 'Fehler im Ursprungswert'  , 'Fehler im Ursprungswert', TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-23', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_leistung_status_vub
	(lsv_id, lsv_shl, lsv_sort, lsv_bez                    , lsv_bez_kurz             , lsv_guelt_von_dat                  , lsv_guelt_bis_dat, lsv_erstel_dat                     , lsv_update_dat, lsv_korr_dat)
	VALUES
	(9999  , '9999' , 9999    , 'Keine Zuordnung möglich'  , 'Keine Zuordnung möglich', TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-23', 'YYYY-MM-DD'), NULL          , NULL        )
SELECT * FROM dual;

