# Cards

Single-page, print-ready references. Designed to fit on one printed page each. Laminate and put in your go-bag, your car, and a kitchen drawer.

## Cards in this set

- [`first-aid.md`](first-aid.md) — core first-aid response flowchart.
- [`stop-the-bleed.md`](stop-the-bleed.md) — bleeding control with and without equipment.
- [`water-purification.md`](water-purification.md) — make water safe to drink.
- [`radio-frequencies.md`](radio-frequencies.md) — emergency, weather, and ham frequencies for the US West Coast.
- [`radiation-shelter.md`](radiation-shelter.md) — fallout-shelter fundamentals (from NWSS).
- [`family-comms.md`](family-comms.md) — blank template, fill out and carry.

## How to print

If you have `pandoc` installed:

```bash
../../tools-scripts/print-cards.sh
```

This produces a single PDF bundle you can print double-sided.

Without pandoc, open each card in your browser's markdown preview and use Print → Save as PDF.

## Use them

- Put one set in each go-bag (see [`../tier-1-setup/02-go-bag.md`](../tier-1-setup/02-go-bag.md)).
- Put one set in each car.
- Laminate if possible; otherwise ziploc bag.
- Review contents with household once a year.
- Mark any important additions in the margins for your specific household (medications, allergies, doctor contacts).

## A note on formatting

Markdown tables and headers are optimized for reading on screen. When printed, layout varies by renderer. For best print results:

- Browser → print preview → "Fit to page" → "No margins" or "Narrow"
- Pandoc → default PDF layout is acceptable; can be tuned with a custom template.
