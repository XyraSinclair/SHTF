#!/bin/bash
# Launch Kiwix to browse offline Wikipedia, Stack Exchange, and all ZIM files
# Usage: ./launch-wikipedia.sh          (opens Kiwix GUI)
#        ./launch-wikipedia.sh serve     (starts web server for all devices)

SHTF_DIR="$(cd "$(dirname "$0")/.." && pwd)"
LOCAL_IP=$(ipconfig getifaddr en0 2>/dev/null || ipconfig getifaddr en1 2>/dev/null || echo "localhost")

echo "=== Offline Knowledge Base Launcher ==="
echo ""

# Count ZIM files
ZIM_COUNT=$(find "$SHTF_DIR" -name "*.zim" -type f 2>/dev/null | wc -l | tr -d ' ')
echo "Found $ZIM_COUNT ZIM files across:"
echo "  wikipedia/     - Wikipedia, Wikibooks, Wiktionary, Wikivoyage"
echo "  medical/       - MDWiki medical encyclopedia"
echo "  reference/     - Stack Overflow, 14 Stack Exchange sites, DevDocs"
echo ""

if [ "$1" = "serve" ]; then
    PORT="${2:-8888}"
    echo "Starting file server on http://$LOCAL_IP:$PORT"
    echo "Other devices on your network can download ZIM files from this URL."
    echo "They just need the Kiwix app to open them."
    echo "Press Ctrl+C to stop."
    echo ""

    SERVE_DIR=$(mktemp -d)
    trap "rm -rf $SERVE_DIR" EXIT
    find "$SHTF_DIR" -name "*.zim" -type f -exec ln -s {} "$SERVE_DIR/" \; 2>/dev/null
    cd "$SERVE_DIR"
    python3 -m http.server "$PORT" --bind 0.0.0.0
else
    if [ -d "/Applications/Kiwix.app" ]; then
        echo "Opening Kiwix..."
        echo ""
        echo "To load ZIM files:"
        echo "  1. File > Open ZIM File"
        echo "  2. Navigate to ~/Desktop/shtf/wikipedia/ or reference/"
        echo "  3. Select any .zim file and click Open"
        echo ""
        echo "TIP: You can open multiple ZIM files. Use the library tab to switch."
        echo "TIP: For Stack Overflow (75GB), give it a moment to index on first open."
        open "/Applications/Kiwix.app"
    else
        echo "Kiwix app not found. Install with: brew install --cask kiwix"
    fi
fi
