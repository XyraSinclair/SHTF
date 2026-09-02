# Storage Footprint

The storage story for SHTF is easy to misunderstand unless it is split into three buckets:

1. the Git checkout itself
2. optional large offline-reference downloads
3. optional local-model downloads and converted artifacts

Do not confuse the fully loaded maintainer machine with what a fresh downloader gets from GitHub.

## Short Version

As of **September 2, 2026**:

- Fresh tracked checkout from GitHub: about **0.9 GB** of working files
- Local `.git` metadata in this clone: about **735 MB**
- Practical budget for a normal `git clone` + checkout: about **1.6-1.8 GB**
- Fully loaded maintainer working tree with optional downloads and models already present: about **974 GB** (measured April 23, 2026)

The base repo is not a 974 GB download. The 974 GB number is what happens after piling on Wikipedia, Stack Exchange, topo maps, multiple local model stacks, and heavyweight experiments.

## Biggest Tracked Parts Of The Base Repo

These are part of the Git checkout itself, not optional pull-afterward extras.

| Path | Rough size | Notes |
|---|---:|---|
| `kindle-ready/` | ~620 MB | Flattened Kindle library; biggest tracked chunk |
| `food-water/` | ~73 MB | Source PDFs and references |
| `survival-guides/` | ~46 MB | Core field manuals and guides |
| `maps/` | ~58 MB | Tracked map pointers and supporting files, not the giant topo PDFs |
| `sanitation/` | ~49 MB | Bundled references |
| `herbal-medicine/` | ~32 MB | Bundled references |
| `medical/` | ~17 MB tracked | Core PDFs only; MDWiki is an optional extra |
| `radio/` | ~12 MB tracked | Core PDFs only; local extras can make it much larger |
| `playbooks/`, `docs/`, `tools-scripts/` | tiny | Operational glue, not the storage problem |

The biggest single reason the base checkout is already around 0.9 GB is the bundled `kindle-ready/` library.

## Optional Add-Ons: Real Disk Budget

These are the things that make the repo balloon.

| Optional add-on | Rough extra disk | Notes |
|---|---:|---|
| Ollama `qwen3.6` current path | ~17-31 GB | Depends on tag; Apple coding tags are the larger end |
| Raw HF `Qwen3.6-27B` cache | ~52-56 GB | `models/Qwen3.6-27B/` |
| Gemma 4 `E2B` source + BF16 GGUF | ~23 GB retained | About `9.6G` source + `13G` GGUF in this tree |
| Gemma 4 `E4B` source + BF16 GGUF | ~35 GB retained | About `15G` source + `20G` GGUF |
| Gemma 4 `31B` source + BF16 GGUF | ~134 GB retained | About `58G` source + `76G` GGUF |
| Gemma 4 `26B-A4B` source + BF16 GGUF | ~112 GB retained | About `48G` source + `64G` GGUF |
| All four Gemma 4 source + BF16 GGUF | ~303 GB retained | This is why the Gemma path needs real planning |
| MDWiki medical encyclopedia | ~10 GB | Optional offline medical wiki |
| Wikipedia / Kiwix bundle | ~136 GB | Full English Wikipedia plus companion ZIMs |
| Stack Exchange / reference bundle | ~85 GB | Stack Overflow + selected sites |
| Current local `maps/` payload | ~69 GB | Mostly topo PDFs in this working tree |
| `kimi-k2.5/` local checkout | ~263 GB | Heavyweight optional path |

## Budget Tiers

Use this if you just want to know whether the machine is in the right ballpark.

| What you want | Rough total budget |
|---|---:|
| Base repo only, downloaded as ZIP | ~0.9 GB |
| Base repo only, cloned with Git | ~1.6-1.8 GB |
| Base repo + one current Ollama Qwen path | ~20-33 GB |
| Base repo + raw HF Qwen cache | ~54-58 GB |
| Base repo + Gemma 4 E2B retained locally | ~25 GB |
| Base repo + Wikipedia + Stack Exchange + maps | ~290 GB |
| Base repo + all four Gemma 4 retained locally | ~305 GB |
| This maintainer machine right now | ~974 GB |

## Important Caveats

- The Gemma numbers above are **retained disk**, not just download size. The setup flow keeps both source checkpoints and converted GGUF output.
- Leave extra scratch space during conversion. Final retained size is not the same thing as peak temporary disk usage.
- `du` numbers in the maintainer tree include optional content that is **not** part of a fresh GitHub download.
- If you are space-constrained, do not start with giant optional pulls. Start with the base repo and the chooser:

```bash
./tools-scripts/choose-local-model.sh
```

## Related Docs

- [README.md](../README.md)
- [START-HERE.md](../START-HERE.md)
- [DOWNLOADS.md](../DOWNLOADS.md)
- [local-ai-models.md](local-ai-models.md)
