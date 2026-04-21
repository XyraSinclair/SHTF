# First-run trust shipping tranche

Goal
- Make SHTF feel like a trustworthy offline utility cabinet that a stranger can download, inspect, and use with one command, without feeling ideologically steered or prematurely personalized.

Product intent
- The repo is an offline emergency reference cabinet.
- Playbooks are the front door for what to do.
- The library is the backing authority for what to consult.
- The canonical first action is `./tools-scripts/get-squared-away.sh`.
- Personalization is optional, private, and secondary.

Current state
- Core verification is strong: `verify-all.sh --essential` passes with 0 errors.
- `get-squared-away.sh` already acts as a truthful bootstrap and inventory surface.
- `household-setup.sh` now defaults to blank private templates, which is closer to the desired liability posture.
- The repo recently drifted into a partial advanced-surface rollout around `playbooks/cards/high-signal-field-brief.*`.

What was tightened in this tranche
- Removed top-level and cards-surface references to the untracked `high-signal-field-brief` artifact so the shipped docs only describe tracked, coherent surfaces.
- Corrected `playbooks/cards/README.md` so the summons card is described as filled via `household-setup.sh --summons` or by hand, matching current script behavior.
- Re-verified `git diff --check` and shell parsing for the main scripts after the cleanup.

Acceptance criteria for this shipping tranche
- A fresh downloader can run `./tools-scripts/get-squared-away.sh` and understand what the repo is, what is present, and what to do next.
- `START-HERE.md` acts as a crisis dispatcher, not a worldview or setup funnel.
- `README.md`, `START-HERE.md`, `FIELD-INDEX.md`, `USAGE.md`, and `get-squared-away.sh` agree on the first-run hierarchy.
- `household-setup.sh` is clearly optional and private everywhere it appears.
- No top-level docs reference files or workflows that are not actually shipped.

Remaining work before calling the trust surface fully settled
1. Decide whether `playbooks/cards/high-signal-field-brief.html` and `.pdf` are a real shipped feature.
   - If yes: track them, document them intentionally, and decide whether they belong in `print-cards.sh` or in a clearly separate advanced-print path.
   - If no: keep them local until they have a stable purpose and verification story.
2. Do one final pass over top-level copy for any wording that still sounds lifestyle-ish, ideological, or more prescriptive than necessary.
3. Commit the current documentation/script tranche as one coherent product-positioning change rather than as mixed incidental edits.

Suggested commit scope
- AGENTS.md
- README.md
- START-HERE.md
- FIELD-INDEX.md
- USAGE.md
- playbooks/README.md
- playbooks/cards/README.md
- playbooks/cards/summons.md
- playbooks/frameworks/stay-or-go.md
- playbooks/tier-1-setup/00-first-weekend.md
- playbooks/tier-1-setup/06-digital-hardening.md
- tools-scripts/get-squared-away.sh
- tools-scripts/household-setup.sh

Verification commands
```bash
./tools-scripts/get-squared-away.sh --json
./tools-scripts/verify-all.sh --essential
bash -n tools-scripts/get-squared-away.sh tools-scripts/household-setup.sh tools-scripts/print-cards.sh tools-scripts/verify-all.sh
git diff --check
```

Out of scope for this tranche
- Broad redesign of the repo architecture
- New preparedness content domains
- New local-AI features
- Interactive setup expansion
- Committing or integrating the `high-signal-field-brief` artifact before its role is clear

Operator note for Codex/Hermes
- Protect first-run trust over novelty.
- Do not add advanced or personalized surfaces to the top-level flow unless they are fully shipped, verified, and clearly optional.
- Prefer truthful inventory, dispatch, and file maps over persuasive guidance.
