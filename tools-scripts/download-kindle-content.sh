#!/bin/bash
# SHTF Kindle Content Downloader
# Downloads free, public domain survival/preparedness content
# All US government works (public domain) or freely distributed publications

set -euo pipefail

BASE="/Users/xyra/Desktop/SHTF/kindle-ready"
CURL="curl -fSL --connect-timeout 15 --max-time 120 --retry 2 -o"

# Track stats
DOWNLOADED=0
FAILED=0
SKIPPED=0

dl() {
    local dir="$1" file="$2" url="$3"
    mkdir -p "$BASE/$dir"
    local dest="$BASE/$dir/$file"
    if [ -f "$dest" ]; then
        echo "  SKIP (exists) $file"
        ((SKIPPED++)) || true
        return
    fi
    echo "  GET  $file"
    if $CURL "$dest" "$url" 2>/dev/null; then
        local size=$(du -h "$dest" | cut -f1)
        echo "       -> $size"
        ((DOWNLOADED++)) || true
    else
        echo "       -> FAILED"
        rm -f "$dest"
        ((FAILED++)) || true
    fi
}

echo "============================================================"
echo "SHTF KINDLE CONTENT DOWNLOADER"
echo "============================================================"
echo ""

# ============================================================
# 1. US MILITARY FIELD MANUALS (Public Domain)
# ============================================================
echo "=== US MILITARY FIELD MANUALS ==="

dl "02-Survival" "FM3-05.70_Survival.pdf" \
    "https://irp.fas.org/doddir/army/fm3-05-70.pdf"

dl "02-Survival" "FM5-34_Engineer_Field_Data.pdf" \
    "https://www.bits.de/NRANEU/others/amd-us-archive/fm-5-34C3(03).pdf"

dl "02-Survival" "FM3-06_Urban_Operations.pdf" \
    "https://irp.fas.org/doddir/army/fm3-06.pdf"

dl "02-Survival" "FM21-18_Foot_Marches.pdf" \
    "https://www.bits.de/NRANEU/others/amd-us-archive/FM21-18(58).pdf"

dl "02-Survival" "FM3-97.6_Mountain_Operations.pdf" \
    "https://irp.fas.org/doddir/army/fm3-97-6.pdf"

dl "02-Survival" "FM90-5_Jungle_Operations.pdf" \
    "https://irp.fas.org/doddir/army/fm90-5.pdf"

dl "02-Survival" "FM31-70_Cold_Weather_Manual.pdf" \
    "https://upload.wikimedia.org/wikipedia/commons/c/c8/FM-31-70-Basic-Cold-Weather-Manual.pdf"

dl "02-Survival" "ATP3-50.21_Survival_Evasion_Recovery.pdf" \
    "https://irp.fas.org/doddir/army/atp3-50-21.pdf"

dl "02-Survival" "FM5-103_Survivability.pdf" \
    "https://www.bits.de/NRANEU/others/amd-us-archive/fm5-103(85).pdf"

dl "02-Survival" "MCRP3-02F_USMC_Survival.pdf" \
    "https://modernsurvivalonline.com/Files/books/US%20Marine%20Corps%20-%20Survival%20-%20MCRP%203-02F.pdf"

dl "01-Medical" "TC4-02.1_First_Aid.pdf" \
    "https://armypubs.army.mil/epubs/DR_pubs/DR_a/pdf/web/ARN14135_TC%204-02x1%20C2%20INCL%20FINAL%20WEB.pdf"

dl "07-Sanitation" "FM3-34.5_Environmental_Considerations.pdf" \
    "https://www.globalsecurity.org/military/library/policy/army/fm/3-34-5/fm3-34-5.pdf"

# ============================================================
# 2. FEMA / GOVERNMENT EMERGENCY GUIDES (Public Domain)
# ============================================================
echo ""
echo "=== FEMA / GOVERNMENT GUIDES ==="

dl "02-Survival" "FEMA_Are_You_Ready_Guide.pdf" \
    "https://www.ready.gov/sites/default/files/2021-11/are-you-ready-guide.pdf"

dl "02-Survival" "FEMA_CERT_Training_Manual.pdf" \
    "https://www.fema.gov/sites/default/files/2020-07/fema-cert_basic-training-participant-manual_01-01-2011.pdf"

dl "02-Survival" "FEMA_All_Hazard_Info_Sheets.pdf" \
    "https://www.ready.gov/sites/default/files/2025-02/fema_full-suite-hazard-info-sheets.pdf"

dl "02-Survival" "FEMA_Nuclear_Response_72hr.pdf" \
    "https://www.fema.gov/sites/default/files/documents/fema_oet-72-hour-nuclear-detonation-response-guidance.pdf"

dl "02-Survival" "FEMA_Radiological_Emergency_Manual.pdf" \
    "https://www.fema.gov/sites/default/files/documents/fema_npd-rpm-2023.pdf"

dl "10-Construction" "FEMA_P361_Safe_Rooms.pdf" \
    "https://www.fema.gov/sites/default/files/documents/fema_p-361_safe-rooms-for-tornadoes-and-hurricanes_122024.pdf"

dl "10-Construction" "FEMA_P320_Building_Safe_Room.pdf" \
    "https://www.fema.gov/sites/default/files/documents/fema_taking-shelter-from-the-storm_p-320.pdf"

dl "02-Survival" "FEMA_P530_Earthquake_Safety.pdf" \
    "https://www.fema.gov/sites/default/files/2020-08/fema_earthquakes_fema-p-530-earthquake-safety-at-home-march-2020.pdf"

dl "03-Food-Water" "EPA_Emergency_Water_Disinfection.pdf" \
    "https://www.epa.gov/sites/default/files/2017-09/documents/emergency_disinfection_of_drinking_water_sept2017.pdf"

dl "03-Food-Water" "USDA_Kitchen_Companion_Food_Safety.pdf" \
    "https://www.fsis.usda.gov/sites/default/files/media_file/2020-12/Kitchen-Companion.pdf"

dl "03-Food-Water" "USDA_Canning_Meat_Poultry_Game.pdf" \
    "https://www.nifa.usda.gov/sites/default/files/resource/Canning%20Meat%20Poultry%20and%20Game.pdf"

dl "02-Survival" "FEMA_Wildfire_Protection.pdf" \
    "https://www.usfa.fema.gov/downloads/pdf/publications/wildfires_protect_yourself_and_your_community.pdf"

dl "02-Survival" "FEMA_Flood_Damage_Guide.pdf" \
    "https://www.fema.gov/pdf/fima/FEMA511-complete.pdf"

# Water supply engineering
dl "03-Food-Water" "USACE_Water_Supply_Sources.pdf" \
    "https://www.publications.usace.army.mil/Portals/76/Publications/EngineerManuals/EM_1110-2-503.pdf"

dl "03-Food-Water" "USACE_Well_Drilling_Water_Supply.pdf" \
    "https://www.publications.usace.army.mil/portals/76/publications/engineermanuals/em_1110-2-501.pdf"

# ============================================================
# 3. WHO / UN PUBLICATIONS (Freely Distributed)
# ============================================================
echo ""
echo "=== WHO / UN PUBLICATIONS ==="

dl "03-Food-Water" "WHO_Drinking_Water_Quality_Guidelines.pdf" \
    "https://iris.who.int/bitstream/handle/10665/352532/9789240045064-eng.pdf"

dl "03-Food-Water" "WHO_Emergency_Water_Treatment.pdf" \
    "https://cdn.who.int/media/docs/default-source/wash-documents/who-tn-05-emergency-treatment-of-drinking-water-at-the-point-of-use.pdf"

dl "01-Medical" "WHO_Surgical_Care_District_Hospital.pdf" \
    "https://indexmedicus.afro.who.int/iah/fulltext/SCDH.pdf"

dl "01-Medical" "WHO_Safe_Surgery_Guidelines.pdf" \
    "https://iris.who.int/bitstream/handle/10665/44185/9789241598552_eng.pdf"

dl "01-Medical" "WHO_mhGAP_Mental_Health_Guide.pdf" \
    "https://iris.who.int/bitstream/handle/10665/250239/9789241549790-eng.pdf"

dl "01-Medical" "WHO_Essential_Medicines_List_2025.pdf" \
    "https://iris.who.int/server/api/core/bitstreams/17642505-ecd3-4940-a691-4f1dfa0d835a/content"

dl "02-Survival" "Sphere_Handbook_Humanitarian_Standards.pdf" \
    "https://spherestandards.org/wp-content/uploads/Sphere-Handbook-2018-EN.pdf"

dl "01-Medical" "Hesperian_Where_No_Doctor_2024.pdf" \
    "https://hesperian.org/wp-content/uploads/pdf/en_wtnd_2024/en_wtnd_2024_fm.pdf"

# ============================================================
# 4. PEACE CORPS MANUALS (Public Domain)
# ============================================================
echo ""
echo "=== PEACE CORPS MANUALS ==="

dl "03-Food-Water" "PC_Beekeeping_Manual.pdf" \
    "https://files.peacecorps.gov/documents/M0017_Small_Scale_Beekeeping.pdf"

dl "03-Food-Water" "PC_Aquaculture_Training.pdf" \
    "https://files.peacecorps.gov/documents/T0057_Aquaculture-Training-Manual.pdf"

dl "03-Food-Water" "PC_Intensive_Vegetable_Gardening.pdf" \
    "https://files.peacecorps.gov/documents/R0025-Intensive-Vegetable-Gardening.pdf"

dl "03-Food-Water" "PC_Crop_Production_Handbook.pdf" \
    "https://files.peacecorps.gov/documents/R0006_New-Crop-Production-Handbook.pdf"

# ============================================================
# 5. PRACTICAL GUIDES (Freely Distributed)
# ============================================================
echo ""
echo "=== PRACTICAL GUIDES ==="

dl "06-Power-Solar" "Solar_Cooker_Guide.pdf" \
    "https://www.solarcookers.org/files/7914/5687/8521/How_to_make_use_understand_English_Update.pdf"

dl "06-Power-Solar" "DOE_Small_Wind_Guidebook.pdf" \
    "https://windexchange.energy.gov/small-wind-guidebook.pdf"

dl "06-Power-Solar" "FAO_Biogas_Training_Manual.pdf" \
    "https://www.fao.org/4/ae897e/ae897e00.pdf"

dl "03-Food-Water" "Rainwater_Harvesting_Guide.pdf" \
    "https://www.agromisa.org/wp-content/uploads/Agrodok-43-Rainwater-harvesting-for-domestic-use.pdf"

dl "07-Sanitation" "Humanure_Composting_Toilet_Manual.pdf" \
    "https://humanurehandbook.com/downloads/humanure_instruction_manual.pdf"

dl "07-Sanitation" "Composting_Toilet_Construction.pdf" \
    "https://humanurehandbook.com/downloads/Loo_Construction.pdf"

dl "08-Mechanical" "Micro_Hydro_Power_Guide.pdf" \
    "https://attradev.ncat.org/wp-content/uploads/2022/06/microhydrodesign.pdf"

dl "03-Food-Water" "FAO_Improved_Stove_Design.pdf" \
    "https://www.fao.org/4/AD588E/ad588e00.pdf"

dl "01-Medical" "FAO_Primary_Animal_Health_Worker.pdf" \
    "https://www.fao.org/4/i2294e/i2294e00.pdf"

# ============================================================
# 6. PROJECT GUTENBERG (Public Domain EPUBs)
# ============================================================
echo ""
echo "=== PROJECT GUTENBERG BOOKS ==="

# Farming & Gardening
dl "03-Food-Water" "Manual_of_Gardening_Bailey.epub" \
    "https://www.gutenberg.org/ebooks/9550.epub.images"

dl "03-Food-Water" "Ten_Acres_Enough_Morris.epub" \
    "https://www.gutenberg.org/ebooks/48753.epub.images"

dl "03-Food-Water" "Home_Vegetable_Gardening_Rockwell.epub" \
    "https://www.gutenberg.org/ebooks/7123.epub.images"

dl "03-Food-Water" "War_Gardens_Pocket_Guide.epub" \
    "https://www.gutenberg.org/ebooks/63013.epub.images"

dl "03-Food-Water" "Kitchen_Garden_One_Acre.epub" \
    "https://www.gutenberg.org/ebooks/76930.epub.images"

dl "03-Food-Water" "Farm_Gardening_Cheap_Manuring.epub" \
    "https://www.gutenberg.org/ebooks/36064.epub.images"

# Animal Husbandry
dl "03-Food-Water" "Domestic_Animals_Allen.epub" \
    "https://www.gutenberg.org/ebooks/34175.epub.images"

# Woodworking & Carpentry
dl "10-Construction" "Woodwork_Joints_Fairham.epub" \
    "https://www.gutenberg.org/ebooks/21531.epub.images"

dl "10-Construction" "Carpentry_Woodwork_Foster.epub" \
    "https://www.gutenberg.org/ebooks/43574.epub.images"

dl "10-Construction" "Woodworking_Beginners_Wheeler.epub" \
    "https://www.gutenberg.org/ebooks/43604.epub.images"

# Knots & Rope Work
dl "02-Survival" "Knots_Splices_Rope_Work_Verrill.epub" \
    "https://www.gutenberg.org/ebooks/13510.epub.images"

dl "02-Survival" "Use_of_Ropes_and_Tackle.epub" \
    "https://www.gutenberg.org/ebooks/56585.epub.images"

dl "02-Survival" "Knots_Bends_Splices_Jutsum.epub" \
    "https://www.gutenberg.org/ebooks/30983.epub.images"

# Food Preservation
dl "03-Food-Water" "USDA_Canning_Storing_Produce.epub" \
    "https://www.gutenberg.org/ebooks/59977.epub.images"

# Soap Making
dl "08-Mechanical" "Handbook_Soap_Manufacture.epub" \
    "https://www.gutenberg.org/ebooks/21724.epub.images"

# Leather Tanning
dl "08-Mechanical" "Textbook_of_Tanning_Procter.epub" \
    "https://www.gutenberg.org/ebooks/56601.epub.images"

# Herbal Medicine
dl "04-Herbal-Medicine" "Complete_Herbal_Culpeper.epub" \
    "https://www.gutenberg.org/ebooks/49513.epub.images"

dl "04-Herbal-Medicine" "Herbal_Simples_Modern_Cures.epub" \
    "https://www.gutenberg.org/ebooks/19352.epub.images"

# Beekeeping
dl "03-Food-Water" "Bee_Keepers_Manual_Taylor.epub" \
    "https://www.gutenberg.org/ebooks/51813.epub.images"

# Trapping & Hunting
dl "02-Survival" "Deadfalls_and_Snares_Harding.epub" \
    "https://www.gutenberg.org/ebooks/34110.epub.images"

dl "02-Survival" "Fox_Trapping_Harding.epub" \
    "https://www.gutenberg.org/ebooks/34076.epub.images"

dl "02-Survival" "Wolf_Coyote_Trapping_Harding.epub" \
    "https://www.gutenberg.org/ebooks/34501.epub.images"

# Outdoor Skills & Woodcraft
dl "02-Survival" "Woodcraft_and_Camping_Nessmuk.epub" \
    "https://www.gutenberg.org/ebooks/34607.epub.images"

dl "02-Survival" "Camp_Lore_Woodcraft_Beard.epub" \
    "https://www.gutenberg.org/ebooks/44215.epub.images"

# Weaving & Textiles
dl "08-Mechanical" "Cotton_Weaving_Designing.epub" \
    "https://www.gutenberg.org/ebooks/57031.epub.images"

# Practical Chemistry & Arts
dl "08-Mechanical" "Valuable_Curious_Arts_Experiments.epub" \
    "https://www.gutenberg.org/ebooks/38067.epub.images"

# ============================================================
# SUMMARY
# ============================================================
echo ""
echo "============================================================"
echo "DOWNLOAD COMPLETE"
echo "============================================================"
echo "  Downloaded: $DOWNLOADED"
echo "  Failed:     $FAILED"
echo "  Skipped:    $SKIPPED"
echo ""
echo "=== FINAL SIZE ==="
du -sh "$BASE"
echo ""
echo "=== BY CATEGORY ==="
for d in "$BASE"/*/; do
    count=$(find "$d" -type f | wc -l | tr -d ' ')
    size=$(du -sh "$d" | cut -f1)
    echo "  $size  ($count files)  $(basename "$d")"
done
echo ""
echo "Total files:"
find "$BASE" -type f | wc -l
