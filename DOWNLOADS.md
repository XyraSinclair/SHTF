# Downloading Large Resources

These files are too large for GitHub but are freely available. You'll need **Kiwix** to view ZIM files (download from [kiwix.org](https://kiwix.org)).

## Budget First

Before downloading anything in this file, understand the difference between the base repo and the optional giant extras.

As of **September 2, 2026**:

- base tracked checkout from GitHub: about **0.9 GB**
- typical local `git clone` + checkout: about **1.6-1.8 GB**
- fully loaded maintainer tree with optional downloads and models: about **974 GB** (measured April 23, 2026)

Fast budgeting:

| What you add | Rough extra disk |
|---|---:|
| Wikipedia / Kiwix bundle | ~136 GB |
| Stack Exchange / reference bundle | ~85 GB |
| Current local map payload | ~69 GB |
| Raw HF `Qwen3.6-27B` | ~52-56 GB |
| Current Ollama `qwen3.6` path | ~17-31 GB |
| Gemma 4 `E2B` retained locally | ~23 GB |
| All four Gemma 4 retained locally | ~303 GB |
| `kimi-k2.5/` local checkout | ~263 GB |

Full breakdown: [`docs/storage-footprint.md`](docs/storage-footprint.md)

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

## Local AI: choose first, then pull

Before downloading a model, run:

```bash
./tools-scripts/choose-local-model.sh
```

That gives a recommendation from this machine's platform, RAM, and free disk. The default day-to-day path is now:

- Apple Silicon with headroom: Ollama + `Qwen3.6` coding variant
- Non-Mac / Intel Mac with headroom: Ollama + `qwen3.6:27b`
- Smaller or more conservative hardware: self-contained `Gemma 4` through the repo scripts

OpenCode and Hermes both work better when Ollama gets a real context window. See `docs/local-ai-models.md` for the platform-specific one-time setup. After that, verify it with:

```bash
ollama ps
```

`ollama ps` lets you verify the loaded split and context length.

## Local AI: Qwen3.6-27B priority raw cache

Qwen3.6-27B is the first high-capability model to cache for SHTF use while the internet is available. It is a public Apache-2.0 Hugging Face checkpoint, roughly 52-56 GB on disk.

```bash
./tools-scripts/download-qwen36-27b.py
```

The script downloads to `models/Qwen3.6-27B/`, verifies the expected core files and 15 safetensor shards, and is safe to interrupt and rerun. Serving is hardware-dependent; see [`docs/qwen36-27b.md`](docs/qwen36-27b.md).

## Local AI: current Ollama path

If you want the least-friction current local model path, use Ollama:

```bash
# Apple Silicon defaults
ollama pull qwen3.6:27b-coding-nvfp4
# or, bigger/fancier Apple Silicon option
ollama pull qwen3.6:27b-coding-mxfp8

# Cross-platform default
ollama pull qwen3.6:27b
```

Use the chooser to decide which one is sane for the machine in front of you.
If you also want OpenCode in this repo to default to the same pulled model, run:

```bash
python3 ./tools-scripts/set-opencode-model.py shtf-ollama/qwen3.6-27b
```

Replace the model id with the Apple Silicon tag the chooser recommended if needed.

## Local AI: Gemma 4 validated fallback

Gemma 4 is the validated repo-local runtime path in this repo. Four instruction-tuned models, from a laptop-friendly 2B up through 31B, all runnable locally via llama.cpp.

Important: the real disk budget is not just the checkpoint download. The current workflow keeps both the source checkpoint and the converted GGUF output.

One command to go from nothing to a working model:

```bash
./tools-scripts/setup-gemma4.sh          # E2B only — the safe starter (~9 GB)
./tools-scripts/setup-gemma4.sh --all    # all four models (~131 GB of checkpoints)
./tools-scripts/setup-gemma4.sh E4B      # pick specific models
```

That script runs, in order: download from Hugging Face → build llama.cpp → convert to GGUF → smoke-test. It prints pass/fail per step and is safe to re-run; completed steps are skipped.

The four models:

| Model | HF repo | Source | BF16 GGUF retained | Rough retained total |
|-------|---------|-------:|-------------------:|---------------------:|
| `E2B` | `google/gemma-4-E2B-it` | ~9.6 GB | ~13 GB | ~23 GB |
| `E4B` | `google/gemma-4-E4B-it` | ~15 GB | ~20 GB | ~35 GB |
| `31B` | `google/gemma-4-31B-it` | ~58 GB | ~76 GB | ~134 GB |
| `26B-A4B` | `google/gemma-4-26B-A4B-it` | ~48 GB | ~64 GB | ~112 GB |

If you retain all four current source checkpoints and BF16 GGUF outputs, budget about **303 GB** total before extra quantizations.

After setup, use any model:

```bash
./tools-scripts/run-gemma4-llamacpp.sh E2B
./tools-scripts/run-gemma4-llamacpp.sh --list
./tools-scripts/run-gemma4-llamacpp.sh 31B "Give me 10 shelf-stable protein sources."
```

Details and manual workflow: [`docs/local-ai-models.md`](docs/local-ai-models.md) and [`docs/gemma4-llamacpp.md`](docs/gemma4-llamacpp.md).

### Smaller, simpler: tiny Ollama fallback

If the machine is too small for the main Qwen or Gemma paths:

```bash
ollama pull qwen2.5-coder:3b  # ~2 GB - code help
```

### Heavyweight optional: Kimi K2.5 (~263 GB)

Only if you have the disk, RAM, and a specific reason. Most people should cache Qwen3.6-27B, then use Gemma 4 for the validated llama.cpp path.

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
