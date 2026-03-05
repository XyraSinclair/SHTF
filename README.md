# SHTF: Offline Survival Library

If the grid goes down, the internet disappears, and you're on your own -- this is what you want on your hard drive and your Kindle.

This is a curated, organized collection of freely available survival knowledge: military field manuals, medical handbooks, food preservation guides, radio programming references, solar power tutorials, blacksmithing, and more. Everything is sourced from US government publications (public domain), WHO/UN freely distributed guides, Peace Corps manuals, and Project Gutenberg.

## Kindle-Ready Library

The `kindle-ready/` folder is the heart of this repo: **144 books** in EPUB and PDF format, flattened into a single folder so you can drag them straight onto a Kindle via USB. Connect your Kindle, open its `documents` folder, and drop them in.

Files are prefixed by category so they sort together:

| # | Category | Count | Highlights |
|---|----------|-------|------------|
| 01 | **Medical** | 10 | *Where There Is No Doctor/Dentist*, WHO surgical guide, psychological first aid, crisis counseling, essential medicines |
| 02 | **Survival** | 42 | US Army field manuals (survival, marksmanship, urban ops, cold weather, mountain), FEMA guides, nuclear survival, knots, trapping, woodcraft, firearms maintenance |
| 03 | **Food & Water** | 38 | Gardening, seed saving, beekeeping, canning, foraging, fishing, butchering (beef/lamb/pork), sausage making, distillation, brewing, water purification |
| 04 | **Herbal Medicine** | 5 | Culpeper's Complete Herbal, WHO medicinal plant monographs |
| 05 | **Radio & Comms** | 11 | Baofeng UV-5R programming, ARRL emergency comms, CHIRP setup |
| 06 | **Power & Solar** | 4 | Off-grid solar installation, wind power, biogas, solar cookers |
| 07 | **Sanitation** | 6 | Emergency hygiene, composting toilets, WHO WASH guidelines |
| 08 | **Mechanical** | 9 | Engine repair, soap making, weaving, leather tanning, micro hydro |
| 09 | **Navigation & Weather** | 4 | Celestial navigation, meteorology, reading weather patterns |
| 10 | **Construction** | 10 | Log cabin building, brickmaking, carpentry, barn construction, FEMA safe rooms |
| 11 | **Metalworking & Crafts** | 5 | Blacksmithing, forge work, working metals, pottery making |

To rebuild or update the Kindle library from source URLs, run:
```bash
./tools-scripts/download-kindle-content.sh
```

## Additional Resources

The repo also includes original source PDFs organized by topic, NOAA weather radio frequencies, topo map URL lists, and helper scripts. See [USAGE.md](USAGE.md) for detailed instructions on using every resource in this kit.

## Large Downloads (not in repo)

Some resources are too large for GitHub. See **[DOWNLOADS.md](DOWNLOADS.md)** for step-by-step instructions:

| Resource | Size | What |
|----------|------|------|
| Wikipedia | ~136 GB | Full English Wikipedia, Wikibooks, Wiktionary (Kiwix ZIM files) |
| Stack Exchange | ~85 GB | Stack Overflow + 14 specialized Q&A sites |
| Medical wiki | ~10 GB | MDWiki medical encyclopedia |
| Topo maps | ~66 GB | 1,729 USGS GeoPDF maps for CA/OR/WA |
| Street maps | ~2 GB | OpenStreetMap data for west coast states |
| Video tutorials | ~1.7 GB | Baofeng radio, solar power, knot tying |
| AI model | ~263 GB | Kimi K2.5 (or use Ollama for lighter models) |

## License

The repository structure, scripts, and documentation are released under [MIT](LICENSE). The books and guides within have their own licenses -- primarily US government works (public domain), WHO/UN freely distributed publications, and Project Gutenberg public domain texts. See individual files for details.
