-- Behebt ORA-00904 auf MAT_TEILNAHMEMODUS (und jede andere Spalte
-- dieser Tabelle) -- odi_bsg_default hatte GAR KEIN Recht auf
-- PSD1_DWL_FST.TL_DWL_MATT, weder tabellen- noch spaltenweise.
GRANT SELECT ON PSD1_DWL_FST.TL_DWL_MATT TO odi_bsg_default;
