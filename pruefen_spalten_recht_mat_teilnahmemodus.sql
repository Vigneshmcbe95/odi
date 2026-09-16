-- Prueft, ob odi_bsg_default nur auf BESTIMMTE Spalten von
-- PSD1_DWL_FST.TL_DWL_MATT SELECT-Recht hat (spaltenweise Grants),
-- statt auf die ganze Tabelle -- erklaert ORA-00904 fuer eine echt
-- existierende Spalte, wenn genau diese Spalte nicht mitgegrantet wurde.

-- 1) Alle spaltenweisen Grants fuer odi_bsg_default auf dieser Tabelle
SELECT grantee, column_name, privilege
FROM dba_col_privs
WHERE owner = 'PSD1_DWL_FST'
      AND table_name = 'TL_DWL_MATT'
      AND grantee = 'ODI_BSG_DEFAULT'
ORDER BY column_name;

-- 2) Tabellenweiter Grant (falls das die eigentliche Zugriffsart ist)
SELECT grantee, privilege
FROM dba_tab_privs
WHERE owner = 'PSD1_DWL_FST'
      AND table_name = 'TL_DWL_MATT'
      AND grantee = 'ODI_BSG_DEFAULT';

-- 3) Falls beides leer ist: odi_bsg_default hat GAR KEIN Recht auf
--    diese Tabelle -- Fix waere ein normaler GRANT SELECT auf die
--    ganze Tabelle:
-- GRANT SELECT ON PSD1_DWL_FST.TL_DWL_MATT TO odi_bsg_default;
