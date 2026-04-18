# FAA aviation handbooks (public domain)

These are the authoritative, free, redistributable FAA pilot handbooks. All are
U.S. government works — public domain. The FAA publishes them per-chapter PDFs and
reshuffles URLs on every revision, so the full-book links below rot faster than we
can mirror them.

## Canonical landing pages (always current)

- Pilot's Handbook of Aeronautical Knowledge (PHAK, FAA-H-8083-25):
  https://www.faa.gov/regulations_policies/handbooks_manuals/aviation/phak
- Airplane Flying Handbook (FAA-H-8083-3):
  https://www.faa.gov/regulations_policies/handbooks_manuals/aviation/airplane_handbook
- Helicopter Flying Handbook (FAA-H-8083-21):
  https://www.faa.gov/regulations_policies/handbooks_manuals/aviation/helicopter_flying_handbook
- Weight and Balance Handbook (FAA-H-8083-1)
- Aviation Maintenance Technician Handbook — General / Airframe / Powerplant
  (FAA-H-8083-30 / 31 / 32)
- Aeronautical Information Manual (AIM)
- Instrument Flying Handbook (FAA-H-8083-15)
- Instrument Procedures Handbook (FAA-H-8083-16)
- Glider Flying Handbook (FAA-H-8083-13)

## To actually download a full handbook for offline use

Visit the landing page above. Each lists either a single "full handbook" PDF
(~50 MB) or a per-chapter set you can fetch with:

```bash
# Example: mirror every PDF linked from a handbook landing page
wget -r -l1 -H -A pdf -nd -P aviation/phak \
  https://www.faa.gov/regulations_policies/handbooks_manuals/aviation/phak
```

## What's already here

`01_phak_front.pdf` — the PHAK front matter, which is the most stable URL in the
FAA's handbook hierarchy and enough to identify the current revision.
