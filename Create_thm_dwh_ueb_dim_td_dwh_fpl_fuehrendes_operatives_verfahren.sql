CREATE TABLE THM_DWH_UEB_DIM.td_dwh_fpl_fuehrendes_operatives_verfahren
	( fov_id number(5) NOT NULL,
	fov_ba_schl varchar2(20) NOT NULL,
	fov_sort number(10) NOT NULL,
	fov_bez_lang varchar2(255) NOT NULL,
	fov_bez_kurz varchar2(64),
	fov_guelt_von_dat date NOT NULL,
	fov_guelt_bis_dat date,
	fov_erstel_dat date NOT NULL,
	fov_update_dat date,
	fos_korr_dat date )

;

ALTER TABLE THM_DWH_UEB_DIM.td_dwh_fpl_fuehrendes_operatives_verfahren
	ADD PRIMARY KEY 
	( fov_id )
;

