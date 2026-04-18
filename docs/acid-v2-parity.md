# ACID V2 parity

This repo is not a product. But a useful sanity check is: can it match or exceed what
a commercial "portable offline internet" device (the Etsy-listed **ACID V2**) claims to
provide? If it can't, that's a real gap in coverage for the person who might otherwise
buy one.

This doc maps each marketed claim against what this repo actually provisions, plus the
exact command to close any gap. The hardware claims (battery, IP67, keyboard, hotspot)
are device-level and outside scope — the *content* claims are in.

## Content parity matrix

| ACID V2 claim | This repo has | Close the gap |
|---|---|---|
| ~60,000 books | 144 curated Kindle-ready books | `download-acid-parity.sh gutenberg` → Project Gutenberg ZIM (~70k) |
| Entire Wikipedia | Pointer in DOWNLOADS.md | `download-acid-parity.sh wikipedia` |
| WikiMed medical encyclopedia | `medical/mdwiki_en_all_*.zim` referenced | Already present if you pulled MDWiki |
| iFixit repair manuals | Missing | `download-acid-parity.sh ifixit` |
| Ready.gov emergency preparedness | Scattered PDFs only | `download-acid-parity.sh ready-gov` |
| Wikispecies animal / insect DB | Missing | `download-acid-parity.sh wikispecies` |
| Wikivoyage geography DB | Pointer only | `download-acid-parity.sh wikivoyage` |
| Apocalypse survival resources | `zimgit-post-disaster_en` referenced | `download-acid-parity.sh post-disaster appropedia` |
| TED Talk videos | Missing | `download-acid-parity.sh ted` |
| Wilderness / camping cookbooks | Covered (`food-water/`, `survival-guides/`) | — |
| Post-disaster recovery | `zimgit-post-disaster_en` | `download-acid-parity.sh post-disaster` |
| Science / outer space / chemistry | Covered via Wikipedia + SE ZIMs | already in DOWNLOADS.md |
| Khan Academy videos | Missing | `download-acid-parity.sh khan-academy` |
| Government disaster survival | FEMA / FM manuals present | — |
| Medicine, history, banking, engineering, CS, aviation, vehicle repair | Partial — missing aviation, vehicle repair | `download-acid-parity.sh aviation vehicle-repair` |

## One-shot: full parity bundle

```bash
./tools-scripts/download-acid-parity.sh all
```

Rough disk cost for the full parity bundle (approximate, English-only, latest ZIMs at
time of writing — exact numbers move as Kiwix rebuilds):

| Piece | Size |
|---|---|
| Project Gutenberg (en, all) | ~75 GB |
| iFixit (en, all) | ~3 GB |
| TED (en, all) | ~40 GB |
| Khan Academy (en) | ~60 GB |
| Wikispecies | ~300 MB |
| Wikivoyage (en, maxi) | ~1 GB |
| Appropedia | ~600 MB |
| zimgit-post-disaster | ~615 MB |
| WikiHow (en, maxi) | ~50 GB |
| Ready.gov pull | ~500 MB |
| FAA aviation handbooks | ~1 GB |
| Vehicle repair (Survivor Library auto) | ~2 GB |

You do **not** need all of this. Pick what matches your risk model. The parity script
accepts any subset:

```bash
./tools-scripts/download-acid-parity.sh ifixit ready-gov post-disaster wikivoyage
```

## How the downloader resolves current files

ZIM filenames include a date (e.g. `ifixit_en_all_2025-10.zim`). Dates drift every
month as Kiwix rebuilds. The script never hardcodes a date — it queries the Kiwix OPDS
catalog for each named ZIM and picks the newest open-access download URL.

If your network is patchy, you can mirror from `download.kiwix.org` directly; the
script prints the resolved URL before fetching so you can retry by hand.

## Why this matters

The ACID V2 listing is a clean articulation of what a non-technical person considers
"offline internet essentials." If a disaster hits and a household only has this repo,
the content parity matrix above is the honest answer to *do we have what they'd have?*

Gaps in the matrix are work items, not marketing copy.
