# SHTF: Offline Survival Kit

If utilities fail, the internet is gone, or you just want a serious offline reference cabinet, this repo gives you PDFs, ZIM files, maps, printable cards, and a few helper scripts.

## If something is happening right now

Open this first: **[START-HERE.md](START-HERE.md)** — one page that maps the emergency to a likely file.

Useful first stops:

1. **[START-HERE.md](START-HERE.md)** — the dispatcher
2. **[playbooks/cards/summons.md](playbooks/cards/summons.md)** — the 6-line wallet / lock-screen card
3. **[playbooks/cards/what-kills.md](playbooks/cards/what-kills.md)** — the real disaster killers (CO, heat, floodwater, hypothermia)
4. **[playbooks/frameworks/stay-or-go.md](playbooks/frameworks/stay-or-go.md)** — the main movement/shelter decision framework
5. **[medical/Where_There_Is_No_Doctor_FULL.pdf](medical/Where_There_Is_No_Doctor_FULL.pdf)** — a core medical reference when professional care is unavailable

Print the cards. Fill the summons card privately. Screenshot it to your phone lock screen only if that is safe for your situation.

```bash
./tools-scripts/print-cards.sh   # bundles every emergency card into one printable bundle; PDF if pandoc is installed
```

## If you are preparing

```bash
./tools-scripts/get-squared-away.sh    # local orientation + verification report; no network
./tools-scripts/print-cards.sh         # printable cards bundle; PDF if pandoc is installed
```

Then use the indexes:

- [FIELD-INDEX.md](FIELD-INDEX.md) — short file-level map
- [USAGE.md](USAGE.md) — resource use by problem
- [DOWNLOADS.md](DOWNLOADS.md) — optional large downloads

If you want a read-only first look before running anything, open [START-HERE.md](START-HERE.md) and [FIELD-INDEX.md](FIELD-INDEX.md).

Optional worksheet:

```bash
./tools-scripts/household-setup.sh              # blank private templates; no questions
./tools-scripts/household-setup.sh --quick      # optional questionnaire
./tools-scripts/household-setup.sh --full --summons
```

## Read this as defaults, not doctrine

Survival is personal. A good resource for a healthy adult in a detached house can be wrong for an apartment renter, a wheelchair user, a dialysis patient, a parent with infants, an elder living alone, a person without a car, or someone with local legal or cultural constraints.

The playbooks give conservative defaults and point to sources. Change them for your body, household, climate, terrain, budget, medical needs, disability access, pets, local law, and trusted local emergency instructions.

---

## What's in the repo

Two halves:

1. **[Playbooks](playbooks/)** — short checklists and cards for when a full manual is too much.
2. **Library** — the authoritative references the playbooks point into. 144 Kindle-ready books plus source PDFs, offline Wikipedia, topo maps.

Everything is sourced from US government publications (public domain), WHO/UN freely distributed guides, Peace Corps manuals, Project Gutenberg, and FEMA / CDC / NOAA / FCC guidance.

## 1. Playbooks — what to DO

### Tier-1 setup — a starting foundation

Build a first version. Review when your life changes. See [`playbooks/tier-1-setup/00-first-weekend.md`](playbooks/tier-1-setup/00-first-weekend.md).

1. [Household roster](playbooks/tier-1-setup/01-household-roster.md)
2. [Go-bag per person](playbooks/tier-1-setup/02-go-bag.md)
3. [14-day water + food stockpile](playbooks/tier-1-setup/03-water-food-stockpile.md)
4. [Cash + documents](playbooks/tier-1-setup/04-cash-and-documents.md)
5. [Family communications plan](playbooks/tier-1-setup/05-family-comms-plan.md)
6. [Digital hardening](playbooks/tier-1-setup/06-digital-hardening.md) — password managers, 2FA, backups, SIM-swap protection

### Scenario playbooks — what to do when

- [01. House fire](playbooks/scenarios/01-house-fire.md) — the most likely real emergency
- [02. Severe weather](playbooks/scenarios/02-severe-weather.md) — hurricane, tornado, blizzard, heat dome, flood, ice storm, lightning, dust storm
- [03. Earthquake (Cascadia focus)](playbooks/scenarios/03-earthquake-cascadia.md)
- [04. Wildfire evacuation](playbooks/scenarios/04-wildfire-evacuation.md)
- [05. Extended grid-down](playbooks/scenarios/05-grid-down-extended.md)
- [06. Pandemic](playbooks/scenarios/06-pandemic.md)
- [07. Cyber collapse](playbooks/scenarios/07-cyber-collapse.md)
- [08. Nuclear](playbooks/scenarios/08-nuclear.md) — distant fallout, near airburst, dirty bomb, reactor accident
- [09. Civil unrest / bug-in](playbooks/scenarios/09-civil-unrest-bug-in.md)
- [10. Stranded or lost](playbooks/scenarios/10-stranded-or-lost.md)
- [11. Offline lookup drill](playbooks/scenarios/11-lookup-drill.md)

### Decision frameworks — judgment calls before gear

- [Stay or go](playbooks/frameworks/stay-or-go.md) — movement versus shelter framework
- [Triage](playbooks/frameworks/triage.md)
- [Signalling & rescue](playbooks/frameworks/signalling-and-rescue.md)
- [Myths that kill](playbooks/frameworks/myths-that-kill.md)

### Emergency cards — one page each

[`playbooks/cards/`](playbooks/cards/) — make a printable bundle with `./tools-scripts/print-cards.sh`.

Read these two early: **[what-kills.md](playbooks/cards/what-kills.md)** and **[when-not-to.md](playbooks/cards/when-not-to.md)**. They may change what you buy and what you do.

The rest: summons · first aid · stop the bleed · water purification · psychological first aid · chronic conditions · radiation shelter · radio frequencies · offline knowledge map · family comms (fill in).

### Post-disaster recovery — the second disaster

[`playbooks/recovery/`](playbooks/recovery/) — insurance claims, FEMA IA, documentation salvage, contractor vetting, financial recovery, housing displacement, mental-health timeline, legal-document reconstruction, household recovery. The first 72 hours are about staying alive; the next year is often the second hard problem.

## 2. Library — what to LOOK UP

### Kindle-ready (144 books, drag-and-drop)

`kindle-ready/` is flattened so you can drop it straight onto a Kindle via USB. Files are category-prefixed so they sort together on the device.

| # | Category | Count | Highlights |
|---|----------|-------|------------|
| 01 | **Medical** | 10 | *Where There Is No Doctor/Dentist*, WHO surgical guide, psychological first aid, essential medicines |
| 02 | **Survival** | 42 | US Army field manuals (survival, marksmanship, urban ops, cold weather, mountain), FEMA, nuclear survival, knots, trapping |
| 03 | **Food & Water** | 38 | Gardening, seed saving, beekeeping, canning, foraging, fishing, butchering, sausage, distillation, brewing, water purification |
| 04 | **Herbal Medicine** | 5 | Culpeper's, WHO medicinal plant monographs |
| 05 | **Radio & Comms** | 11 | Baofeng UV-5R programming, ARRL emergency comms, CHIRP |
| 06 | **Power & Solar** | 4 | Off-grid solar, wind, biogas, solar cookers |
| 07 | **Sanitation** | 6 | Emergency hygiene, composting toilets, WHO WASH |
| 08 | **Mechanical** | 9 | Engine repair, soap making, weaving, leather tanning, micro hydro |
| 09 | **Navigation & Weather** | 4 | Celestial navigation, meteorology, weather patterns |
| 10 | **Construction** | 10 | Log cabin, brickmaking, carpentry, barn construction, FEMA safe rooms |
| 11 | **Metalworking & Crafts** | 5 | Blacksmithing, forge work, pottery |

Rebuild from source URLs: `./tools-scripts/download-kindle-content.sh`

### Source PDFs, offline wikis, maps

Original source PDFs by topic (`medical/`, `survival-guides/`, `food-water/`, `radio/`, `power-electrical/`, `maps/`), NOAA radio frequency sheets, offline Wikipedia (Kiwix ZIM), USGS topo maps. See [USAGE.md](USAGE.md) for scenario-based usage of the library.

### Local AI (optional)

A local-model stack (Gemma 4 via llama.cpp, Kimi K2.5, Ollama) is included for answering questions when you have no internet but still have power. See [docs/local-ai-models.md](docs/local-ai-models.md) and [docs/gemma4-llamacpp.md](docs/gemma4-llamacpp.md). This is prep work, not response work — do not set it up during an emergency.

## Optional large downloads (not in repo)

Too large for GitHub. See **[DOWNLOADS.md](DOWNLOADS.md)** for step-by-step instructions, or use the one-shot parity bundle:

```bash
./tools-scripts/download-acid-parity.sh --list
./tools-scripts/download-acid-parity.sh ifixit ready-gov wikivoyage post-disaster
```

See [docs/acid-v2-parity.md](docs/acid-v2-parity.md) for the parity matrix against a typical commercial offline-reference device.

| Resource | Size | What |
|----------|------|------|
| Wikipedia | ~136 GB | Full English Wikipedia, Wikibooks, Wiktionary (Kiwix ZIM) |
| Stack Exchange | ~85 GB | Stack Overflow + 14 specialized Q&A sites |
| Medical wiki | ~10 GB | MDWiki medical encyclopedia |
| Topo maps | ~66 GB | 1,729 USGS GeoPDF maps for CA/OR/WA |
| Street maps | ~2 GB | OpenStreetMap for west coast states |
| Video tutorials | ~1.7 GB | Baofeng radio, solar power, knot tying |
| AI model | ~263 GB | Kimi K2.5 (or Ollama for lighter models) |

## Key surfaces

| File | Use |
|------|-----|
| [START-HERE.md](START-HERE.md) | Emergency dispatcher — open this first in a crisis |
| [playbooks/cards/summons.md](playbooks/cards/summons.md) | Fill privately, print, wallet. Screenshot only if safe |
| [FIELD-INDEX.md](FIELD-INDEX.md) | Short file-level index of the whole repo |
| [USAGE.md](USAGE.md) | Scenario-based library usage |
| [DOWNLOADS.md](DOWNLOADS.md) | Optional large downloads |
| [AGENTS.md](AGENTS.md) | Contract for AI agents working in this repo |

Helper scripts (in `tools-scripts/`):

- `print-cards.sh` — bundle every emergency card into a printable bundle; PDF when pandoc is installed
- `household-setup.sh` — blank private templates; `--quick` / `--full --summons` ask more
- `get-squared-away.sh` — report what is set up and what is missing
- `verify-all.sh --essential` — deeper verification
- `launch-wikipedia.sh` — open Kiwix with local ZIM files
- `launch-maps.sh` — open maps
- `serve-local-network.sh` — share this repo to a household LAN

## License

Repository structure, scripts, docs, and playbooks are released under [MIT](LICENSE). The books and guides within have their own licenses — primarily US government works (public domain), WHO/UN, and Project Gutenberg. See individual files.
