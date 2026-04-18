# Offline Lookup Drill

Most people discover their offline reference is unusable only when they actually need it — under stress, in the dark, with a phone at 12% battery. This drill exposes that failure mode in 30 minutes while everything is calm.

## If you only read one line

**Set a timer, answer five real questions using only this repo, no internet.** If you can't find any of them in under two minutes, that's a bug in your setup, not in your head.

## Before you start

- Unplug the router, or turn on airplane mode on your laptop.
- Open a terminal in the repo root.
- Put this file on a phone (screenshot it) — because you're about to lose internet.
- Start a stopwatch.

## The five questions

Each question has one "right" primary source. Time-box each to 2 minutes. Write down what you actually opened and how long it took.

### 1. Medical — "Someone just cut themselves badly on the forearm. What do I do right now?"

Target: `playbooks/cards/stop-the-bleed.md` in under 30 seconds. If you opened Wikipedia first, your reflex is wrong — fix it by moving the cards card to the top of your bookmarks, or printing them.

### 2. Water — "The tap water has a boil-water advisory. I have bleach. How much per gallon?"

Target: `playbooks/cards/water-purification.md`. Confirm the card gives you the bleach ratio without making you read a PDF first. If it doesn't, that's a gap in the card.

### 3. Repair — "The fridge compressor is humming but not cooling. What's the first thing to check?"

Target: `reference/ifixit_en_all_*.zim` via Kiwix, or `reference/diy.stackexchange.com_*.zim`. If neither is present, run `./tools-scripts/download-acid-parity.sh ifixit` and re-drill.

### 4. Radio — "Channel 16 is busy. What frequency should I try for a weather update?"

Target: `playbooks/cards/radio-frequencies.md`. Should name NOAA Weather Radio (162.400–162.550 MHz) without a detour through the ARRL manual.

### 5. Navigation — "I'm in an unfamiliar town and my phone is dead. How do I find the nearest major road from a paper topo?"

Target: `survival-guides/FM3-25.26_Map_Reading_Land_Navigation.pdf` or offline maps via `./tools-scripts/launch-maps.sh`. Actually open it — don't just point at it.

## After the drill — write down

For each question:
- Time to first correct source (target: under 2 minutes).
- Time to actionable answer (target: under 5 minutes for anything except a quiz question).
- Did your muscle memory take you to the right place, or did you fumble?
- Was the answer on a **card**, or did you have to scroll a PDF?

**Anything that took over 2 minutes is a bug.** Cards exist so that the answer is one screen away. If the answer wasn't on a card, decide whether the card should grow or a new card should be born.

## Common failures and fixes

| Failure | Fix |
|---|---|
| You opened Wikipedia before the card | Print cards; put the PDF bundle in every go-bag |
| Kiwix wasn't running | Launch on boot, or add `./tools-scripts/launch-wikipedia.sh` to a desktop shortcut |
| The ZIM you wanted wasn't present | `./tools-scripts/download-acid-parity.sh <target>` |
| You had Wi-Fi on and didn't notice | Physically turn off the router during the drill — this is not optional |
| Laptop battery died at 30% | Add a solar panel + USB-C power bank to the tier-1 stockpile |
| Nobody else in the household knew how | Run the drill with them, not for them |

## Run this

- Once now, to baseline.
- Once per season, to catch rot (apps update, bookmarks move, things break).
- Once as a family, with all adults on their own laptop or phone.

## Before it happens, do this once

- Open `playbooks/cards/offline-knowledge-map.md` and screenshot it to your phone.
- Run `./tools-scripts/download-acid-parity.sh --list` and pick what your household actually uses.
- Run `./tools-scripts/print-cards.sh` and put the resulting PDF in every bag and drawer that needs one.
- Bookmark `./tools-scripts/launch-wikipedia.sh` and `./tools-scripts/serve-local-network.sh` in your shell history or a notes file.
