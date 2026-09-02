SELECT owner, table_name, column_name
FROM dba_tab_columns
WHERE table_name = 'TD_DWH_MASSNAHME_MGBB_TBD'
  AND owner IN ('SVS41WH_FST', 'PSD1_DWH_FST')
ORDER BY owner, column_id;


SVS41WH_FST.TH_DWH_MASSNAHME_MAT_ALT
SVS41WH_FST.TH_DWH_TEILNAHME_AUW_MB

