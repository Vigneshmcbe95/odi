--
-- Dimension 'DIM_FPL_Beendigungsgrund' (td_dwh_fpl_beendigungsgrund)
--
-- Spalten:
-- bey_id            Beendigungsgrund-ID       
-- bey_ba_schl       Beendigungsgrund FPL      
-- bey_sort          Sortierschlüssel          
-- bey_bez_lang      Bezeichnung               
-- bey_bez_kurz      Kurzbezeichnung           
-- bey_guelt_von_dat Beginndatum der Gültigkeit
-- bey_guelt_bis_dat Endedatum der Gültigkeit  
-- bey_erstel_dat    Erstelldatum              
-- bey_update_dat    Änderungsdatum            
-- bey_korr_dat      Korrekturdatum            
--
-- 16 Zeilen einzufügen.
INSERT ALL
	INTO td_dwh_fpl_beendigungsgrund
	(bey_id, bey_ba_schl, bey_sort, bey_bez_lang                                                                          , bey_bez_kurz                                  , bey_guelt_von_dat                  , bey_guelt_bis_dat, bey_erstel_dat                     , bey_update_dat, bey_korr_dat)
	VALUES
	(1     , '20'       , 1       , 'Arbeitsaufnahme (befristete, unbefristete, geringfügige oder selbständige Tätigkeit)', 'Arbeitsaufnahme'                             , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-20', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_beendigungsgrund
	(bey_id, bey_ba_schl, bey_sort, bey_bez_lang                                                                          , bey_bez_kurz                                  , bey_guelt_von_dat                  , bey_guelt_bis_dat, bey_erstel_dat                     , bey_update_dat, bey_korr_dat)
	VALUES
	(2     , '30'       , 2       , 'Aufnahme einer Ausbildung (betrieblich, außerbetrieblich, schulisch)'                , 'Aufnahme einer Ausbildung '                  , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-20', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_beendigungsgrund
	(bey_id, bey_ba_schl, bey_sort, bey_bez_lang                                                                          , bey_bez_kurz                                  , bey_guelt_von_dat                  , bey_guelt_bis_dat, bey_erstel_dat                     , bey_update_dat, bey_korr_dat)
	VALUES
	(3     , '40'       , 3       , 'Maßnahme-/ Förderziel (vorzeitig) erreicht'                                          , 'Maßnahme-/ Förderziel (vorzeitig) erreicht ' , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-20', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_beendigungsgrund
	(bey_id, bey_ba_schl, bey_sort, bey_bez_lang                                                                          , bey_bez_kurz                                  , bey_guelt_von_dat                  , bey_guelt_bis_dat, bey_erstel_dat                     , bey_update_dat, bey_korr_dat)
	VALUES
	(4     , '42'       , 4       , 'vertragswidriges Verhalten'                                                          , 'vertragswidriges Verhalten'                  , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-20', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_beendigungsgrund
	(bey_id, bey_ba_schl, bey_sort, bey_bez_lang                                                                          , bey_bez_kurz                                  , bey_guelt_von_dat                  , bey_guelt_bis_dat, bey_erstel_dat                     , bey_update_dat, bey_korr_dat)
	VALUES
	(5     , '43'       , 5       , 'fehlende Motivation/Mitwirkung'                                                      , 'fehlende Motivation/Mitwirkung'              , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-20', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_beendigungsgrund
	(bey_id, bey_ba_schl, bey_sort, bey_bez_lang                                                                          , bey_bez_kurz                                  , bey_guelt_von_dat                  , bey_guelt_bis_dat, bey_erstel_dat                     , bey_update_dat, bey_korr_dat)
	VALUES
	(6     , '44'       , 6       , 'Über-/Unterforderung'                                                                , 'Über-/Unterforderung'                        , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-20', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_beendigungsgrund
	(bey_id, bey_ba_schl, bey_sort, bey_bez_lang                                                                          , bey_bez_kurz                                  , bey_guelt_von_dat                  , bey_guelt_bis_dat, bey_erstel_dat                     , bey_update_dat, bey_korr_dat)
	VALUES
	(7     , '50'       , 7       , 'Maßnahme-/ Förderziel nicht erreicht und z. B. Wechsel in andere Maßnahme'           , 'Berufsvorbereitung (z.B. EQ, BvB, AsA)'      , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-20', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_beendigungsgrund
	(bey_id, bey_ba_schl, bey_sort, bey_bez_lang                                                                          , bey_bez_kurz                                  , bey_guelt_von_dat                  , bey_guelt_bis_dat, bey_erstel_dat                     , bey_update_dat, bey_korr_dat)
	VALUES
	(8     , '60'       , 8       , 'fehlende Arbeitsmarkt-Fähigkeit (z. B. WfbM)'                                        , 'fehlende Arbeitsmarkt-Fähigkeit (z. B. WfbM)', TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-20', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_beendigungsgrund
	(bey_id, bey_ba_schl, bey_sort, bey_bez_lang                                                                          , bey_bez_kurz                                  , bey_guelt_von_dat                  , bey_guelt_bis_dat, bey_erstel_dat                     , bey_update_dat, bey_korr_dat)
	VALUES
	(9     , '70'       , 9       , 'gesundheitliche Beeinträchtigungen'                                                  , 'gesundheitliche Beeinträchtigungen'          , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-20', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_beendigungsgrund
	(bey_id, bey_ba_schl, bey_sort, bey_bez_lang                                                                          , bey_bez_kurz                                  , bey_guelt_von_dat                  , bey_guelt_bis_dat, bey_erstel_dat                     , bey_update_dat, bey_korr_dat)
	VALUES
	(10    , '80'       , 10      , 'Schule / Studium'                                                                    , 'Schule / Studium'                            , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-20', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_beendigungsgrund
	(bey_id, bey_ba_schl, bey_sort, bey_bez_lang                                                                          , bey_bez_kurz                                  , bey_guelt_von_dat                  , bey_guelt_bis_dat, bey_erstel_dat                     , bey_update_dat, bey_korr_dat)
	VALUES
	(11    , '90'       , 11      , 'Sonstige Gründe (z.B. Mutterschutz, Wehrdienst, Umzug)'                              , 'Sonstige Gründe '                            , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-20', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_beendigungsgrund
	(bey_id, bey_ba_schl, bey_sort, bey_bez_lang                                                                          , bey_bez_kurz                                  , bey_guelt_von_dat                  , bey_guelt_bis_dat, bey_erstel_dat                     , bey_update_dat, bey_korr_dat)
	VALUES
	(12    , '91'       , 12      , 'Aufgabe des Betriebs oder Maßnahmenträgers'                                          , 'Aufgabe des Betriebs oder Maßnahmenträgers'  , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-20', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_beendigungsgrund
	(bey_id, bey_ba_schl, bey_sort, bey_bez_lang                                                                          , bey_bez_kurz                                  , bey_guelt_von_dat                  , bey_guelt_bis_dat, bey_erstel_dat                     , bey_update_dat, bey_korr_dat)
	VALUES
	(9996  , '9996'     , 9996    , 'Trifft nicht zu'                                                                     , 'Trifft nicht zu'                             , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-20', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_beendigungsgrund
	(bey_id, bey_ba_schl, bey_sort, bey_bez_lang                                                                          , bey_bez_kurz                                  , bey_guelt_von_dat                  , bey_guelt_bis_dat, bey_erstel_dat                     , bey_update_dat, bey_korr_dat)
	VALUES
	(9997  , '9997'     , 9997    , 'Keine Angabe'                                                                        , 'Keine Angabe'                                , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-20', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_beendigungsgrund
	(bey_id, bey_ba_schl, bey_sort, bey_bez_lang                                                                          , bey_bez_kurz                                  , bey_guelt_von_dat                  , bey_guelt_bis_dat, bey_erstel_dat                     , bey_update_dat, bey_korr_dat)
	VALUES
	(9998  , '9998'     , 9998    , 'Fehler im Ursprungswert'                                                             , 'Fehler im Ursprungswert'                     , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-20', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_beendigungsgrund
	(bey_id, bey_ba_schl, bey_sort, bey_bez_lang                                                                          , bey_bez_kurz                                  , bey_guelt_von_dat                  , bey_guelt_bis_dat, bey_erstel_dat                     , bey_update_dat, bey_korr_dat)
	VALUES
	(9999  , '9999'     , 9999    , 'Keine Zuordnung möglich'                                                             , 'Keine Zuordnung möglich'                     , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-20', 'YYYY-MM-DD'), NULL          , NULL        )
SELECT * FROM dual;

