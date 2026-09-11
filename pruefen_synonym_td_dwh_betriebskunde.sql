-- Rein lesend: zeigt, worauf das Synonym TD_DWH_BETRIEBSKUNDE in
-- SVS41WH_BA_TRS tatsaechlich zeigt -- bevor entschieden wird, ob es
-- geloescht werden darf.
SELECT owner, synonym_name, table_owner, table_name, db_link
FROM dba_synonyms
WHERE owner = 'SVS41WH_BA_TRS'
      AND synonym_name = 'TD_DWH_BETRIEBSKUNDE';
