# START HERE

Three doors. Pick one.

---

## 🚨 Door 1 — Something is happening right now

Pick the closest match. Open one page. Adapt for the people actually with you.

| If… | Open |
|-----|------|
| Someone is bleeding hard | [cards/stop-the-bleed.md](playbooks/cards/stop-the-bleed.md) |
| Someone is hurt or sick and you cannot reach emergency services | [cards/first-aid.md](playbooks/cards/first-aid.md) · `medical/Where_There_Is_No_Doctor_FULL.pdf` |
| No clean water | [cards/water-purification.md](playbooks/cards/water-purification.md) |
| House is on fire | [scenarios/01-house-fire.md](playbooks/scenarios/01-house-fire.md) |
| Tornado / hurricane / blizzard warning | [scenarios/02-severe-weather.md](playbooks/scenarios/02-severe-weather.md) |
| Ground just shook | [scenarios/03-earthquake-cascadia.md](playbooks/scenarios/03-earthquake-cascadia.md) |
| Wildfire close / heavy smoke | [scenarios/04-wildfire-evacuation.md](playbooks/scenarios/04-wildfire-evacuation.md) |
| Power out > 24 hours | [scenarios/05-grid-down-extended.md](playbooks/scenarios/05-grid-down-extended.md) |
| Novel disease wave | [scenarios/06-pandemic.md](playbooks/scenarios/06-pandemic.md) |
| Banks, payments, phones down | [scenarios/07-cyber-collapse.md](playbooks/scenarios/07-cyber-collapse.md) |
| Flash, fallout warning, reactor alert | [scenarios/08-nuclear.md](playbooks/scenarios/08-nuclear.md) · [cards/radiation-shelter.md](playbooks/cards/radiation-shelter.md) |
| Civil unrest, sheltering in place | [scenarios/09-civil-unrest-bug-in.md](playbooks/scenarios/09-civil-unrest-bug-in.md) |
| Stranded in car, boat, plane, on foot | [scenarios/10-stranded-or-lost.md](playbooks/scenarios/10-stranded-or-lost.md) |
| Someone panicking; child terrified | [cards/psychological-first-aid.md](playbooks/cards/psychological-first-aid.md) |
| Insulin / oxygen / dialysis / heart meds involved | [cards/chronic-conditions.md](playbooks/cards/chronic-conditions.md) |
| Kid with you needs clear instructions | [cards/kids-what-to-do.md](playbooks/cards/kids-what-to-do.md) |
| The event has passed; insurance/FEMA/bills start | [recovery/README.md](playbooks/recovery/README.md) |
| Don't know — just scared | [frameworks/stay-or-go.md](playbooks/frameworks/stay-or-go.md) |

**Default movement rule:** stay where you are unless staying is unsafe or officials order evacuation. Fire, flood in the house, smoke, violence, or an evacuation order override that. See [stay-or-go.md](playbooks/frameworks/stay-or-go.md).

---

## 🌙 Door 2 — I have tonight

You have one evening. You are not trying to become a prepper. You are trying to not feel helpless.

```bash
./tools-scripts/build-envelope.sh
```

That creates [`playbooks/envelope/`](playbooks/envelope/) — a folder of 11 files to print once and put in a manila envelope. Tonight sheet, summons cards 6-up, blank household roster, first-weekend checklist, the killer cards, water/bleeding/first aid. One command. That's it.

If you cannot run a shell script, just open [`playbooks/cards/tonight.md`](playbooks/cards/tonight.md) and do the eight things before bed. Twenty minutes, zero dollars.

---

## 🧰 Door 3 — I am building the full kit

One weekend of real work, then ongoing.

Storage reality before you start downloading extras: the base repo is about **0.9 GB** of tracked files, but a fully loaded machine with optional maps, Wikipedia, reference bundles, and local models can exceed **900 GB**. Read [docs/storage-footprint.md](docs/storage-footprint.md) before pulling giant add-ons.

1. Read [`playbooks/tier-1-setup/00-first-weekend.md`](playbooks/tier-1-setup/00-first-weekend.md) — the canonical first weekend.
2. Before buying gear, read [`cards/what-kills.md`](playbooks/cards/what-kills.md) and [`cards/when-not-to.md`](playbooks/cards/when-not-to.md). They change what you buy.
3. If any of these describe your household, read the matching card first:
   - Kids → [kids-parents-guide.md](playbooks/cards/kids-parents-guide.md)
   - Elderly relative alone → [elderly-alone-prep.md](playbooks/cards/elderly-alone-prep.md)
   - Disability, medical equipment, specialty meds → [disability-preparedness.md](playbooks/cards/disability-preparedness.md)
   - Renting / apartment → [renter-preparedness.md](playbooks/cards/renter-preparedness.md)
   - Tight budget → [low-income-no-spend-prep.md](playbooks/cards/low-income-no-spend-prep.md)
4. Then review what's set up and what isn't:

   ```bash
   ./tools-scripts/get-squared-away.sh
   ./tools-scripts/verify-all.sh --essential
   ```

   If you want local AI, do not guess from memory. Run:

   ```bash
   ./tools-scripts/choose-local-model.sh
   ```

   It prints the exact next steps for this machine. If the Ollama path feels too heavy or too fussy, the self-contained fallback is `Gemma 4 E2B` via `./tools-scripts/setup-gemma4.sh E2B`.

---

## Deeper when you want it

Once the envelope is printed and the weekend is done, the rest of the repo is a library you can use when a specific question comes up.

- [README.md](README.md) — what's in the box
- [playbooks/README.md](playbooks/README.md) — the complete playbook index
- [FIELD-INDEX.md](FIELD-INDEX.md) — file-level index
- [USAGE.md](USAGE.md) — scenario-based library usage
- [DOWNLOADS.md](DOWNLOADS.md) — optional large downloads (Wikipedia, maps, AI models)
- [docs/storage-footprint.md](docs/storage-footprint.md) — what the repo itself costs versus the giant optional extras
- [docs/local-ai-models.md](docs/local-ai-models.md) — local AI chooser, current Qwen/Ollama path, Gemma 4 fallback, raw Qwen cache

### Scripts

| Command | Purpose |
|---------|---------|
| `./tools-scripts/build-envelope.sh` | Generate the manila envelope (the one thing) |
| `./tools-scripts/get-squared-away.sh` | Canonical orientation; writes a report |
| `./tools-scripts/verify-all.sh --essential` | Check the life-support library |
| `./tools-scripts/verify-all.sh --full` | Check everything including optional |
| `./tools-scripts/household-setup.sh` | Blank private templates; `--quick` / `--full --summons` for more |
| `./tools-scripts/print-cards.sh` | Bundle every emergency card (not just the envelope) |
| `./tools-scripts/launch-wikipedia.sh` | Open Kiwix (offline reference) |
| `./tools-scripts/launch-maps.sh` | Open offline maps |
| `./tools-scripts/serve-local-network.sh` | Serve ZIMs and files on a household LAN |
| `./tools-scripts/choose-local-model.sh` | Recommend a local model from RAM, free disk, and platform |
| `python3 ./tools-scripts/set-opencode-model.py ...` | Point the repo-local OpenCode config at the model you actually pulled |
| `./tools-scripts/download-qwen36-27b.py` | Priority high-capability local model cache |
| `./tools-scripts/setup-gemma4.sh` | Optional local AI (Gemma 4, E2B default; `--all` for all four) |

## A note on defaults

Survival is personal. The playbooks give conservative defaults for a healthy adult in a detached house. Change them for your body, household, climate, terrain, budget, medical needs, disability access, pets, local law, and official instructions. You are not behind. Starting now is enough.
