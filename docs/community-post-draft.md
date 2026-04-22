# Draft post for the rationalist community

I put together an offline household continuity kit that is meant to be practical under stress, not ideological.

The repo's center of gravity is one command:

```bash
./tools-scripts/build-envelope.sh
```

That generates a folder you print once, staple, and put in a manila envelope labeled "Just in case." Eleven sections: a one-page "tonight" sheet, six blank summons cards per letter sheet, blank household roster and comms templates, the first-weekend checklist, the killer cards (what-kills, when-not-to), and water / bleed / first-aid. A PDF builds too if pandoc is installed.

Behind the envelope there's a library — PDFs, offline Wikipedia, maps, scenario runbooks for fire/weather/earthquake/grid-down/nuclear/etc., a recovery playbook for Day 3 to Year 1+, and optional local AI via Gemma 4 (one command: `./tools-scripts/setup-gemma4.sh`).

What I think is distinctive
- it tries to be a prepared object rather than a product
- the envelope is the real output; everything else is a library you return to
- it separates "what to do" from "what to consult"
- it verifies what is actually present instead of pretending all large optional datasets are there
- local AI is a one-command path, not an eight-script tour

If you want the shortest honest demo:
```bash
./tools-scripts/build-envelope.sh     # then look at playbooks/envelope/
./tools-scripts/get-squared-away.sh   # what's present, what's missing
```

If something is actively happening, open:
- `START-HERE.md` — three doors: emergency now / I have tonight / building the full kit

Caveats
- this is not medical or legal advice
- the defaults are not universal
- local official instructions and real household constraints should override generic guidance
- local AI is optional and should not be trusted for dosing, diagnosis, law, or other high-stakes judgment without checking source documents

If you try it, the feedback I most want is not "cool repo" but:
- where did the first-run path feel confusing?
- what felt like unnecessary steering?
- what important real-world use case still feels underspecified?
- does the envelope actually feel printable-and-forgettable, or does it still feel like a project?
