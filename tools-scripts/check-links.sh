#!/bin/bash
# Check every download URL in the scripts and key docs for link rot.
# Operational tool, not a test: run it before relying on the download scripts.
# Usage: ./tools-scripts/check-links.sh [file ...]   (defaults to the download
# scripts, README.md, DOWNLOADS.md, and USAGE.md)

SHTF_DIR="$(cd "$(dirname "$0")/.." && pwd)"
UA="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0 Safari/537.36"
FILES=("$@")
[ ${#FILES[@]} -eq 0 ] && FILES=(
    "$SHTF_DIR/tools-scripts/download-kindle-content.sh"
    "$SHTF_DIR/tools-scripts/download-remaining.sh"
    "$SHTF_DIR/tools-scripts/download-acid-parity.sh"
    "$SHTF_DIR/README.md"
    "$SHTF_DIR/DOWNLOADS.md"
    "$SHTF_DIR/USAGE.md"
)

dead=0 alive=0
for url in $(grep -hoE 'https?://[^"<>()\\ ]+' "${FILES[@]}" | sed 's/[.,)*`]*$//' | grep -v '\\\\' | sort -u); do
    # web.archive.org rate-limits aggressively; pace requests to it.
    case "$url" in https://web.archive.org/*) sleep 10 ;; esac
    code=$(curl -sIL -A "$UA" --connect-timeout 12 --max-time 30 -o /dev/null -w "%{http_code}" "$url")
    # Some hosts refuse HEAD; retry those with a 1-byte GET before calling them dead.
    case "$code" in
        403|405|000) code=$(curl -sL -A "$UA" --connect-timeout 12 --max-time 30 -r 0-0 -o /dev/null -w "%{http_code}" "$url") ;;
    esac
    case "$code" in
        2*|3*) alive=$((alive+1)) ;;
        *) dead=$((dead+1)); echo "DEAD $code  $url" ;;
    esac
done

echo
echo "Checked $((alive+dead)) URLs: $alive alive, $dead dead."
[ "$dead" -eq 0 ]
