# Cards

Single-page, print-ready references. Designed to fit on one printed page each. Laminate and put in your go-bag, your car, and a kitchen drawer.

## Cards in this set

**Start here** (the card that finds you):
- [`summons.md`](summons.md) — 6-line wallet / lock-screen card. Fill via `household-setup.sh --summons` or by hand.

**Education — read these before you need them:**
- [`what-kills.md`](what-kills.md) — what actually kills people in disasters. CO, heat, floodwater driving, smoke, cardiac, falls, and more. The counterintuitive list.
- [`when-not-to.md`](when-not-to.md) — the negations that save lives. When NOT to drive, NOT to flush, NOT to run a generator, NOT to re-enter, NOT to evacuate.

**Response:**
- [`first-aid.md`](first-aid.md) — core first-aid response flowchart.
- [`stop-the-bleed.md`](stop-the-bleed.md) — bleeding control with and without equipment.
- [`water-purification.md`](water-purification.md) — make water safe to drink.
- [`psychological-first-aid.md`](psychological-first-aid.md) — panic, freeze, grief, kids. WHO's Look-Listen-Link.

**Specific populations / scenarios:**
- [`chronic-conditions.md`](chronic-conditions.md) — insulin, oxygen, dialysis, heart meds, CPAP, pregnancy in a disaster.
- [`kids-what-to-do.md`](kids-what-to-do.md) — written for kids 8–12. Lost, fire, someone hurt, pocket card.
- [`kids-parents-guide.md`](kids-parents-guide.md) — parent's guide: involving kids in prep without scaring them.
- [`kids-talking-about-preparedness.md`](kids-talking-about-preparedness.md) — how to talk to kids about disasters. Teachable moments, age-appropriate framing.
- [`elderly-alone-prep.md`](elderly-alone-prep.md) — older adults living alone. Network first, medical continuity, I'm-OK sign.
- [`disability-preparedness.md`](disability-preparedness.md) — mobility, blind/low-vision, deaf/HoH, cognitive, autism/sensory. ADA shelter rights.
- [`renter-preparedness.md`](renter-preparedness.md) — portable preps, renters insurance, floor captains. For apartment/condo dwellers.
- [`low-income-no-spend-prep.md`](low-income-no-spend-prep.md) — prep on near-zero budget. Water is free, the library is a prep resource.
- [`radiation-shelter.md`](radiation-shelter.md) — fallout-shelter fundamentals (from NWSS).
- [`radio-frequencies.md`](radio-frequencies.md) — emergency, weather, and ham frequencies for the US West Coast.

**Reference / fill-in:**
- [`family-comms.md`](family-comms.md) — blank template, fill out and carry.
- [`offline-knowledge-map.md`](offline-knowledge-map.md) — what's where when the internet is gone.
- [`translations-priority.md`](translations-priority.md) — how to translate cards for non-English speakers. Priorities, sourcing, distribution.

**Advanced supplement:**
- [`high-signal-field-brief.html`](high-signal-field-brief.html) — dense six-panel operations brief for comms, radiation, power, local AI, trade, and sleep. Treat it as an optional supplement, not the first thing to print.

## How to print

For the standard deck, run `print-cards.sh`.
For the advanced supplement, open `high-signal-field-brief.html` in a browser and print it separately.

If you have `pandoc` installed:

```bash
../../tools-scripts/print-cards.sh
```

This produces a single PDF bundle you can print double-sided.

Without pandoc, `print-cards.sh` still writes a bundled markdown file under `playbooks/cards/.build/`. Open that bundle or the individual card files in a browser and use Print → Save as PDF.

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
