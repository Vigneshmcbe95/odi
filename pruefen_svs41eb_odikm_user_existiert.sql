-- Rein lesend: existiert SVS41EB_ODIKM ueberhaupt als echter
-- Datenbank-User/-Rolle (fuer GRANT ... TO noetig), oder nur als
-- Schema-Praefix in Code-Referenzen?
SELECT username, account_status
FROM dba_users
WHERE username = 'SVS41EB_ODIKM';

-- Falls keine Zeile zurueckkommt: SVS41EB_ODIKM existiert nicht als
-- echter User -- das erklaert ORA-01917 beim GRANT. Dann muss zuerst
-- geprueft werden, ob es vielleicht einen leicht anderen Namen gibt:
SELECT username
FROM dba_users
WHERE username LIKE '%ODIKM%'
ORDER BY username;

-- Existiert das Synonym selbst trotzdem schon (CREATE SYNONYM kann
-- erfolgreich gewesen sein, auch wenn der GRANT danach fehlschlug)?
SELECT owner, synonym_name, table_owner, table_name
FROM dba_synonyms
WHERE owner = 'SVS41EB_ODIKM'
      AND synonym_name IN ('LFST_UPD5D_MN_LADETAB','GFST_STPARAM_HIST5D','PROT_KM_USING','LFST_Z5DEX_MN_LADETAB');
