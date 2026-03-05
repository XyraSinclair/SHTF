# SHTF Offline Survival Resource Kit

A curated collection of offline survival, medical, and preparedness resources for when infrastructure goes down. Everything works without internet access.

## Kindle-Ready Library (drag straight to your Kindle)

The `kindle-ready/` folder contains **115+ books** in EPUB and PDF format, organized by category and ready to drag directly onto a Kindle. Files are prefixed by category so they sort nicely:

| Prefix | Category | What's Inside |
|--------|----------|---------------|
| `01-Medical` | Medical | Where There Is No Doctor/Dentist, WHO surgical & medicines guides, first aid |
| `02-Survival` | Survival | US Army field manuals, FEMA guides, nuclear survival, knots, trapping, woodcraft |
| `03-Food-Water` | Food & Water | Gardening, seed saving, beekeeping, food preservation, water purification, foraging |
| `04-Herbal-Medicine` | Herbal Medicine | Culpeper's Complete Herbal, WHO medicinal plant monographs |
| `05-Radio-Comms` | Radio & Comms | Baofeng UV-5R guides, ARRL emergency comms, CHIRP programming |
| `06-Power-Solar` | Power & Solar | Off-grid solar, wind power, biogas, solar cookers |
| `07-Sanitation` | Sanitation | Emergency hygiene, composting toilets, WASH guidelines |
| `08-Mechanical` | Mechanical | Engine repair, soap making, weaving, tanning, hydro power |
| `09-Navigation` | Navigation | Celestial navigation with sextant |
| `10-Construction` | Construction | Carpentry, woodworking, FEMA safe rooms, shelter construction |

**To load onto Kindle:** Connect your Kindle via USB, then drag files from `kindle-ready/` into the Kindle's `documents` folder. All files are flat (no subfolders) so they transfer directly.

Sources include US government publications (public domain), WHO/UN freely distributed guides, Peace Corps manuals, and Project Gutenberg public domain books. Run `tools-scripts/download-kindle-content.sh` to re-download or update everything.

## Other Resources (included in repo)

| Folder | Contents |
|--------|----------|
| `survival-guides/` | PDFs of field manuals, water purification, nuclear survival, sanitation |
| `food-water/` | USDA canning guide, foraging guides, seed saving, food preservation |
| `herbal-medicine/` | Complete Herbalist (1897), WHO medicinal plant monographs |
| `medical/` | Where There Is No Doctor/Dentist (full PDFs), women's health |
| `radio/` | Baofeng manuals, ARRL emergency comms, NOAA frequencies |
| `power-electrical/` | NREL off-grid solar guide |
| `sanitation/` | WASH emergency guidelines, CDC hygiene, sanitation guides |
| `mechanical/` | Small engine repair manuals |
| `navigation/` | Celestial navigation guides |
| `construction/` | Shelter construction techniques |
| `tools-scripts/` | Helper scripts for downloading, launching, and verifying resources |

## Large Downloads (not in repo)

Some resources are too large for GitHub. See **[DOWNLOADS.md](DOWNLOADS.md)** for instructions on obtaining:

- **Wikipedia offline** (~136 GB) - Full English Wikipedia, Wikibooks, Wiktionary, and more via Kiwix ZIM files
- **Stack Overflow & Stack Exchange** (~85 GB) - Programming and practical Q&A archives
- **Medical encyclopedia** (~10 GB) - MDWiki for Kiwix
- **OpenStreetMap data** (~2 GB) - West coast US states
- **USGS topographic maps** (~66 GB) - 1,729 GeoPDF topo maps for CA/OR/WA
- **AI model** (~263 GB) - Kimi K2.5 for local AI assistant
- **Video tutorials** (~1.7 GB) - Baofeng radio, solar power, knot tying

## Quick Start

See `INDEX.txt` for detailed usage instructions covering:
- Offline Wikipedia/encyclopedia browsing with Kiwix
- Local AI assistant via Ollama
- Offline maps with QGIS or Organic Maps
- Radio programming and emergency frequencies
- And more

## Tools & Scripts

| Script | Purpose |
|--------|---------|
| `tools-scripts/download-kindle-content.sh` | Download/update all Kindle-ready content |
| `tools-scripts/kindle-prep.py` | Convert source PDFs to EPUB for Kindle |
| `tools-scripts/launch-wikipedia.sh` | Open Kiwix with all ZIM files |
| `tools-scripts/launch-maps.sh` | Launch map viewer |
| `tools-scripts/serve-local-network.sh` | Serve resources on local network |
| `tools-scripts/pull-all-models.sh` | Pull/update Ollama AI models |
| `tools-scripts/download-remaining.sh` | Resume interrupted large downloads |
| `tools-scripts/verify-all.sh` | Verify all downloads are complete |
