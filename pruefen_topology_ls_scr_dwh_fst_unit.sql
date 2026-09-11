-- Diese Pruefung erfolgt NICHT per SQL gegen die DB, sondern muss in
-- ODI Studio (Topology-Tab) gemacht werden -- dort steht die
-- eigentliche Zuordnung, nicht in einer Oracle-Systemtabelle.
--
-- Schritte in ODI Studio:
-- 1) Topology -> Contexts -> CT_ESTAT_FST_41 oeffnen.
-- 2) Nach der logischen Schema-Zuordnung fuer "LS_SCR_DWH_FST" (bzw.
--    "LS_SCR_DWH_FST_UNIT", falls als eigener Eintrag vorhanden)
--    suchen.
-- 3) Pruefen, welches PHYSISCHE Schema dort tatsaechlich eingetragen
--    ist -- muss exakt "SSC41WH_FST" sein (nicht z.B. SSC41DWH_FST,
--    SSC41_WH_FST oder eine andere Variante mit anderem Namen).
--
-- Falls die Zuordnung falsch/anders ist: das ist der eigentliche
-- Fehler, nicht fehlende Rechte -- dann muss die Physical-Schema-
-- Zuordnung im Context korrigiert werden, nicht Grants vergeben
-- werden.
--
-- Alternative, rein lesende Pruefung direkt in der ODI-Datenbank
-- (Work Repository), falls Zugriff via SQL gewuenscht -- Owner des
-- Work Repository anpassen (aus HOOK_PARAMS: WORKREPOSITORY_SCHEMA =
-- ODI_FST_E_B05):
SELECT
    lsch.schema_name AS logisches_schema,
    ctx.context_name,
    psch.physical_schema_name,
    psch.schema_name AS physisches_ziel_schema
FROM ODI_FST_E_B05.snp_context ctx
     JOIN ODI_FST_E_B05.snp_ls_pschema_map map ON map.context_id = ctx.context_id
     JOIN ODI_FST_E_B05.snp_pschema psch ON psch.i_phys_schema = map.i_phys_schema
     JOIN ODI_FST_E_B05.snp_l_schema lsch ON lsch.i_l_schema = map.i_l_schema
WHERE ctx.context_name = 'CT_ESTAT_FST_41'
      AND lsch.schema_name LIKE '%SCR_DWH_FST%';
