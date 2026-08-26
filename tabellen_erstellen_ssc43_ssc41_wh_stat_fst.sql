SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET LONG 100000
SET LINESIZE 200

-- Create ALL tables from SSC43WH_STAT_FST in SSC41WH_STAT_FST that don't already exist.
--
-- Same fixed approach as tabellen_erstellen_ssc43_ssc41_wh_fst.sql (root cause of
-- ORA-00922 was DBMS_METADATA's default trailing ';' via SQLTERMINATOR, now disabled):
--   * explicit DBMS_METADATA SQLTERMINATOR=FALSE
--   * defensive trailing ';'/newline strip on the generated DDL before EXECUTE IMMEDIATE
--   * per-table exception handling: one bad table is logged (with its full generated
--     DDL for debugging) and the loop continues instead of aborting the whole run
--
-- Logic: for every table in SSC43WH_STAT_FST -> if it already exists in
-- SSC41WH_STAT_FST, skip; otherwise clone its DDL (no STORAGE/SEGMENT_ATTRIBUTES/
-- TABLESPACE) and create it.

DECLARE
  v_src_schema VARCHAR2(128) := 'SSC43WH_STAT_FST';
  v_tgt_schema VARCHAR2(128) := 'SSC41WH_STAT_FST';

  v_ddl         CLOB;
  v_exists_cnt  PLS_INTEGER;

  v_created_cnt PLS_INTEGER := 0;
  v_skipped_cnt PLS_INTEGER := 0;
  v_failed_cnt  PLS_INTEGER := 0;

  PROCEDURE print_clob(p_clob CLOB) IS
    v_len   PLS_INTEGER := DBMS_LOB.GETLENGTH(p_clob);
    v_pos   PLS_INTEGER := 1;
    v_chunk PLS_INTEGER := 250;
  BEGIN
    WHILE v_pos <= v_len LOOP
      DBMS_OUTPUT.PUT_LINE(DBMS_LOB.SUBSTR(p_clob, v_chunk, v_pos));
      v_pos := v_pos + v_chunk;
    END LOOP;
  END print_clob;

BEGIN
  DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM, 'STORAGE', FALSE);
  DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM, 'SEGMENT_ATTRIBUTES', FALSE);
  DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM, 'TABLESPACE', FALSE);
  DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM, 'SQLTERMINATOR', FALSE);
  DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM, 'PRETTY', TRUE);

  FOR t IN (
    SELECT table_name
    FROM all_tables
    WHERE owner = v_src_schema
      AND (iot_type IS NULL OR iot_type != 'IOT_OVERFLOW')  -- skip IOT overflow segments
      AND nested = 'NO'                                     -- skip nested-table storage tables
      AND secondary = 'N'                                   -- skip domain-index secondary tables
    ORDER BY table_name
  ) LOOP

    -- skip if it already exists in the target schema
    SELECT COUNT(*) INTO v_exists_cnt
    FROM all_tables
    WHERE owner = v_tgt_schema
      AND table_name = t.table_name;

    IF v_exists_cnt > 0 THEN
      DBMS_OUTPUT.PUT_LINE('SKIP (already exists): ' || t.table_name);
      v_skipped_cnt := v_skipped_cnt + 1;
      CONTINUE;
    END IF;

    BEGIN
      v_ddl := DBMS_METADATA.GET_DDL('TABLE', t.table_name, v_src_schema);
      v_ddl := REPLACE(v_ddl, v_src_schema, v_tgt_schema);

      -- defensive: strip trailing ; / newline if GET_DDL left one
      v_ddl := RTRIM(v_ddl);
      WHILE SUBSTR(v_ddl, LENGTH(v_ddl), 1) IN (';', CHR(10), CHR(13)) LOOP
        v_ddl := RTRIM(SUBSTR(v_ddl, 1, LENGTH(v_ddl) - 1));
      END LOOP;

      EXECUTE IMMEDIATE v_ddl;
      DBMS_OUTPUT.PUT_LINE('CREATED: ' || t.table_name);
      v_created_cnt := v_created_cnt + 1;

    EXCEPTION
      WHEN OTHERS THEN
        v_failed_cnt := v_failed_cnt + 1;
        DBMS_OUTPUT.PUT_LINE('FAILED: ' || t.table_name || ' - ' || SQLERRM);
        DBMS_OUTPUT.PUT_LINE('--- Generated DDL for ' || t.table_name || ' (for debugging) ---');
        print_clob(v_ddl);
        DBMS_OUTPUT.PUT_LINE('--- end DDL ---');
    END;

  END LOOP;

  DBMS_OUTPUT.PUT_LINE('=================================================');
  DBMS_OUTPUT.PUT_LINE('Done. Created: ' || v_created_cnt
                        || ', Skipped (already existed): ' || v_skipped_cnt
                        || ', Failed: ' || v_failed_cnt);
END;
/
