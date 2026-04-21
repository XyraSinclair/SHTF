#!/bin/bash
# Tier-1 prep template generator.
# Default mode asks no questions. It writes plain blank templates that the
# user can print or edit by hand.

set -euo pipefail

SHTF_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PLAYBOOKS="$SHTF_DIR/playbooks"
MODE="blank"
COLLECT_SUMMONS=0
OUT="${SHTF_OUT:-}"

if [ ! -d "$PLAYBOOKS" ]; then
    echo "playbooks/ directory not found at $PLAYBOOKS" >&2
    echo "Run this from a checked-out SHTF repo." >&2
    exit 1
fi

usage() {
    cat <<'EOF'
Usage: ./tools-scripts/household-setup.sh [options]

Default:
  Blank mode. Asks no questions and writes:
    - shtf-personal-checklist.md
    - shtf-summons-card.txt

Options:
  --blank           Write blank templates without asking questions (default)
  --quick           Ask a short household questionnaire
  --full            Ask the longer household-detail questionnaire
  --summons         Fill summons-card fields during this run; stays blank-template mode unless combined with --quick/--full
  --output PATH     Write the checklist to PATH
  --help            Show this help

This script gives you a starting point, not a universal plan. Edit the output
for your household, body, budget, climate, legal setting, and actual hazards.
EOF
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --blank) MODE="blank" ;;
        --quick) MODE="quick" ;;
        --full)
            MODE="full"
            ;;
        --summons) COLLECT_SUMMONS=1 ;;
        --output)
            if [[ $# -lt 2 || -z "${2:-}" ]]; then
                echo "--output requires a path" >&2
                usage >&2
                exit 1
            fi
            OUT="$2"
            shift
            ;;
        --help|-h)
            usage
            exit 0
            ;;
        *)
            echo "Unknown option: $1" >&2
            usage >&2
            exit 1
            ;;
    esac
    shift
done

if [[ -z "${OUT:-}" ]]; then
    OUT="$PWD/shtf-personal-checklist.md"
fi

if [[ "$MODE" = "blank" && "$COLLECT_SUMMONS" -eq 1 ]]; then
    OUT_DIR="$(dirname "$OUT")"
    mkdir -p "$OUT_DIR"
    SUMMONS_OUT="$OUT_DIR/shtf-summons-card.txt"

    echo ""
    echo "--- Summons card fields ---"
    echo "Leave any field blank if you would rather fill it in by hand."
    read -r -p "ICE contact name []: " ICE_NAME
    read -r -p "ICE phone []: " ICE_PHONE
    read -r -p "Primary meeting point []: " MEET_ADDR
    read -r -p "Your name []: " MY_NAME
    read -r -p "Critical medical note (allergies, meds, devices; optional) []: " MY_MED_NOTE

    {
        echo "# Household Preparedness Template"
        echo ""
        echo "*Generated $(date +%Y-%m-%d). Blank by design except for any summons fields you chose to fill here.*"
        echo ""
        echo "This is a worksheet, not advice tailored to you. Change it for disability, medical needs, pregnancy, infants, elders, pets, budget, housing, vehicle access, climate, local law, and local emergency instructions."
        echo ""
        echo "**Do not commit this file with personal data.**"
        echo ""
        echo "## People and Needs"
        echo ""
        echo "- People in household:"
        echo "- Pets or animals:"
        echo "- Medications, devices, power, mobility, sensory, language, or caregiver needs:"
        echo "- Out-of-area contact:"
        echo "- Primary meeting place:"
        echo "- Backup meeting place:"
        echo ""
        echo "## Resource Baseline"
        echo ""
        echo "- Water on hand:"
        echo "- Food on hand:"
        echo "- Lights/batteries:"
        echo "- First-aid supplies:"
        echo "- Cash:"
        echo "- Documents backed up:"
        echo "- Radio / offline info access:"
        echo ""
        echo "## First Three Fixes"
        echo ""
        echo "Pick three. Do not make this complicated."
        echo ""
        echo "- [ ]"
        echo "- [ ]"
        echo "- [ ]"
        echo ""
        echo "## Useful Repo Paths"
        echo ""
        echo "- [START-HERE.md]($SHTF_DIR/START-HERE.md)"
        echo "- [FIELD-INDEX.md]($SHTF_DIR/FIELD-INDEX.md)"
        echo "- [USAGE.md]($SHTF_DIR/USAGE.md)"
        echo "- [first weekend]($SHTF_DIR/playbooks/tier-1-setup/00-first-weekend.md)"
        echo "- [playbooks/cards/]($SHTF_DIR/playbooks/cards/)"
        echo "- [Where There Is No Doctor]($SHTF_DIR/medical/Where_There_Is_No_Doctor_FULL.pdf)"
        echo "- [Emergency Water Purification Guide]($SHTF_DIR/survival-guides/Emergency_Water_Purification_Guide.pdf)"
        echo "- [Emergency Toilet Guidebook]($SHTF_DIR/survival-guides/sanitation/Emergency_Toilet_Guidebook.pdf)"
        echo "- [First Aid Manual]($SHTF_DIR/survival-guides/FM4-25.11_First_Aid_Manual.pdf)"
        echo ""
        echo "## Notes"
        echo ""
        echo "-"
    } > "$OUT"

    {
        echo "SHTF SUMMONS CARD  ($(date +%Y-%m-%d))"
        echo "-----------------------------------------------"
        echo "ICE: ${ICE_NAME:-____________________}  ${ICE_PHONE:-___-___-____}"
        echo "MEET: ${MEET_ADDR:-_______________________________}"
        echo "ME: ${MY_NAME:-__________}"
        echo "MED NOTE: ${MY_MED_NOTE:-allergies / meds / devices: ____________________}"
        echo "BLEEDING -> limb spurting or won't stop? Tourniquet if trained/available; otherwise press hard."
        echo "WATER (clear) -> 8 drops unscented bleach per gallon, wait 30 min."
        echo "WHAT NOW? -> usual default: stay unless this place is unsafe or officials order evacuation."
        echo "-----------------------------------------------"
        echo "Fill privately. Carry one. Screenshot only if that is safe for you."
    } > "$SUMMONS_OUT"

    echo "Wrote blank checklist: $OUT"
    echo "Wrote summons card: $SUMMONS_OUT"
    echo "For a guided questionnaire, run:"
    echo "  ./tools-scripts/household-setup.sh --quick"
    echo "  ./tools-scripts/household-setup.sh --full --summons"
    exit 0
fi

if [ "$MODE" = "blank" ]; then
    OUT_DIR="$(dirname "$OUT")"
    mkdir -p "$OUT_DIR"
    SUMMONS_OUT="$OUT_DIR/shtf-summons-card.txt"

    {
        echo "# Household Preparedness Template"
        echo ""
        echo "*Generated $(date +%Y-%m-%d). Blank by design. Fill this in privately.*"
        echo ""
        echo "This is a worksheet, not advice tailored to you. Change it for disability, medical needs, pregnancy, infants, elders, pets, budget, housing, vehicle access, climate, local law, and local emergency instructions."
        echo ""
        echo "**Do not commit this file with personal data.**"
        echo ""
        echo "## People and Needs"
        echo ""
        echo "- People in household:"
        echo "- Pets or animals:"
        echo "- Medications, devices, power, mobility, sensory, language, or caregiver needs:"
        echo "- Out-of-area contact:"
        echo "- Primary meeting place:"
        echo "- Backup meeting place:"
        echo ""
        echo "## Resource Baseline"
        echo ""
        echo "- Water on hand:"
        echo "- Food on hand:"
        echo "- Lights/batteries:"
        echo "- First-aid supplies:"
        echo "- Cash:"
        echo "- Documents backed up:"
        echo "- Radio / offline info access:"
        echo ""
        echo "## First Three Fixes"
        echo ""
        echo "Pick three. Do not make this complicated."
        echo ""
        echo "- [ ]"
        echo "- [ ]"
        echo "- [ ]"
        echo ""
        echo "## Useful Repo Paths"
        echo ""
        echo "- [START-HERE.md]($SHTF_DIR/START-HERE.md)"
        echo "- [FIELD-INDEX.md]($SHTF_DIR/FIELD-INDEX.md)"
        echo "- [USAGE.md]($SHTF_DIR/USAGE.md)"
        echo "- [first weekend]($SHTF_DIR/playbooks/tier-1-setup/00-first-weekend.md)"
        echo "- [playbooks/cards/]($SHTF_DIR/playbooks/cards/)"
        echo "- [Where There Is No Doctor]($SHTF_DIR/medical/Where_There_Is_No_Doctor_FULL.pdf)"
        echo "- [Emergency Water Purification Guide]($SHTF_DIR/survival-guides/Emergency_Water_Purification_Guide.pdf)"
        echo "- [Emergency Toilet Guidebook]($SHTF_DIR/survival-guides/sanitation/Emergency_Toilet_Guidebook.pdf)"
        echo "- [First Aid Manual]($SHTF_DIR/survival-guides/FM4-25.11_First_Aid_Manual.pdf)"
        echo ""
        echo "## Notes"
        echo ""
        echo "-"
    } > "$OUT"

    {
        echo "SHTF SUMMONS CARD  ($(date +%Y-%m-%d))"
        echo "-----------------------------------------------"
        echo "ICE: ____________________  ___-___-____"
        echo "MEET: _______________________________"
        echo "ME: __________"
        echo "MED NOTE: allergies / meds / devices: ____________________"
        echo "BLEEDING -> limb spurting or won't stop? Tourniquet if trained/available; otherwise press hard."
        echo "WATER (clear) -> 8 drops unscented bleach per gallon, wait 30 min."
        echo "WHAT NOW? -> usual default: stay unless this place is unsafe or officials order evacuation."
        echo "-----------------------------------------------"
        echo "Fill privately. Carry one. Screenshot only if that is safe for you."
    } > "$SUMMONS_OUT"

    echo "Wrote blank checklist: $OUT"
    echo "Wrote blank summons card: $SUMMONS_OUT"
    echo "For a guided questionnaire, run:"
    echo "  ./tools-scripts/household-setup.sh --quick"
    echo "  ./tools-scripts/household-setup.sh --full --summons"
    exit 0
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

num_or_default() {
    local value="$1"
    local default="$2"
    case "$value" in
        ''|*[!0-9]*) echo "$default" ;;
        *) echo "$value" ;;
    esac
}

trim() {
    local s="$*"
    s="${s#"${s%%[![:space:]]*}"}"
    s="${s%"${s##*[![:space:]]}"}"
    printf '%s' "$s"
}

split_concerns() {
    local raw="$1"
    local part
    local -a concern_parts=()
    CONCERNS=()
    [ -z "$raw" ] && return 0
    IFS=',' read -r -a concern_parts <<< "$raw"
    for part in "${concern_parts[@]}"; do
        part="$(trim "$part")"
        [ -n "$part" ] && CONCERNS+=("$part")
    done
}

echo ""
echo "================================================"
echo " SHTF household setup"
echo "================================================"
echo ""
echo "Guided mode asks questions and writes a filled checklist."
echo "Run without flags for blank templates and no questions."
echo ""
echo "This is a starting point. Survival planning is personal: change"
echo "anything that does not fit your body, household, budget, climate,"
echo "legal setting, terrain, or actual hazards."
echo ""
echo "Press Enter to use the default shown in [brackets]."
echo ""

ADULTS=2
KIDS=0
INFANTS=0
PETS=0
MEDS="unknown"
MOBILITY="unknown"
REGION="local area"
HOUSING="home"
HAVE_BASEMENT="unknown"
HAVE_CAR="unknown"
RENTER="unknown"
CRITICAL_NEEDS=""
CONCERNS=()

if [ "$MODE" = "full" ]; then
    echo "--- Full questionnaire ---"
    ADULTS=$(num_or_default "$(ask "Adults in the household" "2")" "2")
    KIDS=$(num_or_default "$(ask "Children under 18" "0")" "0")
    INFANTS=$(num_or_default "$(ask "Children under 2, or diaper/formula needs" "0")" "0")
    PETS=$(num_or_default "$(ask "Pets" "0")" "0")
    MEDS=$(ask_yn "Daily prescription meds in the household" "n")
    MOBILITY=$(ask_yn "Mobility, disability, sensory, or communication needs" "n")
    REGION=$(ask "Region or hazard context" "local area")
    HOUSING=$(ask "Home context (house / apartment / mobile / rural / other)" "home")
    HAVE_BASEMENT=$(ask_yn "Basement or below-grade space available" "n")
    HAVE_CAR=$(ask_yn "Working vehicle available" "y")
    RENTER=$(ask_yn "Rent or lease this home" "n")
    CRITICAL_NEEDS=$(ask "Other critical needs to design around (optional)" "")
    echo ""
    echo "Top concerns, comma-separated. Example: wildfire, insulin, elder alone"
    split_concerns "$(ask "Concerns" "")"
else
    echo "--- Quick questionnaire ---"
    ADULTS=$(num_or_default "$(ask "Adults" "2")" "2")
    KIDS=$(num_or_default "$(ask "Children under 18" "0")" "0")
    if [ "$KIDS" -gt 0 ]; then
        INFANTS=$(num_or_default "$(ask "Children under 2, or diaper/formula needs" "0")" "0")
    fi
    PETS=$(num_or_default "$(ask "Pets" "0")" "0")
    REGION=$(ask "Region or main hazard context" "local area")
    HOUSING=$(ask "Home context (house / apartment / mobile / rural / other)" "home")
    CRITICAL_NEEDS=$(ask "Critical needs to plan around (meds, mobility, power, language, budget; optional)" "")
    echo ""
    echo "Top concerns, comma-separated. Example: wildfire, insulin, elder alone"
    split_concerns "$(ask "Concerns" "")"

    case "$CRITICAL_NEEDS" in
        *[Mm]ed*|*[Rr]x*|*[Ii]nsulin*|*[Oo]xygen*|*[Dd]ialysis*|*[Cc][Pp][Aa][Pp]*) MEDS="yes" ;;
    esac
    case "$CRITICAL_NEEDS" in
        *[Mm]obility*|*[Ww]heelchair*|*[Ww]alker*|*[Dd]isab*|*[Bb]lind*|*[Dd]eaf*|*[Aa]utism*|*[Cc]aregiver*) MOBILITY="yes" ;;
    esac
fi

if [ "$COLLECT_SUMMONS" -eq 1 ]; then
    echo ""
    echo "--- Summons card fields ---"
    echo "Leave any field blank if you would rather fill it in by hand."
    ICE_NAME=$(ask "ICE contact name" "")
    ICE_PHONE=$(ask "ICE phone" "")
    MEET_ADDR=$(ask "Primary meeting point" "")
    MY_NAME=$(ask "Your name" "")
    MY_MED_NOTE=$(ask "Critical medical note (allergies, meds, devices; optional)" "")
else
    ICE_NAME=""
    ICE_PHONE=""
    MEET_ADDR=""
    MY_NAME=""
    MY_MED_NOTE=""
fi

echo ""
echo "Checklist and summons card will be saved beside:"
echo "  $OUT"
echo ""
OUT=$(ask "Save checklist to" "$OUT")

OUT_DIR="$(dirname "$OUT")"
mkdir -p "$OUT_DIR"

household_size=$((ADULTS + KIDS))
water_gallons_14d=$((household_size * 14))
food_days_target=14
review_needs="no"
if [ -n "$CRITICAL_NEEDS" ] || [ "$MEDS" = "yes" ] || [ "$MOBILITY" = "yes" ]; then
    review_needs="yes"
fi

{
    echo "# Household Starting Checklist"
    echo ""
    echo "*Generated $(date +%Y-%m-%d) for $household_size people ($ADULTS adults, $KIDS kids, $PETS pets) in $REGION.*"
    echo ""
    echo "**This is a starting point, not a verdict.** Adapt it for your household, disability and medical needs, pregnancy, elders, kids, pets, languages, budget, climate, local law, and actual hazard profile. For medical, radiological, or legal specifics, use the source documents and local authorities."
    echo ""
    echo "**Do not commit this file.** It is in \`.gitignore\` by pattern, but double-check before pushing."
    echo ""
    echo "---"
    echo ""
    echo "## Starting facts"
    echo ""
    echo "- Household: $household_size people ($ADULTS adults, $KIDS kids, $INFANTS infant/diaper-formula needs), $PETS pets"
    echo "- Home context: $HOUSING"
    echo "- Region or hazard context: $REGION"
    if [ "$MODE" = "full" ]; then
        echo "- Basement or below-grade shelter: $HAVE_BASEMENT"
        echo "- Working vehicle: $HAVE_CAR"
        echo "- Rent/lease: $RENTER"
        echo "- Daily prescription meds in household: $MEDS"
        echo "- Mobility/disability/sensory/communication needs: $MOBILITY"
    fi
    if [ -n "$CRITICAL_NEEDS" ]; then
        echo "- Critical needs noted: $CRITICAL_NEEDS"
    else
        echo "- Critical needs noted: not captured here. Add meds, mobility, power, language, caregiver, and access needs by hand."
    fi
    if [ "${#CONCERNS[@]}" -gt 0 ]; then
        echo "- Top concerns: ${CONCERNS[*]}"
    fi
    echo ""
    echo "## Planning defaults to adapt"
    echo ""
    echo "- **Water default**: $water_gallons_14d gallons for 14 days (1 gal/person/day x $household_size x 14). FEMA uses 1 gallon per person per day as a baseline; heat, illness, pregnancy, nursing, exertion, disability, and pets can raise it."
    echo "- **Food rough target**: ~$((household_size * food_days_target * 2000)) kcal total for 14 days if using a 2,000 kcal/person/day planning number. Real needs vary by person."
    echo "- See [water & food stockpile]($SHTF_DIR/playbooks/tier-1-setup/03-water-food-stockpile.md) before buying specialty food."
    echo ""
    echo "## First pass"
    echo ""
    echo "Pick the first useful three if time, money, or energy is tight."
    echo ""
    echo "- [ ] Fill or print a private household roster"
    echo "- [ ] Pick one out-of-area contact and tell them"
    echo "- [ ] Pick one meeting point near home and one outside the neighborhood"
    echo "- [ ] Locate and label gas, water, and electrical shutoffs"
    echo "- [ ] Save IDs, insurance, medications, and key records somewhere you can reach offline"
    echo "- [ ] Stage flashlights where people sleep"
    echo "- [ ] Store a 3-day water baseline: $((household_size * 3)) gallons, then build toward 14 days if practical"
    echo ""
    echo "## Core checklist"
    echo ""
    echo "Use these as modules. Skip, change, or reorder anything that does not fit your situation."
    echo ""
    echo "- [ ] [Household roster]($SHTF_DIR/playbooks/tier-1-setup/01-household-roster.md)"
    echo "- [ ] [Go-bag per person]($SHTF_DIR/playbooks/tier-1-setup/02-go-bag.md)"
    if [ "$INFANTS" -gt 0 ]; then
        echo "    - [ ] Add infant/diaper-formula supplies that match the child and caregiver routine"
    fi
    if [ "$PETS" -gt 0 ]; then
        echo "    - [ ] Add pet supplies: food, water, leash/carrier, vaccine records, photo"
    fi
    if [ "$review_needs" = "yes" ]; then
        echo "    - [ ] Adapt the bag for meds, mobility, communication, sensory, caregiver, and power needs"
    fi
    echo "- [ ] [Water + food stockpile]($SHTF_DIR/playbooks/tier-1-setup/03-water-food-stockpile.md)"
    echo "- [ ] [Cash + documents]($SHTF_DIR/playbooks/tier-1-setup/04-cash-and-documents.md)"
    echo "- [ ] [Family comms plan]($SHTF_DIR/playbooks/tier-1-setup/05-family-comms-plan.md)"
    echo "- [ ] [Digital hardening]($SHTF_DIR/playbooks/tier-1-setup/06-digital-hardening.md)"
    echo ""
    if [ "$review_needs" = "yes" ]; then
        echo "## Adapt for critical needs"
        echo ""
        echo "Do this before gear shopping. Generic kits miss the needs that fail first."
        echo ""
        echo "- [ ] Read [chronic conditions]($SHTF_DIR/playbooks/cards/chronic-conditions.md)"
        echo "- [ ] Read [disability preparedness]($SHTF_DIR/playbooks/cards/disability-preparedness.md)"
        echo "- [ ] List what must keep working: medication, power, cold chain, mobility, breathing, hearing alerts, vision, communication, sensory regulation, caregiver access"
        echo "- [ ] Make a replacement plan for any single point of failure"
        echo ""
    fi
    echo "## Local priorities to consider"
    echo ""
    case "$REGION" in
        *[Pp]acific*|*PNW*|*[Nn]orthwest*|*[Cc]ascadia*)
            echo "- [ ] If earthquake risk is real for you, read [earthquake - Cascadia]($SHTF_DIR/playbooks/scenarios/03-earthquake-cascadia.md)"
            echo "- [ ] If you are in a tsunami zone, identify high ground and a walking route"
            echo "- [ ] If wildfire smoke or evacuation is plausible, read [wildfire evacuation]($SHTF_DIR/playbooks/scenarios/04-wildfire-evacuation.md)"
            echo "- [ ] Consider ShakeAlert/MyShake and local wildfire alert tools while networks work"
            ;;
        *[Gg]ulf*|*[Hh]urricane*|*[Ff]lorida*|*[Ll]ouisiana*|*[Tt]exas*)
            echo "- [ ] If hurricane or storm surge is plausible, read [severe weather]($SHTF_DIR/playbooks/scenarios/02-severe-weather.md)"
            echo "- [ ] Check your flood zone and insurance reality before storm season"
            echo "- [ ] Pick an evacuation destination that matches your vehicle, pets, budget, and medical needs"
            ;;
        *[Tt]ornado*|*[Mm]idwest*|*[Oo]klahoma*|*[Kk]ansas*)
            echo "- [ ] If tornado risk is plausible, read [severe weather]($SHTF_DIR/playbooks/scenarios/02-severe-weather.md)"
            echo "- [ ] Identify the best available shelter: basement first when available, otherwise lowest interior room without windows"
            echo "- [ ] Consider a NOAA weather radio programmed for your county"
            ;;
        *[Ww]ildfire*|*[Cc]alifornia*|*[Ww]est*)
            echo "- [ ] If wildfire is plausible, read [wildfire evacuation]($SHTF_DIR/playbooks/scenarios/04-wildfire-evacuation.md)"
            echo "- [ ] Register for local emergency alerts"
            echo "- [ ] Check whether defensible-space work is feasible for your home, lease, budget, and body"
            ;;
        *)
            echo "- [ ] Pick the 2-3 scenarios that match your actual area from [playbooks/scenarios/]($SHTF_DIR/playbooks/scenarios/)"
            ;;
    esac
    echo ""
    echo "## Home context"
    echo ""
    case "$HOUSING" in
        *[Aa]partment*|*[Cc]ondo*)
            echo "- [ ] Know two exits from your unit and floor"
            echo "- [ ] Test smoke and CO detectors; do not assume someone else did"
            echo "- [ ] Check whether window bars, stairwells, pets, elevators, or mobility needs change your plan"
            echo "- [ ] Know at least one neighbor on your floor if that is safe for you"
            ;;
        *[Mm]obile*|*[Tt]railer*)
            echo "- [ ] Pre-identify a nearby sturdy shelter for tornado or severe wind"
            echo "- [ ] If fallout sheltering matters, scout a better-shielded nearby structure before you need it"
            echo "- [ ] Check tie-downs if you own the unit and can do so safely"
            ;;
        *[Rr]ural*|*[Ff]arm*)
            echo "- [ ] Plan for well-pump failure if the grid is down"
            echo "- [ ] Check septic, freezer, livestock, and road-access dependencies"
            echo "- [ ] Raise first-aid and communication readiness because response times may be longer"
            ;;
        *)
            echo "- [ ] Test smoke and CO detectors"
            echo "- [ ] Identify the best available interior shelter area for wind or fallout"
            ;;
    esac
    if [ "$MODE" = "full" ]; then
        if [ "$HAVE_BASEMENT" = "yes" ]; then
            echo "- [ ] A basement is often the strongest available shelter for tornado and fallout. Verify access, supplies, and hazards."
        else
            echo "- [ ] Without a basement, pre-identify the best available interior room with the most mass between you and outside."
        fi
    fi
    echo ""
    echo "## Suggested next reading"
    echo ""
    echo "Edit this order. The right order depends on your hazards and household."
    echo ""
    echo "1. [House fire]($SHTF_DIR/playbooks/scenarios/01-house-fire.md)"
    echo "2. [Severe weather]($SHTF_DIR/playbooks/scenarios/02-severe-weather.md)"
    echo "3. [Grid-down extended]($SHTF_DIR/playbooks/scenarios/05-grid-down-extended.md)"
    echo "4. [Stay or go]($SHTF_DIR/playbooks/frameworks/stay-or-go.md)"
    echo "5. [Myths that kill]($SHTF_DIR/playbooks/frameworks/myths-that-kill.md)"
    if [ "${#CONCERNS[@]}" -gt 0 ]; then
        echo ""
        echo "Your listed concerns may also point to:"
        for c in "${CONCERNS[@]}"; do
            case "$c" in
                *[Pp]andemic*|*[Dd]isease*|*[Ff]lu*|*[Cc]ovid*) echo "- [Pandemic]($SHTF_DIR/playbooks/scenarios/06-pandemic.md)" ;;
                *[Cc]yber*|*[Hh]ack*|*[Rr]ansom*|*[Gg]rid*) echo "- [Cyber collapse]($SHTF_DIR/playbooks/scenarios/07-cyber-collapse.md) and [digital hardening]($SHTF_DIR/playbooks/tier-1-setup/06-digital-hardening.md)" ;;
                *[Nn]uke*|*[Nn]uclear*|*[Ff]allout*|*[Rr]adiation*) echo "- [Nuclear]($SHTF_DIR/playbooks/scenarios/08-nuclear.md) and [radiation shelter card]($SHTF_DIR/playbooks/cards/radiation-shelter.md)" ;;
                *[Cc]ivil*|*[Rr]iot*|*[Uu]nrest*|*[Cc]ollapse*) echo "- [Civil unrest / bug-in]($SHTF_DIR/playbooks/scenarios/09-civil-unrest-bug-in.md)" ;;
                *[Ll]ost*|*[Ss]tranded*|*[Cc]ar*) echo "- [Stranded or lost]($SHTF_DIR/playbooks/scenarios/10-stranded-or-lost.md)" ;;
                *[Ww]ild*|*[Ff]ire*) echo "- [Wildfire evacuation]($SHTF_DIR/playbooks/scenarios/04-wildfire-evacuation.md)" ;;
                *[Ee]arthquake*|*[Qq]uake*) echo "- [Earthquake]($SHTF_DIR/playbooks/scenarios/03-earthquake-cascadia.md)" ;;
            esac
        done
    fi
    echo ""
    echo "## Cards to print or save"
    echo ""
    echo "Run \`$SHTF_DIR/tools-scripts/print-cards.sh\` to build the printable cards bundle."
    echo ""
    echo "- [Summons]($SHTF_DIR/playbooks/cards/summons.md)"
    echo "- [What kills]($SHTF_DIR/playbooks/cards/what-kills.md)"
    echo "- [When not to]($SHTF_DIR/playbooks/cards/when-not-to.md)"
    echo "- [First aid]($SHTF_DIR/playbooks/cards/first-aid.md)"
    echo "- [Stop the bleed]($SHTF_DIR/playbooks/cards/stop-the-bleed.md)"
    echo "- [Water purification]($SHTF_DIR/playbooks/cards/water-purification.md)"
    echo "- [Family comms]($SHTF_DIR/playbooks/cards/family-comms.md) (fill in privately)"
    echo ""
    echo "## Review triggers"
    echo ""
    echo "- Seasonal: rotate water, batteries, bleach, and food you actually eat"
    echo "- Household change: move, birth, death, job change, relationship change, new diagnosis, new caregiver, new pet"
    echo "- Local risk change: fire season, storm season, heat, wildfire smoke, civil disruption, travel"
    echo "- If this checklist feels wrong for your life, edit it. That is the point."
    echo ""
    echo "---"
    echo ""
    echo "*Generated by \`tools-scripts/household-setup.sh\`. Re-run or edit any time.*"
} > "$OUT"

SUMMONS_OUT="$(dirname "$OUT")/shtf-summons-card.txt"

[ -z "$ICE_NAME" ] && ICE_NAME="____________________"
[ -z "$ICE_PHONE" ] && ICE_PHONE="___-___-____"
[ -z "$MEET_ADDR" ] && MEET_ADDR="_______________________________"
[ -z "$MY_NAME" ] && MY_NAME="__________"
[ -z "$MY_MED_NOTE" ] && MY_MED_NOTE="allergies / meds / devices: ____________________"

{
    echo "SHTF SUMMONS CARD  ($(date +%Y-%m-%d))"
    echo "-----------------------------------------------"
    echo "ICE: $ICE_NAME  $ICE_PHONE"
    echo "MEET: $MEET_ADDR"
    echo "ME: $MY_NAME"
    echo "MED NOTE: $MY_MED_NOTE"
    echo "BLEEDING -> limb spurting or won't stop? Tourniquet if trained/available; otherwise press hard."
    echo "WATER (clear) -> 8 drops unscented bleach per gallon, wait 30 min."
    echo "WHAT NOW? -> usual default: stay unless this place is unsafe or officials order evacuation."
    echo "-----------------------------------------------"
    echo "Fill privately. Carry one. Screenshot only if that is safe for you."
} > "$SUMMONS_OUT"

echo ""
echo "Checklist written to: $OUT"
echo "Summons card written to: $SUMMONS_OUT"
echo ""
echo "Next steps:"
echo "  1. Open $OUT"
echo "  2. Pick the first useful three tasks"
echo "  3. Print the cards: bash $SHTF_DIR/tools-scripts/print-cards.sh"
echo "  4. Fill $SUMMONS_OUT by hand unless you used --summons"
echo ""
echo "Do not commit your private checklist or summons card to git."
