--
-- Dimension 'DIM_FPL_Förderart' (td_dwh_fpl_foerderart)
--
-- Spalten:
-- foa_id            Förderart-ID              
-- fot_id            Fördertyp-ID              
-- foa_ba_schl       Förderart FPL             
-- foa_sort          Sortierschlüssel          
-- foa_bez_lang      Bezeichnung               
-- foa_bez_kurz      Kurzbezeichnung           
-- foa_guelt_von_dat Beginndatum der Gültigkeit
-- foa_guelt_bis_dat Endedatum der Gültigkeit  
-- foa_erstel_dat    Erstelldatum              
-- foa_update_dat    Änderungsdatum            
-- foa_korr_dat      Korrekturdatum            
--
-- 24 Zeilen einzufügen.
INSERT ALL
	INTO td_dwh_fpl_foerderart
	(foa_id, fot_id, foa_ba_schl             , foa_sort, foa_bez_lang                                                                                      , foa_bez_kurz, foa_guelt_von_dat                  , foa_guelt_bis_dat, foa_erstel_dat                     , foa_update_dat, foa_korr_dat)
	VALUES
	(1     , 1     , 'EQ-SGB3-001'           , 1       , 'Einstiegsqualifizierung SGB III'                                                                 , NULL        , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-20', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_foerderart
	(foa_id, fot_id, foa_ba_schl             , foa_sort, foa_bez_lang                                                                                      , foa_bez_kurz, foa_guelt_von_dat                  , foa_guelt_bis_dat, foa_erstel_dat                     , foa_update_dat, foa_korr_dat)
	VALUES
	(2     , 1     , 'EQ-SGB2-001'           , 2       , 'Einstiegsqualifizierung SGB II'                                                                  , NULL        , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-20', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_foerderart
	(foa_id, fot_id, foa_ba_schl             , foa_sort, foa_bez_lang                                                                                      , foa_bez_kurz, foa_guelt_von_dat                  , foa_guelt_bis_dat, foa_erstel_dat                     , foa_update_dat, foa_korr_dat)
	VALUES
	(3     , 1     , 'EGZ-SGB3-AUW-001'      , 3       , 'Eingliederungszuschuss – im Anschluss an Aus- oder Weiterbildung SGB III'                        , NULL        , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-20', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_foerderart
	(foa_id, fot_id, foa_ba_schl             , foa_sort, foa_bez_lang                                                                                      , foa_bez_kurz, foa_guelt_von_dat                  , foa_guelt_bis_dat, foa_erstel_dat                     , foa_update_dat, foa_korr_dat)
	VALUES
	(4     , 1     , 'EGZ-SGB2-AUW-001'      , 4       , 'Eingliederungszuschuss – im Anschluss an Aus- oder Weiterbildung SGB II'                         , NULL        , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-20', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_foerderart
	(foa_id, fot_id, foa_ba_schl             , foa_sort, foa_bez_lang                                                                                      , foa_bez_kurz, foa_guelt_von_dat                  , foa_guelt_bis_dat, foa_erstel_dat                     , foa_update_dat, foa_korr_dat)
	VALUES
	(5     , 1     , 'AZ-SGB3-SB-001'        , 5       , 'Ausbildungszuschuss – für schwerbehinderte und gleichgestellte Menschen SGB III'                 , NULL        , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-20', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_foerderart
	(foa_id, fot_id, foa_ba_schl             , foa_sort, foa_bez_lang                                                                                      , foa_bez_kurz, foa_guelt_von_dat                  , foa_guelt_bis_dat, foa_erstel_dat                     , foa_update_dat, foa_korr_dat)
	VALUES
	(6     , 1     , 'AZ-SGB2-SB-001'        , 6       , 'Ausbildungszuschuss – für schwerbehinderte und gleichgestellte Menschen SGB II'                  , NULL        , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-20', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_foerderart
	(foa_id, fot_id, foa_ba_schl             , foa_sort, foa_bez_lang                                                                                      , foa_bez_kurz, foa_guelt_von_dat                  , foa_guelt_bis_dat, foa_erstel_dat                     , foa_update_dat, foa_korr_dat)
	VALUES
	(7     , 1     , 'AZ-SGB3-001'           , 7       , '	Ausbildungszuschuss – Reha SGB III'                                                             , NULL        , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-20', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_foerderart
	(foa_id, fot_id, foa_ba_schl             , foa_sort, foa_bez_lang                                                                                      , foa_bez_kurz, foa_guelt_von_dat                  , foa_guelt_bis_dat, foa_erstel_dat                     , foa_update_dat, foa_korr_dat)
	VALUES
	(8     , 1     , 'AEZ-SGB3-001'          , 8       , 'Arbeitsentgeltzuschuss bei beruflicher Weiterbildung SGB III'                                    , NULL        , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-20', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_foerderart
	(foa_id, fot_id, foa_ba_schl             , foa_sort, foa_bez_lang                                                                                      , foa_bez_kurz, foa_guelt_von_dat                  , foa_guelt_bis_dat, foa_erstel_dat                     , foa_update_dat, foa_korr_dat)
	VALUES
	(9     , 1     , 'EGZ-SGB3-ALL-001'      , 9       , 'Eingliederungszuschuss – allgemein SGB III'                                                      , NULL        , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-20', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_foerderart
	(foa_id, fot_id, foa_ba_schl             , foa_sort, foa_bez_lang                                                                                      , foa_bez_kurz, foa_guelt_von_dat                  , foa_guelt_bis_dat, foa_erstel_dat                     , foa_update_dat, foa_korr_dat)
	VALUES
	(10    , 1     , 'EGZ-SGB2-ALL-001'      , 10      , 'Eingliederungszuschuss – allgemein SGB II'                                                       , NULL        , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-20', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_foerderart
	(foa_id, fot_id, foa_ba_schl             , foa_sort, foa_bez_lang                                                                                      , foa_bez_kurz, foa_guelt_von_dat                  , foa_guelt_bis_dat, foa_erstel_dat                     , foa_update_dat, foa_korr_dat)
	VALUES
	(11    , 1     , 'EGZ-SGB3-AELT-001'     , 11      , 'Eingliederungszuschuss – für Ältere SGB III'                                                     , NULL        , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-20', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_foerderart
	(foa_id, fot_id, foa_ba_schl             , foa_sort, foa_bez_lang                                                                                      , foa_bez_kurz, foa_guelt_von_dat                  , foa_guelt_bis_dat, foa_erstel_dat                     , foa_update_dat, foa_korr_dat)
	VALUES
	(12    , 1     , 'EGZ-SGB2-AELT-001 '    , 12      , 'Eingliederungszuschuss – für Ältere SGB II'                                                      , NULL        , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-20', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_foerderart
	(foa_id, fot_id, foa_ba_schl             , foa_sort, foa_bez_lang                                                                                      , foa_bez_kurz, foa_guelt_von_dat                  , foa_guelt_bis_dat, foa_erstel_dat                     , foa_update_dat, foa_korr_dat)
	VALUES
	(13    , 1     , 'EGZ-SGB3-SB-001'       , 13      , 'Eingliederungszuschuss – für Menschen mit Behinderungen und schwerbehinderte Menschen SGB III'   , NULL        , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-20', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_foerderart
	(foa_id, fot_id, foa_ba_schl             , foa_sort, foa_bez_lang                                                                                      , foa_bez_kurz, foa_guelt_von_dat                  , foa_guelt_bis_dat, foa_erstel_dat                     , foa_update_dat, foa_korr_dat)
	VALUES
	(14    , 1     , 'EGZ-SGB2-SB-001 '      , 14      , 'Eingliederungszuschuss – für Menschen mit Behinderungen und schwerbehinderte Menschen SGB II'    , NULL        , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-20', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_foerderart
	(foa_id, fot_id, foa_ba_schl             , foa_sort, foa_bez_lang                                                                                      , foa_bez_kurz, foa_guelt_von_dat                  , foa_guelt_bis_dat, foa_erstel_dat                     , foa_update_dat, foa_korr_dat)
	VALUES
	(15    , 1     , 'EGZ-SGB3-BBSB-AELT-001', 15      , 'Eingliederungszuschuss – für besonders betroffene schwerbehinderte Menschen ab 55 Jahren SGB III', NULL        , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-20', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_foerderart
	(foa_id, fot_id, foa_ba_schl             , foa_sort, foa_bez_lang                                                                                      , foa_bez_kurz, foa_guelt_von_dat                  , foa_guelt_bis_dat, foa_erstel_dat                     , foa_update_dat, foa_korr_dat)
	VALUES
	(16    , 1     , 'EGZ-SGB2-BBSB-AELT-001', 16      , 'Eingliederungszuschuss – für besonders betroffene schwerbehinderte Menschen ab 55 Jahren SGB II' , NULL        , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-20', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_foerderart
	(foa_id, fot_id, foa_ba_schl             , foa_sort, foa_bez_lang                                                                                      , foa_bez_kurz, foa_guelt_von_dat                  , foa_guelt_bis_dat, foa_erstel_dat                     , foa_update_dat, foa_korr_dat)
	VALUES
	(17    , 1     , 'EGZ-SGB3-BBSB-001'     , 17      , 'Eingliederungszuschuss – für besonders betroffene schwerbehinderte Menschen SGB III'             , NULL        , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-20', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_foerderart
	(foa_id, fot_id, foa_ba_schl             , foa_sort, foa_bez_lang                                                                                      , foa_bez_kurz, foa_guelt_von_dat                  , foa_guelt_bis_dat, foa_erstel_dat                     , foa_update_dat, foa_korr_dat)
	VALUES
	(18    , 1     , 'EGZ-SGB2-BBSB-001'     , 18      , 'Eingliederungszuschuss – für besonders betroffene schwerbehinderte Menschen SGB II'              , NULL        , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-20', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_foerderart
	(foa_id, fot_id, foa_ba_schl             , foa_sort, foa_bez_lang                                                                                      , foa_bez_kurz, foa_guelt_von_dat                  , foa_guelt_bis_dat, foa_erstel_dat                     , foa_update_dat, foa_korr_dat)
	VALUES
	(19    , 1     , 'BEZ-SGB2-eT-001'       , 19      , 'Beschäftigungszuschuss für Tätigkeiten außerhalb öffentlich geförderter Beschäftigung SGBII'     , NULL        , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-20', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_foerderart
	(foa_id, fot_id, foa_ba_schl             , foa_sort, foa_bez_lang                                                                                      , foa_bez_kurz, foa_guelt_von_dat                  , foa_guelt_bis_dat, foa_erstel_dat                     , foa_update_dat, foa_korr_dat)
	VALUES
	(20    , 1     , 'BEZ-SGB2-oeT-001'      , 20      , 'Beschäftigungszuschuss für zusätzliche und im öffentlichen Interesse liegende Tätigkeiten SGBII' , NULL        , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-20', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_foerderart
	(foa_id, fot_id, foa_ba_schl             , foa_sort, foa_bez_lang                                                                                      , foa_bez_kurz, foa_guelt_von_dat                  , foa_guelt_bis_dat, foa_erstel_dat                     , foa_update_dat, foa_korr_dat)
	VALUES
	(9996  , 9996  , '9996'                  , 9996    , 'trifft nicht zu'                                                                                 , NULL        , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-20', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_foerderart
	(foa_id, fot_id, foa_ba_schl             , foa_sort, foa_bez_lang                                                                                      , foa_bez_kurz, foa_guelt_von_dat                  , foa_guelt_bis_dat, foa_erstel_dat                     , foa_update_dat, foa_korr_dat)
	VALUES
	(9997  , 9997  , '9997'                  , 9997    , 'keine Angabe'                                                                                    , NULL        , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-20', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_foerderart
	(foa_id, fot_id, foa_ba_schl             , foa_sort, foa_bez_lang                                                                                      , foa_bez_kurz, foa_guelt_von_dat                  , foa_guelt_bis_dat, foa_erstel_dat                     , foa_update_dat, foa_korr_dat)
	VALUES
	(9998  , 9998  , '9998'                  , 9998    , 'Fehler im Ursprungswert'                                                                         , NULL        , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-20', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_foerderart
	(foa_id, fot_id, foa_ba_schl             , foa_sort, foa_bez_lang                                                                                      , foa_bez_kurz, foa_guelt_von_dat                  , foa_guelt_bis_dat, foa_erstel_dat                     , foa_update_dat, foa_korr_dat)
	VALUES
	(9999  , 9999  , '9999'                  , 9999    , 'keine Zuordnung möglich'                                                                         , NULL        , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-20', 'YYYY-MM-DD'), NULL          , NULL        )
SELECT * FROM dual;

