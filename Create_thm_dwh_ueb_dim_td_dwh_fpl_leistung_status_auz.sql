CREATE TABLE THM_DWH_UEB_DIM.td_dwh_fpl_leistung_status_auz
	( lsz_id number(5) NOT NULL,
	lsz_ba_schl varchar2(20) NOT NULL,
	lsz_sort number(10) NOT NULL,
	lsz_bez_lang varchar2(255) NOT NULL,
	lsz_bez_kurz varchar2(64),
	lsz_guelt_von_dat date NOT NULL,
	lsz_guelt_bis_dat date,
	lsz_erstel_dat date NOT NULL,
	lsz_update_dat date,
	lstg_stat_auz_korr_dat date )

;

ALTER TABLE THM_DWH_UEB_DIM.td_dwh_fpl_leistung_status_auz
	ADD PRIMARY KEY 
	( lsz_id )
;

