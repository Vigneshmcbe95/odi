--
-- Dimension 'DIM_FPL_Leistungstyp' (td_dwh_fpl_Leistungstyp)
--
-- Spalten:
-- lst_id            Leistungstyp-ID           
-- lst_ba_schl       Leistungstyp-FPL          
-- lst_sort          Sortierschlüssel          
-- lst_bez_lang      Bezeichnung               
-- lst_bez_kurz      Kurzbezeichnung           
-- lst_guelt_von_dat Beginndatum der Gültigkeit
-- lst_guelt_bis_dat Endedatum der Gültigkeit  
-- lst_erstel_dat    Erstelldatum              
-- lst_update_dat    Änderungsdatum            
-- lstg_typ_korr_dat Korrekturdatum            
--
-- 19 Zeilen einzufügen.
INSERT ALL
	INTO td_dwh_fpl_Leistungstyp
	(lst_id, lst_ba_schl, lst_sort, lst_bez_lang                                                              , lst_bez_kurz             , lst_guelt_von_dat                  , lst_guelt_bis_dat, lst_erstel_dat                     , lst_update_dat, lstg_typ_korr_dat)
	VALUES
	(1     , '1'        , 1       , 'Lohnkostenzuschuss / Entgeltzuschuss'                                    , NULL                     , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-23', 'YYYY-MM-DD'), NULL          , NULL             )
	INTO td_dwh_fpl_Leistungstyp
	(lst_id, lst_ba_schl, lst_sort, lst_bez_lang                                                              , lst_bez_kurz             , lst_guelt_von_dat                  , lst_guelt_bis_dat, lst_erstel_dat                     , lst_update_dat, lstg_typ_korr_dat)
	VALUES
	(2     , '2'        , 2       , 'Fahrkosten'                                                              , NULL                     , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-23', 'YYYY-MM-DD'), NULL          , NULL             )
	INTO td_dwh_fpl_Leistungstyp
	(lst_id, lst_ba_schl, lst_sort, lst_bez_lang                                                              , lst_bez_kurz             , lst_guelt_von_dat                  , lst_guelt_bis_dat, lst_erstel_dat                     , lst_update_dat, lstg_typ_korr_dat)
	VALUES
	(3     , '3'        , 3       , 'Weiterbildungskosten'                                                    , NULL                     , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-23', 'YYYY-MM-DD'), NULL          , NULL             )
	INTO td_dwh_fpl_Leistungstyp
	(lst_id, lst_ba_schl, lst_sort, lst_bez_lang                                                              , lst_bez_kurz             , lst_guelt_von_dat                  , lst_guelt_bis_dat, lst_erstel_dat                     , lst_update_dat, lstg_typ_korr_dat)
	VALUES
	(4     , '4'        , 4       , 'Vermittlungsprämie'                                                      , NULL                     , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-23', 'YYYY-MM-DD'), NULL          , NULL             )
	INTO td_dwh_fpl_Leistungstyp
	(lst_id, lst_ba_schl, lst_sort, lst_bez_lang                                                              , lst_bez_kurz             , lst_guelt_von_dat                  , lst_guelt_bis_dat, lst_erstel_dat                     , lst_update_dat, lstg_typ_korr_dat)
	VALUES
	(5     , '5'        , 5       , 'Passiv-Aktiv-Transfer'                                                   , NULL                     , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-23', 'YYYY-MM-DD'), NULL          , NULL             )
	INTO td_dwh_fpl_Leistungstyp
	(lst_id, lst_ba_schl, lst_sort, lst_bez_lang                                                              , lst_bez_kurz             , lst_guelt_von_dat                  , lst_guelt_bis_dat, lst_erstel_dat                     , lst_update_dat, lstg_typ_korr_dat)
	VALUES
	(6     , '6'        , 6       , 'Auswärtige Unterbringungs- und Verpflegungskosten'                       , NULL                     , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-23', 'YYYY-MM-DD'), NULL          , NULL             )
	INTO td_dwh_fpl_Leistungstyp
	(lst_id, lst_ba_schl, lst_sort, lst_bez_lang                                                              , lst_bez_kurz             , lst_guelt_von_dat                  , lst_guelt_bis_dat, lst_erstel_dat                     , lst_update_dat, lstg_typ_korr_dat)
	VALUES
	(7     , '7'        , 7       , 'Kinderbetreuungskosten'                                                  , NULL                     , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-23', 'YYYY-MM-DD'), NULL          , NULL             )
	INTO td_dwh_fpl_Leistungstyp
	(lst_id, lst_ba_schl, lst_sort, lst_bez_lang                                                              , lst_bez_kurz             , lst_guelt_von_dat                  , lst_guelt_bis_dat, lst_erstel_dat                     , lst_update_dat, lstg_typ_korr_dat)
	VALUES
	(8     , '8'        , 8       , 'Sonstige Kosten'                                                         , NULL                     , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-23', 'YYYY-MM-DD'), NULL          , NULL             )
	INTO td_dwh_fpl_Leistungstyp
	(lst_id, lst_ba_schl, lst_sort, lst_bez_lang                                                              , lst_bez_kurz             , lst_guelt_von_dat                  , lst_guelt_bis_dat, lst_erstel_dat                     , lst_update_dat, lstg_typ_korr_dat)
	VALUES
	(9     , '9'        , 9       , 'behinderungsbedingter Mehraufwand'                                       , NULL                     , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-23', 'YYYY-MM-DD'), NULL          , NULL             )
	INTO td_dwh_fpl_Leistungstyp
	(lst_id, lst_ba_schl, lst_sort, lst_bez_lang                                                              , lst_bez_kurz             , lst_guelt_von_dat                  , lst_guelt_bis_dat, lst_erstel_dat                     , lst_update_dat, lstg_typ_korr_dat)
	VALUES
	(10    , '10'       , 10      , 'Weiterbildungsgeld (Zwischenprüfung und Abschlussprüfung folgen daraus?)', NULL                     , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-23', 'YYYY-MM-DD'), NULL          , NULL             )
	INTO td_dwh_fpl_Leistungstyp
	(lst_id, lst_ba_schl, lst_sort, lst_bez_lang                                                              , lst_bez_kurz             , lst_guelt_von_dat                  , lst_guelt_bis_dat, lst_erstel_dat                     , lst_update_dat, lstg_typ_korr_dat)
	VALUES
	(11    , '11'       , 11      , 'Familienheimfahrten'                                                     , NULL                     , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-23', 'YYYY-MM-DD'), NULL          , NULL             )
	INTO td_dwh_fpl_Leistungstyp
	(lst_id, lst_ba_schl, lst_sort, lst_bez_lang                                                              , lst_bez_kurz             , lst_guelt_von_dat                  , lst_guelt_bis_dat, lst_erstel_dat                     , lst_update_dat, lstg_typ_korr_dat)
	VALUES
	(12    , '12'       , 12      , 'Haushaltshilfe'                                                          , NULL                     , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-23', 'YYYY-MM-DD'), NULL          , NULL             )
	INTO td_dwh_fpl_Leistungstyp
	(lst_id, lst_ba_schl, lst_sort, lst_bez_lang                                                              , lst_bez_kurz             , lst_guelt_von_dat                  , lst_guelt_bis_dat, lst_erstel_dat                     , lst_update_dat, lstg_typ_korr_dat)
	VALUES
	(13    , '13'       , 13      , 'Pendelfahrten'                                                           , NULL                     , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-23', 'YYYY-MM-DD'), NULL          , NULL             )
	INTO td_dwh_fpl_Leistungstyp
	(lst_id, lst_ba_schl, lst_sort, lst_bez_lang                                                              , lst_bez_kurz             , lst_guelt_von_dat                  , lst_guelt_bis_dat, lst_erstel_dat                     , lst_update_dat, lstg_typ_korr_dat)
	VALUES
	(14    , '14'       , 14      , 'Wertmarke'                                                               , NULL                     , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-23', 'YYYY-MM-DD'), NULL          , NULL             )
	INTO td_dwh_fpl_Leistungstyp
	(lst_id, lst_ba_schl, lst_sort, lst_bez_lang                                                              , lst_bez_kurz             , lst_guelt_von_dat                  , lst_guelt_bis_dat, lst_erstel_dat                     , lst_update_dat, lstg_typ_korr_dat)
	VALUES
	(15    , '15'       , 15      , 'Maßnahmekosten'                                                          , NULL                     , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-23', 'YYYY-MM-DD'), NULL          , NULL             )
	INTO td_dwh_fpl_Leistungstyp
	(lst_id, lst_ba_schl, lst_sort, lst_bez_lang                                                              , lst_bez_kurz             , lst_guelt_von_dat                  , lst_guelt_bis_dat, lst_erstel_dat                     , lst_update_dat, lstg_typ_korr_dat)
	VALUES
	(9996  , '9996'     , 9996    , 'Trifft nicht zu'                                                         , 'Trifft nicht zu'        , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-23', 'YYYY-MM-DD'), NULL          , NULL             )
	INTO td_dwh_fpl_Leistungstyp
	(lst_id, lst_ba_schl, lst_sort, lst_bez_lang                                                              , lst_bez_kurz             , lst_guelt_von_dat                  , lst_guelt_bis_dat, lst_erstel_dat                     , lst_update_dat, lstg_typ_korr_dat)
	VALUES
	(9997  , '9997'     , 9997    , 'Keine Angabe'                                                            , 'Keine Angabe'           , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-23', 'YYYY-MM-DD'), NULL          , NULL             )
	INTO td_dwh_fpl_Leistungstyp
	(lst_id, lst_ba_schl, lst_sort, lst_bez_lang                                                              , lst_bez_kurz             , lst_guelt_von_dat                  , lst_guelt_bis_dat, lst_erstel_dat                     , lst_update_dat, lstg_typ_korr_dat)
	VALUES
	(9998  , '9998'     , 9998    , 'Fehler im Ursprungswert'                                                 , 'Fehler im Ursprungswert', TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-23', 'YYYY-MM-DD'), NULL          , NULL             )
	INTO td_dwh_fpl_Leistungstyp
	(lst_id, lst_ba_schl, lst_sort, lst_bez_lang                                                              , lst_bez_kurz             , lst_guelt_von_dat                  , lst_guelt_bis_dat, lst_erstel_dat                     , lst_update_dat, lstg_typ_korr_dat)
	VALUES
	(9999  , '9999'     , 9999    , 'Keine Zuordnung möglich'                                                 , 'Keine Zuordnung möglich', TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-23', 'YYYY-MM-DD'), NULL          , NULL             )
SELECT * FROM dual;

