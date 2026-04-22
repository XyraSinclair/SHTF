# Release notes — 2026-04-21

SHTF is now in a shape I would be comfortable sharing with a serious external audience.

The center of gravity has shifted. Instead of "library you navigate," the repo is now "manila envelope it hands you." One command produces a complete print-once packet. Local AI is now a one-command path built around Gemma 4.

## Headline changes

- **`build-envelope.sh`** generates `playbooks/envelope/` — eleven print-and-staple sections covering tonight, the first weekend, summons cards, blanks for household roster and comms, the killer cards, and water / bleed / first aid. Cover letter reads "Do these first. Ignore the rest until tomorrow." Builds a single PDF when pandoc is installed.
- **`playbooks/cards/tonight.md`** — eight things to do before bed. Twenty minutes. No money. No printer required.
- **`START-HERE.md`** is three doors: *Emergency now* / *I have tonight* / *Building the full kit*. Everything else moves below.
- **`setup-gemma4.sh`** — one command for download + build + GGUF convert + smoke test. Default E2B (~9 GB); `--all` for all four Gemma 4 models. Kimi K2.5 is demoted to a heavyweight footnote.

## Most important surfaces

- `./tools-scripts/build-envelope.sh` — the one thing
- `playbooks/cards/tonight.md`
- `START-HERE.md` — three doors
- `./tools-scripts/get-squared-away.sh`
- `./tools-scripts/setup-gemma4.sh` — optional local AI
- `playbooks/cards/what-kills.md`
- `playbooks/frameworks/stay-or-go.md`

## Framing

- This repo is not a personalized plan.
- The playbooks are defaults, not doctrine.
- The library behind the envelope is the authority layer.
- Local AI is optional and should not be treated as a medical or legal authority.

## Suggested first-run path

1. `./tools-scripts/build-envelope.sh` — the manila envelope
2. `START-HERE.md` — three doors
3. `./tools-scripts/get-squared-away.sh` — canonical bootstrap
4. `playbooks/README.md`
5. `FIELD-INDEX.md`
6. `USAGE.md`
7. `DOWNLOADS.md` — optional large downloads

## Caution when sharing

- Avoid presenting it as comprehensive life advice.
- Present it as an offline household continuity kit with practical defaults and explicit limits.
- The envelope is designed to be printed and walked away from. The rest of the repo is a library to return to when a specific question comes up.
