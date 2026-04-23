# Usage Guide

How to use each resource in this kit. Everything works offline.

For the fastest path:
- `./tools-scripts/build-envelope.sh` — **the one thing**: generate the print-once manila envelope
- [playbooks/cards/tonight.md](playbooks/cards/tonight.md) — eight things to do before bed (no printer needed)
- `./tools-scripts/get-squared-away.sh` — canonical bootstrap report
- [START-HERE.md](START-HERE.md) — three doors: emergency / tonight / full kit
- [playbooks/README.md](playbooks/README.md) — runbooks and frameworks
- [FIELD-INDEX.md](FIELD-INDEX.md) — file index
- `./tools-scripts/verify-all.sh --essential` — what's ready now
- `./tools-scripts/print-cards.sh` — full deck of printable emergency cards (not just the envelope)

Optional worksheet: `./tools-scripts/household-setup.sh` writes blank private templates without asking questions.

## Layers: playbook, then library

The repo has two layers. The playbook is what you **start from**. The library is what you **read when you need a number or detail**.

1. **Playbook first**: open [`playbooks/`](playbooks/). Scenario runbooks, tier-1 prep, decision frameworks, printable cards.
2. **Library second**: the PDFs, Kindle books, and ZIMs below back the playbook up with specifics.

Treat every checklist as a default to adapt. Your plan changes with disability, medical dependence, pregnancy, kids, elders, pets, language, budget, housing, vehicle access, climate, local law, and official local instructions.

## Use by problem, not by folder

### I need medical help
- Card: [playbooks/cards/first-aid.md](playbooks/cards/first-aid.md) + [playbooks/cards/stop-the-bleed.md](playbooks/cards/stop-the-bleed.md)
- Framework: [playbooks/frameworks/triage.md](playbooks/frameworks/triage.md)
- Reference: `medical/Where_There_Is_No_Doctor_FULL.pdf`
- First aid manual: `survival-guides/FM4-25.11_First_Aid_Manual.pdf`
- Dental: `medical/Where_There_Is_No_Dentist_FULL.pdf`
- Full offline medical: Kiwix with `medical/mdwiki_en_all_2025-11.zim`

### I need safe water and sanitation
- Card: [playbooks/cards/water-purification.md](playbooks/cards/water-purification.md)
- Reference: `survival-guides/Emergency_Water_Purification_Guide.pdf`
- Reference: `survival-guides/Water_Purification_Methods.pdf`
- Sanitation: `survival-guides/sanitation/Emergency_Toilet_Guidebook.pdf`
- Sanitation: `survival-guides/FM21-10_Field_Hygiene_Sanitation.pdf`

### I need radio/comms
- Card: [playbooks/cards/radio-frequencies.md](playbooks/cards/radio-frequencies.md)
- Quick ref: `radio/UV-5R_Quick_Reference_Card.pdf`
- Programming: `radio/UV-5R_Programming_Cheat_Sheet.pdf`
- Programming: `radio/Baofeng_UV-5R_Programming_Guide.pdf`
- Emergency nets: `radio/ARRL_ARES_Field_Resources_Manual.pdf`

### I need maps/navigation
- Open `survival-guides/FM3-25.26_Map_Reading_Land_Navigation.pdf`
- Run `./tools-scripts/launch-maps.sh`
- Search topo maps with `./tools-scripts/launch-maps.sh topo <place>`

### I need food preservation or foraging
- Open `food-water/USDA_Complete_Guide_Home_Canning_2015.pdf`
- Open `food-water/Washington_State_Foraging_Guide.pdf`
- Open `food-water/Seed_Saving_Guide.pdf`

### I need broad offline reference search
- Run `./tools-scripts/launch-wikipedia.sh`
- If you want LAN access to raw files or Kiwix-served ZIMs, run `./tools-scripts/serve-local-network.sh`

## Kindle Books

Connect your Kindle via USB. Drag files from `kindle-ready/` into the Kindle's `documents` folder. Done. Files are flat (no subfolders) so they transfer directly.

To rebuild the library from source URLs:
```bash
./tools-scripts/download-kindle-content.sh
```

To convert new PDFs to Kindle-friendly EPUBs (requires calibre):
```bash
pip install pymupdf
python tools-scripts/kindle-prep.py
```

## Wikipedia & Encyclopedias (requires download)

1. Install [Kiwix](https://kiwix.org) (or `brew install --cask kiwix` on Mac)
2. Download ZIM files per [DOWNLOADS.md](DOWNLOADS.md) into `wikipedia/`
3. Open Kiwix > File > Open ZIM File > select any `.zim` file
4. Browse and search just like the real Wikipedia

All ZIM files use Kiwix: Wikipedia, Wikibooks, Stack Exchange sites, DevDocs, and the medical encyclopedia.

## Local AI Assistant

Start here:

```bash
./tools-scripts/choose-local-model.sh
```

That script looks at platform, RAM, and free disk, then gives the least-bad local-model answer for the machine in front of you. On capable Apple Silicon Macs it steers toward current `Qwen3.6` models in Ollama. On smaller or more conservative setups it steers toward the validated `Gemma 4` repo-local path.

Treat the chooser as the real entry point. It decides whether this machine should use the current Ollama + `Qwen3.6` lane, the self-contained `Gemma 4` repo-local path, or only a small emergency fallback.

Use it for summaries, rough planning estimates, how-to help, and navigation through the local library. Verify arithmetic yourself or with a calculator. Do not treat any local model as a medical authority; use the medical sources and clinicians when available.

For detailed manual paths, Qwen serving notes, the Gemma four-model ladder (E2B -> E4B -> 31B -> 26B-A4B), and platform-specific Ollama context setup, read `docs/local-ai-models.md`, `docs/qwen36-27b.md`, and `docs/gemma4-llamacpp.md`.

## Maps (requires download)

**Desktop:** Install [QGIS](https://qgis.org) (`brew install --cask qgis`), open `.osm.pbf` files from `maps/`.

**Phone:** Install [Organic Maps](https://organicmaps.app/) and download regions while you still have internet.

**USGS Topo Maps:** Open the GeoPDF files in `maps/topo/pdfs/` with any PDF viewer. These show elevation contours, trails, water features, and terrain detail.

## Medical Reference

Priority reading: **Where There Is No Doctor** -- a broad primary-care reference for low-resource settings. Use it as a sourcebook when professional medical help is unavailable or delayed.

Also available: dental care guide, women's health guide, WHO surgical manual, and the full MDWiki medical encyclopedia (via Kiwix).

## Radio Communications

Program your Baofeng UV-5R using the guides in `kindle-ready/` (search for `05-Radio-Comms`).

**Key emergency frequencies:**
| Frequency | Use |
|-----------|-----|
| 146.520 MHz | 2m calling frequency (ham) |
| 446.000 MHz | 70cm calling frequency (ham) |
| 156.800 MHz | Marine Channel 16 - distress |
| 462.5625 MHz | FRS Channel 1 |

**NOAA Weather Radio:** 162.400, 162.425, 162.450, 162.475, 162.500, 162.525, 162.550 MHz. See `radio/NOAA_Weather_Radio_Frequencies_West_Coast.txt` for station-specific details.

## Food & Water

- **Canning:** USDA Complete Guide to Home Canning is the primary reference
- **Foraging:** Washington State guide has plant photos for PNW identification
- **Seeds:** Multiple seed saving guides cover harvest, storage, and replanting
- **Preservation:** Dehydration, smoking, and raw food preservation methods
- **Water:** Purification guides covering boiling, chemical treatment, solar disinfection, and filtration

## Solar & Power

Start with the NREL off-grid guide for system sizing and installation. The DOE Small Wind Guidebook covers wind power basics. FAO Biogas Training Manual covers methane generation from waste.

## What to Download on Your Phone

While you still have internet access:

1. **Organic Maps** - download your state/region for offline navigation
2. **Kiwix** - download a Wikipedia ZIM for mobile reference
3. **First Aid** by American Red Cross
4. **Signal** - encrypted messaging if cell networks are degraded but functional
5. **A notes or files app with offline copies** of your emergency PDFs, IDs, insurance, and contact card
