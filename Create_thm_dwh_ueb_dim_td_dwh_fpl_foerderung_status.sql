CREATE TABLE THM_DWH_UEB_DIM.td_dwh_fpl_foerderung_status
	( foe_id number(5) NOT NULL,
	foe_ba_schl varchar2(20) NOT NULL,
	foe_sort number(10) NOT NULL,
	foe_bez_lang varchar2(255) NOT NULL,
	foe_bez_kurz varchar2(64) NOT NULL,
	foe_guelt_von_dat date NOT NULL,
	foe_guelt_bis_dat date,
	foe_erstel_dat date NOT NULL,
	foe_update_dat date,
	foerd_korr_dat date )

;

ALTER TABLE THM_DWH_UEB_DIM.td_dwh_fpl_foerderung_status
	ADD PRIMARY KEY 
	( foe_id )
;

