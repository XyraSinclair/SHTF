#!/bin/bash
# Verify all SHTF resources are properly downloaded and not corrupted

SHTF_DIR="$(cd "$(dirname "$0")/.." && pwd)"
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "==============================================="
echo "     SHTF Resource Verification"
echo "==============================================="
echo ""

errors=0
warnings=0

# macOS stat uses -f%z, Linux uses --format=%s
get_size() { stat -f%z "$1" 2>/dev/null || stat --format=%s "$1" 2>/dev/null; }

# macOS doesn't have numfmt, use awk instead
human_size() {
    local bytes=$1
    if [ "$bytes" -ge 1073741824 ]; then
        echo "$(awk "BEGIN{printf \"%.1fG\", $bytes/1073741824}")"
    elif [ "$bytes" -ge 1048576 ]; then
        echo "$(awk "BEGIN{printf \"%.1fM\", $bytes/1048576}")"
    elif [ "$bytes" -ge 1024 ]; then
        echo "$(awk "BEGIN{printf \"%.1fK\", $bytes/1024}")"
    else
        echo "${bytes}B"
    fi
}

check_file() {
    local path="$1"
    local min_size="$2"
    local desc="$3"

    if [ ! -f "$path" ]; then
        echo -e "  ${RED}MISSING${NC}: $desc"
        ((errors++))
        return
    fi

    local size=$(get_size "$path")
    if [ "$size" -lt "$min_size" ]; then
        echo -e "  ${YELLOW}TOO SMALL${NC}: $desc ($(human_size $size), expected $(human_size $min_size)+)"
        ((warnings++))
    else
        echo -e "  ${GREEN}OK${NC}: $desc ($(du -h "$path" | cut -f1))"
    fi

    # Check for incomplete aria2 download
    if [ -f "${path}.aria2" ]; then
        echo -e "    ${YELLOW}^ Still downloading (aria2 tracking file exists)${NC}"
        ((warnings++))
    fi
}

echo "--- WIKIPEDIA & ENCYCLOPEDIAS ---"
check_file "$SHTF_DIR/wikipedia/wikipedia_en_all_maxi_2025-08.zim" 100000000000 "Full English Wikipedia"
check_file "$SHTF_DIR/wikipedia/wikipedia_es_all_nopic_2025-10.zim" 8000000000 "Spanish Wikipedia"
check_file "$SHTF_DIR/wikipedia/wikibooks_en_all_maxi_2026-01.zim" 4000000000 "English Wikibooks"
check_file "$SHTF_DIR/wikipedia/wiktionary_en_all_nopic_2026-02.zim" 7000000000 "English Wiktionary"
check_file "$SHTF_DIR/wikipedia/wiktionary_es_all_nopic_2025-12.zim" 400000000 "Spanish Wiktionary"
check_file "$SHTF_DIR/wikipedia/wikivoyage_en_all_maxi_2025-12.zim" 900000000 "English Wikivoyage"
check_file "$SHTF_DIR/wikipedia/zimgit-post-disaster_en_2024-05.zim" 500000000 "Post-Disaster Guide"
check_file "$SHTF_DIR/wikipedia/zimgit-food-preparation_en_2025-04.zim" 80000000 "Food Preparation"
check_file "$SHTF_DIR/wikipedia/zimgit-medicine_en_2024-08.zim" 60000000 "Medicine Reference"
check_file "$SHTF_DIR/wikipedia/zimgit-knots_en_2024-08.zim" 20000000 "Knots Reference"
check_file "$SHTF_DIR/wikipedia/zimgit-water_en_2024-08.zim" 15000000 "Water Reference"

echo ""
echo "--- MEDICAL ---"
check_file "$SHTF_DIR/medical/mdwiki_en_all_2025-11.zim" 9000000000 "MDWiki Medical Encyclopedia"
check_file "$SHTF_DIR/medical/Where_There_Is_No_Doctor_FULL.pdf" 5000000 "Where There Is No Doctor"
check_file "$SHTF_DIR/medical/Where_There_Is_No_Dentist_FULL.pdf" 5000000 "Where There Is No Dentist"

echo ""
echo "--- SURVIVAL GUIDES ---"
check_file "$SHTF_DIR/survival-guides/FM21-76_US_Army_Survival_Manual.pdf" 1000000 "US Army Survival Manual"
check_file "$SHTF_DIR/survival-guides/FM21-76_Survival_TruePrepper.pdf" 5000000 "Survival Manual (TruePrepper)"
check_file "$SHTF_DIR/survival-guides/FM21-10_Field_Hygiene_Sanitation.pdf" 3000000 "Field Hygiene & Sanitation"
check_file "$SHTF_DIR/survival-guides/FM4-25.11_First_Aid_Manual.pdf" 1000000 "First Aid Manual"
check_file "$SHTF_DIR/survival-guides/FM3-25.26_Map_Reading_Land_Navigation.pdf" 5000000 "Map Reading Manual"
check_file "$SHTF_DIR/survival-guides/Nuclear_War_Survival_Skills.pdf" 3000000 "Nuclear War Survival Skills"

echo ""
echo "--- SANITATION ---"
check_file "$SHTF_DIR/sanitation/WASH_Emergency_Guidelines.pdf" 10000000 "WASH Emergency Guidelines"
check_file "$SHTF_DIR/sanitation/Sanitation_Hygiene_Guide.pdf" 5000000 "Sanitation & Hygiene Guide"
check_file "$SHTF_DIR/sanitation/CDC_Emergency_Hygiene_Guidelines.pdf" 50000 "CDC Emergency Hygiene"
check_file "$SHTF_DIR/survival-guides/sanitation/Compendium_Sanitation_Technologies_Emergencies.pdf" 5000000 "Sanitation Tech Compendium"
check_file "$SHTF_DIR/survival-guides/sanitation/Emergency_Toilet_Guidebook.pdf" 500000 "Emergency Toilet Guide"

echo ""
echo "--- SOLAR & POWER ---"
check_file "$SHTF_DIR/survival-guides/solar-power/DIY_Solar_Panel_Build_Guide.pdf" 1000000 "DIY Solar Build Guide"
check_file "$SHTF_DIR/survival-guides/solar-power/Solar_Electric_System_Design_Operation_Installation.pdf" 400000 "Solar System Design"
check_file "$SHTF_DIR/power-electrical/NREL_Off_Grid_Solar_Installation_Maintenance.pdf" 2000000 "NREL Off-Grid Solar"
check_file "$SHTF_DIR/power-electrical/Solar_Power_Complete_DIY_Guide_2000W.mp4" 100000000 "Solar DIY Video (2kW)"

echo ""
echo "--- FOOD & WATER ---"
check_file "$SHTF_DIR/food-water/USDA_Complete_Guide_Home_Canning_2015.pdf" 10000000 "USDA Canning Guide"
check_file "$SHTF_DIR/food-water/Washington_State_Foraging_Guide.pdf" 10000000 "WA Foraging Guide"
check_file "$SHTF_DIR/food-water/Seed_Saving_Guide.pdf" 3000000 "Seed Saving Guide"
check_file "$SHTF_DIR/food-water/preservation/Handbook_of_Food_Preservation.pdf" 5000000 "Food Preservation Handbook"

echo ""
echo "--- MAPS ---"
# OSM maps - check actual filenames
for f in "$SHTF_DIR"/maps/*.osm.pbf; do
    [ -f "$f" ] && check_file "$f" 50000000 "$(basename "$f")"
done

# Topo maps
TOPO_COUNT=$(ls "$SHTF_DIR/maps/topo/pdfs/"*.pdf 2>/dev/null | wc -l | tr -d ' ')
TOPO_SIZE=$(du -sh "$SHTF_DIR/maps/topo/pdfs/" 2>/dev/null | cut -f1)
if [ "$TOPO_COUNT" -gt 1000 ]; then
    echo -e "  ${GREEN}OK${NC}: USGS Topo Maps ($TOPO_COUNT maps, $TOPO_SIZE)"
elif [ "$TOPO_COUNT" -gt 0 ]; then
    echo -e "  ${YELLOW}PARTIAL${NC}: USGS Topo Maps ($TOPO_COUNT maps, expected 1729)"
    ((warnings++))
else
    echo -e "  ${RED}MISSING${NC}: USGS Topo Maps"
    ((errors++))
fi

echo ""
echo "--- REFERENCE (Stack Exchange & Stack Overflow) ---"
check_file "$SHTF_DIR/reference/stackoverflow.com_en_all_2023-11.zim" 70000000000 "Stack Overflow"
check_file "$SHTF_DIR/reference/electronics.stackexchange.com_en_all_2026-02.zim" 3000000000 "Electronics SE"
check_file "$SHTF_DIR/reference/diy.stackexchange.com_en_all_2026-02.zim" 1000000000 "DIY SE"
check_file "$SHTF_DIR/reference/physics.stackexchange.com_en_all_2026-02.zim" 1000000000 "Physics SE"
check_file "$SHTF_DIR/reference/gardening.stackexchange.com_en_all_2026-02.zim" 500000000 "Gardening SE"
check_file "$SHTF_DIR/reference/mechanics.stackexchange.com_en_all_2026-02.zim" 200000000 "Mechanics SE"
check_file "$SHTF_DIR/reference/engineering.stackexchange.com_en_all_2026-02.zim" 200000000 "Engineering SE"
check_file "$SHTF_DIR/reference/cooking.stackexchange.com_en_all_2026-02.zim" 150000000 "Cooking SE"
check_file "$SHTF_DIR/reference/outdoors.stackexchange.com_en_all_2026-02.zim" 100000000 "Outdoors SE"
check_file "$SHTF_DIR/reference/ham.stackexchange.com_en_all_2026-02.zim" 50000000 "Ham Radio SE"

echo ""
echo "--- DEVELOPER DOCS ---"
DEVDOC_COUNT=$(ls "$SHTF_DIR/reference/devdocs/"*.zim 2>/dev/null | wc -l | tr -d ' ')
DEVDOC_SIZE=$(du -sh "$SHTF_DIR/reference/devdocs/" 2>/dev/null | cut -f1)
if [ "$DEVDOC_COUNT" -ge 19 ]; then
    echo -e "  ${GREEN}OK${NC}: DevDocs ($DEVDOC_COUNT docs, $DEVDOC_SIZE)"
else
    echo -e "  ${YELLOW}PARTIAL${NC}: DevDocs ($DEVDOC_COUNT of 19 docs)"
    ((warnings++))
fi

echo ""
echo "--- RADIO ---"
check_file "$SHTF_DIR/radio/Baofeng_Radio_Bible_10in1.pdf" 1000000 "Baofeng Radio Bible"
check_file "$SHTF_DIR/radio/ARRL_ARES_Field_Resources_Manual.pdf" 500000 "ARRL ARES Manual"

echo ""
echo "--- OLLAMA MODELS ---"
if command -v ollama &>/dev/null; then
    MODELS=$(ollama list 2>/dev/null | tail -n +2 | wc -l | tr -d ' ')
    echo -e "  ${GREEN}OK${NC}: Ollama installed ($MODELS models)"
    ollama list 2>/dev/null | tail -n +2 | while read line; do
        echo "    $line"
    done
else
    echo -e "  ${RED}MISSING${NC}: Ollama not installed"
    ((errors++))
fi

echo ""
echo "--- APPLICATIONS ---"
for app in "Kiwix" "QGIS"; do
    if [ -d "/Applications/${app}.app" ]; then
        echo -e "  ${GREEN}OK${NC}: $app"
    else
        echo -e "  ${RED}MISSING${NC}: $app (brew install --cask $(echo $app | tr '[:upper:]' '[:lower:]'))"
        ((errors++))
    fi
done

echo ""
echo "==============================================="
echo "Total disk usage: $(du -sh "$SHTF_DIR" | cut -f1)"
echo "Free disk space:  $(df -h / | tail -1 | awk '{print $4}')"
echo "Errors: $errors  Warnings: $warnings"
if [ $errors -eq 0 ] && [ $warnings -eq 0 ]; then
    echo -e "${GREEN}All resources verified!${NC}"
fi
echo "==============================================="
