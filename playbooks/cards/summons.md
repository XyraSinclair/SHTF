# Summons Card

**The card that finds you. Fill in, print 6-up, and keep copies where they help. Put it on a phone lock screen only if that is safe for your privacy and situation.**

Six lines. If it doesn't fit on six lines, it's not a summons card.

---

## Template (fill in, then cut down)

```
ICE: ___________________________________  ___-___-____
MEET: _________________________________ (primary)
ME: ___________  MED NOTE: allergies / meds / devices: ___________
BLEEDING → Limb spurting or won't stop? Tourniquet if trained/available. Else press hard.
WATER (clear) → 8 drops unscented bleach per gallon, wait 30 min.
WHAT NOW? → usual default: stay unless this place is unsafe or officials order evacuation.
```

---

## Rules

- **Six lines, no more.** This is the card you look at when you cannot think.
- **Print 6-up on a letter sheet** (6 copies per page). Cut, laminate at FedEx/UPS (~$2 per card).
- **Screenshot it to your phone lock screen only if safe.** For some people, exposed medical or contact info creates risk.
- Put copies in the places that make sense: wallet, go-bag, fridge, vehicle, caregiver binder, or bedside.
- Re-issue annually. Old cards → shred.

The longer cards (`first-aid.md`, `stop-the-bleed.md`, `water-purification.md`, `radiation-shelter.md`) are the deep-dives. This card is the **summons** — it tells a scared person what to do in the first 10 seconds before they can read anything else.

## Why each line

1. **ICE contact** — Paramedics look for this. One number. The out-of-area hub from your comms plan.
2. **Meeting point** — Where your people go when phones don't work. Street address, not a vibe.
3. **You** — Name plus the medical note that would matter if you could not talk: allergies, critical meds, implanted devices, oxygen, insulin, seizure meds, or "none."
4. **Bleeding** — Leading preventable cause of death from trauma. Pressure first. Tourniquet for severe limb bleeding when trained or when no other option is controlling it.
5. **Water** — Clean water is often the first practical constraint. The bleach dose points you back to the water card.
6. **Stay or go** — Staying is often the safer default, but fire, flood, smoke, heat/cold, violence, medical needs, access needs, or an evacuation order can override it.

Generate a blank copy: `./tools-scripts/household-setup.sh`. Fill fields during the run with `./tools-scripts/household-setup.sh --summons`.

Deep-dive sources: [family-comms.md](family-comms.md), [stop-the-bleed.md](stop-the-bleed.md), [water-purification.md](water-purification.md), [../frameworks/stay-or-go.md](../frameworks/stay-or-go.md).
