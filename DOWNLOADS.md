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

## Kimi K2.5 AI Model (~263 GB)

For a local AI assistant, clone the model from HuggingFace:

```bash
# Install git-lfs first
brew install git-lfs
git lfs install

# Clone the model
git clone https://huggingface.co/moonshotai/Kimi-K2.5
mv Kimi-K2.5 kimi-k2.5
```

For a lighter option, use Ollama instead:

```bash
brew install ollama
ollama pull llama3.2:3b       # 2 GB - general purpose
ollama pull phi4-mini          # 2.5 GB - reasoning
ollama pull qwen2.5-coder:3b  # 2 GB - coding
```

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
