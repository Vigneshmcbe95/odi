-- =====================================================================
-- PD technischer Durchstich - eigene Testtabellen fuer Nils (NIR)
-- Zielschema: SVS41WH_FST (B05, Kontext 41, logisches Schema LS_THM_DWH_FST)
-- Struktur: 1:1 Kopie der PD-View VS_PAL_DWH_FST_TECHNISCHER_DURCHSTICH
--           (wie Joerns Tabellen PAL_DWH_FST_TECHNISCHER_DURCHSTICH_TEST/_JDBC_TEST)
--
-- Tabelle 1: ..._NIR       -> Ziel fuer LKM Oracle to Oracle Pull (DB Link)
-- Tabelle 2: ..._JDBC_NIR  -> Ziel fuer LKM SQL to Oracle (Built-In), JDBC ueber Agent
--
-- Wiederholbar: existierende Tabellen werden uebersprungen, nicht geloescht.
-- In SQL Developer komplett mit F5 ausfuehren.
-- =====================================================================
SET SERVEROUTPUT ON

DECLARE
  TYPE t_names IS TABLE OF VARCHAR2(128);
  v_tables t_names := t_names(
    'PAL_DWH_FST_TECHNISCHER_DURCHSTICH_NIR',
    'PAL_DWH_FST_TECHNISCHER_DURCHSTICH_JDBC_NIR'
  );
  v_cnt NUMBER;
BEGIN
  FOR i IN 1 .. v_tables.COUNT LOOP
    SELECT COUNT(*) INTO v_cnt
    FROM   all_tables
    WHERE  owner = 'SVS41WH_FST'
    AND    table_name = v_tables(i);

    IF v_cnt > 0 THEN
      DBMS_OUTPUT.PUT_LINE('UEBERSPRUNGEN (existiert bereits): ' || v_tables(i));
    ELSE
      EXECUTE IMMEDIATE
        'CREATE TABLE SVS41WH_FST.' || v_tables(i) || ' (
           STG_RECORDTIMESTAMP         TIMESTAMP(6),
           KAFKA_TOPIC                 VARCHAR2(100 CHAR),
           KAFKA_PARTITION             NUMBER(10),
           KAFKA_OFFSET                NUMBER(19),
           KAFKA_RECORDTIMESTAMP       TIMESTAMP(6),
           UUID                        VARCHAR2(36 CHAR),
           ZEITSTEMPEL                 TIMESTAMP(6),
           EREIGNIS                    VARCHAR2(100 CHAR),
           EKID                        VARCHAR2(100 CHAR),
           ISTMULTIFAKTOR              NUMBER(1),
           AUSLOESER                   VARCHAR2(100 CHAR),
           GUELTIGAB                   DATE,
           LOHNSTEUERKLASSEFAKTOR      NUMBER(4,3),
           SUBSTRUKTUR_PFLICHTFELD     VARCHAR2(100 CHAR),
           SUBSTRUKTUR_OPTIONALESFELD  NUMBER(4)
         )';
      DBMS_OUTPUT.PUT_LINE('ERSTELLT: ' || v_tables(i));
    END IF;
  END LOOP;
END;
/

-- Pruefung: erwartet 4 Zeilen (2x Joern, 2x NIR)
SELECT table_name, num_rows, last_analyzed
FROM   all_tables
WHERE  owner = 'SVS41WH_FST'
AND    table_name LIKE 'PAL_DWH_FST_TECHNISCHER_DURCHSTICH%'
ORDER  BY table_name;

-- Pruefung: Spaltenvergleich mit Joerns Tabelle (erwartet: keine Zeilen = identisch)
SELECT column_name, data_type, data_length, data_precision, data_scale
FROM   all_tab_columns
WHERE  owner = 'SVS41WH_FST' AND table_name = 'PAL_DWH_FST_TECHNISCHER_DURCHSTICH_TEST'
MINUS
SELECT column_name, data_type, data_length, data_precision, data_scale
FROM   all_tab_columns
WHERE  owner = 'SVS41WH_FST' AND table_name = 'PAL_DWH_FST_TECHNISCHER_DURCHSTICH_NIR';
