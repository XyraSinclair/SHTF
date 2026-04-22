#!/bin/bash
# build-envelope.sh — produce the manila envelope.
#
# Generates playbooks/envelope/ with eleven printable sections plus a bundled
# envelope.md (the single-file form of all eleven, for one-shot PDF).
#
# Sections:
#   00-read-me-first.md      cover letter, explains what's in the envelope
#   01-tonight.md            the eight things to do before bed
#   02-summons-6up.md        six summons cards per letter sheet, blank
#   03-household-roster.md   blank template
#   04-family-comms.md       blank template
#   05-first-weekend.md      the one weekend of real work
#   06-what-kills.md         the real disaster killers
#   07-when-not-to.md        the don'ts that save lives
#   08-water-purification.md clean-water procedures
#   09-stop-the-bleed.md     hemorrhage control
#   10-first-aid.md          primary first-aid card
#
# Also builds envelope.pdf when pandoc is installed.
#
# Usage:
#   ./tools-scripts/build-envelope.sh           # build the envelope
#   ./tools-scripts/build-envelope.sh --pdf     # fail if pandoc can't produce a PDF
#   ./tools-scripts/build-envelope.sh --open    # open the folder when done
#   ./tools-scripts/build-envelope.sh --check   # verify sources only; don't write
#   ./tools-scripts/build-envelope.sh --help
#
# The envelope is what you print. The rest of the repo is the library
# behind it. If you only do one thing in this repo, do this.

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CARDS="$ROOT/playbooks/cards"
TIER1="$ROOT/playbooks/tier-1-setup"
OUT="$ROOT/playbooks/envelope"

FORCE_PDF=0
OPEN_AFTER=0
CHECK_ONLY=0

usage() { sed -n '3,29p' "$0" | sed 's/^# \{0,1\}//'; }

while [[ $# -gt 0 ]]; do
  case "$1" in
    --pdf) FORCE_PDF=1 ;;
    --open) OPEN_AFTER=1 ;;
    --check) CHECK_ONLY=1 ;;
    --help|-h) usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage; exit 1 ;;
  esac
  shift
done

# Required sources — a section is empty without them. If any of these are
# missing, the envelope is a lie, so we refuse to build.
required_sources=(
  "$CARDS/tonight.md:01-tonight.md"
  "$TIER1/01-household-roster.md:03-household-roster.md"
  "$TIER1/05-family-comms-plan.md:04-family-comms.md"
  "$TIER1/00-first-weekend.md:05-first-weekend.md"
  "$CARDS/what-kills.md:06-what-kills.md"
  "$CARDS/when-not-to.md:07-when-not-to.md"
  "$CARDS/water-purification.md:08-water-purification.md"
  "$CARDS/stop-the-bleed.md:09-stop-the-bleed.md"
  "$CARDS/first-aid.md:10-first-aid.md"
)

missing=()
for pair in "${required_sources[@]}"; do
  src="${pair%%:*}"
  [[ -f "$src" ]] || missing+=("$src")
done

if [[ ${#missing[@]} -gt 0 ]]; then
  echo "build-envelope.sh: required source files missing:" >&2
  for f in "${missing[@]}"; do echo "  - $f" >&2; done
  echo "" >&2
  echo "The envelope is meant to be complete. Fix the repo before rebuilding." >&2
  exit 1
fi

if [[ $CHECK_ONLY -eq 1 ]]; then
  echo "All eleven sources present."
  if command -v pandoc >/dev/null 2>&1; then
    echo "pandoc: available (PDF will build)"
  else
    echo "pandoc: not installed (PDF will be skipped)"
  fi
  exit 0
fi

# Clean rebuild — never mix old output with new.
rm -rf "$OUT"
mkdir -p "$OUT"

# ---------- 00: cover letter ----------
cat > "$OUT/00-read-me-first.md" <<'EOF'
# The Envelope

Print everything in this folder. Staple each section. Put all of it in a manila envelope labeled **"Just in case"** and leave it on the kitchen counter or in the junk drawer. That's it.

You don't have to read the repo. You don't have to buy anything. You don't have to build a bunker. This envelope is enough to start.

## What's in here

1. **Tonight** — eight small things to do before you go to sleep. Twenty minutes. No money.
2. **Summons cards** — six per sheet, blank. Fill in, cut, put one in each wallet, car, and by the bed.
3. **Household roster** — a blank page for names, medical notes, meeting points.
4. **Family comms** — one page that decides whether you regroup in two hours or two days if phones don't work.
5. **First weekend** — two to four hours of actual work that gives you a usable first-version plan.
6. **What kills** — the real causes of disaster death. Most are preventable with zero spending.
7. **When not to** — the don'ts. The things that get people killed who were trying to help.
8. **Water, bleeding, first aid** — the three cards you'll look at when you can't think.

## How to use this

Tonight: do the eight things on page 1.
This weekend: work through the first-weekend checklist with whoever lives with you.
After that: the rest of the repo is a library. You can read it or not. The envelope is enough to start.

If something bad happens and you haven't finished the weekend yet: the envelope is still enough to start. Begin with the tonight page and the summons card. The rest can wait.

## Adapt this for your household

These pages are conservative defaults for a healthy adult in a detached house. Change them for your body, household, climate, terrain, budget, medical needs, disability access, pets, local law, and any official instructions you've been given. An apartment renter, a wheelchair user, a dialysis patient, a parent with infants, an elder living alone, a household with refrigerated or controlled medications, someone without a car — each of these changes the right answer. Nothing in this envelope overrides what a clinician, caseworker, or local emergency manager tells you.

## What this is not

This is not a prepper kit. It is not a product. It is not an opinion about politics, the economy, or the end of the world. It is a manila envelope your household can keep in a drawer so that if a bad night comes, you don't have to think very hard about what to do in the first ten minutes.

You are not behind. Starting now is enough.
EOF

# ---------- 01: tonight ----------
cp "$CARDS/tonight.md" "$OUT/01-tonight.md"

# ---------- 02: summons 6-up ----------
cat > "$OUT/02-summons-6up.md" <<'EOF'
# Summons Cards (fill in, print, cut into 6)

Print this page. Fill in the six blank fields in pen on one card, photocopy the filled card, cut into six. Keep one in each wallet, one in each car, one in each go-bag, one on the fridge, one with your out-of-area contact.

If putting this on a phone lock screen is safe for your situation, screenshot a filled card and use the image as your wallpaper.

---

```
┌────────────────────────────┬────────────────────────────┐
│ ICE: ______________________│ ICE: ______________________│
│      ___-___-____          │      ___-___-____          │
│ MEET: _____________________│ MEET: _____________________│
│ ME: _______ MEDS: _________│ ME: _______ MEDS: _________│
│ BLEED→press hard. TQ if bad│ BLEED→press hard. TQ if bad│
│ WATER→8 drops bleach/gal,  │ WATER→8 drops bleach/gal,  │
│ 30 min. STAY unless unsafe.│ 30 min. STAY unless unsafe.│
├────────────────────────────┼────────────────────────────┤
│ ICE: ______________________│ ICE: ______________________│
│      ___-___-____          │      ___-___-____          │
│ MEET: _____________________│ MEET: _____________________│
│ ME: _______ MEDS: _________│ ME: _______ MEDS: _________│
│ BLEED→press hard. TQ if bad│ BLEED→press hard. TQ if bad│
│ WATER→8 drops bleach/gal,  │ WATER→8 drops bleach/gal,  │
│ 30 min. STAY unless unsafe.│ 30 min. STAY unless unsafe.│
├────────────────────────────┼────────────────────────────┤
│ ICE: ______________________│ ICE: ______________________│
│      ___-___-____          │      ___-___-____          │
│ MEET: _____________________│ MEET: _____________________│
│ ME: _______ MEDS: _________│ ME: _______ MEDS: _________│
│ BLEED→press hard. TQ if bad│ BLEED→press hard. TQ if bad│
│ WATER→8 drops bleach/gal,  │ WATER→8 drops bleach/gal,  │
│ 30 min. STAY unless unsafe.│ 30 min. STAY unless unsafe.│
└────────────────────────────┴────────────────────────────┘
```

## The six lines, plain text

- **ICE**: one out-of-area contact. Paramedics look for this.
- **MEET**: where your household goes when phones don't work. Street address.
- **ME**: your name and any medical note that would matter if you couldn't speak.
- **BLEED**: press hard on the wound. Tourniquet only for severe limb bleeding when trained.
- **WATER**: 8 drops unscented bleach per gallon of clear water, wait 30 minutes.
- **STAY**: the default is stay home. Fire, flood, smoke, violence, or an order override that.

## Where the water dose comes from

The bleach dose is the US EPA / CDC standard for emergency disinfection of drinking water: 8 drops (~0.5 mL) of unscented household bleach (5.25%–8.25% sodium hypochlorite) per US gallon of clear water, mixed and allowed to stand 30 minutes. Cloudy water gets 16 drops and must be filtered first. See `08-water-purification.md` in this envelope, and `playbooks/cards/water-purification.md` in the repo, for the full procedure and edge cases (very cold water, cloudy water, iodine alternatives, pregnancy considerations).

Sources: US EPA *Emergency Disinfection of Drinking Water*, CDC *Making Water Safe in an Emergency*, WHO *Guidelines for Drinking-water Quality* emergency annex.
EOF

# ---------- 03 through 10: carry through existing cards and tier-1 pages ----------
cp "$TIER1/01-household-roster.md"  "$OUT/03-household-roster.md"
cp "$TIER1/05-family-comms-plan.md" "$OUT/04-family-comms.md"
cp "$TIER1/00-first-weekend.md"     "$OUT/05-first-weekend.md"
cp "$CARDS/what-kills.md"           "$OUT/06-what-kills.md"
cp "$CARDS/when-not-to.md"          "$OUT/07-when-not-to.md"
cp "$CARDS/water-purification.md"   "$OUT/08-water-purification.md"
cp "$CARDS/stop-the-bleed.md"       "$OUT/09-stop-the-bleed.md"
cp "$CARDS/first-aid.md"            "$OUT/10-first-aid.md"

# ---------- Bundled markdown (build artifact — not counted in the eleven sections) ----------
BUILD_DIR="$OUT/.build"
mkdir -p "$BUILD_DIR"
BUNDLE="$BUILD_DIR/envelope.md"
{
  echo "---"
  echo "title: The Envelope"
  echo "subtitle: SHTF household continuity kit"
  echo "date: $(date +%Y-%m-%d)"
  echo "---"
  echo ""
  for f in "$OUT"/[0-9][0-9]-*.md; do
    cat "$f"
    printf '\n\n\\newpage\n\n'
  done
} > "$BUNDLE"

# ---------- PDF ----------
PDF="$BUILD_DIR/envelope.pdf"
pdf_built=0
if command -v pandoc >/dev/null 2>&1; then
  if pandoc "$BUNDLE" \
      --pdf-engine=xelatex \
      -V geometry:margin=0.6in \
      -V fontsize=11pt \
      -o "$PDF" 2>/dev/null; then
    pdf_built=1
  elif pandoc "$BUNDLE" -o "$PDF" 2>/dev/null; then
    pdf_built=1
  fi
fi

echo ""
echo "The envelope is in: $OUT/"
echo ""
echo "Eleven print-and-staple sections:"
for f in "$OUT"/[0-9][0-9]-*.md; do echo "  $(basename "$f")"; done
echo ""
echo "Build artifacts (not for printing individually):"
echo "  .build/envelope.md    (bundled markdown)"
[[ $pdf_built -eq 1 ]] && echo "  .build/envelope.pdf   (single printable PDF)"
echo ""

if [[ $pdf_built -eq 1 ]]; then
  echo "Print $PDF double-sided, fit-to-page. Staple. Put in a manila envelope."
  echo "Leave it on the counter."
elif [[ $FORCE_PDF -eq 1 ]]; then
  echo "ERROR: --pdf was requested but pandoc failed or is not installed." >&2
  echo "Install: brew install pandoc basictex   (macOS)" >&2
  echo "         sudo apt install pandoc texlive-xetex   (Debian/Ubuntu)" >&2
  exit 1
else
  echo "No PDF built (pandoc not installed — that's fine)."
  echo "Open any section in a markdown viewer and Print → Save as PDF."
  echo "Or install pandoc once and re-run:"
  echo "  brew install pandoc basictex"
fi

if [[ $OPEN_AFTER -eq 1 ]]; then
  if command -v open >/dev/null 2>&1; then
    open "$OUT"
  elif command -v xdg-open >/dev/null 2>&1; then
    xdg-open "$OUT" >/dev/null 2>&1 || true
  fi
fi
