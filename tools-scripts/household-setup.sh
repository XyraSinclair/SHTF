#!/bin/bash
# Interactive Tier-1 prep walkthrough.
# Asks a short set of questions and writes a personalized checklist
# pointing into the relevant playbook files.

set -euo pipefail

SHTF_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PLAYBOOKS="$SHTF_DIR/playbooks"

if [ ! -d "$PLAYBOOKS" ]; then
    echo "playbooks/ directory not found at $PLAYBOOKS" >&2
    echo "Run this from a checked-out SHTF repo." >&2
    exit 1
fi

ask() {
    # ask "question" "default"
    local q="$1"
    local default="${2:-}"
    local reply
    if [ -n "$default" ]; then
        read -r -p "$q [$default]: " reply || true
        echo "${reply:-$default}"
    else
        read -r -p "$q: " reply || true
        echo "$reply"
    fi
}

ask_yn() {
    # ask_yn "question" "default y|n"
    local q="$1"
    local default="${2:-n}"
    local hint="y/N"
    [ "$default" = "y" ] && hint="Y/n"
    local reply
    read -r -p "$q [$hint]: " reply || true
    reply="${reply:-$default}"
    case "$reply" in
        y|Y|yes|YES) echo "yes" ;;
        *) echo "no" ;;
    esac
}

echo ""
echo "======================================================"
echo " SHTF household setup — interactive Tier-1 walkthrough"
echo "======================================================"
echo ""
echo "This will ask ~10 questions and write a personalized checklist"
echo "pointing into the relevant playbooks. Nothing is transmitted"
echo "anywhere. The output file stays on your machine."
echo ""
echo "Press Enter to use the default shown in [brackets]."
echo ""

ADULTS=$(ask "How many adults in the household?" "2")
KIDS=$(ask "How many children (under 18)?" "0")
INFANTS=$(ask "  of which infants (under 2, need formula/diapers)?" "0")
PETS=$(ask "How many pets (dogs/cats)?" "0")
MEDS=$(ask_yn "Does anyone take daily prescription meds?" "n")
MOBILITY=$(ask_yn "Anyone with mobility limitations?" "n")
REGION=$(ask "Region (e.g. Pacific NW, Gulf Coast, Tornado Alley)" "Pacific NW")
HOUSING=$(ask "Housing type (house / apartment / mobile / rural)" "house")
HAVE_BASEMENT=$(ask_yn "Do you have a basement or below-grade space?" "n")
HAVE_CAR=$(ask_yn "Do you have a working vehicle?" "y")
RENTER=$(ask_yn "Do you rent (vs own)?" "n")

echo ""
echo "What are your top 3 concerns? (enter one per line, blank to finish)"
CONCERNS=()
while :; do
    c=$(ask "  concern" "")
    [ -z "$c" ] && break
    CONCERNS+=("$c")
    [ "${#CONCERNS[@]}" -ge 3 ] && break
done

DEFAULT_OUT="$HOME/shtf-personal-checklist.md"
OUT=$(ask "Save checklist to" "$DEFAULT_OUT")

# Ensure target directory exists.
OUT_DIR="$(dirname "$OUT")"
mkdir -p "$OUT_DIR"

household_size=$((ADULTS + KIDS))
water_gallons_14d=$((household_size * 14))
food_days_target=14

{
    echo "# Personal SHTF Checklist"
    echo ""
    echo "*Generated $(date +%Y-%m-%d) for a household of $household_size ($ADULTS adults, $KIDS kids, $PETS pets) in $REGION.*"
    echo ""
    echo "**Do not commit this file.** It is in \`.gitignore\` by pattern, but double-check before pushing."
    echo ""
    echo "---"
    echo ""
    echo "## Your starting stats"
    echo ""
    echo "- Household: $household_size people ($ADULTS adults, $KIDS kids, $INFANTS infants), $PETS pets"
    echo "- Housing: $HOUSING, basement: $HAVE_BASEMENT, vehicle: $HAVE_CAR, rent: $RENTER"
    echo "- Daily meds in household: $MEDS"
    echo "- Mobility limitations: $MOBILITY"
    echo "- Region: $REGION"
    if [ "${#CONCERNS[@]}" -gt 0 ]; then
        echo "- Top concerns: ${CONCERNS[*]}"
    fi
    echo ""
    echo "## Water and food targets (14 days)"
    echo ""
    echo "- **Water**: $water_gallons_14d gallons minimum (1 gal/person/day × $household_size × 14)"
    echo "    - Add ~1 gal/day for each pet dog, 0.25 gal/day for each cat"
    echo "    - Heat, illness, pregnancy, or nursing raises the target"
    echo "- **Food**: ~$((household_size * food_days_target * 2000)) kcal total (2000 kcal/person/day)"
    echo "    - See [water & food stockpile](./playbooks/tier-1-setup/03-water-food-stockpile.md)"
    echo ""
    echo "## This weekend (2-hour minimum)"
    echo ""
    echo "Follow [first-weekend.md](./playbooks/tier-1-setup/00-first-weekend.md)."
    echo ""
    echo "- [ ] Fill the household roster (private copy only)"
    echo "- [ ] Photograph IDs, insurance, deeds, Rx list; put on encrypted USB"
    echo "- [ ] Pick an out-of-area contact hub and tell them"
    echo "- [ ] Pick primary and secondary meeting points"
    echo "- [ ] Locate and label gas, water, electrical shutoffs"
    echo "- [ ] Put \$200–500 cash in small bills somewhere safe"
    echo "- [ ] Fill water to 3-day minimum: $((household_size * 3)) gallons"
    echo ""
    echo "## Tier 1 checklist (full)"
    echo ""
    echo "Each item links to a playbook. Check in order."
    echo ""
    echo "- [ ] [Household roster](./playbooks/tier-1-setup/01-household-roster.md)"
    echo "- [ ] [Go-bag per person](./playbooks/tier-1-setup/02-go-bag.md)"
    if [ "$INFANTS" -gt 0 ]; then
        echo "    - [ ] Add **infant kit** per child: formula, bottles, diapers, wipes, med dropper"
    fi
    if [ "$PETS" -gt 0 ]; then
        echo "    - [ ] Add **pet kit**: 7d food, water, leash, carrier, vax records, photo"
    fi
    if [ "$MEDS" = "yes" ]; then
        echo "    - [ ] **7-day Rx stash** per person (rotated monthly)"
    fi
    echo "- [ ] [Water + food stockpile](./playbooks/tier-1-setup/03-water-food-stockpile.md)"
    echo "- [ ] [Cash + documents](./playbooks/tier-1-setup/04-cash-and-documents.md)"
    echo "- [ ] [Family comms plan](./playbooks/tier-1-setup/05-family-comms-plan.md)"
    echo "- [ ] [Digital hardening](./playbooks/tier-1-setup/06-digital-hardening.md)"
    echo ""
    echo "## Region-specific priorities"
    echo ""
    case "$REGION" in
        *[Pp]acific*|*PNW*|*[Nn]orthwest*|*[Cc]ascadia*)
            echo "- [ ] Read [earthquake — Cascadia](./playbooks/scenarios/03-earthquake-cascadia.md)"
            echo "- [ ] Strap water heater; anchor tall furniture; secure bed from falling objects"
            echo "- [ ] Know if your address is in a **tsunami inundation zone**; identify high ground"
            echo "- [ ] Install [ShakeAlert](https://www.shakealert.org) / MyShake app"
            echo "- [ ] Read [wildfire evacuation](./playbooks/scenarios/04-wildfire-evacuation.md)"
            echo "- [ ] Install Watch Duty app"
            ;;
        *[Gg]ulf*|*[Hh]urricane*|*[Ff]lorida*|*[Ll]ouisiana*|*[Tt]exas*)
            echo "- [ ] Read [severe weather — hurricane](./playbooks/scenarios/02-severe-weather.md)"
            echo "- [ ] Pre-identify evacuation routes and out-of-state destination"
            echo "- [ ] Flood insurance review; know if you're in SFHA (FEMA flood map)"
            echo "- [ ] Board / impact windows for the roof and openings"
            ;;
        *[Tt]ornado*|*[Mm]idwest*|*[Oo]klahoma*|*[Kk]ansas*)
            echo "- [ ] Read [severe weather — tornado](./playbooks/scenarios/02-severe-weather.md)"
            echo "- [ ] Identify safe room: basement, interior room lowest floor, no windows"
            echo "- [ ] NOAA weather radio with S.A.M.E. programmed to your county"
            ;;
        *[Ww]ildfire*|*[Cc]alifornia*|*[Ww]est*)
            echo "- [ ] Read [wildfire evacuation](./playbooks/scenarios/04-wildfire-evacuation.md)"
            echo "- [ ] Defensible space: 0–5 ft non-combustible, 5–30 ft lean/clean/green"
            echo "- [ ] Install Watch Duty app; register for local emergency alerts"
            ;;
        *)
            echo "- [ ] Pick the 2–3 scenarios most likely for your area from [playbooks/scenarios/](./playbooks/scenarios/)"
            ;;
    esac
    echo ""
    echo "## Housing-specific"
    echo ""
    case "$HOUSING" in
        *[Aa]partment*|*[Cc]ondo*)
            echo "- [ ] Know both stairwells; never count on elevators"
            echo "- [ ] Smoke detector and CO detector — test; landlords skip this"
            echo "- [ ] Window bars / fire escape route from your unit"
            echo "- [ ] Neighbors on your floor: know at least one, trade numbers"
            ;;
        *[Mm]obile*|*[Tt]railer*)
            echo "- [ ] Mobile homes offer near-zero tornado / wind protection — pre-identify a nearby sturdy structure"
            echo "- [ ] Radiation shelter option: not your unit. Pre-scout a basement or multi-story building"
            echo "- [ ] Tie-downs inspected annually"
            ;;
        *[Rr]ural*|*[Ff]arm*)
            echo "- [ ] Well pump backup plan (no grid = no water); store >14 days"
            echo "- [ ] Septic: know pump-out plan if power-out > 1 week with heavy use"
            echo "- [ ] Generator sized for freezer + well + fridge at minimum; fuel storage rotation"
            echo "- [ ] EMS response times longer — raise first-aid skill floor; CPR + Stop the Bleed class"
            ;;
        *)
            echo "- [ ] Check smoke + CO detectors monthly"
            echo "- [ ] Identify interior safe room (lowest floor, no windows) for tornado/fallout"
            ;;
    esac
    echo ""
    if [ "$HAVE_BASEMENT" = "yes" ]; then
        echo "- [ ] **You have a basement.** This is your best shelter for tornado and radiation. Read [radiation shelter card](./playbooks/cards/radiation-shelter.md)."
    else
        echo "- [ ] **No basement.** Pre-identify the best interior room (lowest floor, most walls between you and outside) for tornado/fallout shelter."
    fi
    echo ""
    echo "## Scenarios to read this month (in order)"
    echo ""
    echo "Read one per evening. 10-15 min each."
    echo ""
    echo "1. [House fire](./playbooks/scenarios/01-house-fire.md) — most likely real emergency"
    echo "2. [Severe weather](./playbooks/scenarios/02-severe-weather.md) — pick your region's section"
    echo "3. [Grid-down extended](./playbooks/scenarios/05-grid-down-extended.md)"
    echo "4. [Stay or go](./playbooks/frameworks/stay-or-go.md) — the single most important call"
    echo "5. [Triage](./playbooks/frameworks/triage.md)"
    echo "6. [Myths that kill](./playbooks/frameworks/myths-that-kill.md)"
    if [ "${#CONCERNS[@]}" -gt 0 ]; then
        echo ""
        echo "Your listed concerns suggest also reading:"
        for c in "${CONCERNS[@]}"; do
            case "$c" in
                *[Pp]andemic*|*[Dd]isease*|*[Ff]lu*|*[Cc]ovid*) echo "- [Pandemic](./playbooks/scenarios/06-pandemic.md)" ;;
                *[Cc]yber*|*[Hh]ack*|*[Rr]ansom*|*[Gg]rid*) echo "- [Cyber collapse](./playbooks/scenarios/07-cyber-collapse.md) and [digital hardening](./playbooks/tier-1-setup/06-digital-hardening.md)" ;;
                *[Nn]uke*|*[Nn]uclear*|*[Ff]allout*|*[Rr]adiation*) echo "- [Nuclear](./playbooks/scenarios/08-nuclear.md) and [radiation shelter card](./playbooks/cards/radiation-shelter.md)" ;;
                *[Cc]ivil*|*[Rr]iot*|*[Uu]nrest*|*[Cc]ollapse*) echo "- [Civil unrest / bug-in](./playbooks/scenarios/09-civil-unrest-bug-in.md)" ;;
                *[Ll]ost*|*[Ss]tranded*|*[Cc]ar*) echo "- [Stranded or lost](./playbooks/scenarios/10-stranded-or-lost.md)" ;;
                *[Ww]ild*|*[Ff]ire*) echo "- [Wildfire evacuation](./playbooks/scenarios/04-wildfire-evacuation.md)" ;;
                *[Ee]arthquake*|*[Qq]uake*) echo "- [Earthquake](./playbooks/scenarios/03-earthquake-cascadia.md)" ;;
            esac
        done
    fi
    echo ""
    echo "## Print these cards and put them in your go-bag"
    echo ""
    echo "Run \`tools-scripts/print-cards.sh\` to bundle into PDF."
    echo ""
    echo "- [First aid](./playbooks/cards/first-aid.md)"
    echo "- [Stop the bleed](./playbooks/cards/stop-the-bleed.md)"
    echo "- [Water purification](./playbooks/cards/water-purification.md)"
    echo "- [Radiation shelter](./playbooks/cards/radiation-shelter.md)"
    echo "- [Radio frequencies](./playbooks/cards/radio-frequencies.md)"
    echo "- [Family comms](./playbooks/cards/family-comms.md) (fill in)"
    echo ""
    echo "## Review schedule"
    echo ""
    echo "- Every 6 months: rotate water, bleach, batteries; review roster"
    echo "- Annually: full kit audit, family drill, update family comms card"
    echo "- After any major life change (move, birth, job, relationship): re-run \`household-setup.sh\`"
    echo ""
    echo "---"
    echo ""
    echo "*Generated by \`tools-scripts/household-setup.sh\`. Re-run any time — the checklist is regenerated from scratch.*"
} > "$OUT"

echo ""
echo "✅ Checklist written to: $OUT"
echo ""
echo "Next steps:"
echo "  1. Open $OUT in your editor of choice"
echo "  2. Walk through the 'This weekend' section today"
echo "  3. Print the cards: bash tools-scripts/print-cards.sh"
echo ""
echo "Do not commit your personal checklist to git."
