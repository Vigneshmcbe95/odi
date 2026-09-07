-- Fuer Christian: Struktur von dbo.tm_steuerlistenfile_dimensionen
-- anzeigen (SQL Server, daher INFORMATION_SCHEMA statt DBA_TAB_COLUMNS)
-- -- damit er weiss, welche Spalten er per INSERT direkt befuellen muss,
-- ohne den Umweg ueber die (nicht existierende) CSV-Datei.

-- 1) Struktur: Spaltenname, Datentyp, Laenge, Nullable, Reihenfolge
SELECT
    c.COLUMN_NAME,
    c.DATA_TYPE,
    c.CHARACTER_MAXIMUM_LENGTH,
    c.IS_NULLABLE,
    c.ORDINAL_POSITION
FROM INFORMATION_SCHEMA.COLUMNS c
WHERE c.TABLE_SCHEMA = 'dbo'
      AND c.TABLE_NAME = 'tm_steuerlistenfile_dimensionen'
ORDER BY c.ORDINAL_POSITION;

-- 2) Falls die Tabelle noch NICHT existiert -- Beispiel-CREATE TABLE
-- als Vorlage (Spalten/Typen bitte an echte Struktur/Confluence-
-- Screenshot anpassen, das ist nur ein Platzhalter-Geruest):
--
-- CREATE TABLE dbo.tm_steuerlistenfile_dimensionen (
--     THEMENGEBIET      VARCHAR(50)  NOT NULL,
--     DIMENSION_NAME     VARCHAR(100) NOT NULL,
--     DIMENSION_WERT     VARCHAR(255) NULL,
--     GUELTIG_AB         DATE         NULL,
--     GUELTIG_BIS        DATE         NULL
-- );

-- 3) Direkter INSERT (ersetzt den CSV-Ladeweg) -- eine Zeile pro
-- Datensatz aus dem Confluence-Screenshot, Spaltennamen an echte
-- Struktur aus Schritt 1 anpassen:
--
-- INSERT INTO dbo.tm_steuerlistenfile_dimensionen
--     (THEMENGEBIET, DIMENSION_NAME, DIMENSION_WERT, GUELTIG_AB, GUELTIG_BIS)
-- VALUES
--     ('<themengebiet>', '<dimension_name>', '<wert>', '<gueltig_ab>', '<gueltig_bis>');
--
-- (mehrere VALUES-Zeilen mit Komma getrennt anhaengen fuer mehrere
-- Datensaetze in einem INSERT)
