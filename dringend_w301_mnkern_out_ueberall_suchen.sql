-- DRINGEND: SSC41WH_FST.W301_MNKERN_OUT wurde gedroppt, Recreate aus
-- THM_DWH_FST schlug fehl (ORA-31603 -- Tabelle dort nicht gefunden).
-- Tabelle existiert aktuell NIRGENDS mehr in SSC41WH_FST. Bevor irgendwas
-- anderes versucht wird: ueberall suchen, wo W301_MNKERN_OUT wirklich
-- liegt (auch als View/Synonym, auch unter leicht anderem Namen).

-- 1) Existiert der Name ueberhaupt irgendwo, unter welchem Owner/Typ?
SELECT owner, object_name, object_type, status
FROM dba_objects
WHERE object_name = 'W301_MNKERN_OUT'
ORDER BY owner;

-- 2) Falls der exakte Name nirgends existiert -- aehnliche Namen suchen
--    (Tippfehler/Suffix-Unterschied moeglich).
SELECT owner, object_name, object_type, status
FROM dba_objects
WHERE object_name LIKE '%MNKERN_OUT%'
ORDER BY owner, object_name;

-- 3) Papierkorb pruefen -- evtl. liegt die frisch gedroppte Tabelle noch
--    im Recycle Bin von SSC41WH_FST und kann per FLASHBACK zurueckgeholt
--    werden, OHNE irgendwo neu klonen zu muessen.
SELECT owner, object_name, original_name, type, droptime
FROM dba_recyclebin
WHERE original_name = 'W301_MNKERN_OUT'
      AND owner = 'SSC41WH_FST';

-- FALLS Schritt 3 einen Treffer bringt: sofortige Wiederherstellung,
-- OHNE Datenverlust und ohne Reference-Schema-Rateraten:
-- FLASHBACK TABLE SSC41WH_FST.W301_MNKERN_OUT TO BEFORE DROP;
