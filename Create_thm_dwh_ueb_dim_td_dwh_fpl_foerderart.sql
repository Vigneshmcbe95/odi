CREATE TABLE THM_DWH_UEB_DIM.td_dwh_fpl_foerderart
	( foa_id number(5) NOT NULL,
	fot_id number(5) NOT NULL,
	foa_ba_schl varchar2(50) NOT NULL,
	foa_sort number(10) NOT NULL,
	foa_bez_lang varchar2(255) NOT NULL,
	foa_bez_kurz varchar2(128),
	foa_guelt_von_dat date NOT NULL,
	foa_guelt_bis_dat date,
	foa_erstel_dat date NOT NULL,
	foa_update_dat date,
	foa_korr_dat date )

;

ALTER TABLE THM_DWH_UEB_DIM.td_dwh_fpl_foerderart
	ADD PRIMARY KEY 
	( foa_id )
;

