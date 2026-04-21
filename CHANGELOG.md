# CHANGELOG

This changelog tracks the repo as an offline emergency reference cabinet: playbooks for what to do, a library for what to consult, and scripts that verify what is actually present.

Evidence sources:
- `git log`
- commit messages and touched-file scopes
- current top-level docs (`README.md`, `START-HERE.md`, `FIELD-INDEX.md`, `USAGE.md`)

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
