SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED

-- Erstellt Synonyme in SVS41WH_UEB_DIM, die auf die Basistabellen in
-- THM_DWH_UEB_DIM zeigen -- KEINE echten Tabellenkopien.
--
-- Hintergrund (Thorsten, 2026-08-31): bei UEB_DIM (und aehnlichen
-- uebergreifenden/geteilten Bereichen) legt man normalerweise keine
-- eigenen Tabellen pro Sandbox an, sondern nur Synonyme auf die THM-Basis.
-- Ausnahme waere nur, wenn wirklich eigene Weiterentwicklungsdaten noetig
-- sind, die im THM noch nicht existieren oder veraltet sind.
--
-- Sicher wiederholbar: bereits vorhandene Synonyme werden uebersprungen.
-- Ein Fehler bei einem Objekt stoppt nicht den restlichen Lauf.

DECLARE
  v_src_schema VARCHAR2(128) := 'THM_DWH_UEB_DIM';
  v_tgt_schema VARCHAR2(128) := 'SVS41WH_UEB_DIM';

  v_grant_select BOOLEAN := TRUE;  -- SELECT-Recht auf Basistabelle mitvergeben,
                                    -- sonst ORA-00942 beim Zugriff ueber das Synonym

  v_exists_cnt   PLS_INTEGER;
  v_created_cnt  PLS_INTEGER := 0;
  v_skipped_cnt  PLS_INTEGER := 0;
  v_failed_cnt   PLS_INTEGER := 0;

BEGIN
  FOR t IN (
    SELECT table_name
    FROM dba_tables
    WHERE owner = v_src_schema
    ORDER BY table_name
  ) LOOP

    -- Existiert das Synonym im Ziel bereits? -> ueberspringen
    SELECT COUNT(*) INTO v_exists_cnt
    FROM dba_synonyms
    WHERE owner = v_tgt_schema
      AND synonym_name = t.table_name;

    IF v_exists_cnt > 0 THEN
      DBMS_OUTPUT.PUT_LINE('SKIP (Synonym existiert bereits): ' || t.table_name);
      v_skipped_cnt := v_skipped_cnt + 1;
      CONTINUE;
    END IF;

    BEGIN
      EXECUTE IMMEDIATE
        'CREATE SYNONYM ' || v_tgt_schema || '.' || t.table_name ||
        ' FOR ' || v_src_schema || '.' || t.table_name;

      IF v_grant_select THEN
        EXECUTE IMMEDIATE
          'GRANT SELECT ON ' || v_src_schema || '.' || t.table_name ||
          ' TO ' || v_tgt_schema;
      END IF;

      DBMS_OUTPUT.PUT_LINE('ERSTELLT: ' || v_tgt_schema || '.' || t.table_name ||
                            ' -> ' || v_src_schema || '.' || t.table_name);
      v_created_cnt := v_created_cnt + 1;

    EXCEPTION
      WHEN OTHERS THEN
        v_failed_cnt := v_failed_cnt + 1;
        DBMS_OUTPUT.PUT_LINE('FEHLER :: ' || t.table_name || ' - ' || SQLERRM);
    END;

  END LOOP;

  DBMS_OUTPUT.PUT_LINE('=================================================');
  DBMS_OUTPUT.PUT_LINE('Fertig. Erstellt: ' || v_created_cnt
                        || ', Uebersprungen: ' || v_skipped_cnt
                        || ', Fehlgeschlagen: ' || v_failed_cnt);
END;
/
