--
-- Dimension 'DIM_FPL_Foerdergrundlage' (td_dwh_fpl_foerdergrundlage)
--
-- Spalten:
-- fgl_id                    Foerdergrundlage-ID       
-- fgl_ba_schl               Foerdergrundlage-FPL      
-- fgl_sort                  Sortierschlüssel          
-- fgl_bez_lang              Bezeichnung               
-- fgl_bez_kurz              Kurzbezeichnung           
-- fgl_guelt_von_dat         Beginndatum der Gültigkeit
-- fgl_guelt_bis_dat         Endedatum der Gültigkeit  
-- fgl_erstel_dat            Erstelldatum              
-- fgl_update_dat            Änderungsdatum            
-- foerdergrundlage_korr_dat Korrekturdatum            
--
-- 18 Zeilen einzufügen.
INSERT ALL
	INTO td_dwh_fpl_foerdergrundlage
	(fgl_id, fgl_ba_schl, fgl_sort, fgl_bez_lang                                                                                                                               , fgl_bez_kurz                     , fgl_guelt_von_dat                  , fgl_guelt_bis_dat, fgl_erstel_dat                     , fgl_update_dat, foerdergrundlage_korr_dat)
	VALUES
	(1     , '101'      , 1       , 'EQ: Ausbildungsbewerberinnen und -bewerber mit aus individuellen Gründen eingeschränkten Vermittlungsperspektiven (§ 54 (4) Nr.1 SGB III)', 'EQ: § 54 (4) Nr.1 SGB III'      , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-23', 'YYYY-MM-DD'), NULL          , NULL                     )
	INTO td_dwh_fpl_foerdergrundlage
	(fgl_id, fgl_ba_schl, fgl_sort, fgl_bez_lang                                                                                                                               , fgl_bez_kurz                     , fgl_guelt_von_dat                  , fgl_guelt_bis_dat, fgl_erstel_dat                     , fgl_update_dat, foerdergrundlage_korr_dat)
	VALUES
	(2     , '102'      , 2       , 'EQ: Ausbildungssuchende, die noch nicht in vollem Maße über die erforderliche Ausbildungsreife verfügen (§ 54 (4) Nr.2 SGB III)'          , 'EQ: § 54 (4) Nr.2 SGB III'      , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-23', 'YYYY-MM-DD'), NULL          , NULL                     )
	INTO td_dwh_fpl_foerdergrundlage
	(fgl_id, fgl_ba_schl, fgl_sort, fgl_bez_lang                                                                                                                               , fgl_bez_kurz                     , fgl_guelt_von_dat                  , fgl_guelt_bis_dat, fgl_erstel_dat                     , fgl_update_dat, foerdergrundlage_korr_dat)
	VALUES
	(3     , '103'      , 3       , 'EQ: Lernbeeinträchtigte und sozial benachteiligte Ausbildungssuchende (§ 54 (4) Nr.3 SGB III)'                                            , 'EQ: § 54 (4) Nr.3 SGB III'      , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-23', 'YYYY-MM-DD'), NULL          , NULL                     )
	INTO td_dwh_fpl_foerdergrundlage
	(fgl_id, fgl_ba_schl, fgl_sort, fgl_bez_lang                                                                                                                               , fgl_bez_kurz                     , fgl_guelt_von_dat                  , fgl_guelt_bis_dat, fgl_erstel_dat                     , fgl_update_dat, foerdergrundlage_korr_dat)
	VALUES
	(4     , '121'      , 4       , 'AEZ: Betriebe mit 1-49 Beschäftigten (§ 82 Abs. 3 Nr. 1 SGB III)'                                                                         , 'AEZ: § 82 Abs. 3 Nr. 1 SGB III' , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-23', 'YYYY-MM-DD'), NULL          , NULL                     )
	INTO td_dwh_fpl_foerdergrundlage
	(fgl_id, fgl_ba_schl, fgl_sort, fgl_bez_lang                                                                                                                               , fgl_bez_kurz                     , fgl_guelt_von_dat                  , fgl_guelt_bis_dat, fgl_erstel_dat                     , fgl_update_dat, foerdergrundlage_korr_dat)
	VALUES
	(5     , '122'      , 5       , 'AEZ: Betriebe mit 50-499 Beschäftigten (§ 82 Abs. 3 Nr. 2 SGB III)'                                                                       , 'AEZ: § 82 Abs. 3 Nr. 2 SGB III' , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-23', 'YYYY-MM-DD'), NULL          , NULL                     )
	INTO td_dwh_fpl_foerdergrundlage
	(fgl_id, fgl_ba_schl, fgl_sort, fgl_bez_lang                                                                                                                               , fgl_bez_kurz                     , fgl_guelt_von_dat                  , fgl_guelt_bis_dat, fgl_erstel_dat                     , fgl_update_dat, foerdergrundlage_korr_dat)
	VALUES
	(6     , '123'      , 6       , 'AEZ: Betriebe ab 500 Beschäftigten (§ 82 Abs. 3 Nr. 3 SGB III)'                                                                           , 'AEZ: § 82 Abs. 3 Nr. 3 SGB III' , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-23', 'YYYY-MM-DD'), NULL          , NULL                     )
	INTO td_dwh_fpl_foerdergrundlage
	(fgl_id, fgl_ba_schl, fgl_sort, fgl_bez_lang                                                                                                                               , fgl_bez_kurz                     , fgl_guelt_von_dat                  , fgl_guelt_bis_dat, fgl_erstel_dat                     , fgl_update_dat, foerdergrundlage_korr_dat)
	VALUES
	(7     , '124'      , 7       , 'AEZ: Geringqualifizierte Beschäftigte (§ 81 Abs. 2 SGB III)'                                                                              , 'AEZ: § 81 Abs. 2 SGB III'       , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-23', 'YYYY-MM-DD'), NULL          , NULL                     )
	INTO td_dwh_fpl_foerdergrundlage
	(fgl_id, fgl_ba_schl, fgl_sort, fgl_bez_lang                                                                                                                               , fgl_bez_kurz                     , fgl_guelt_von_dat                  , fgl_guelt_bis_dat, fgl_erstel_dat                     , fgl_update_dat, foerdergrundlage_korr_dat)
	VALUES
	(8     , '141'      , 8       , 'EGZ: allgemein (§ 89 Satz 1 SGB III)'                                                                                                     , 'EGZ: § 89 Satz 1 SGB III'       , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-23', 'YYYY-MM-DD'), NULL          , NULL                     )
	INTO td_dwh_fpl_foerdergrundlage
	(fgl_id, fgl_ba_schl, fgl_sort, fgl_bez_lang                                                                                                                               , fgl_bez_kurz                     , fgl_guelt_von_dat                  , fgl_guelt_bis_dat, fgl_erstel_dat                     , fgl_update_dat, foerdergrundlage_korr_dat)
	VALUES
	(9     , '142'      , 9       , 'EGZ: Ältere (§ 89 Satz 2 SGB III)'                                                                                                        , 'EGZ: § 89 Satz 2 SGB III'       , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-23', 'YYYY-MM-DD'), NULL          , NULL                     )
	INTO td_dwh_fpl_foerdergrundlage
	(fgl_id, fgl_ba_schl, fgl_sort, fgl_bez_lang                                                                                                                               , fgl_bez_kurz                     , fgl_guelt_von_dat                  , fgl_guelt_bis_dat, fgl_erstel_dat                     , fgl_update_dat, foerdergrundlage_korr_dat)
	VALUES
	(10    , '143'      , 10      , 'EGZ: Menschen mit Behinderungen und schwerbehinderte Menschen (§ 90 Abs. 1 SGB III)'                                                      , 'EGZ: § 90 Abs. 1 SGB III'       , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-23', 'YYYY-MM-DD'), NULL          , NULL                     )
	INTO td_dwh_fpl_foerdergrundlage
	(fgl_id, fgl_ba_schl, fgl_sort, fgl_bez_lang                                                                                                                               , fgl_bez_kurz                     , fgl_guelt_von_dat                  , fgl_guelt_bis_dat, fgl_erstel_dat                     , fgl_update_dat, foerdergrundlage_korr_dat)
	VALUES
	(11    , '144'      , 11      , 'EGZ: Besonders betroffene schwerbehinderte Menschen (§ 90 Abs. 2 Satz 1 SGB III)'                                                         , 'EGZ: § 90 Abs. 2 Satz 1 SGB III', TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-23', 'YYYY-MM-DD'), NULL          , NULL                     )
	INTO td_dwh_fpl_foerdergrundlage
	(fgl_id, fgl_ba_schl, fgl_sort, fgl_bez_lang                                                                                                                               , fgl_bez_kurz                     , fgl_guelt_von_dat                  , fgl_guelt_bis_dat, fgl_erstel_dat                     , fgl_update_dat, foerdergrundlage_korr_dat)
	VALUES
	(12    , '145'      , 12      , 'EGZ: Besonders betroffene schwerbehinderte Menschen ab 55 Jahren (§ 90 Abs. 2 Satz 2 SGB III)'                                            , 'EGZ: § 90 Abs. 2 Satz 2 SGB III', TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-23', 'YYYY-MM-DD'), NULL          , NULL                     )
	INTO td_dwh_fpl_foerdergrundlage
	(fgl_id, fgl_ba_schl, fgl_sort, fgl_bez_lang                                                                                                                               , fgl_bez_kurz                     , fgl_guelt_von_dat                  , fgl_guelt_bis_dat, fgl_erstel_dat                     , fgl_update_dat, foerdergrundlage_korr_dat)
	VALUES
	(13    , '161'      , 13      , 'AZ: Reha-Zuschüsse zur Ausbildungsvergütung (§ 73 (1) SGB III)'                                                                           , 'AZ: § 73 (1) SGB III'           , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-23', 'YYYY-MM-DD'), NULL          , NULL                     )
	INTO td_dwh_fpl_foerdergrundlage
	(fgl_id, fgl_ba_schl, fgl_sort, fgl_bez_lang                                                                                                                               , fgl_bez_kurz                     , fgl_guelt_von_dat                  , fgl_guelt_bis_dat, fgl_erstel_dat                     , fgl_update_dat, foerdergrundlage_korr_dat)
	VALUES
	(14    , '162'      , 14      , 'AZ: SB/GL - Zuschüsse zur Ausbildungsvergütung (§ 73 (1) SGB III)'                                                                        , 'AZ: § 73 (1) SGB III'           , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-23', 'YYYY-MM-DD'), NULL          , NULL                     )
	INTO td_dwh_fpl_foerdergrundlage
	(fgl_id, fgl_ba_schl, fgl_sort, fgl_bez_lang                                                                                                                               , fgl_bez_kurz                     , fgl_guelt_von_dat                  , fgl_guelt_bis_dat, fgl_erstel_dat                     , fgl_update_dat, foerdergrundlage_korr_dat)
	VALUES
	(9996  , '9996'     , 9996    , 'Trifft nicht zu'                                                                                                                          , 'Trifft nicht zu'                , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-23', 'YYYY-MM-DD'), NULL          , NULL                     )
	INTO td_dwh_fpl_foerdergrundlage
	(fgl_id, fgl_ba_schl, fgl_sort, fgl_bez_lang                                                                                                                               , fgl_bez_kurz                     , fgl_guelt_von_dat                  , fgl_guelt_bis_dat, fgl_erstel_dat                     , fgl_update_dat, foerdergrundlage_korr_dat)
	VALUES
	(9997  , '9997'     , 9997    , 'Keine Angabe'                                                                                                                             , 'Keine Angabe'                   , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-23', 'YYYY-MM-DD'), NULL          , NULL                     )
	INTO td_dwh_fpl_foerdergrundlage
	(fgl_id, fgl_ba_schl, fgl_sort, fgl_bez_lang                                                                                                                               , fgl_bez_kurz                     , fgl_guelt_von_dat                  , fgl_guelt_bis_dat, fgl_erstel_dat                     , fgl_update_dat, foerdergrundlage_korr_dat)
	VALUES
	(9998  , '9998'     , 9998    , 'Fehler im Ursprungswert'                                                                                                                  , 'Fehler im Ursprungswert'        , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-23', 'YYYY-MM-DD'), NULL          , NULL                     )
	INTO td_dwh_fpl_foerdergrundlage
	(fgl_id, fgl_ba_schl, fgl_sort, fgl_bez_lang                                                                                                                               , fgl_bez_kurz                     , fgl_guelt_von_dat                  , fgl_guelt_bis_dat, fgl_erstel_dat                     , fgl_update_dat, foerdergrundlage_korr_dat)
	VALUES
	(9999  , '9999'     , 9999    , 'Keine Zuordnung möglich'                                                                                                                  , 'Keine Zuordnung möglich'        , TO_DATE('1970-01-01', 'YYYY-MM-DD'), NULL             , TO_DATE('2026-10-23', 'YYYY-MM-DD'), NULL          , NULL                     )
SELECT * FROM dual;

