#!/bin/bash
# Share offline knowledge over your local network.
# Usage: ./serve-local-network.sh [port]
#
# If kiwix-serve is installed, this exposes browsable ZIM content over HTTP.
# Otherwise it falls back to a raw file share so other devices can download the
# ZIM files and open them locally with Kiwix.

PORT="${1:-8888}"
SHTF_DIR="$(cd "$(dirname "$0")/.." && pwd)"

LOCAL_IP=$(ipconfig getifaddr en0 2>/dev/null || ipconfig getifaddr en1 2>/dev/null || echo "localhost")

echo "=== SHTF Local Knowledge Share ==="
echo ""

# Find all ZIM files
ZIMS=$(find "$SHTF_DIR" -name "*.zim" -type f 2>/dev/null)
ZIM_COUNT=$(echo "$ZIMS" | wc -l | tr -d ' ')

echo "Found $ZIM_COUNT ZIM files:"
echo "$ZIMS" | while read f; do
    SIZE=$(ls -lh "$f" 2>/dev/null | awk '{print $5}')
    NAME=$(basename "$f" .zim)
    printf "  %-50s %s\n" "$NAME" "$SIZE"
done

echo ""

# Method 1: Try kiwix-serve if available
if command -v kiwix-serve &>/dev/null; then
    echo "Starting kiwix-serve on port $PORT..."
    echo ""
    echo "Access from this Mac:    http://localhost:$PORT"
    echo "Access from any device:  http://$LOCAL_IP:$PORT"
    echo ""
    echo "Share this URL with phones/tablets on the same WiFi network."
    echo "Press Ctrl+C to stop."
    # shellcheck disable=SC2086
    kiwix-serve --port "$PORT" $ZIMS
    exit 0
fi

# Method 2: raw file share only
echo "kiwix-serve not available. Starting raw file share over HTTP..."
echo ""
echo "This mode shares the raw ZIM files only; it does not provide browsable Wikipedia pages."
echo "On other devices: install Kiwix, then download ZIMs from this server and open them locally."
echo ""
echo "File server: http://$LOCAL_IP:$PORT"
echo "Press Ctrl+C to stop."
echo ""

# Create a temporary directory with symlinks to all ZIMs for clean serving
SERVE_DIR=$(mktemp -d)
trap "rm -rf $SERVE_DIR" EXIT

echo "$ZIMS" | while read f; do
    ln -s "$f" "$SERVE_DIR/$(basename "$f")" 2>/dev/null
done

cd "$SERVE_DIR"
python3 -m http.server "$PORT" --bind 0.0.0.0
