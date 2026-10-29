CREATE TABLE THM_DWH_UEB_DIM.td_dwh_fpl_beendigungsgrund
	( bey_id number(5) NOT NULL,
	bey_ba_schl varchar2(20) NOT NULL,
	bey_sort number(10) NOT NULL,
	bey_bez_lang varchar2(255) NOT NULL,
	bey_bez_kurz varchar2(64) NOT NULL,
	bey_guelt_von_dat date NOT NULL,
	bey_guelt_bis_dat date,
	bey_erstel_dat date NOT NULL,
	bey_update_dat date,
	bey_korr_dat date )

;

ALTER TABLE THM_DWH_UEB_DIM.td_dwh_fpl_beendigungsgrund
	ADD PRIMARY KEY 
	( bey_id )
;

