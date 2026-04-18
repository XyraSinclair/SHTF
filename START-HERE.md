# START HERE

This repo is most useful when you do not have time to browse calmly. Start here.

## First time, not in an emergency

Do these three, in order, this weekend:

```bash
./tools-scripts/get-squared-away.sh       # inventory what's actually here
./tools-scripts/household-setup.sh        # produces your personal checklist
./tools-scripts/print-cards.sh            # bundles cards/ into a printable PDF
```

Then open [`playbooks/tier-1-setup/00-first-weekend.md`](playbooks/tier-1-setup/00-first-weekend.md). Two hours minimum; full weekend preferred.

For an AI agent entering cold:

```bash
./tools-scripts/get-squared-away.sh --json
```

## If something is happening right now

Pick the closest match. These are quick runbooks — not panic playlists.

| Situation | Open this first |
|-----------|-----------------|
| Fire in the house | [scenarios/01-house-fire.md](playbooks/scenarios/01-house-fire.md) |
| Severe weather warning (hurricane/tornado/blizzard/heat dome) | [scenarios/02-severe-weather.md](playbooks/scenarios/02-severe-weather.md) |
| Earthquake / just finished shaking | [scenarios/03-earthquake-cascadia.md](playbooks/scenarios/03-earthquake-cascadia.md) |
| Wildfire advancing / smoke heavy | [scenarios/04-wildfire-evacuation.md](playbooks/scenarios/04-wildfire-evacuation.md) |
| Power out > 24 hours | [scenarios/05-grid-down-extended.md](playbooks/scenarios/05-grid-down-extended.md) |
| Pandemic / novel disease wave | [scenarios/06-pandemic.md](playbooks/scenarios/06-pandemic.md) |
| Banks / payments / phones down (cyber) | [scenarios/07-cyber-collapse.md](playbooks/scenarios/07-cyber-collapse.md) |
| Nuclear detonation / fallout / reactor accident | [scenarios/08-nuclear.md](playbooks/scenarios/08-nuclear.md) + [cards/radiation-shelter.md](playbooks/cards/radiation-shelter.md) |
| Civil unrest, sheltering in place | [scenarios/09-civil-unrest-bug-in.md](playbooks/scenarios/09-civil-unrest-bug-in.md) |
| Stranded in car, boat, plane, or on foot | [scenarios/10-stranded-or-lost.md](playbooks/scenarios/10-stranded-or-lost.md) |
| Someone is bleeding hard | [cards/stop-the-bleed.md](playbooks/cards/stop-the-bleed.md) |
| Someone is hurt or sick | [cards/first-aid.md](playbooks/cards/first-aid.md) + `medical/Where_There_Is_No_Doctor_FULL.pdf` |
| No clean water | [cards/water-purification.md](playbooks/cards/water-purification.md) |
| Need radio contact | [cards/radio-frequencies.md](playbooks/cards/radio-frequencies.md) |

The one question that decides everything: [frameworks/stay-or-go.md](playbooks/frameworks/stay-or-go.md).

## The 10-minute orientation

If you just got the repo and want the essentials on screen now:

- Medical: `medical/Where_There_Is_No_Doctor_FULL.pdf`
- First aid: `survival-guides/FM4-25.11_First_Aid_Manual.pdf`
- Water: `survival-guides/Emergency_Water_Purification_Guide.pdf`
- Sanitation: `survival-guides/sanitation/Emergency_Toilet_Guidebook.pdf`
- Comms: `radio/UV-5R_Quick_Reference_Card.pdf`
- Navigation: `survival-guides/FM3-25.26_Map_Reading_Land_Navigation.pdf`
- Food preservation: `food-water/USDA_Complete_Guide_Home_Canning_2015.pdf`
- Power: `power-electrical/NREL_Off_Grid_Solar_Installation_Maintenance.pdf`

Then run the health check:

```bash
./tools-scripts/verify-all.sh --essential
```

## Best paths by device

### Kindle only
Drop the contents of `kindle-ready/` into the Kindle `documents` folder. Medical, survival, food/water, radio, and construction books are already flattened and category-prefixed. Also drop your printed emergency cards PDF onto it.

### Laptop only
- Browse PDFs directly.
- Offline Wikipedia: `./tools-scripts/launch-wikipedia.sh`
- Offline maps: `./tools-scripts/launch-maps.sh`
- Health check: `./tools-scripts/verify-all.sh --essential`

### Phone only (while you still have internet)
- Install **Kiwix** → download a Wikipedia ZIM
- Install **Organic Maps** → download your region
- Install **Watch Duty** (wildfire) if in the West
- Save the emergency card PDF and `medical/Where_There_Is_No_Doctor_FULL.pdf` to the device
- Program a **NOAA weather radio** if you have one (162.400–162.550 MHz)

### One laptop serving a household
- Raw file share: `./tools-scripts/serve-local-network.sh`
- For Kiwix-served ZIMs, install `kiwix-serve` and rerun the same command.

## Core commands

| Command | Purpose |
|---------|---------|
| `./tools-scripts/get-squared-away.sh` | Canonical orientation; writes a report |
| `./tools-scripts/household-setup.sh` | Interactive Tier-1 walkthrough → personal checklist |
| `./tools-scripts/print-cards.sh` | Bundle emergency cards into a printable PDF |
| `./tools-scripts/verify-all.sh --essential` | Check only the life-support library |
| `./tools-scripts/verify-all.sh --full` | Check everything including optional |
| `./tools-scripts/launch-wikipedia.sh` | Open Kiwix (offline reference) |
| `./tools-scripts/launch-maps.sh` | Open offline maps |
| `./tools-scripts/launch-maps.sh topo Seattle` | Search topo maps for a place |
| `./tools-scripts/serve-local-network.sh` | Serve ZIMs / files on LAN |

## Next docs

- [README.md](README.md)
- [playbooks/README.md](playbooks/README.md)
- [playbooks/cards/offline-knowledge-map.md](playbooks/cards/offline-knowledge-map.md)
- [FIELD-INDEX.md](FIELD-INDEX.md)
- [USAGE.md](USAGE.md)
- [DOWNLOADS.md](DOWNLOADS.md)
- [docs/acid-v2-parity.md](docs/acid-v2-parity.md) — content parity vs a typical commercial offline-reference device
- [docs/local-ai-models.md](docs/local-ai-models.md)
- [docs/gemma4-llamacpp.md](docs/gemma4-llamacpp.md)
