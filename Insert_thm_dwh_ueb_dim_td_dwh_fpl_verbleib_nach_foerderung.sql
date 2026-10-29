--
-- Dimension 'DIM_FPL_Verbleib_nach_Förderung' (td_dwh_fpl_verbleib_nach_foerderung)
--
-- Spalten:
-- vbl_id            Verbleib nach Förderung-ID 
-- vbl_fpl_schl      Verbleib nach Förderung FPL
-- vbl_sort          Sortierschlüssel           
-- vbl_bez_lang      Bezeichnung                
-- vbl_bez_kurz      Kurzbezeichnung            
-- vbl_guelt_von_dat Beginndatum der Gültigkeit 
-- vbl_guelt_bis_dat Endedatum der Gültigkeit   
-- vbl_erstel_dat    Erstelldatum               
-- vbl_update_dat    Änderungsdatum             
-- vbl_korr_dat      Korrekturdatum             
--
-- 32 Zeilen einzufügen.
INSERT ALL
	INTO td_dwh_fpl_verbleib_nach_foerderung
	(vbl_id, vbl_fpl_schl, vbl_sort, vbl_bez_lang                                                                               , vbl_bez_kurz                                                              , vbl_guelt_von_dat                  , vbl_guelt_bis_dat, vbl_erstel_dat                     , vbl_update_dat, vbl_korr_dat)
	VALUES
	(1     , '000'       , 1       , 'keine näheren Angaben möglich'                                                            , 'keine näheren Angaben möglich'                                           , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-20', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_verbleib_nach_foerderung
	(vbl_id, vbl_fpl_schl, vbl_sort, vbl_bez_lang                                                                               , vbl_bez_kurz                                                              , vbl_guelt_von_dat                  , vbl_guelt_bis_dat, vbl_erstel_dat                     , vbl_update_dat, vbl_korr_dat)
	VALUES
	(2     , '100'       , 2       , 'Arbeitslosigkeit '                                                                        , 'Arbeitslosigkeit '                                                       , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-20', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_verbleib_nach_foerderung
	(vbl_id, vbl_fpl_schl, vbl_sort, vbl_bez_lang                                                                               , vbl_bez_kurz                                                              , vbl_guelt_von_dat                  , vbl_guelt_bis_dat, vbl_erstel_dat                     , vbl_update_dat, vbl_korr_dat)
	VALUES
	(3     , '201'       , 3       , 'Arbeit – versicherungspflichtige Beschäftigung – befristet'                               , 'Arbeit vers. pfl. Beschäftigung befr.'                                   , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-20', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_verbleib_nach_foerderung
	(vbl_id, vbl_fpl_schl, vbl_sort, vbl_bez_lang                                                                               , vbl_bez_kurz                                                              , vbl_guelt_von_dat                  , vbl_guelt_bis_dat, vbl_erstel_dat                     , vbl_update_dat, vbl_korr_dat)
	VALUES
	(4     , '202'       , 4       , 'Arbeit – versicherungspflichtige Beschäftigung – unbefristet'                             , 'Arbeit vers. pfl. Beschäftigung unbefr.'                                 , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-20', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_verbleib_nach_foerderung
	(vbl_id, vbl_fpl_schl, vbl_sort, vbl_bez_lang                                                                               , vbl_bez_kurz                                                              , vbl_guelt_von_dat                  , vbl_guelt_bis_dat, vbl_erstel_dat                     , vbl_update_dat, vbl_korr_dat)
	VALUES
	(5     , '203'       , 5       , 'Arbeit – geringfügige Beschäftigung'                                                      , 'Arbeit – geringfügige Beschäftigung'                                     , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-20', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_verbleib_nach_foerderung
	(vbl_id, vbl_fpl_schl, vbl_sort, vbl_bez_lang                                                                               , vbl_bez_kurz                                                              , vbl_guelt_von_dat                  , vbl_guelt_bis_dat, vbl_erstel_dat                     , vbl_update_dat, vbl_korr_dat)
	VALUES
	(6     , '204'       , 6       , 'Arbeit - selbständige Tätigkeit'                                                          , 'Arbeit - selbständige Tätigkeit'                                         , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-20', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_verbleib_nach_foerderung
	(vbl_id, vbl_fpl_schl, vbl_sort, vbl_bez_lang                                                                               , vbl_bez_kurz                                                              , vbl_guelt_von_dat                  , vbl_guelt_bis_dat, vbl_erstel_dat                     , vbl_update_dat, vbl_korr_dat)
	VALUES
	(7     , '301'       , 7       , 'Ausbildung - betriebliche Ausbildung'                                                     , 'Ausbildung - betriebliche Ausbildung'                                    , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-20', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_verbleib_nach_foerderung
	(vbl_id, vbl_fpl_schl, vbl_sort, vbl_bez_lang                                                                               , vbl_bez_kurz                                                              , vbl_guelt_von_dat                  , vbl_guelt_bis_dat, vbl_erstel_dat                     , vbl_update_dat, vbl_korr_dat)
	VALUES
	(8     , '302'       , 8       , 'Ausbildung - außerbetriebliche Ausbildung'                                                , 'Aufnahme einer außerbetr. Ausbildung'                                    , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-20', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_verbleib_nach_foerderung
	(vbl_id, vbl_fpl_schl, vbl_sort, vbl_bez_lang                                                                               , vbl_bez_kurz                                                              , vbl_guelt_von_dat                  , vbl_guelt_bis_dat, vbl_erstel_dat                     , vbl_update_dat, vbl_korr_dat)
	VALUES
	(9     , '303'       , 9       , 'Ausbildung - schulische Ausbildung'                                                       , 'Ausbildung - schulische Ausbildung'                                      , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-20', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_verbleib_nach_foerderung
	(vbl_id, vbl_fpl_schl, vbl_sort, vbl_bez_lang                                                                               , vbl_bez_kurz                                                              , vbl_guelt_von_dat                  , vbl_guelt_bis_dat, vbl_erstel_dat                     , vbl_update_dat, vbl_korr_dat)
	VALUES
	(10    , '400'       , 10      , 'Berufsbildende Schule '                                                                   , 'Berufsbildende Schule '                                                  , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-20', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_verbleib_nach_foerderung
	(vbl_id, vbl_fpl_schl, vbl_sort, vbl_bez_lang                                                                               , vbl_bez_kurz                                                              , vbl_guelt_von_dat                  , vbl_guelt_bis_dat, vbl_erstel_dat                     , vbl_update_dat, vbl_korr_dat)
	VALUES
	(11    , '501'       , 11      , 'Berufsvorbereitung schulisch'                                                             , 'Berufsvorbereitung schulisch'                                            , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-20', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_verbleib_nach_foerderung
	(vbl_id, vbl_fpl_schl, vbl_sort, vbl_bez_lang                                                                               , vbl_bez_kurz                                                              , vbl_guelt_von_dat                  , vbl_guelt_bis_dat, vbl_erstel_dat                     , vbl_update_dat, vbl_korr_dat)
	VALUES
	(12    , '502'       , 12      , 'Berufsvorbereitung nach BBiG'                                                             , 'Berufsvorbereitung nach BBiG'                                            , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-20', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_verbleib_nach_foerderung
	(vbl_id, vbl_fpl_schl, vbl_sort, vbl_bez_lang                                                                               , vbl_bez_kurz                                                              , vbl_guelt_von_dat                  , vbl_guelt_bis_dat, vbl_erstel_dat                     , vbl_update_dat, vbl_korr_dat)
	VALUES
	(13    , '503'       , 13      , 'Berufsvorbereitung EQ'                                                                    , 'Berufsvorbereitung EQ'                                                   , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-20', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_verbleib_nach_foerderung
	(vbl_id, vbl_fpl_schl, vbl_sort, vbl_bez_lang                                                                               , vbl_bez_kurz                                                              , vbl_guelt_von_dat                  , vbl_guelt_bis_dat, vbl_erstel_dat                     , vbl_update_dat, vbl_korr_dat)
	VALUES
	(14    , '504'       , 14      , 'Berufsvorbereitung BvB'                                                                   , 'Berufsvorbereitung BvB'                                                  , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-20', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_verbleib_nach_foerderung
	(vbl_id, vbl_fpl_schl, vbl_sort, vbl_bez_lang                                                                               , vbl_bez_kurz                                                              , vbl_guelt_von_dat                  , vbl_guelt_bis_dat, vbl_erstel_dat                     , vbl_update_dat, vbl_korr_dat)
	VALUES
	(15    , '601'       , 15      , 'Erneute Teilnahme / Wechsel in andere Maßnahme – Maßnahmen nach SGB III'                  , 'Erneute Teiln. / Maßnahmewechsel SGB III'                                , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-20', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_verbleib_nach_foerderung
	(vbl_id, vbl_fpl_schl, vbl_sort, vbl_bez_lang                                                                               , vbl_bez_kurz                                                              , vbl_guelt_von_dat                  , vbl_guelt_bis_dat, vbl_erstel_dat                     , vbl_update_dat, vbl_korr_dat)
	VALUES
	(16    , '602'       , 16      , 'Erneute Teilnahme / Wechsel in andere Maßnahme – Förderung in sonstigen anderen Maßnahmen', 'Erneute Teiln. / sonst. Maßnahmewechsel '                                , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-20', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_verbleib_nach_foerderung
	(vbl_id, vbl_fpl_schl, vbl_sort, vbl_bez_lang                                                                               , vbl_bez_kurz                                                              , vbl_guelt_von_dat                  , vbl_guelt_bis_dat, vbl_erstel_dat                     , vbl_update_dat, vbl_korr_dat)
	VALUES
	(17    , '603'       , 17      , 'Wechsel der Maßnahme aufgrund Vertragsende'                                               , 'Maßnahmenwechsel aufgrund Vertragsende'                                  , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-20', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_verbleib_nach_foerderung
	(vbl_id, vbl_fpl_schl, vbl_sort, vbl_bez_lang                                                                               , vbl_bez_kurz                                                              , vbl_guelt_von_dat                  , vbl_guelt_bis_dat, vbl_erstel_dat                     , vbl_update_dat, vbl_korr_dat)
	VALUES
	(18    , '701'       , 18      , 'Werkstatt für behinderte Menschen und andere Leistungsanbieter (EV, BBB)'                 , 'Werkstatt für behinderte Menschen u.a.Leistungsanbieter (EV, BBB)'       , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-20', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_verbleib_nach_foerderung
	(vbl_id, vbl_fpl_schl, vbl_sort, vbl_bez_lang                                                                               , vbl_bez_kurz                                                              , vbl_guelt_von_dat                  , vbl_guelt_bis_dat, vbl_erstel_dat                     , vbl_update_dat, vbl_korr_dat)
	VALUES
	(19    , '702'       , 19      , 'Werkstatt für behinderte Menschen und andere Leistungsanbieter (Arbeitsbereich)'          , 'Werkstatt für behinderte Menschen u.a.Leistungsanbieter (Arbeitsbereich)', TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-20', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_verbleib_nach_foerderung
	(vbl_id, vbl_fpl_schl, vbl_sort, vbl_bez_lang                                                                               , vbl_bez_kurz                                                              , vbl_guelt_von_dat                  , vbl_guelt_bis_dat, vbl_erstel_dat                     , vbl_update_dat, vbl_korr_dat)
	VALUES
	(20    , '801'       , 20      , 'Arbeitsunfähigkeit'                                                                       , 'Arbeitsunfähigkeit'                                                      , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-20', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_verbleib_nach_foerderung
	(vbl_id, vbl_fpl_schl, vbl_sort, vbl_bez_lang                                                                               , vbl_bez_kurz                                                              , vbl_guelt_von_dat                  , vbl_guelt_bis_dat, vbl_erstel_dat                     , vbl_update_dat, vbl_korr_dat)
	VALUES
	(21    , '802'       , 21      , 'Erwerbsunfähigkeit'                                                                       , 'Erwerbsunfähigkeit'                                                      , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-20', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_verbleib_nach_foerderung
	(vbl_id, vbl_fpl_schl, vbl_sort, vbl_bez_lang                                                                               , vbl_bez_kurz                                                              , vbl_guelt_von_dat                  , vbl_guelt_bis_dat, vbl_erstel_dat                     , vbl_update_dat, vbl_korr_dat)
	VALUES
	(22    , '901'       , 22      , 'Mutterschutz / Elternzeit'                                                                , 'Mutterschutz / Elternzeit'                                               , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-20', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_verbleib_nach_foerderung
	(vbl_id, vbl_fpl_schl, vbl_sort, vbl_bez_lang                                                                               , vbl_bez_kurz                                                              , vbl_guelt_von_dat                  , vbl_guelt_bis_dat, vbl_erstel_dat                     , vbl_update_dat, vbl_korr_dat)
	VALUES
	(23    , '902'       , 23      , 'Grundwehrdienst / Wehrersatzdienst'                                                       , 'Grundwehrdienst / Wehrersatzdienst'                                      , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-20', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_verbleib_nach_foerderung
	(vbl_id, vbl_fpl_schl, vbl_sort, vbl_bez_lang                                                                               , vbl_bez_kurz                                                              , vbl_guelt_von_dat                  , vbl_guelt_bis_dat, vbl_erstel_dat                     , vbl_update_dat, vbl_korr_dat)
	VALUES
	(24    , '903'       , 24      , 'Studium'                                                                                  , 'Studium'                                                                 , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-20', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_verbleib_nach_foerderung
	(vbl_id, vbl_fpl_schl, vbl_sort, vbl_bez_lang                                                                               , vbl_bez_kurz                                                              , vbl_guelt_von_dat                  , vbl_guelt_bis_dat, vbl_erstel_dat                     , vbl_update_dat, vbl_korr_dat)
	VALUES
	(25    , '904'       , 25      , 'FSJ / FÖJ / FSTJ'                                                                         , 'FSJ / FÖJ / FSTJ'                                                        , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-20', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_verbleib_nach_foerderung
	(vbl_id, vbl_fpl_schl, vbl_sort, vbl_bez_lang                                                                               , vbl_bez_kurz                                                              , vbl_guelt_von_dat                  , vbl_guelt_bis_dat, vbl_erstel_dat                     , vbl_update_dat, vbl_korr_dat)
	VALUES
	(26    , '905'       , 26      , 'Au Pair'                                                                                  , 'Au Pair'                                                                 , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-20', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_verbleib_nach_foerderung
	(vbl_id, vbl_fpl_schl, vbl_sort, vbl_bez_lang                                                                               , vbl_bez_kurz                                                              , vbl_guelt_von_dat                  , vbl_guelt_bis_dat, vbl_erstel_dat                     , vbl_update_dat, vbl_korr_dat)
	VALUES
	(27    , '906'       , 27      , 'Allgemeinbildende Schule '                                                                , 'Allgemeinbildende Schule '                                               , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-20', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_verbleib_nach_foerderung
	(vbl_id, vbl_fpl_schl, vbl_sort, vbl_bez_lang                                                                               , vbl_bez_kurz                                                              , vbl_guelt_von_dat                  , vbl_guelt_bis_dat, vbl_erstel_dat                     , vbl_update_dat, vbl_korr_dat)
	VALUES
	(28    , '907'       , 28      , 'Bundesfreiwilligendienst'                                                                 , 'Bundesfreiwilligendienst'                                                , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-20', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_verbleib_nach_foerderung
	(vbl_id, vbl_fpl_schl, vbl_sort, vbl_bez_lang                                                                               , vbl_bez_kurz                                                              , vbl_guelt_von_dat                  , vbl_guelt_bis_dat, vbl_erstel_dat                     , vbl_update_dat, vbl_korr_dat)
	VALUES
	(9996  , '9996'      , 9996    , 'trifft nicht zu'                                                                          , 'trifft nicht zu'                                                         , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-20', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_verbleib_nach_foerderung
	(vbl_id, vbl_fpl_schl, vbl_sort, vbl_bez_lang                                                                               , vbl_bez_kurz                                                              , vbl_guelt_von_dat                  , vbl_guelt_bis_dat, vbl_erstel_dat                     , vbl_update_dat, vbl_korr_dat)
	VALUES
	(9997  , '9997'      , 9997    , 'keine Angabe'                                                                             , 'keine Angabe'                                                            , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-20', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_verbleib_nach_foerderung
	(vbl_id, vbl_fpl_schl, vbl_sort, vbl_bez_lang                                                                               , vbl_bez_kurz                                                              , vbl_guelt_von_dat                  , vbl_guelt_bis_dat, vbl_erstel_dat                     , vbl_update_dat, vbl_korr_dat)
	VALUES
	(9998  , '9998'      , 9998    , 'Fehler im Ursprungswert'                                                                  , 'Fehler im Ursprungswert'                                                 , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-20', 'YYYY-MM-DD'), NULL          , NULL        )
	INTO td_dwh_fpl_verbleib_nach_foerderung
	(vbl_id, vbl_fpl_schl, vbl_sort, vbl_bez_lang                                                                               , vbl_bez_kurz                                                              , vbl_guelt_von_dat                  , vbl_guelt_bis_dat, vbl_erstel_dat                     , vbl_update_dat, vbl_korr_dat)
	VALUES
	(9999  , '9999'      , 9999    , 'keine Zuordnung möglich'                                                                  , 'keine Zuordnung möglich'                                                 , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-20', 'YYYY-MM-DD'), NULL          , NULL        )
SELECT * FROM dual;

