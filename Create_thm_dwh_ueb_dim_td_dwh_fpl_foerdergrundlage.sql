CREATE TABLE THM_DWH_UEB_DIM.td_dwh_fpl_foerdergrundlage
	( fgl_id number(5) NOT NULL,
	fgl_ba_schl varchar2(20) NOT NULL,
	fgl_sort number(10) NOT NULL,
	fgl_bez_lang varchar2(255) NOT NULL,
	fgl_bez_kurz varchar2(64),
	fgl_guelt_von_dat date NOT NULL,
	fgl_guelt_bis_dat date,
	fgl_erstel_dat date NOT NULL,
	fgl_update_dat date,
	foerdergrundlage_korr_dat date )

;

ALTER TABLE THM_DWH_UEB_DIM.td_dwh_fpl_foerdergrundlage
	ADD PRIMARY KEY 
	( fgl_id )
;

