---
name: project-fst-odi
description: "FST/BA (Förderstatistik) client ODI 12c project — Confluence space, team, meeting sources, and ODI-concepts-for-SSIS-developers teaching material. Call this 'ODI' in future chats."
metadata: 
  node_type: memory
  type: project
  originSessionId: b7ca0f2c-2005-4417-b8b2-3bff3865b377
  modified: 2026-08-26T08:05:53.184Z
---

**Call sign**: user refers to this whole context simply as **"ODI"** — when they say "ODI" in a future chat, this is the project they mean (distinct from [[project-odi-etl]], which is an unrelated personal homelab ODI test environment).

## What this is
User (Vignesh) is a new/onboarding developer on the **FST** (Förderstatistik) team at a client (Bundesagentur-style organization, German). The team builds ETL pipelines in **Oracle Data Integrator (ODI) 12c** feeding a DWH used for funding-statistics reporting. A new sub-project, the **Förderplattform**, is being onboarded onto a new dev environment (B05).

## Confluence
- Site: `ingravure.atlassian.net`, personal space "Assistance Ingravure" (space ID 24477752).
- Main page: "FST-Einarbeitung: BI-Projekt, Zugänge & Team" — https://ingravure.atlassian.net/wiki/x/AoAcUg (page ID 1377599490). Sections: 1 BI-Projekt Details, 2 Zugänge & Tools, 3 Team & Ansprechpartner, 4 Umgebungen Dev→Int→Abnahme→Prod, 5 E-Mail-Vorlagen, 6 Förderplattform B05-Setup & ODI-Konzepte.
- Child page: "Entwicklungsumgebung Förderplattform (UP15) – Vertiefte Doku" — https://ingravure.atlassian.net/wiki/x/AQAuUg
- Child page: "Onboarding ODI – Vertiefte Doku (mit Screenshots)" — https://ingravure.atlassian.net/wiki/x/AoAuUg

## Source material
- Audio meeting recordings transcribed from iTop Screen Recorder (`AppData/LocalLow/iTop Screen Recorder/Audios`), transcribed with faster-whisper (medium model, language forced to `de`, VAD filter — small model + no forced language hallucinates badly on this German audio).
- Two official Confluence-exported meeting-notes PDFs (with real screenshots) from `Downloads/`, cross-referenced against the transcripts to fill in real names (attendees, repo names, schema names, actual code).
- Two full transcript pairs (DE + EN) saved on Desktop, e.g. `20260727_135426_transcript_de.txt` / `_EN.txt`.

## Key people
Thorsten Senft (trainer/senior dev, login DEV_SENFTT002), Jörn Kulessa (available only until 05.08.2026, then 2.5 weeks vacation), Michael Bachler, Nils Rümmeli (the other new external dev alongside the user), Andreas Mehlins (PuT, repo cloning), Tobias Holtkamp (Jira tickets).

## Key ODI domain facts
- Naming: `B01..B05` = dev environment nicknames, each maps to a number range (B01→44, B02→43, B03→45, B04→48, new B05→41). `SVS[nr]WH_FST` = persistent/final data schema; `SSC[nr]WH_FST` = scratch/staging schema; `ODI_FST_E_B0x` = the ODI repository (metadata) schema, separate from both.
- B05 is being built as a **clone of ODI_FST_E_R01** (reference/production mirror), not empty — done by PuT/Andreas Mehlins.
- Flow: Package (recipe) → Mapping (one data-flow step) → uses a **logical schema** (nickname) → resolved at runtime by a **Context** → real **physical schema**. Raw load + all transforms happen in scratch tables; only the final "Buchen" step (atomic Insert-Select or partition exchange) writes into the real permanent table. Operator tab = execution log (green check/red X/green arrow running; "Caused by" line in error stack is the only part that matters).
- Technical DB user `odi_bsg_default` is very powerful — used for all schema connections.

## B05 environment build order (confirmed 2026-08-13 via colleague email to Nils)
Setting up a new sandbox/environment (like B05) requires two categories of schema, created in a strict order:
1. **"ODI-Schemas"** — Physical Schema objects registered inside **ODI Topology** (one per subject area, e.g. matching the `PSD1_*`/`THM_*` naming families). Must be created first.
2. A Context then maps each logical schema (`LS_THM_*`) to its new Physical Schema.
3. **Only after that** can **RDE** actually create the real Oracle DB-side schema (the "ESTAT Schemata", e.g. `SSC41*`/`SVS41*` — scratch/persistent) via its Create Schema trick — RDE's Context-based translation has nothing to resolve against until step 1-2 exist.
Colleague's exact words: "Die ESTAT Schemata sind die, die auf der ESTAT als DB-Schema angelegt werden müssen, die ODI-Schemas müssen im ODI als Physical Schemas angelegt werden... erst dann kann man per RDE die DB-Schema anlegen." Relates to [[project-odi-etl]] concepts (logical schema/Context/physical schema), taught via detailed walkthrough of a real Aug 5 demo recording (RDE release management: naming conventions, Create Schema trick, Connect Schema/XXXSYS, Transfer & Install wizard, UC4 as RDE's background job engine).

## Teaching approach that worked well
User has strong **SSIS background** — explaining ODI concepts via direct SSIS analogies (Connection Manager ↔ logical schema, Catalog Environment ↔ Context, Data Flow Task ↔ Mapping, staging tables ↔ scratch tables, Catalog execution report ↔ Operator) was very effective. User prefers **very slow, one-concept-at-a-time teaching** — explicitly asked to pause after each step and only continue on "next"/"yes". Keep future ODI explanations in this incremental, analogy-driven style.

## SCR vs THM terminology (confirmed via Aug 18 Thorsten session)
**SCR** = old Informix-era name for "Scratch" — temporary/intermediate ETL working tables. **THM** = "Themenbereich" (subject area) — final/permanent tables (history, entities, facts, load tables). Build order: SCR schemas first (fewer scripts, safe to just run all of them), THM schemas second — but THM folders contain far more `.sql` scripts than needed (historically accumulated, many obsolete); filter by checking which tables actually exist in the live reference schema (e.g. THM_DWH_FST in SQL Developer), or by cross-checking against `FST_Tabellen.txt` where it's listed. Never hardcode a schema owner in a script (`CREATE TABLE SCR_DWH_FST.X` breaks — RDE connects AS the resolved target user and runs the bare statement).

## B05 (sandbox 41) status as of 2026-08-26
**Repo, Context, Topology**: done. Thorsten built `CT_ESTAT_FST_41`, registered all `SVS41*`/`SSC41*` Physical Schemas, linked them in the Context (`LS_THM_*` → `SVS41*`, `LS_SCR_*` → `SSC41*`). `SVS41EB_ODIKM` deliberately skipped — Context points straight at `THM_UEB_ODIKM` instead (no dedicated sandbox copy needed, per Thorsten's email).

**Reference docs used** (from `\\dst.baintern.de\...\DUD\SVS41\`, downloaded to `Downloads/`): `FST_Schemata.txt` (full schema list — DB-ESTAT physical + ODI logical), `FST_Tabellen.txt` (which tables belong in which of the 5 SVS41 target schemas, only covers `SVS41WH_FST`/`WH_BA_TRS`/`WH_STAT_FST`/`WH_STAT_BA_TRS`/`M_STAT_FST` — no `SSC*`/scratch coverage, and `SVS41WH_STAT_FST` has no listed copier script — unresolved gap), plus 4 original team-authored `tabellen_kopieren_*.sql` templates (source/target hardcoded per sandbox, e.g. `psd1→svs44`, `xro→svs46_ba_trs` — must retarget `v_target_user` per script, source stays same).

**Table creation**: in progress via RDE, dragging individual `AFM*_create_table_*.sql` files from SVN Explorer folders into Release Definition Editor (release file `FST_NR_B05.xml`, NOT `FST_SVS44.xml` — must Save As, never overwrite another sandbox's release). Hit and fixed a long chain of real bugs across many install runs (LaufNr 3→41+): stray space/double-dot after `&&1` substitution var (`&&1. .X`/`&&1..X` → must be `&&1.X`, source-file typos, found repeatedly across many CREATE TABLE scripts in the same files), quoting `"&&1"` exposing hidden whitespace in the substituted value (ORA-01918 user not found — fix: remove quotes around `&&1`, keep table name quoted), duplicate `PARALLEL` clause (ORA-12812), single `&1` vs `&&1` causing SQL*Plus to interactively prompt and swallow the next script line (ORA-00903 downstream). Pattern: always fix the real `.sql` source file, never the Content-Type (TEXT is required for RDE variable substitution; BINARY skips substitution entirely and is never the fix).

**Data loading**: separate step, via custom-built PL/SQL copier scripts (team's own template had no row limit — full load — which caused `ORA-01652 TEMP tablespace STAT_DM_SCR full` on multi-million-row tables). User decided: cap every copy at 1000 rows/table via `FETCH FIRST 1000 ROWS ONLY`, and never TRUNCATE (target schemas start empty, insert-only is safer). Also added: only copy columns existing in BOTH source and target (avoids `ORA-00904` from structural drift between sandbox table defs and source, e.g. `STS_ID_PRS_EIN` existed in source `SSC43M_STAT_FST` but not sandbox's `SSC41M_STAT_FST` version).

**For empty target schemas with zero tables** (e.g. `SSC41WH_FST`), built a `DBMS_METADATA.GET_DDL`-based script instead of manual per-table drag-and-drop: loops every table in the `43`-equivalent source schema, generates real DDL, strips `STORAGE`/`SEGMENT_ATTRIBUTES`/`TABLESPACE` (per Thorsten's own written rule: never hardcode storage, only partitioning must stay explicit), remaps schema name, executes, skips tables that already exist in target (rerunnable safely). **`ORA-00922` root cause found and fixed (resolved on a different machine, pulled back in 2026-08-26):** NOT a storage-clause artifact as first suspected — `DBMS_METADATA.GET_DDL` appends a trailing `;` terminator by default (`SQLTERMINATOR` transform param, defaults TRUE), which `EXECUTE IMMEDIATE` can't handle inside the string. Fix: `SET_TRANSFORM_PARAM(..., 'SQLTERMINATOR', FALSE)` + a defensive trailing `;`/newline strip loop before executing, plus `SET DEFINE OFF` at the script top (prevents any `&`-substitution misfire in table/column names, same bug class as the earlier RDE `&&1` issues). Full script now also filters out IOT-overflow/nested-table/secondary-index internal objects from `all_tables`, and reports final Created/Skipped/Failed counts. A standalone single-table test harness (`test_create_one_table.sql`) was added too — edit one variable, run, useful for isolating one problem table before a full-schema run.

**All scripts pushed to GitHub**: `https://github.com/Vigneshmcbe95/odi` (branch `main`), local clone at `C:\Users\BA\odi`. Contains: `log` (the RDE/UC4 deploy log, 1.5MB/~28k lines — too large for WebFetch to read in full, must `git pull` and grep/sed locally), `tabellen_kopieren_ssc43_ssc41_ll_fst.sql`, `tabellen_kopieren_ssc43_ssc41_m_stat_fst.sql`, `tabellen_erstellen_ssc43_ssc41_wh_fst.sql` (DDL-clone-and-create, fixed version), `test_create_one_table.sql` (single-table debug harness), `ODI_PROJECT_MEMORY.md` (a copy of this memory file, pushed there specifically so a session on another machine can `git pull` and resume without local memory files — **must be manually kept in sync**, doesn't auto-update). Git identity for this repo had to be set locally (`vm@ingravure.org` / `Vignesh`) — global config wasn't set on this machine. **Multi-machine workflow confirmed working**: user pushed fixes from a different computer, this session pulled and reviewed them successfully — this is the established pattern for continuing work across machines going forward.

**Also touched, separate ticket**: UP15-291 "Entwurf neuer konsH-Abgriff für die DM-Verarbeitung" — a design/analysis task (not build work), asks for a rough draft of the current Data Mart processing steps and which are reusable vs. need rebuilding, 13 points, Sprint 7. Not started — needs either access to existing `PRJ_THM_DM_STAT_FST` ODI mappings or input from Thorsten/Michael on current DM pipeline steps.

## Flow diagram published
Artifact showing the full ODI repo → logical schema → Context → physical schema → real Oracle schema resolution path, plus the separate clone+load path: https://claude.ai/code/artifact/f1ff0afb-ce13-46c3-abbe-1e978395df2b
