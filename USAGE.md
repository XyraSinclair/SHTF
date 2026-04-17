# Usage Guide

How to use each resource in this kit. Everything works offline.

For the fastest path:
- ./tools-scripts/get-squared-away.sh
- START-HERE.md
- FIELD-INDEX.md
- ./tools-scripts/verify-all.sh --essential

## Use by problem, not by folder

### I need medical help
- Open `medical/Where_There_Is_No_Doctor_FULL.pdf`
- Then open `survival-guides/FM4-25.11_First_Aid_Manual.pdf`
- For dental issues, open `medical/Where_There_Is_No_Dentist_FULL.pdf`
- For larger offline medical reference, use Kiwix with `medical/mdwiki_en_all_2025-11.zim`

### I need safe water and sanitation
- Open `survival-guides/Emergency_Water_Purification_Guide.pdf`
- Open `survival-guides/Water_Purification_Methods.pdf`
- Open `survival-guides/sanitation/Emergency_Toilet_Guidebook.pdf`
- Open `survival-guides/FM21-10_Field_Hygiene_Sanitation.pdf`

### I need radio/comms
- Open `radio/UV-5R_Quick_Reference_Card.pdf`
- Open `radio/UV-5R_Programming_Cheat_Sheet.pdf`
- Open `radio/Baofeng_UV-5R_Programming_Guide.pdf`
- Open `radio/ARRL_ARES_Field_Resources_Manual.pdf`

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

### Fastest path: small Ollama models

```bash
brew install ollama
ollama pull llama3.2:3b          # 2 GB - general purpose
ollama run llama3.2:3b           # start chatting

# Other useful models:
ollama pull phi4-mini            # 2.5 GB - reasoning
ollama pull qwen2.5-coder:3b     # 2 GB - coding help
```

Works completely offline. Ask it medical questions, how-to, calculations, or general reference questions.

### Gemma 4 in this repo

The four Gemma 4 source checkpoints live under `models/gemma-4/`.

Native Apple Silicon smoke test:

```bash
uv run tools-scripts/test-gemma4-models.py
```

llama.cpp workflow:

```bash
./tools-scripts/build-llama-cpp-gemma4.sh --update
./tools-scripts/convert-gemma4-to-gguf.sh E2B
./tools-scripts/audit-gemma4-artifacts.py
./tools-scripts/test-gemma4-llamacpp.py E2B
./tools-scripts/run-gemma4-llamacpp.sh E2B
```

Use `E2B` as the first model unless you already know you want a bigger checkpoint. BF16 is the canonical default; quantization is optional.

For the full model ladder, practical hardware guidance, and manual/server examples, read `docs/local-ai-models.md` and `docs/gemma4-llamacpp.md`.

## Maps (requires download)

**Desktop:** Install [QGIS](https://qgis.org) (`brew install --cask qgis`), open `.osm.pbf` files from `maps/`.

**Phone:** Install [Organic Maps](https://organicmaps.app/) and download regions while you still have internet.

**USGS Topo Maps:** Open the GeoPDF files in `maps/topo/pdfs/` with any PDF viewer. These show elevation contours, trails, water features, and terrain detail.

## Medical Reference

Priority reading: **Where There Is No Doctor** -- the definitive village healthcare handbook. Covers diagnosis, treatment, medications, childbirth, and preventive care when professional medical help isn't available.

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

- **Canning:** USDA Complete Guide to Home Canning is the gold standard
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
5. **Merlin Bird ID** - offline wildlife identification
6. **PlantNet** - offline plant identification
