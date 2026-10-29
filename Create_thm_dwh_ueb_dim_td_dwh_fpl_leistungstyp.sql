CREATE TABLE THM_DWH_UEB_DIM.td_dwh_fpl_Leistungstyp
	( lst_id number(5) NOT NULL,
	lst_ba_schl varchar2(20) NOT NULL,
	lst_sort number(10) NOT NULL,
	lst_bez_lang varchar2(255) NOT NULL,
	lst_bez_kurz varchar2(64),
	lst_guelt_von_dat date NOT NULL,
	lst_guelt_bis_dat date,
	lst_erstel_dat date NOT NULL,
	lst_update_dat date,
	lstg_typ_korr_dat date )

;

ALTER TABLE THM_DWH_UEB_DIM.td_dwh_fpl_Leistungstyp
	ADD PRIMARY KEY 
	( lst_id )
;

