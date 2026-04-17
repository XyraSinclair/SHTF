#!/bin/bash
# Bundle playbooks/cards/ into a single printable PDF.
# Uses pandoc if available; otherwise emits a bundled markdown and prints instructions.

set -euo pipefail

SHTF_DIR="$(cd "$(dirname "$0")/.." && pwd)"
CARDS_DIR="$SHTF_DIR/playbooks/cards"
OUT_DIR="$SHTF_DIR/playbooks/cards/.build"
PDF_OUT="$OUT_DIR/shtf-cards.pdf"
MD_OUT="$OUT_DIR/shtf-cards.md"

if [ ! -d "$CARDS_DIR" ]; then
    echo "Cards directory not found at $CARDS_DIR" >&2
    exit 1
fi

mkdir -p "$OUT_DIR"

# Build a single bundled markdown file in a deterministic order.
# Put first-aid first since it is the most-used card.
CARD_ORDER=(
    "first-aid.md"
    "stop-the-bleed.md"
    "water-purification.md"
    "radiation-shelter.md"
    "radio-frequencies.md"
    "family-comms.md"
)

echo "Bundling cards in $CARDS_DIR ..."

{
    echo "---"
    echo "title: SHTF Emergency Cards"
    echo "date: $(date +%Y-%m-%d)"
    echo "---"
    echo ""
    for card in "${CARD_ORDER[@]}"; do
        if [ -f "$CARDS_DIR/$card" ]; then
            # Skip the front-matter separator lines when bundling, but keep the heading.
            cat "$CARDS_DIR/$card"
            printf '\n\n\\newpage\n\n'
        else
            echo "Warning: $card not found, skipping" >&2
        fi
    done
} > "$MD_OUT"

echo "Wrote bundled markdown: $MD_OUT"

if command -v pandoc >/dev/null 2>&1; then
    echo "Generating PDF via pandoc ..."
    if pandoc "$MD_OUT" \
        --pdf-engine=xelatex \
        -V geometry:margin=0.5in \
        -V fontsize=10pt \
        -o "$PDF_OUT" 2>/dev/null; then
        echo "✅ PDF: $PDF_OUT"
        echo ""
        echo "Print double-sided, fit-to-page. Consider laminating."
        echo "Put one bundle in each go-bag, one in each car, one in a kitchen drawer."
    else
        echo "pandoc + xelatex failed. Trying default engine..."
        if pandoc "$MD_OUT" -o "$PDF_OUT"; then
            echo "✅ PDF: $PDF_OUT (default engine)"
        else
            echo "❌ PDF generation failed. Use the markdown bundle directly:"
            echo "   $MD_OUT"
            echo ""
            echo "Open it in a markdown viewer and use Print → Save as PDF."
            exit 1
        fi
    fi
else
    echo ""
    echo "pandoc not installed. Options:"
    echo ""
    echo "1. Install pandoc and re-run:"
    echo "     brew install pandoc basictex    # macOS"
    echo "     sudo apt install pandoc texlive-xetex    # Debian/Ubuntu"
    echo ""
    echo "2. Open the bundled markdown in your browser or markdown viewer and"
    echo "   use Print → Save as PDF. Bundle is at:"
    echo "     $MD_OUT"
    echo ""
    echo "3. Print each card file individually:"
    for card in "${CARD_ORDER[@]}"; do
        echo "     $CARDS_DIR/$card"
    done
    exit 0
fi
