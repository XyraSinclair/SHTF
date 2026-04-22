# Downloading Large Resources

These files are too large for GitHub but are freely available. You'll need **Kiwix** to view ZIM files (download from [kiwix.org](https://kiwix.org)).

## Wikipedia & Encyclopedias (~136 GB)

Download ZIM files from [library.kiwix.org](https://library.kiwix.org/) and place them in `wikipedia/`:

| File | Size | Download |
|------|------|----------|
| English Wikipedia (full, with images) | 111 GB | [library.kiwix.org](https://library.kiwix.org/) - search "wikipedia en all maxi" |
| Spanish Wikipedia (no images) | 9.2 GB | search "wikipedia es all nopic" |
| English Wikibooks | 5.1 GB | search "wikibooks en all maxi" |
| English Wiktionary | 8.2 GB | search "wiktionary en all nopic" |
| Wikivoyage | 1.1 GB | search "wikivoyage en all maxi" |
| Spanish Wiktionary | — | search "wiktionary es all nopic" |

**Curated topic ZIMs** (also on library.kiwix.org, search "zimgit"):
- `zimgit-post-disaster_en` (615 MB) - Post-disaster recovery
- `zimgit-food-preparation_en` (93 MB) - Food preparation
- `zimgit-medicine_en` (67 MB) - Medical reference
- `zimgit-knots_en` (27 MB) - Knot tying
- `zimgit-water_en` (20 MB) - Water purification

## Stack Overflow & Stack Exchange (~85 GB)

Download from [library.kiwix.org](https://library.kiwix.org/) and place in `reference/`:

| File | Size | Search term |
|------|------|-------------|
| Stack Overflow | 75 GB | "stackoverflow en all" |
| Electronics SE | 3.9 GB | "electronics.stackexchange" |
| DIY SE | 1.9 GB | "diy.stackexchange" |
| Physics SE | 1.7 GB | "physics.stackexchange" |
| Gardening SE | 882 MB | "gardening.stackexchange" |
| Biology SE | 403 MB | "biology.stackexchange" |
| Chemistry SE | 397 MB | "chemistry.stackexchange" |
| Mechanics SE | 323 MB | "mechanics.stackexchange" |
| Engineering SE | 242 MB | "engineering.stackexchange" |
| Cooking SE | 226 MB | "cooking.stackexchange" |
| Outdoors SE | 136 MB | "outdoors.stackexchange" |
| Woodworking SE | 100 MB | "woodworking.stackexchange" |
| Ham Radio SE | 72 MB | "ham.stackexchange" |
| Homebrew SE | 36 MB | "homebrew.stackexchange" |
| Sustainability SE | 26 MB | "sustainability.stackexchange" |

**Developer documentation** - place in `reference/devdocs/`:
Search "devdocs" on library.kiwix.org for Bash, C, C++, CSS, Docker, Git, Go, HTML, JavaScript, Linux man pages, Nginx, Node.js, PHP, PostgreSQL, Python, Redis, Ruby, Rust, SQLite.

## Medical Encyclopedia (~10 GB)

Place in `medical/`:

| File | Size | Search term |
|------|------|-------------|
| MDWiki medical encyclopedia | 10 GB | "mdwiki en all" on library.kiwix.org |

## OpenStreetMap Data (~2 GB)

Download from [download.geofabrik.de](https://download.geofabrik.de/north-america/us.html) and place in `maps/`:

```bash
cd maps/
# Download whichever states you need:
wget https://download.geofabrik.de/north-america/us/california-latest.osm.pbf
wget https://download.geofabrik.de/north-america/us/oregon-latest.osm.pbf
wget https://download.geofabrik.de/north-america/us/washington-latest.osm.pbf
wget https://download.geofabrik.de/north-america/us/nevada-latest.osm.pbf
wget https://download.geofabrik.de/north-america/us/arizona-latest.osm.pbf
```

View with [QGIS](https://qgis.org/) or use [Organic Maps](https://organicmaps.app/) on your phone.

## USGS Topographic Maps (~66 GB)

The `maps/topo/` directory includes text files listing download URLs. To download the 1,729 priority topo maps for CA/OR/WA:

```bash
cd maps/topo/
mkdir -p pdfs
# Download using the URL list (requires aria2 for parallel downloads):
aria2c -i ../west_coast_topos_priority.txt -d pdfs/ --max-concurrent-downloads=8
# Or with wget:
wget -P pdfs/ -i ../west_coast_topos_priority.txt
```

These are GeoPDF files showing elevation contours, trails, water features, and terrain. Open with any PDF viewer.

## Local AI: Gemma 4 (recommended)

Gemma 4 is the primary offline-AI path in this repo. Four instruction-tuned models, from a laptop-friendly 2B up through 31B, all runnable locally via llama.cpp.

One command to go from nothing to a working model:

```bash
./tools-scripts/setup-gemma4.sh          # E2B only — the safe starter (~9 GB)
./tools-scripts/setup-gemma4.sh --all    # all four models (~131 GB of checkpoints)
./tools-scripts/setup-gemma4.sh E4B      # pick specific models
```

That script runs, in order: download from Hugging Face → build llama.cpp → convert to GGUF → smoke-test. It prints pass/fail per step and is safe to re-run; completed steps are skipped.

The four models:

| Model | HF repo | Source size | When to pick it |
|-------|---------|-------------|-----------------|
| `E2B` | `google/gemma-4-E2B-it` | ~9 GB | Starter. Works on most laptops. |
| `E4B` | `google/gemma-4-E4B-it` | ~14 GB | Better answers, still modest. |
| `31B` | `google/gemma-4-31B-it` | ~55 GB | Strongest single-model path. Needs headroom. |
| `26B-A4B` | `google/gemma-4-26B-A4B-it` | ~55 GB | MoE variant; ~4B active params per token. |

After setup, use any model:

```bash
./tools-scripts/run-gemma4-llamacpp.sh E2B
./tools-scripts/run-gemma4-llamacpp.sh --list
./tools-scripts/run-gemma4-llamacpp.sh 31B "Give me 10 shelf-stable protein sources."
```

Details and manual workflow: [`docs/local-ai-models.md`](docs/local-ai-models.md) and [`docs/gemma4-llamacpp.md`](docs/gemma4-llamacpp.md).

### Smaller, simpler: Ollama

If you don't need the full Gemma 4 ladder, Ollama is a two-minute setup:

```bash
brew install ollama
ollama pull llama3.2:3b       # ~2 GB - general purpose
ollama pull phi4-mini         # ~2.5 GB - reasoning
ollama pull qwen2.5-coder:3b  # ~2 GB - code help
```

### Heavyweight optional: Kimi K2.5 (~263 GB)

Only if you have the disk, RAM, and a specific reason. Most people should stop at Gemma 4 31B.

```bash
brew install git-lfs && git lfs install
git clone https://huggingface.co/moonshotai/Kimi-K2.5
mv Kimi-K2.5 kimi-k2.5
```

## Extra offline reference — ACID V2 content parity

A common commercial offering ("ACID V2" on Etsy and similar) bundles iFixit, TED,
Khan Academy, Wikispecies, Wikivoyage, Project Gutenberg (~60k books), Appropedia,
zimgit post-disaster, Ready.gov PDFs, FAA aviation handbooks, and public-domain
vehicle-repair manuals. One script pulls any subset of that stack:

```bash
./tools-scripts/download-acid-parity.sh --list            # show all targets
./tools-scripts/download-acid-parity.sh ifixit ready-gov  # pick what you want
./tools-scripts/download-acid-parity.sh all               # the full bundle
```

URLs are resolved from the Kiwix OPDS catalog so the script doesn't rot with
monthly rebuilds. See `docs/acid-v2-parity.md` for the full parity matrix and
rough sizes.

## Video Tutorials (~1.7 GB)

These are not redistributable via GitHub. The download script references for each category:

**Radio (Baofeng UV-5R):**
- Search YouTube for "Baofeng UV-5R beginner tutorial"
- Search "How to program Baofeng UV-5R CHIRP"

**Solar Power:**
- Search YouTube for "DIY off-grid solar system complete guide"
- Search "budget DIY solar power system"

**Knots:**
- Search YouTube for "essential knots for survival"

Use `yt-dlp` to download for offline use:
```bash
brew install yt-dlp
yt-dlp -o 'radio/%(title)s.%(ext)s' '<video-url>'
```
