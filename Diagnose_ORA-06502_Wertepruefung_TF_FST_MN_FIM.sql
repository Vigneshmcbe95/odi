-- Alle 10 Spalten von TF_FST_MN_FIM sind laut dba_tab_columns zwischen
-- Quelle und Ziel identisch (gleicher Typ/Praezision/Scale) - der ORA-06502
-- kommt also nicht aus einem Schema-Unterschied, sondern aus einem
-- tatsaechlichen Datenwert in der Quelle, der die eigene deklarierte
-- Praezision verletzt (kann bei Direct-Path-Load/DB-Link-Ladewegen passieren,
-- die Constraints nicht immer pruefen). Diese Abfrage findet die Zeile(n).
SELECT 'FFA_ID' AS spalte, ffa_id AS wert, mon_id
FROM PSD1_DM_STAT_FST.TF_FST_MN_FIM
WHERE ffa_id IS NOT NULL AND LENGTH(TRUNC(ABS(ffa_id))) > 5
UNION ALL
SELECT 'FNM_ID', fnm_id, mon_id
FROM PSD1_DM_STAT_FST.TF_FST_MN_FIM
WHERE fnm_id IS NOT NULL AND LENGTH(TRUNC(ABS(fnm_id))) > 10
UNION ALL
SELECT 'FNV_ID', fnv_id, mon_id
FROM PSD1_DM_STAT_FST.TF_FST_MN_FIM
WHERE fnv_id IS NOT NULL AND LENGTH(TRUNC(ABS(fnv_id))) > 10
UNION ALL
SELECT 'KMD_ID', kmd_id, mon_id
FROM PSD1_DM_STAT_FST.TF_FST_MN_FIM
WHERE kmd_id IS NOT NULL AND LENGTH(TRUNC(ABS(kmd_id))) > 10
UNION ALL
SELECT 'KMF_ANZ_GENEHM_TN_PLATZ', kmf_anz_genehm_tn_platz, mon_id
FROM PSD1_DM_STAT_FST.TF_FST_MN_FIM
WHERE kmf_anz_genehm_tn_platz IS NOT NULL AND LENGTH(TRUNC(ABS(kmf_anz_genehm_tn_platz))) > 10
UNION ALL
SELECT 'KMF_ID', kmf_id, mon_id
FROM PSD1_DM_STAT_FST.TF_FST_MN_FIM
WHERE kmf_id IS NOT NULL AND LENGTH(TRUNC(ABS(kmf_id))) > 19
UNION ALL
SELECT 'MON_ID', mon_id, mon_id
FROM PSD1_DM_STAT_FST.TF_FST_MN_FIM
WHERE mon_id IS NOT NULL AND LENGTH(TRUNC(ABS(mon_id))) > 10;

-- KMF_ART ist VARCHAR2(8) - separat auf Laenge pruefen:
SELECT kmf_art, mon_id, LENGTH(kmf_art) AS laenge
FROM PSD1_DM_STAT_FST.TF_FST_MN_FIM
WHERE LENGTH(kmf_art) > 8;
