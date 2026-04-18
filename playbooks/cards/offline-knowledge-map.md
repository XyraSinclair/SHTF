# Offline knowledge map

If the internet is gone and you need to look something up, this is where you go —
in this repo or in the offline reference libraries it points to.

## If you only read one line
Pick the category, open the primary source first; go to the ZIMs only if the primary
doesn't answer you. Do not rabbit-hole on a ZIM while a person is bleeding.

## Primary sources by need

| Need | Open first | Then |
|---|---|---|
| Someone hurt / sick | cards/first-aid.md · cards/stop-the-bleed.md | medical/Where_There_Is_No_Doctor_FULL.pdf · medical/mdwiki_en_all_*.zim |
| Water isn't safe | cards/water-purification.md | survival-guides/Emergency_Water_Purification_Guide.pdf |
| Radio check-in | cards/radio-frequencies.md | radio/UV-5R_Quick_Reference_Card.pdf · ARRL manuals |
| Where am I / where to go | playbooks/frameworks/stay-or-go.md | survival-guides/FM3-25.26_Map_Reading_Land_Navigation.pdf · maps/ |
| Fix broken gear | reference/ifixit_en_all_*.zim | mechanical/ PDFs · reference/diy.stackexchange_*.zim |
| Fix a vehicle | mechanical/vehicle-repair/ | Survivor Library auto section (see README there) |
| Fix a radio / electronics | reference/electronics.stackexchange_*.zim | radio/ PDFs |
| Build / repair a structure | construction/ · playbooks/cards/ | reference/diy.stackexchange_*.zim |
| Grow / forage / preserve food | food-water/ | reference/gardening.stackexchange_*.zim · wikipedia |
| Identify a plant / animal / insect | reference/wikispecies_*.zim | wikipedia/*.zim |
| Navigate unknown terrain by road | reference/wikivoyage_*.zim | maps/ |
| Teach kids while out of school | reference/khan-academy_*.zim | reference/wikibooks_*.zim |
| Reference anything civilizational | wikipedia/*.zim | reference/stackoverflow_*.zim |
| Cook / ration food | food-water/preservation/ | reference/cooking.stackexchange_*.zim |
| Morale / long nights | reference/gutenberg_en_all_*.zim | survival-guides/ narrative works |
| Rebuild after event | reference/zimgit-post-disaster_en_*.zim · reference/appropedia_*.zim | ready-gov/ FEMA guides |

## How to actually open the ZIMs

```bash
./tools-scripts/launch-wikipedia.sh        # local Kiwix reader
./tools-scripts/serve-local-network.sh     # share on your LAN so phones can browse
```

Kiwix reads every `.zim` file under `wikipedia/`, `medical/`, `reference/`, etc.
Everything marketed as "entire offline internet" on commercial survival devices is
a thin UI over the same Kiwix ZIMs you have here.

## Before it happens, do this once
- Run `./tools-scripts/download-acid-parity.sh all` (or a subset matching your
  risk model — see docs/acid-v2-parity.md).
- Confirm coverage: `./tools-scripts/verify-all.sh --full`.
- Open `serve-local-network.sh` once on your main machine and bookmark the LAN URL
  on every household phone and tablet. That's your "internet" when the internet
  is gone.
