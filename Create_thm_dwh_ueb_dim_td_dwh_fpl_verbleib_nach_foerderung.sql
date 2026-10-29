CREATE TABLE THM_DWH_UEB_DIM.td_dwh_fpl_verbleib_nach_foerderung
	( vbl_id number(5) NOT NULL,
	vbl_fpl_schl varchar2(20) NOT NULL,
	vbl_sort number(10) NOT NULL,
	vbl_bez_lang varchar2(255) NOT NULL,
	vbl_bez_kurz varchar2(128),
	vbl_guelt_von_dat date NOT NULL,
	vbl_guelt_bis_dat date,
	vbl_erstel_dat date NOT NULL,
	vbl_update_dat date,
	vbl_korr_dat date )

;

ALTER TABLE THM_DWH_UEB_DIM.td_dwh_fpl_verbleib_nach_foerderung
	ADD PRIMARY KEY 
	( vbl_id )
;

