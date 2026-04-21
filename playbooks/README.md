# Playbooks

Plain-language, decision-tree playbooks for use under stress.

These are the **first three minutes** of a scenario. They point into the authoritative PDFs in this repo for anything deeper. They do not replace the PDFs. They replace the search bar when your hands are shaking.

They are defaults, not doctrine. A useful emergency plan changes for disability, medical dependence, pregnancy, kids, elders, pets, budget, car access, housing type, climate, terrain, local law, and trusted local instructions.

## Map

```
playbooks/
├── tier-1-setup/        Do this once, on a calm weekend. Works whether or not SHTF happens.
├── scenarios/           "It is happening right now. What do I do?" playbooks.
├── frameworks/          Decision tools that apply across many scenarios.
├── cards/               Print-ready single-page references for a go-bag.
└── recovery/            Day 3 to Year 1+. Insurance, FEMA, housing, records, money, mental health.
```

## Where to start

| You are... | Start with |
|-----------|------------|
| New, nothing has happened | [`tier-1-setup/00-first-weekend.md`](tier-1-setup/00-first-weekend.md) |
| Something is actively happening | [`frameworks/stay-or-go.md`](frameworks/stay-or-go.md), then the relevant scenario |
| An AI agent or orientation script | [`../START-HERE.md`](../START-HERE.md) |
| About to travel / go off-grid | [`tier-1-setup/02-go-bag.md`](tier-1-setup/02-go-bag.md) and [`cards/`](cards/) |
| The event has passed; now the aftermath starts | [`recovery/README.md`](recovery/README.md) |

## Quality principles

Every playbook in this directory holds to these:

1. **Opens with "If you only read one line:"** — the first useful default, not a universal answer.
2. **Closes with "Before it happens, do this once:"** — ties back to Tier 1.
3. **Cites sources.** Specific claims point to a PDF and chapter in this repo, or a named authority (FEMA, Red Cross, CDC, WHO). No freehand numbers.
4. **Directive in the moment, humble in scope.** Give a clear default, then name the conditions that override it.
5. **Honest about uncertainty.** When the answer depends on conditions you can't measure, say so and give the conservative default.
6. **3-minute readability test.** A panicked non-prepper can read the whole thing and act in three minutes.
7. **No invented medical or radiological protocols.** Summarize and point to the source.
8. **Personalization matters.** Do not imply one gear list, one evacuation trigger, or one shelter strategy fits everyone.
9. **No bunker aesthetic, no fantasy posturing.** Serious, competent, boring. Good emergency guidance reads like a checklist, not a movie.

## What is cited

Most claims trace to one of these sources, already in this repo:

- **Medical**: `medical/Where_There_Is_No_Doctor_FULL.pdf` (WTND), `medical/Where_There_Is_No_Dentist_FULL.pdf`, `survival-guides/FM4-25.11_First_Aid_Manual.pdf`
- **Nuclear / fallout**: `survival-guides/Nuclear_War_Survival_Skills.pdf` (NWSS — a widely cited civilian source)
- **Water and sanitation**: `survival-guides/Emergency_Water_Purification_Guide.pdf`, `survival-guides/FM21-10_Field_Hygiene_Sanitation.pdf`
- **Navigation**: `survival-guides/FM3-25.26_Map_Reading_Land_Navigation.pdf`
- **Radio**: `radio/UV-5R_Quick_Reference_Card.pdf`, `radio/ARRL_ARES_Field_Resources_Manual.pdf`
- **General survival**: `survival-guides/FM21-76_US_Army_Survival_Manual.pdf`
- **Home canning, food preservation**: `food-water/USDA_Complete_Guide_Home_Canning_2015.pdf`

External authorities referenced (not in repo, but widely available):

- FEMA (`ready.gov`)
- American Red Cross
- CDC (pandemic, radiation)
- WHO (pandemic, WASH)
- USGS (earthquake, volcanic)
- NOAA (weather)

## What this is not

- Not medical advice. For any condition outside basic first aid, defer to WTND and a clinician.
- Not legal advice. Laws on firearms, ham radio, medication storage, self-defense vary by jurisdiction.
- Not a substitute for practice. Reading a tourniquet playbook is not the same as having applied one.
- Not universal. The same advice can be wrong for a renter, a disabled person, an elder alone, a household without a car, someone with a medical device, or a person in a different climate or legal setting.
- Not complete. There are scenarios not covered here (industrial accident, home invasion, active shooter, vehicle accident). Use the frameworks to reason about them.

## Reading order if you have one hour

1. [`frameworks/myths-that-kill.md`](frameworks/myths-that-kill.md) — unlearn the dangerous ones first
2. [`frameworks/stay-or-go.md`](frameworks/stay-or-go.md) — movement versus shelter framework
3. [`tier-1-setup/00-first-weekend.md`](tier-1-setup/00-first-weekend.md) — the prep you do now
4. [`scenarios/01-house-fire.md`](scenarios/01-house-fire.md) — most likely actual emergency
5. [`scenarios/08-nuclear.md`](scenarios/08-nuclear.md) — the scenario most people get wrong
