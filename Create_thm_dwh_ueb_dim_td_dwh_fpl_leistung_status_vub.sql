CREATE TABLE THM_DWH_UEB_DIM.td_dwh_fpl_leistung_status_vub
	( lsv_id number(5) NOT NULL,
	lsv_shl varchar2(20) NOT NULL,
	lsv_sort number(10) NOT NULL,
	lsv_bez varchar2(255) NOT NULL,
	lsv_bez_kurz varchar2(64),
	lsv_guelt_von_dat date NOT NULL,
	lsv_guelt_bis_dat date,
	lsv_erstel_dat date NOT NULL,
	lsv_update_dat date,
	lsv_korr_dat date )

;

ALTER TABLE THM_DWH_UEB_DIM.td_dwh_fpl_leistung_status_vub
	ADD PRIMARY KEY 
	( lsv_id )
;

