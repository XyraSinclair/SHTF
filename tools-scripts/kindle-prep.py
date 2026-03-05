#!/usr/bin/env python3
"""
SHTF Kindle Prep - Convert survival PDFs to EPUB for Kindle.
Deduplicates, converts text-rich PDFs, keeps image-heavy PDFs as-is,
and organizes everything into a clean folder structure.
"""

import os
import sys
import subprocess
import shutil
import hashlib
import fitz  # pymupdf

BASE = "/Users/xyra/Desktop/SHTF"
OUTPUT = "/Users/xyra/Desktop/SHTF/kindle-ready"
SKIP_DIRS = {"maps", "kimi-k2.5", "models", "software", "tools-scripts", "wikipedia", "reference", "kindle-ready"}

# Categories for Kindle organization
CATEGORY_MAP = {
    "medical": "01-Medical",
    "survival-guides": "02-Survival",
    "food-water": "03-Food-Water",
    "herbal-medicine": "04-Herbal-Medicine",
    "radio": "05-Radio-Comms",
    "power-electrical": "06-Power-Solar",
    "sanitation": "07-Sanitation",
    "mechanical": "08-Mechanical",
    "navigation": "09-Navigation",
    "construction": "10-Construction",
}

# Known duplicates: map (canonical path -> skip paths)
# We keep the best/fullest version of each
DEDUP_RULES = {
    # Keep the /food-water/preservation copy (same file)
    "USDA_Complete_Guide_Home_Canning_2015.pdf": "food-water/preservation",
    # Keep the named version in survival-guides
    "nuclear-war-survival-skills.pdf": None,  # skip this, keep Nuclear_War_Survival_Skills.pdf
    # Seed saving dupes - keep the Organic Seed Alliance version (most comprehensive name)
    "Seed_Saving_Guide.pdf": None,  # skip, same as Organic_Seed_Alliance version
    "Seed_Saving_Guide_Sovereignty.pdf": None,  # skip, same as Stewardship version
    # Where There Is No Doctor - keep FULL version, skip shorter ones
    "Where_There_Is_No_Doctor_2022.pdf": None,  # skip both copies, we have FULL
    # Water purification dupes
    "survival-water-purification.pdf": None,  # skip, keep Water_Purification_Methods.pdf
    # Where There Is No Dentist - keep FULL
    "Where_There_Is_No_Dentist.pdf": None,  # skip, we have FULL
}

# Image-heavy PDFs (keep as PDF, don't try to convert)
IMAGE_HEAVY = {
    "Small_Engine_Service_Repair.pdf",
    "Washington_State_Foraging_Guide.pdf",
    "FM21-76_Survival_TruePrepper.pdf",
    "Baofeng_UV-5R_Overview_K4MSU.pdf",
}


def get_category_dir(filepath):
    rel = os.path.relpath(filepath, BASE)
    top_dir = rel.split("/")[0]
    return CATEGORY_MAP.get(top_dir, "99-Other")


def should_skip(filepath, filename):
    """Check if this file should be skipped (duplicate)."""
    if filename in DEDUP_RULES:
        preferred_path = DEDUP_RULES[filename]
        if preferred_path is None:
            return True  # Always skip this filename
        if preferred_path not in filepath:
            return True  # Skip copies not in preferred location
    return False


def is_text_rich(filepath, threshold=200):
    """Check if PDF has extractable text."""
    try:
        doc = fitz.open(filepath)
        pages = len(doc)
        text_chars = 0
        sample_pages = list(set([0, min(5, pages - 1), min(10, pages - 1), pages // 2]))
        for p in sample_pages:
            if p < pages:
                text_chars += len(doc[p].get_text().strip())
        doc.close()
        return (text_chars / max(len(sample_pages), 1)) > threshold
    except:
        return False


def convert_to_epub(input_path, output_path):
    """Convert PDF to EPUB using Calibre's ebook-convert."""
    file_size = os.path.getsize(input_path)
    # Use heuristics only for small files (<5MB) — too slow for large ones
    use_heuristics = file_size < 5 * 1024 * 1024
    timeout = 180 if use_heuristics else 300

    cmd = [
        "ebook-convert",
        input_path,
        output_path,
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
        result = subprocess.run(cmd, capture_output=True, text=True, timeout=timeout)
        return result.returncode == 0, result.stderr
    except subprocess.TimeoutExpired:
        return False, f"TIMEOUT after {timeout}s"


def convert_html_to_epub(input_path, output_path, title=""):
    """Convert HTML to EPUB."""
    cmd = [
        "ebook-convert",
        input_path,
        output_path,
        "--output-profile", "kindle",
        "--title", title or os.path.basename(input_path).replace(".html", ""),
    ]
    result = subprocess.run(cmd, capture_output=True, text=True, timeout=300)
    return result.returncode == 0, result.stderr


def main():
    # Clean output dir
    if os.path.exists(OUTPUT):
        shutil.rmtree(OUTPUT)

    # Create category directories
    for cat_dir in CATEGORY_MAP.values():
        os.makedirs(os.path.join(OUTPUT, cat_dir), exist_ok=True)

    # Collect all PDFs (excluding maps, kimi, etc.)
    all_pdfs = []
    for root, dirs, files in os.walk(BASE):
        # Skip excluded dirs
        rel_root = os.path.relpath(root, BASE)
        top_dir = rel_root.split("/")[0]
        if top_dir in SKIP_DIRS:
            continue
        for f in files:
            if f.lower().endswith(".pdf"):
                all_pdfs.append(os.path.join(root, f))

    print(f"Found {len(all_pdfs)} PDFs to process")
    print()

    # Process PDFs
    converted = []
    kept_as_pdf = []
    skipped = []
    failed = []

    for i, pdf_path in enumerate(sorted(all_pdfs)):
        filename = os.path.basename(pdf_path)
        category = get_category_dir(pdf_path)
        size_mb = os.path.getsize(pdf_path) / 1024 / 1024

        # Check for duplicates
        if should_skip(pdf_path, filename):
            print(f"  [{i+1:2d}/{len(all_pdfs)}] SKIP (duplicate) {filename}")
            skipped.append(pdf_path)
            continue

        # Image-heavy: copy as PDF
        if filename in IMAGE_HEAVY:
            dest = os.path.join(OUTPUT, category, filename)
            shutil.copy2(pdf_path, dest)
            dest_size = os.path.getsize(dest) / 1024 / 1024
            print(f"  [{i+1:2d}/{len(all_pdfs)}] PDF  {size_mb:6.1f}MB -> {dest_size:6.1f}MB  {filename}")
            kept_as_pdf.append((pdf_path, dest))
            continue

        # Text-rich: convert to EPUB
        epub_name = filename.replace(".pdf", ".epub")
        dest = os.path.join(OUTPUT, category, epub_name)

        print(f"  [{i+1:2d}/{len(all_pdfs)}] EPUB {size_mb:6.1f}MB -> ", end="", flush=True)
        success, err = convert_to_epub(pdf_path, dest)

        if success and os.path.exists(dest):
            dest_size = os.path.getsize(dest) / 1024 / 1024
            ratio = (1 - dest_size / size_mb) * 100 if size_mb > 0 else 0
            # If EPUB is bigger than PDF, keep the PDF instead
            if dest_size > size_mb * 1.1:  # >10% larger
                os.remove(dest)
                dest_pdf = os.path.join(OUTPUT, category, filename)
                shutil.copy2(pdf_path, dest_pdf)
                print(f"{dest_size:6.1f}MB (bloated) -> kept PDF {size_mb:.1f}MB  {filename}")
                kept_as_pdf.append((pdf_path, dest_pdf))
            else:
                print(f"{dest_size:6.1f}MB ({ratio:+.0f}%) {filename}")
                converted.append((pdf_path, dest, size_mb, dest_size))
        else:
            # Fallback: copy PDF as-is
            dest_pdf = os.path.join(OUTPUT, category, filename)
            shutil.copy2(pdf_path, dest_pdf)
            dest_size = os.path.getsize(dest_pdf) / 1024 / 1024
            print(f"FAIL -> kept PDF {dest_size:6.1f}MB  {filename}")
            if os.path.exists(dest):
                os.remove(dest)
            failed.append((pdf_path, err[:200] if err else "unknown"))
            kept_as_pdf.append((pdf_path, dest_pdf))

    # Also convert HTML and include existing EPUB
    print()
    print("=== Processing non-PDF content ===")

    # Foraging guide HTML
    html_path = os.path.join(BASE, "food-water/Temperate_North_America_Foraging_Guide.html")
    if os.path.exists(html_path):
        dest = os.path.join(OUTPUT, "03-Food-Water", "Temperate_North_America_Foraging_Guide.epub")
        print(f"  Converting HTML foraging guide...")
        success, err = convert_html_to_epub(html_path, dest, "Temperate North America Foraging Guide")
        if success:
            size = os.path.getsize(dest) / 1024 / 1024
            print(f"  -> {size:.1f}MB {os.path.basename(dest)}")
        else:
            print(f"  -> FAILED: {err[:200]}")

    # Existing EPUB
    epub_path = os.path.join(BASE, "survival-guides/survivor-library/Practical_Mechanics.epub")
    if os.path.exists(epub_path):
        dest = os.path.join(OUTPUT, "08-Mechanical", "Practical_Mechanics.epub")
        shutil.copy2(epub_path, dest)
        size = os.path.getsize(dest) / 1024 / 1024
        print(f"  Copied existing EPUB: {size:.1f}MB Practical_Mechanics.epub")

    # NOAA frequencies text -> include as reference
    noaa_path = os.path.join(BASE, "radio/NOAA_Weather_Radio_Frequencies_West_Coast.txt")
    if os.path.exists(noaa_path):
        dest = os.path.join(OUTPUT, "05-Radio-Comms", "NOAA_Weather_Radio_Frequencies_West_Coast.txt")
        shutil.copy2(noaa_path, dest)
        print(f"  Copied NOAA frequencies reference")

    # Summary
    print()
    print("=" * 60)
    print("SUMMARY")
    print("=" * 60)

    total_input_mb = sum(os.path.getsize(p) / 1024 / 1024 for p, *_ in converted + kept_as_pdf)
    total_output = 0
    file_count = 0
    for root, dirs, files in os.walk(OUTPUT):
        for f in files:
            fp = os.path.join(root, f)
            total_output += os.path.getsize(fp)
            file_count += 1

    total_output_mb = total_output / 1024 / 1024

    print(f"  Converted to EPUB:  {len(converted)} files")
    print(f"  Kept as PDF:        {len(kept_as_pdf)} files")
    print(f"  Skipped (dupes):    {len(skipped)} files")
    print(f"  Failed:             {len(failed)} files")
    print(f"  Total output files: {file_count}")
    print(f"  Total output size:  {total_output_mb:.1f}MB")
    print(f"  Space saved:        {total_input_mb - total_output_mb:.1f}MB ({((total_input_mb - total_output_mb)/total_input_mb*100) if total_input_mb > 0 else 0:.0f}%)")
    print()
    print(f"  Output: {OUTPUT}/")
    print()

    # List by category
    print("=== BY CATEGORY ===")
    for cat_dir in sorted(os.listdir(OUTPUT)):
        cat_path = os.path.join(OUTPUT, cat_dir)
        if not os.path.isdir(cat_path):
            continue
        cat_files = os.listdir(cat_path)
        if not cat_files:
            continue
        cat_size = sum(os.path.getsize(os.path.join(cat_path, f)) for f in cat_files) / 1024 / 1024
        print(f"  {cat_dir}/ ({len(cat_files)} files, {cat_size:.1f}MB)")
        for f in sorted(cat_files):
            fsize = os.path.getsize(os.path.join(cat_path, f)) / 1024 / 1024
            print(f"    {fsize:6.1f}MB  {f}")

    if failed:
        print()
        print("=== FAILURES ===")
        for path, err in failed:
            print(f"  {os.path.basename(path)}: {err}")


if __name__ == "__main__":
    main()
