#!/usr/bin/env python3
"""Convert newly downloaded PDFs to EPUB, keeping smaller format."""
import os, subprocess, shutil, fitz

BASE = "/Users/xyra/Desktop/SHTF/kindle-ready"

# PDFs that are scanned images - skip conversion
IMAGE_HEAVY = {
    "Small_Engine_Service_Repair.pdf",
    "Washington_State_Foraging_Guide.pdf",
    "FM21-76_Survival_TruePrepper.pdf",
    "Baofeng_UV-5R_Overview_K4MSU.pdf",
    "Composting_Toilet_Construction.pdf",
}

# PDFs we already tried converting in round 1 - skip
ALREADY_CONVERTED = {
    "Shelter_Construction_Techniques.pdf", "Saving_Seed_Hawaii_Guide.pdf",
    "Seed_Saving_Guide_Organic_Seed_Alliance.pdf", "Seed_Saving_Guide_Seed_Savers.pdf",
    "Food_Dehydration_Drying_Manual.pdf", "Handbook_of_Food_Preservation.pdf",
    "WHO_Monographs_Medicinal_Plants_Vol1.pdf", "WHO_Monographs_Medicinal_Plants_Vol4.pdf",
    "Where_Women_Have_No_Doctor_2023.pdf", "Celestial_Navigation_Sextant_Intro.pdf",
    "Celestial_Navigation_Short_Guide.pdf", "ARRL_ARES_Field_Resources_Manual.pdf",
    "ARRL_ARES_Plan_2025.pdf", "Baofeng_Radio_Bible_10in1.pdf",
    "Baofeng_Radio_Manual_Archer.pdf", "Baofeng_UV-5R_Programming_Guide.pdf",
    "Baofeng_UV-5R_Quick_Setup.pdf", "UV-5R_Programming_Cheat_Sheet.pdf",
    "CDC_Emergency_Hygiene_Guidelines.pdf", "Sanitation_Hygiene_Guide.pdf",
    "Emergency_Water_Purification_Guide.pdf", "Nuclear_War_Survival_Skills.pdf",
    "Water_Purification_Methods.pdf", "Compendium_Sanitation_Technologies_Emergencies.pdf",
    "Disaster_Sanitation_Planning.pdf", "Emergency_Toilet_Guidebook.pdf",
    "WHO_WASH_Emergency_Risk_Management.pdf", "DIY_Solar_Panel_Build_Guide.pdf",
    "Solar_Electric_System_Design_Operation_Installation.pdf",
    "Saving_Seeds_OSU_Extension.pdf",
}

def is_text_rich(path):
    try:
        doc = fitz.open(path)
        pages = len(doc)
        samples = list(set([0, min(5, pages-1), min(10, pages-1), pages//2]))
        chars = sum(len(doc[p].get_text().strip()) for p in samples if p < pages)
        doc.close()
        return (chars / max(len(samples), 1)) > 200
    except:
        return False

def convert(input_path, output_path):
    size = os.path.getsize(input_path)
    use_heuristics = size < 5 * 1024 * 1024
    timeout = 180 if use_heuristics else 300
    cmd = [
        "ebook-convert", input_path, output_path,
        "--output-profile", "kindle",
        "--change-justification", "left",
        "--insert-blank-line",
        "--remove-paragraph-spacing",
        "--minimum-line-height", "120",
        "--no-default-epub-cover",
    ]
    if use_heuristics:
        cmd.append("--enable-heuristics")
    try:
        r = subprocess.run(cmd, capture_output=True, text=True, timeout=timeout)
        return r.returncode == 0
    except subprocess.TimeoutExpired:
        return False

# Find all PDFs in kindle-ready that don't have a corresponding EPUB
pdfs_to_convert = []
for root, dirs, files in os.walk(BASE):
    for f in files:
        if not f.endswith('.pdf'):
            continue
        if f in IMAGE_HEAVY or f in ALREADY_CONVERTED:
            continue
        epub_name = f.replace('.pdf', '.epub')
        if epub_name in files:
            continue  # already has EPUB companion
        path = os.path.join(root, f)
        if is_text_rich(path):
            pdfs_to_convert.append(path)

print(f"Converting {len(pdfs_to_convert)} new PDFs to EPUB...")
print()

converted = 0
kept_pdf = 0
failed = 0

for i, pdf in enumerate(sorted(pdfs_to_convert)):
    name = os.path.basename(pdf)
    epub = pdf.replace('.pdf', '.epub')
    size_mb = os.path.getsize(pdf) / 1024 / 1024

    print(f"  [{i+1:2d}/{len(pdfs_to_convert)}] {size_mb:5.1f}MB  {name} -> ", end="", flush=True)

    if convert(pdf, epub):
        epub_size = os.path.getsize(epub) / 1024 / 1024
        if epub_size > size_mb * 1.1:  # EPUB bloated
            os.remove(epub)
            print(f"kept PDF (EPUB was {epub_size:.1f}MB)")
            kept_pdf += 1
        else:
            os.remove(pdf)  # Remove PDF, keep EPUB
            saved = size_mb - epub_size
            print(f"EPUB {epub_size:.1f}MB (saved {saved:.1f}MB)")
            converted += 1
    else:
        if os.path.exists(epub):
            os.remove(epub)
        print(f"FAILED, kept PDF")
        failed += 1

print()
print(f"Converted: {converted}, Kept as PDF: {kept_pdf}, Failed: {failed}")
print()

# Final size
total = 0
count = 0
for root, dirs, files in os.walk(BASE):
    for f in files:
        total += os.path.getsize(os.path.join(root, f))
        count += 1
print(f"Total: {count} files, {total/1024/1024:.0f}MB")
