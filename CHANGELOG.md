# CHANGELOG

This changelog tracks the repo as an offline emergency reference cabinet: playbooks for what to do, a library for what to consult, and scripts that verify what is actually present.

Evidence sources:
- `git log`
- commit messages and touched-file scopes
- current top-level docs (`README.md`, `START-HERE.md`, `FIELD-INDEX.md`, `USAGE.md`)

## 2026-09-02 — Provenance cleanup: commercial titles removed, licenses untangled

What changed
- **Removed nine likely-infringing commercial titles** (18 files: each source PDF plus its `kindle-ready/` variant): the Baofeng Radio Bible (commercial Kindle book), Handbook of Food Preservation (Macmillan/CRC academic title), Raw Foods Bible, Science of Smoking Foods, the ARRL Emergency Comms "manual" (which was actually a 5-page scrape of ARRL's website), three commercial small-engine repair manuals under `mechanical/`, and the TruePrepper-branded FM 21-76 repack (FM 21-76 itself is public domain and remains as `FM21-76_US_Army_Survival_Manual.pdf`). Kindle library: 144 → 135 books. Counts updated in README, FIELD-INDEX, USAGE, verify-all.sh, and the kindle conversion scripts.
- **LICENSE is now pure MIT** (named copyright holder) so GitHub detects it; the per-content licensing notes moved to `CONTENT-LICENSES.md`, which also corrects the wrong claim that ARRL publications are freely distributed — only the ARES field resources are.
- **Optional downloads are now marked** in FIELD-INDEX.md and USAGE.md with `[optional download — see DOWNLOADS.md]` so an in-crisis reader can tell tracked files from things a fresh clone does not contain.
- **Repointed rotted download URLs** in `download-kindle-content.sh`: the seven `www.fema.gov` PDFs (Akamai now 403s non-browser clients) and the armypubs TC 4-02.1 link now fetch verified Wayback Machine captures; the USMC survival manual moved off a third-party mirror.
- **New: `tools-scripts/check-links.sh`** — HEAD-checks every URL in the download scripts and key docs and reports dead ones.
- **README states the regional scope** (US West Coast defaults) and how to re-region the kit; storage numbers re-measured (base checkout ~0.9 GB after removals).

Why it matters
- A DMCA takedown is the one event that deletes the kit for everyone at once. Removing the commercial titles and telling the truth about content licensing is what keeps the repo durable.

## 2026-04-21 — The envelope, and Gemma 4 as the default local AI

What changed
- **New: `tools-scripts/build-envelope.sh`** — the canonical output of the repo. Generates `playbooks/envelope/` with eleven print-and-staple sections (tonight sheet, summons 6-up, blank roster, blank comms, first-weekend checklist, what-kills, when-not-to, water, bleed, first-aid, plus a cover letter). Builds a single PDF when pandoc is installed. Safe to re-run; fails hard if any source is missing.
- **New: `playbooks/cards/tonight.md`** — single-page sheet of eight things to do before bed. Twenty minutes, zero dollars, no printer required.
- **Rewrote `START-HERE.md` as three doors**: *Emergency now* / *I have tonight* / *Building the full kit*. Demoted Gemma, downloads, and the library index below the fold.
- **Rewrote `README.md` intro** to lead with the envelope ("the one thing") instead of listing repo contents.
- **New: `tools-scripts/setup-gemma4.sh`** — one command to download Gemma 4 checkpoints, build llama.cpp, convert to GGUF, and smoke-test. Default is `E2B` (~9 GB); `--all` covers all four models. Safe to re-run.
- **Demoted Kimi K2.5** across README, DOWNLOADS, `docs/local-ai-models.md`, `docs/gemma4-llamacpp.md`. Gemma 4 is now the documented primary local-AI path. Kimi remains available as an optional heavyweight footnote.
- **Refreshed first-run framing** in `get-squared-away.sh`, `verify-all.sh`, `FIELD-INDEX.md`, `USAGE.md`, `playbooks/README.md` so the envelope and the tonight sheet are the first things a new reader sees.

Why it matters
- The repo's center of gravity shifts from "library you navigate" to "manila envelope the repo hands you." That's closer to how someone unprepared actually needs to receive help.
- Local AI is now a one-command path instead of an eight-step tour of separate scripts.

## 2026-04-21 — First-run trust polish

Commit: `e46e255` `polish first-run trust surfaces for shipping`

What changed
- Tightened first-run trust surfaces across README, START-HERE, FIELD-INDEX, USAGE, and playbook docs.
- Reframed the repo as a serious offline reference cabinet with optional personalization, not a prescriptive household plan.
- Made `get-squared-away.sh` more honest and less noisy in default mode:
  - says it writes local reports only
  - skips optional Gemma audits in `--essential`
  - preserves summaries even when checks fail
  - updates machine-readable JSON and scenario counts
- Made `household-setup.sh` safer and clearer:
  - blank-template mode stays blank by default
  - `--summons` only fills summons fields unless combined with guided modes
  - exported checklists use absolute repo links on the local machine
  - validates missing `--output` path
- Clarified `print-cards.sh` behavior:
  - printable bundle wording instead of overpromising a PDF
  - better fallback path when `pandoc` is missing
  - explicit optional advanced supplement
- Added `playbooks/cards/high-signal-field-brief.html` as an optional dense supplement, not part of the basic first-print surface.

Why it matters
- Lowers friction for a new downloader.
- Reduces trust-surface confusion.
- Makes the repo more publishable to a serious external audience.

## 2026-04-19 — Recovery layer, population-specific cards, and the summons card

Commit: `6567c3b` `Add populations cards, recovery playbooks, summons card, what-kills/when-not-to; lead README with the five files that matter`

What changed
- Added population-specific cards for:
  - kids
  - elderly people living alone
  - disability / medical-equipment constraints
  - renters
  - low-budget households
- Added `summons.md`, a compact wallet / lock-screen reference card.
- Added `what-kills.md` and `when-not-to.md` to emphasize common lethal mistakes and avoidable actions.
- Added `psychological-first-aid.md` and `chronic-conditions.md`.
- Added the full `playbooks/recovery/` layer for insurance, FEMA, documentation salvage, housing, financial recovery, and legal-document reconstruction.
- Reworked README / START-HERE to foreground the most important surfaces.

Why it matters
- The repo stopped assuming one generic household.
- The project gained a serious "day 3 to year 1" recovery layer instead of treating disaster response as the whole problem.

## 2026-04-18 — Parity bundle and lookup drill

Commits:
- `4717570` `Add ACID V2 content-parity bundle + offline knowledge map`
- `aee12f7` `Wire parity bundle + offline-knowledge-map card + lookup drill into verify-all, print-cards, scenarios`

What changed
- Added `tools-scripts/download-acid-parity.sh` to fetch major optional offline-reference surfaces.
- Added `docs/acid-v2-parity.md`.
- Added `playbooks/cards/offline-knowledge-map.md`.
- Added `playbooks/scenarios/11-lookup-drill.md` to test whether the offline reference really works under stress.
- Integrated parity-bundle checks into `verify-all.sh`.
- Added the offline knowledge map to the printed card bundle.

Why it matters
- The repo gained a practical way to close common offline-reference gaps.
- Verification started distinguishing life-support essentials from optional expansion surfaces.

## 2026-04-16 — Playbooks become the front door

Commit: `7ddace9` `Add playbooks/ — tier-1 prep, scenarios, frameworks, printable cards`

What changed
- Added the two-layer product structure:
  - `playbooks/` for what to do
  - library files for what to look up
- Added Tier-1 setup playbooks.
- Added scenario playbooks.
- Added decision frameworks.
- Added the first printable emergency cards.
- Added `household-setup.sh` and `print-cards.sh`.
- Updated bootstrap docs and verification to surface the playbooks as the front door.

Why it matters
- This is the point where the repo became more than a large archive.
- It acquired a usable operational interface under stress.

## 2026-04-16 — Bootstrap orientation and local-AI workflow

Commit: `2b04417` `Add Gemma 4 local-AI workflow, bootstrap script, and field orientation docs`

What changed
- Added `get-squared-away.sh`, `START-HERE.md`, `FIELD-INDEX.md`, and `AGENTS.md`.
- Added the Gemma 4 llama.cpp pipeline:
  - download
  - build
  - convert
  - quantize
  - audit
  - test
  - run
- Added `docs/local-ai-models.md` and `docs/gemma4-llamacpp.md`.
- Reworked `verify-all.sh` around `--essential` and `--full` modes.

Why it matters
- The repo got a canonical orientation path.
- Local AI became a practical optional layer rather than a vague future note.

## 2026-03-05 — Documentation rewrite and library expansion

Commits:
- `f1df477` `Rewrite docs: compelling README, add USAGE.md and LICENSE`
- `b47cbf6` `Add 25 new books: blacksmithing, butchering, fishing, distillation, weather, firearms, construction, psychology`

What changed
- Replaced the early index-style docs with a stronger README and `USAGE.md`.
- Added a formal `LICENSE`.
- Expanded the Kindle-ready and source library into additional practical domains:
  - metalworking
  - butchering and sausage making
  - fishing
  - fermentation / distillation / brewing
  - weather
  - construction
  - firearms manuals
  - psychological first aid and crisis counseling

Why it matters
- The repo became easier to navigate.
- The underlying reference corpus became broader and more serious.

## 2026-03-05 — Initial offline cabinet

Commit: `383d369` `Initial commit: offline survival resource kit with Kindle-ready library`

What changed
- Established the repo as a large offline library with:
  - Kindle-ready books
  - source PDFs
  - helper scripts
  - download guidance for large optional resources
- Covered medical, survival, food and water, herbal medicine, radio, solar, sanitation, mechanical, navigation, and construction.

Why it matters
- This is the base layer the rest of the project builds on.

## Notes for agents and maintainers

The major capability waves are:
1. Build the offline cabinet.
2. Improve docs and broaden the corpus.
3. Add canonical orientation and optional local AI.
4. Put playbooks in front of the library.
5. Add parity-bundle and lookup validation.
6. Add population-specific cards and recovery playbooks.
7. Polish trust surfaces for external shipping.
