-- Zeigt, in welchem Schema LADEPROTOKOLL tatsaechlich liegt.
SELECT owner, table_name
FROM dba_tables
WHERE table_name = 'LADEPROTOKOLL';

-- Zeigt, mit welchem User man aktuell verbunden ist.
SELECT USER FROM dual;
