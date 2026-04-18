# SHTF: Offline Survival Kit

If the grid goes down, the internet disappears, and you're on your own — this is what you want on your hard drive, in your head, and on your Kindle.

Two halves:

1. **Playbooks** — what you actually do. One-weekend prep, scenario runbooks, decision frameworks, print-ready emergency cards. Start here.
2. **Library** — the authoritative references the playbooks point into. Military field manuals, WHO medical handbooks, canning guides, radio references. 144 Kindle-ready books plus source PDFs.

Everything is sourced from US government publications (public domain), WHO/UN freely distributed guides, Peace Corps manuals, Project Gutenberg, and FEMA / CDC / NOAA / FCC guidance.

## Start here in one command

```bash
./tools-scripts/get-squared-away.sh
```

Then, in order:

```bash
# Personal walkthrough → produces a custom checklist for your household
./tools-scripts/household-setup.sh

# Bundle the emergency reference cards into a single printable PDF
./tools-scripts/print-cards.sh
```

For an AI agent entering cold, use `--json`:

```bash
./tools-scripts/get-squared-away.sh --json
```

## The playbooks (new — read these first)

Live under [`playbooks/`](playbooks/). Four parts:

### Tier-1 setup — the one-weekend foundation

Build once. Review every 6 months. See [`playbooks/tier-1-setup/00-first-weekend.md`](playbooks/tier-1-setup/00-first-weekend.md).

1. [Household roster](playbooks/tier-1-setup/01-household-roster.md)
2. [Go-bag per person](playbooks/tier-1-setup/02-go-bag.md)
3. [14-day water + food stockpile](playbooks/tier-1-setup/03-water-food-stockpile.md)
4. [Cash + documents](playbooks/tier-1-setup/04-cash-and-documents.md)
5. [Family communications plan](playbooks/tier-1-setup/05-family-comms-plan.md)
6. [Digital hardening](playbooks/tier-1-setup/06-digital-hardening.md) (password managers, 2FA, backups, SIM-swap protection)

### Scenario playbooks — what to do when

- [01. House fire](playbooks/scenarios/01-house-fire.md) — the most likely real emergency
- [02. Severe weather](playbooks/scenarios/02-severe-weather.md) — hurricane, tornado, blizzard, heat dome, flood, ice storm, lightning, dust storm
- [03. Earthquake (Cascadia focus)](playbooks/scenarios/03-earthquake-cascadia.md)
- [04. Wildfire evacuation](playbooks/scenarios/04-wildfire-evacuation.md)
- [05. Extended grid-down](playbooks/scenarios/05-grid-down-extended.md)
- [06. Pandemic](playbooks/scenarios/06-pandemic.md)
- [07. Cyber collapse](playbooks/scenarios/07-cyber-collapse.md) (reactive — see digital hardening for preventive)
- [08. Nuclear](playbooks/scenarios/08-nuclear.md) — distant fallout, near airburst, dirty bomb, reactor accident
- [09. Civil unrest / bug-in](playbooks/scenarios/09-civil-unrest-bug-in.md)
- [10. Stranded or lost](playbooks/scenarios/10-stranded-or-lost.md)

### Decision frameworks — the judgment calls that matter more than gear

- [Stay or go](playbooks/frameworks/stay-or-go.md) — single most important call
- [Triage](playbooks/frameworks/triage.md) — medical, resource, psychological
- [Signalling & rescue](playbooks/frameworks/signalling-and-rescue.md)
- [Myths that kill](playbooks/frameworks/myths-that-kill.md) — common bad advice to unlearn

### Emergency cards — one page each, print and laminate

[`playbooks/cards/`](playbooks/cards/). Bundle to PDF with `tools-scripts/print-cards.sh`.

- First aid · Stop the bleed · Water purification · Radiation shelter · Radio frequencies · Family comms (fill in)

## The library (what the playbooks point into)

### Kindle-ready (144 books, drag-and-drop)

`kindle-ready/` is flattened so you can drop it straight onto a Kindle via USB. Files are category-prefixed so they sort together.

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

### Source PDFs, offline wikis, local AI

Also in-repo: original source PDFs by topic (`medical/`, `survival-guides/`, `food-water/`, `radio/`, `power-electrical/`, `maps/`), NOAA radio frequency sheets, Gemma 4 source checkpoints (`models/gemma-4/`), plus a practical local-AI stack. See [USAGE.md](USAGE.md) for scenario-based instructions and [docs/local-ai-models.md](docs/local-ai-models.md) for model selection.

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

## Surfaces to know

- [START-HERE.md](START-HERE.md) — fast problem → open-this-file map
- [FIELD-INDEX.md](FIELD-INDEX.md) — short file-level index
- [USAGE.md](USAGE.md) — scenario-based usage of the library
- [DOWNLOADS.md](DOWNLOADS.md) — the optional large downloads
- [AGENTS.md](AGENTS.md) — contract for AI agents

Helper scripts:

- `tools-scripts/verify-all.sh --essential` — what's ready right now
- `tools-scripts/launch-wikipedia.sh` — open Kiwix with local ZIM files
- `tools-scripts/launch-maps.sh` — open maps
- `tools-scripts/serve-local-network.sh` — share reference to a household LAN
- `tools-scripts/household-setup.sh` — build your personal checklist
- `tools-scripts/print-cards.sh` — bundle emergency cards to PDF

## License

Repository structure, scripts, docs, and playbooks are released under [MIT](LICENSE). The books and guides within have their own licenses — primarily US government works (public domain), WHO/UN, and Project Gutenberg. See individual files.
