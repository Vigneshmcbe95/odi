SET SERVEROUTPUT ON SIZE UNLIMITED
SET LONG 100000
SET LINESIZE 200

-- Test harness: create ONE table via DBMS_METADATA.GET_DDL, SSC43WH_FST -> SSC41WH_FST
-- Usage: @test_create_one_table.sql YOUR_TABLE_NAME
-- Debugging ORA-00922 (100% failure rate on tabellen_erstellen_ssc43_ssc41_wh_fst.sql):
-- adds explicit SQLTERMINATOR=FALSE + defensive trailing-';' strip before EXECUTE IMMEDIATE.

DECLARE
  v_ddl        CLOB;
  v_table_name VARCHAR2(128) := UPPER('&&1');
  v_src_schema VARCHAR2(128) := 'SSC43WH_FST';
  v_tgt_schema VARCHAR2(128) := 'SSC41WH_FST';

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

  v_ddl := DBMS_METADATA.GET_DDL('TABLE', v_table_name, v_src_schema);

  -- swap schema name
  v_ddl := REPLACE(v_ddl, v_src_schema, v_tgt_schema);

  -- defensive: strip trailing ; / newline if GET_DDL left one
  v_ddl := RTRIM(v_ddl);
  WHILE SUBSTR(v_ddl, LENGTH(v_ddl), 1) IN (';', CHR(10), CHR(13)) LOOP
    v_ddl := RTRIM(SUBSTR(v_ddl, 1, LENGTH(v_ddl) - 1));
  END LOOP;

  DBMS_OUTPUT.PUT_LINE('=== Generated DDL for ' || v_table_name || ' ===');
  print_clob(v_ddl);
  DBMS_OUTPUT.PUT_LINE('=== END DDL, executing now ===');

  BEGIN
    EXECUTE IMMEDIATE v_ddl;
    DBMS_OUTPUT.PUT_LINE('SUCCESS: ' || v_table_name || ' created in ' || v_tgt_schema);
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('FAILED: ' || v_table_name || ' - ' || SQLERRM);
  END;
END;
/
