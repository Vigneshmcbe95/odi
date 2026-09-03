-- Rein lesend: zeigt die aktuellen Partitionsgrenzen von TL_DWL_50PA,
-- um zu verstehen, warum ORA-14400 trotz Neuaufbau weiter auftritt.
-- HIGH_VALUE ist LONG -- funktioniert in einem einfachen SELECT (nur
-- Vergleiche/CASE mit LONG sind verboten, Anzeige ist unproblematisch).
SELECT partition_name, partition_position, high_value
FROM dba_tab_partitions
WHERE table_owner = 'SVS41WL_FST'
      AND table_name = 'TL_DWL_50PA'
ORDER BY partition_position;

-- Partitionierungsspalte(n) dieser Tabelle
SELECT column_name, column_position
FROM dba_part_key_columns
WHERE owner = 'SVS41WL_FST'
      AND name = 'TL_DWL_50PA'
ORDER BY column_position;
