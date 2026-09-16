-- Behebt ORA-00904: Zieltabelle W309_WRK_MAT_TN_PRELADETAB hat die
-- Spalte MAT_TEILNAHMEMODUS gar nicht -- Spalte fehlt komplett, kein
-- Rechteproblem.

-- 1) Exakte Definition aus der Quelle uebernehmen (PSD1_DWL_FST oder
--    SVS41WL_FST, je nachdem was aktuell ist)
SELECT data_type, data_length, char_length, nullable
FROM dba_tab_columns
WHERE owner = 'PSD1_DWL_FST'
      AND table_name = 'TL_DWL_MATT'
      AND column_name = 'MAT_TEILNAHMEMODUS';

-- 2) Spalte hinzufuegen (Laenge ggf. an Ergebnis aus Abfrage 1
--    anpassen -- hier vorlaeufig VARCHAR2(8) angenommen)
ALTER TABLE SSC41WH_FST.W309_WRK_MAT_TN_PRELADETAB
  ADD (MAT_TEILNAHMEMODUS VARCHAR2(8));
