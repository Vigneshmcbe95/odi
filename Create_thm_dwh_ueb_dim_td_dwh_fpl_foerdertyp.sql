CREATE TABLE THM_DWH_UEB_DIM.td_dwh_fpl_foerdertyp
	( fot_id number(5) NOT NULL,
	fot_ba_schl varchar2(20) NOT NULL,
	fot_sort number(10) NOT NULL,
	fot_bez_lang varchar2(255) NOT NULL,
	fot_bez_kurz varchar2(128),
	fot_guelt_von_dat date NOT NULL,
	fot_guelt_bis_dat date,
	fot_erstel_dat date NOT NULL,
	fot_update_dat date,
	fot_korr_dat date )

;

ALTER TABLE THM_DWH_UEB_DIM.td_dwh_fpl_foerdertyp
	ADD PRIMARY KEY 
	( fot_id )
;

