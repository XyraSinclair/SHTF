# SHTF Quickstart

This repo is most useful when you do not have time to browse calmly.
Start here.

First command for a fresh downloader or AI agent:

```bash
./tools-scripts/get-squared-away.sh
```

If the caller is an AI agent, prefer:

```bash
./tools-scripts/get-squared-away.sh --json
```

## If the internet just died

1. Run the health check:
   ./tools-scripts/verify-all.sh --essential
2. Open the most important medical docs:
   open medical/Where_There_Is_No_Doctor_FULL.pdf
   open survival-guides/FM4-25.11_First_Aid_Manual.pdf
3. Open the water and sanitation docs:
   open survival-guides/Emergency_Water_Purification_Guide.pdf
   open survival-guides/sanitation/Emergency_Toilet_Guidebook.pdf
4. Open radio quick references:
   open radio/UV-5R_Quick_Reference_Card.pdf
   open radio/UV-5R_Programming_Cheat_Sheet.pdf
5. Start offline reference browsing:
   ./tools-scripts/launch-wikipedia.sh
6. Open offline maps:
   ./tools-scripts/launch-maps.sh

## If you only have 10 minutes

Do these first:
- Medical: medical/Where_There_Is_No_Doctor_FULL.pdf
- First aid: survival-guides/FM4-25.11_First_Aid_Manual.pdf
- Water: survival-guides/Emergency_Water_Purification_Guide.pdf
- Sanitation: survival-guides/sanitation/Emergency_Toilet_Guidebook.pdf
- Comms: radio/UV-5R_Quick_Reference_Card.pdf
- Navigation: survival-guides/FM3-25.26_Map_Reading_Land_Navigation.pdf
- Food preservation: food-water/USDA_Complete_Guide_Home_Canning_2015.pdf
- Power: power-electrical/NREL_Off_Grid_Solar_Installation_Maintenance.pdf

## Best paths by device

### Kindle only
Best folder: kindle-ready/
- Drag the whole folder into the Kindle documents folder.
- Medical, survival, food/water, radio, and construction books are already flattened and category-prefixed.

### Laptop only
- Browse PDFs directly with Preview.
- Launch Kiwix with ./tools-scripts/launch-wikipedia.sh
- Launch maps with ./tools-scripts/launch-maps.sh
- Run ./tools-scripts/verify-all.sh --essential to see what is ready now.

### Phone only
Before things get bad:
- Install Kiwix
- Install Organic Maps
- Download your local region in Organic Maps
- Download at least one Wikipedia or medical ZIM in Kiwix
- Save the radio quick references and emergency medical PDFs to the device

### One laptop serving a household
- For raw file sharing: ./tools-scripts/serve-local-network.sh
- For browsable ZIM serving, install kiwix-serve first and rerun the same command.

## What to open by problem

### Someone is hurt
- medical/Where_There_Is_No_Doctor_FULL.pdf
- medical/Where_There_Is_No_Dentist_FULL.pdf
- survival-guides/FM4-25.11_First_Aid_Manual.pdf

### You need safe water
- survival-guides/Emergency_Water_Purification_Guide.pdf
- survival-guides/Water_Purification_Methods.pdf
- survival-guides/survivor-library/survival-water-purification.pdf

### You need comms
- radio/UV-5R_Quick_Reference_Card.pdf
- radio/Baofeng_UV-5R_Programming_Guide.pdf
- radio/ARRL_ARES_Field_Resources_Manual.pdf
- radio/NOAA_Weather_Radio_Frequencies_West_Coast.txt

### You need navigation
- survival-guides/FM3-25.26_Map_Reading_Land_Navigation.pdf
- maps/topo/
- ./tools-scripts/launch-maps.sh topo <place>

### You need food and storage
- food-water/USDA_Complete_Guide_Home_Canning_2015.pdf
- food-water/Washington_State_Foraging_Guide.pdf
- food-water/Seed_Saving_Guide.pdf

### You need power
- power-electrical/NREL_Off_Grid_Solar_Installation_Maintenance.pdf
- survival-guides/solar-power/Solar_Electric_System_Design_Operation_Installation.pdf

## Core commands

- Verify essentials only:
  ./tools-scripts/verify-all.sh --essential
- Verify everything:
  ./tools-scripts/verify-all.sh --full
- Open Kiwix:
  ./tools-scripts/launch-wikipedia.sh
- Share ZIMs or files on LAN:
  ./tools-scripts/serve-local-network.sh
- Open maps:
  ./tools-scripts/launch-maps.sh
- Search topo maps:
  ./tools-scripts/launch-maps.sh topo Seattle

## Next docs

- FIELD-INDEX.md
- USAGE.md
- DOWNLOADS.md
- docs/local-ai-models.md
- docs/gemma4-llamacpp.md
- tools-scripts/audit-gemma4-artifacts.py
