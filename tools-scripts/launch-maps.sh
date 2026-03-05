#!/bin/bash
# Launch QGIS for viewing offline OpenStreetMap data
# Usage: ./launch-maps.sh              (opens QGIS)
#        ./launch-maps.sh topo          (opens a random topo map in Preview)
#        ./launch-maps.sh topo <name>   (search topo maps by name)

SHTF_DIR="$(cd "$(dirname "$0")/.." && pwd)"

case "$1" in
    topo)
        if [ -n "$2" ]; then
            echo "Searching topo maps for '$2'..."
            RESULTS=$(find "$SHTF_DIR/maps/topo/pdfs" -name "*${2}*" -type f 2>/dev/null)
            if [ -z "$RESULTS" ]; then
                echo "No topo maps found matching '$2'"
                echo "Available maps:"
                ls "$SHTF_DIR/maps/topo/pdfs/" | sed 's/.pdf$//' | head -20
                echo "... ($(ls "$SHTF_DIR/maps/topo/pdfs/" | wc -l | tr -d ' ') total)"
            else
                echo "$RESULTS"
                echo ""
                echo "Opening first match..."
                open "$(echo "$RESULTS" | head -1)"
            fi
        else
            echo "=== USGS Topo Maps ==="
            echo "$(ls "$SHTF_DIR/maps/topo/pdfs/"*.pdf 2>/dev/null | wc -l | tr -d ' ') topo maps available"
            echo ""
            echo "Usage: $0 topo <search_term>"
            echo "Example: $0 topo Seattle"
            echo "Example: $0 topo Portland"
            echo "Example: $0 topo San_Francisco"
            echo ""
            echo "States covered: CA, OR, WA"
            echo "Browse all: open $SHTF_DIR/maps/topo/pdfs/"
        fi
        ;;
    *)
        echo "=== Offline Maps Launcher ==="
        echo ""
        echo "OpenStreetMap data files:"
        for f in "$SHTF_DIR"/maps/*.osm.pbf; do
            [ -f "$f" ] && printf "  %-40s %s\n" "$(basename "$f")" "$(du -h "$f" | cut -f1)"
        done
        echo ""
        echo "USGS Topo Maps: $(ls "$SHTF_DIR/maps/topo/pdfs/"*.pdf 2>/dev/null | wc -l | tr -d ' ') maps"
        echo ""

        if [ -d "/Applications/QGIS.app" ]; then
            echo "Opening QGIS..."
            echo ""
            echo "To load a map in QGIS:"
            echo "  1. Layer > Add Layer > Add Vector Layer"
            echo "  2. Browse to ~/Desktop/shtf/maps/"
            echo "  3. Select any .osm.pbf file"
            echo "  4. Click Add"
            echo ""
            echo "For topo maps: $0 topo <search_term>"
            open "/Applications/QGIS.app"
        else
            echo "QGIS not found. Install with: brew install --cask qgis"
            echo ""
            echo "Alternative: Use Organic Maps on your phone (App Store)"
            echo "Alternative: Open topo maps with: open ~/Desktop/shtf/maps/topo/pdfs/any_map.pdf"
        fi
        ;;
esac
