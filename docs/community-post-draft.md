# Draft post for the rationalist community

I put together an offline emergency reference cabinet that is meant to be practical under stress, not ideological.

The repo has two layers:
- playbooks for what to do first
- a library for what to look up when you need details

The goal is not to hand people a universal life plan. The goal is to give them something they can download, inspect locally, and still use if utilities fail or the internet is gone.

What is in it
- printable emergency cards
- scenario playbooks
- medical, water, sanitation, radio, navigation, and power references
- offline-library support surfaces
- optional local-AI workflows for summarization and reference navigation

What I think is distinctive
- it tries hard not to oversteer
- it separates "what to do" from "what to consult"
- it verifies what is actually present instead of pretending all large optional datasets are there
- it now has a cleaner first-run path

If you want the shortest honest demo:
```bash
./tools-scripts/get-squared-away.sh
```

That tells you what the repo is, what is ready now, and what to open next.

If something is actively happening, open:
- `START-HERE.md`

If you want the printable operational layer:
```bash
./tools-scripts/print-cards.sh
```

Caveats
- this is not medical or legal advice
- the defaults are not universal
- local official instructions and real household constraints should override generic guidance
- local AI is optional and should not be trusted for dosing, diagnosis, law, or other high-stakes judgment without checking source documents

If you try it, the feedback I most want is not "cool repo" but:
- where did the first-run path feel confusing?
- what felt like unnecessary steering?
- what important real-world use case still feels underspecified?
