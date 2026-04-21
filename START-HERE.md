# START HERE

Use this page as a simple table of contents.

## Is something happening right now?

---

### → YES.

Pick the closest match. Open one page. Start there, then adapt for immediate safety, disability or medical needs, local conditions, and official instructions.

| If… | Open |
|-----|------|
| Someone is bleeding hard | [cards/stop-the-bleed.md](playbooks/cards/stop-the-bleed.md) |
| Someone is hurt or sick and you cannot reach emergency services | [cards/first-aid.md](playbooks/cards/first-aid.md) + `medical/Where_There_Is_No_Doctor_FULL.pdf` |
| No clean water | [cards/water-purification.md](playbooks/cards/water-purification.md) |
| House is on fire | [scenarios/01-house-fire.md](playbooks/scenarios/01-house-fire.md) |
| Tornado / hurricane / blizzard warning | [scenarios/02-severe-weather.md](playbooks/scenarios/02-severe-weather.md) |
| Ground just shook | [scenarios/03-earthquake-cascadia.md](playbooks/scenarios/03-earthquake-cascadia.md) |
| Wildfire is close / heavy smoke | [scenarios/04-wildfire-evacuation.md](playbooks/scenarios/04-wildfire-evacuation.md) |
| Power out > 24 hours | [scenarios/05-grid-down-extended.md](playbooks/scenarios/05-grid-down-extended.md) |
| Novel disease wave | [scenarios/06-pandemic.md](playbooks/scenarios/06-pandemic.md) |
| Banks, payments, phones down | [scenarios/07-cyber-collapse.md](playbooks/scenarios/07-cyber-collapse.md) |
| Flash or boom, fallout warning, reactor alert | [scenarios/08-nuclear.md](playbooks/scenarios/08-nuclear.md) + [cards/radiation-shelter.md](playbooks/cards/radiation-shelter.md) |
| Civil unrest, sheltering in place | [scenarios/09-civil-unrest-bug-in.md](playbooks/scenarios/09-civil-unrest-bug-in.md) |
| Stranded in car, boat, plane, or on foot | [scenarios/10-stranded-or-lost.md](playbooks/scenarios/10-stranded-or-lost.md) |
| Someone frozen in panic, child terrified | [cards/psychological-first-aid.md](playbooks/cards/psychological-first-aid.md) |
| Has insulin / oxygen / dialysis / heart meds | [cards/chronic-conditions.md](playbooks/cards/chronic-conditions.md) |
| Kid is with you and needs clear instructions | [cards/kids-what-to-do.md](playbooks/cards/kids-what-to-do.md) |
| Elderly relative alone and no one can reach them | [cards/elderly-alone-prep.md](playbooks/cards/elderly-alone-prep.md) |
| Person has a disability, meds, or equipment to consider | [cards/disability-preparedness.md](playbooks/cards/disability-preparedness.md) |
| Before you do the obvious, check the don't list | [cards/when-not-to.md](playbooks/cards/when-not-to.md) |
| The event has passed; now the insurance/FEMA/bills start | [recovery/README.md](playbooks/recovery/README.md) |
| Don't know — just scared | [frameworks/stay-or-go.md](playbooks/frameworks/stay-or-go.md) |

**Main movement/shelter framework:** [stay-or-go.md](playbooks/frameworks/stay-or-go.md). Staying is often the default; specific hazards, evacuation orders, medical needs, heat/cold, smoke, flood, fire, or violence can override it.

---

### → NO. I'm preparing.

Start with these:

```bash
./tools-scripts/get-squared-away.sh       # local orientation + verification report; no network
./tools-scripts/print-cards.sh            # printable cards bundle; PDF if pandoc is installed
```

Then open [FIELD-INDEX.md](FIELD-INDEX.md) or [`playbooks/tier-1-setup/00-first-weekend.md`](playbooks/tier-1-setup/00-first-weekend.md).

Optional private worksheet:

```bash
./tools-scripts/household-setup.sh        # blank templates; no questions
./tools-scripts/household-setup.sh --quick
```

**Before you buy gear, read these two cards.** They catch common mistakes that generic gear lists miss:

- [`cards/what-kills.md`](playbooks/cards/what-kills.md) — the real causes of disaster death (CO, heat, floodwater driving, smoke, cardiac, falls). Most are preventable with zero spending.
- [`cards/when-not-to.md`](playbooks/cards/when-not-to.md) — the don'ts that save lives.

**If any of these describe you, read your card first:**

- Household with kids → [`cards/kids-parents-guide.md`](playbooks/cards/kids-parents-guide.md) and [`cards/kids-talking-about-preparedness.md`](playbooks/cards/kids-talking-about-preparedness.md)
- Elderly relative alone → [`cards/elderly-alone-prep.md`](playbooks/cards/elderly-alone-prep.md)
- You or someone in household has a disability, uses powered medical equipment, or needs specialized meds → [`cards/disability-preparedness.md`](playbooks/cards/disability-preparedness.md)
- Renting / apartment or condo → [`cards/renter-preparedness.md`](playbooks/cards/renter-preparedness.md)
- Tight budget → [`cards/low-income-no-spend-prep.md`](playbooks/cards/low-income-no-spend-prep.md)

## The summons card

When things are calm, fill in and print [`cards/summons.md`](playbooks/cards/summons.md). Six lines. Keep copies where they help. Put it on a phone lock screen only if that is safe for privacy and security.

`household-setup.sh` writes a blank version by default. Use `./tools-scripts/household-setup.sh --summons` if you want to fill summons fields during the run.

## 10-minute orientation (for the laptop on the kitchen table)

- Medical: `medical/Where_There_Is_No_Doctor_FULL.pdf`
- First aid: `survival-guides/FM4-25.11_First_Aid_Manual.pdf`
- Water: `survival-guides/Emergency_Water_Purification_Guide.pdf`
- Sanitation: `survival-guides/sanitation/Emergency_Toilet_Guidebook.pdf`
- Comms: `radio/UV-5R_Quick_Reference_Card.pdf`
- Navigation: `survival-guides/FM3-25.26_Map_Reading_Land_Navigation.pdf`
- Food preservation: `food-water/USDA_Complete_Guide_Home_Canning_2015.pdf`
- Power: `power-electrical/NREL_Off_Grid_Solar_Installation_Maintenance.pdf`

Health check: `./tools-scripts/verify-all.sh --essential`

## Simple paths by device

### Kindle only
Drop `kindle-ready/` into the Kindle `documents` folder. Drop the printed cards bundle there too.

### Laptop only
- `./tools-scripts/launch-wikipedia.sh` — offline Wikipedia
- `./tools-scripts/launch-maps.sh` — offline maps
- `./tools-scripts/verify-all.sh --essential` — what's ready now

### Phone only (while you still have internet)
- Install **Kiwix** → Wikipedia ZIM
- Install **Organic Maps** → your region
- Install **Watch Duty** (West Coast wildfire)
- Save the cards bundle or individual card files + `Where_There_Is_No_Doctor_FULL.pdf` to device
- Program NOAA weather radio (162.400–162.550 MHz)
- **Screenshot the summons card to your lock screen only if safe**

### One laptop serving a household
- `./tools-scripts/serve-local-network.sh`

## Core commands

| Command | Purpose |
|---------|---------|
| `./tools-scripts/get-squared-away.sh` | Canonical orientation; writes a report |
| `./tools-scripts/household-setup.sh` | Blank private templates; no questions |
| `./tools-scripts/household-setup.sh --quick` | Short guided checklist |
| `./tools-scripts/household-setup.sh --full --summons` | Longer guided checklist with summons-card fields |
| `./tools-scripts/print-cards.sh` | Bundle emergency cards into a printable bundle; PDF when pandoc is installed |
| `./tools-scripts/verify-all.sh --essential` | Check only the life-support library |
| `./tools-scripts/verify-all.sh --full` | Check everything including optional |
| `./tools-scripts/launch-wikipedia.sh` | Open Kiwix (offline reference) |
| `./tools-scripts/launch-maps.sh` | Open offline maps |
| `./tools-scripts/launch-maps.sh topo Seattle` | Search topo maps for a place |
| `./tools-scripts/serve-local-network.sh` | Serve ZIMs / files on LAN |

## Deeper docs (after you've done the above)

- [README.md](README.md) — what's in the box
- [playbooks/README.md](playbooks/README.md) — all playbooks
- [FIELD-INDEX.md](FIELD-INDEX.md) — file-level index
- [USAGE.md](USAGE.md) — scenario-based usage of the library
- [DOWNLOADS.md](DOWNLOADS.md) — optional large downloads
- [docs/acid-v2-parity.md](docs/acid-v2-parity.md) — content parity vs commercial devices
- [docs/local-ai-models.md](docs/local-ai-models.md)
- [docs/gemma4-llamacpp.md](docs/gemma4-llamacpp.md)
