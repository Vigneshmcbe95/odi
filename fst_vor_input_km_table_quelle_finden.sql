-- Sucht, welches DB-seitige PL/SQL-Objekt (Prozedur/Package/Funktion)
-- FST_VOR_INPUT_KM_TABLE referenziert -- damit laesst sich pruefen, ob
-- diese Tabelle ueber einen DB-Job/eine Prozedur befuellt wird (statt
-- ueber ein einzelnes Wxxx-ODI-Mapping). Ergaenzend dazu in ODI
-- Designer eine Projektsuche nach "FST_VOR_INPUT_KM_TABLE" als Ziel
-- (Target) durchfuehren -- zeigt, ob ein Mapping/Package hineinschreibt.

-- 1) DB-seitige PL/SQL-Objekte, die den Tabellennamen referenzieren.
SELECT owner, name, type
FROM dba_source
WHERE UPPER(text) LIKE '%FST_VOR_INPUT_KM_TABLE%'
GROUP BY owner, name, type
ORDER BY owner, name;

-- 2) Trigger auf der Tabelle selbst (falls das Befuellen ueber einen
--    Trigger statt eine explizite Prozedur laeuft).
SELECT owner, trigger_name, trigger_type, triggering_event, status
FROM dba_triggers
WHERE table_owner = 'SVS43WH_FST'
      AND table_name = 'FST_VOR_INPUT_KM_TABLE';

-- 3) Wann wurde die Tabelle in SVS43 zuletzt geaendert (Analyze-Datum
--    als grober Anhaltspunkt, wann zuletzt Daten reingeschrieben wurden).
SELECT owner, table_name, last_analyzed, num_rows
FROM dba_tables
WHERE table_name = 'FST_VOR_INPUT_KM_TABLE';

-- 4) DBA_JOBS/DBA_SCHEDULER_JOBS -- laeuft ein DB-Scheduler-Job, der
--    diese Tabelle in seinem Code erwaehnt (Action/Programm-Text)?
SELECT owner, job_name, enabled, state
FROM dba_scheduler_jobs
WHERE UPPER(job_action) LIKE '%FST_VOR_INPUT_KM%'
      OR UPPER(job_name) LIKE '%KM_TABLE%';
