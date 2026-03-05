#!/bin/bash
# Download any remaining large files that may not have completed
# Safe to re-run - wget --continue will skip completed files

SHTF_DIR="$(cd "$(dirname "$0")/.." && pwd)"
set -e

echo "=== Downloading/Resuming SHTF Resources ==="

# Wikipedia (full English with images - 111GB)
echo ""
echo ">>> Wikipedia (111GB) - this is the big one"
cd "$SHTF_DIR/wikipedia"
wget --continue -q --show-progress \
    "https://download.kiwix.org/zim/wikipedia/wikipedia_en_all_maxi_2025-08.zim" \
    -O "wikipedia_en_all_maxi_2025-08.zim" || true

# Wikibooks
echo ""
echo ">>> Wikibooks (5.1GB)"
wget --continue -q --show-progress \
    "https://download.kiwix.org/zim/wikibooks/wikibooks_en_all_maxi_2026-01.zim" \
    -O "wikibooks_en_all_maxi_2026-01.zim" || true

# Wikivoyage
echo ""
echo ">>> Wikivoyage (1.1GB)"
wget --continue -q --show-progress \
    "https://download.kiwix.org/zim/wikivoyage/wikivoyage_en_all_maxi_2025-12.zim" \
    -O "wikivoyage_en_all_maxi_2025-12.zim" || true

# MDWiki medical encyclopedia
echo ""
echo ">>> MDWiki Medical Encyclopedia (10GB)"
cd "$SHTF_DIR/medical"
wget --continue -q --show-progress \
    "https://download.kiwix.org/zim/other/mdwiki_en_all_2025-11.zim" \
    -O "mdwiki_en_all_2025-11.zim" || true

# Maps
echo ""
echo ">>> OpenStreetMap data for West Coast"
cd "$SHTF_DIR/maps"
for state in california oregon washington nevada arizona; do
    echo "  - $state"
    wget --continue -q --show-progress \
        "https://download.geofabrik.de/north-america/us/${state}-latest.osm.pbf" || true
done

echo ""
echo "=== Download check complete ==="
echo ""
echo "Disk usage:"
du -sh "$SHTF_DIR"/*
