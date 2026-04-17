# SHTF agent contract

This repo is an offline preparedness kit plus a practical local-AI bundle.
It is not just a pile of files.

If you are an AI agent entering this repo cold, start with:

```bash
./tools-scripts/get-squared-away.sh --json
```

Then read, in order:
1. `START-HERE.md`
2. `FIELD-INDEX.md`
3. `USAGE.md`
4. `DOWNLOADS.md`
5. `docs/local-ai-models.md`
6. `docs/gemma4-llamacpp.md`

## Core intent

Preserve and improve SHTF as something a real person can use under stress:
- emergency medical reference
- water, sanitation, comms, navigation, food, and power guidance
- offline search/browsing via Kiwix/maps
- practical local AI assistance

## Priority order

1. Keep core emergency-doc access clear and fast
2. Keep verification honest about what is actually present
3. Keep the local-AI path practical, especially Gemma 4 via llama.cpp
4. Only then do cosmetic cleanup

## Local AI specifics that matter here

- Gemma 4 is a first-class local path in this repo.
- The four target models are:
  - `gemma-4-E2B-it`
  - `gemma-4-E4B-it`
  - `gemma-4-31B-it`
  - `gemma-4-26B-A4B-it`
- BF16 is the canonical GGUF conversion path.
- `Q4_K_M` is the fast practical path for repeated local inference.
- Do not describe Gemma 4 support as partial if the actual scripts and smoke tests already validate it.

## Repo behavior expectations

- Prefer one canonical command over scattered doc scavenger hunts.
- Do not assume optional large downloads exist; verify them.
- Do not turn the repo into a vague chat wrapper.
- Keep docs concrete, operational, and stress-friendly.
- If changing workflows, update the canonical onboarding surfaces too.

## Canonical bootstrap command

For a fresh downloader or agent, the single orientation command is:

```bash
./tools-scripts/get-squared-away.sh
```

Useful variants:

```bash
./tools-scripts/get-squared-away.sh --full
./tools-scripts/get-squared-away.sh --with-llama-smoke
./tools-scripts/get-squared-away.sh --json --with-llama-smoke
```
