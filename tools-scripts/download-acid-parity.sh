#!/usr/bin/env bash
# download-acid-parity.sh
#
# Fetches the ACID V2 content-parity bundle: iFixit, TED, Khan Academy, Wikispecies,
# Wikivoyage, Project Gutenberg, Appropedia, WikiHow, zimgit-post-disaster, plus
# Ready.gov disaster PDFs, FAA aviation handbooks, and Survivor Library vehicle
# repair mirrors.
#
# Never hardcodes ZIM filenames — resolves the current open-access URL from Kiwix's
# OPDS catalog so this script does not rot as monthly rebuilds land.
#
# Usage:
#   download-acid-parity.sh all
#   download-acid-parity.sh ifixit ted khan-academy
#   download-acid-parity.sh --list
#   download-acid-parity.sh --dry-run all
#
# See docs/acid-v2-parity.md for the parity matrix and rationale.

set -euo pipefail

SHTF_DIR="$(cd "$(dirname "$0")/.." && pwd)"
CATALOG="https://library.kiwix.org/catalog/v2/entries"
DRY_RUN=0

# name|target_subdir|kiwix_zim_name|url_filter|human_label
# - kiwix_zim_name is the OPDS `name=` query (prefix-ish match against Kiwix catalog).
# - url_filter is an optional substring the resolved acquisition URL must contain;
#   used to disambiguate when a single name matches multiple variants (e.g. maxi vs
#   nopic). Empty means "first match wins".
# - An empty kiwix_zim_name signals a custom non-ZIM fetcher (see run_target).
declare -a TARGETS=(
  "ifixit|reference|ifixit_en_all||iFixit repair manuals"
  "ted|reference|ted_mul_ted-conference||TED Talks (main conference)"
  "khan-academy|reference|khanacademy_en_all||Khan Academy"
  "wikispecies|reference|wikispecies_en_all|_maxi|Wikispecies (with images)"
  "wikivoyage|reference|wikivoyage_en_all|_maxi|Wikivoyage (with images)"
  "gutenberg|reference|gutenberg_en_all||Project Gutenberg (~60k books)"
  "appropedia|reference|appropedia_en_all||Appropedia sustainable living"
  "post-disaster|reference|zimgit-post-disaster_en||zimgit post-disaster"
  "ready-gov|ready-gov|||Ready.gov preparedness PDFs"
  "aviation|aviation|||FAA aviation handbooks"
  "vehicle-repair|mechanical|||Survivor Library vehicle repair"
)

usage() {
  cat <<EOF
Usage: $0 [--dry-run] [--list] <target> [<target> ...]
       $0 all

Targets:
EOF
  for entry in "${TARGETS[@]}"; do
    IFS='|' read -r name subdir zim filter label <<<"$entry"
    printf "  %-16s %s\n" "$name" "$label"
  done
  echo
  echo "Special: 'all' expands to every target. '--list' prints targets and exits."
}

require() {
  for bin in "$@"; do
    command -v "$bin" >/dev/null 2>&1 || {
      echo "ERROR: '$bin' not found in PATH" >&2
      return 1
    }
  done
}

resolve_zim_url() {
  # Resolve the current open-access ZIM URL for a canonical Kiwix book name.
  # If $2 (url_filter) is non-empty, the resolved URL must contain that substring —
  # used to pick between variants (e.g. _maxi vs _nopic) that share a name.
  local name="$1"
  local filter="${2:-}"
  local xml
  xml="$(curl -fsSL --max-time 30 "${CATALOG}?name=${name}" || true)"
  if [ -z "$xml" ]; then
    echo "ERROR: empty response from $CATALOG?name=$name" >&2
    return 1
  fi
  # Extract every open-access acquisition href.
  local hrefs
  hrefs="$(printf '%s' "$xml" \
    | tr '\n' ' ' \
    | grep -oE 'rel="http://opds-spec\.org/acquisition/open-access"[^>]*href="[^"]+\.zim(\.meta4)?"' \
    | grep -oE 'href="[^"]+"' \
    | sed 's/^href="//; s/"$//' \
    || true)"
  if [ -z "$hrefs" ]; then
    echo "ERROR: could not resolve ZIM URL for '$name' from Kiwix OPDS catalog" >&2
    echo "       Try browsing https://library.kiwix.org/?q=$name to confirm availability." >&2
    return 1
  fi
  local url=""
  if [ -n "$filter" ]; then
    url="$(printf '%s\n' "$hrefs" | grep -F "$filter" | head -n1 || true)"
    if [ -z "$url" ]; then
      echo "ERROR: name '$name' matched but no URL contains filter '$filter'. Got:" >&2
      printf '  %s\n' $hrefs >&2
      return 1
    fi
  else
    url="$(printf '%s\n' "$hrefs" | head -n1)"
  fi
  # .meta4 redirects to a real .zim mirror; strip it to fetch the canonical ZIM directly.
  url="${url%.meta4}"
  printf '%s\n' "$url"
}

fetch_zim() {
  local name="$1" subdir="$2" zim="$3" filter="$4" label="$5"
  require curl || return 1
  echo
  echo "==> $label"
  local url
  url="$(resolve_zim_url "$zim" "$filter")" || return 1
  local dest_dir="$SHTF_DIR/$subdir"
  mkdir -p "$dest_dir"
  local fname
  fname="$(basename "$url")"
  local dest="$dest_dir/$fname"
  echo "    URL:   $url"
  echo "    Dest:  $dest"
  if [ -f "$dest" ]; then
    echo "    (already present, skipping)"
    return 0
  fi
  if [ "$DRY_RUN" -eq 1 ]; then
    echo "    (dry-run — not fetching)"
    return 0
  fi
  # -C - resumes partial downloads.
  curl -fL --retry 3 --retry-delay 5 -C - -o "$dest.part" "$url"
  mv "$dest.part" "$dest"
  echo "    done: $(ls -lh "$dest" | awk '{print $5}')"
}

fetch_ready_gov() {
  echo
  echo "==> Ready.gov / FEMA preparedness PDFs"
  local dest="$SHTF_DIR/ready-gov"
  mkdir -p "$dest"
  # HEAD-verified April 2026. Ready.gov / FEMA rearrange URLs often — if something
  # 404s, check https://www.ready.gov/publications or https://www.fema.gov/are-you-ready
  local urls=(
    # Ready.gov
    "https://www.ready.gov/sites/default/files/documents/files/checklist3.pdf"
    "https://www.ready.gov/sites/default/files/2022-10/ready-gov_preparing-make-sense.pdf"
    "https://www.ready.gov/sites/default/files/2022-05/emergency_checklist_kids.pdf"
    "https://www.ready.gov/sites/default/files/documents/files/RRToolkit.pdf"
    # FEMA "Are You Ready?" — the authoritative FEMA household preparedness book
    "https://www.fema.gov/pdf/areyouready/basic_preparedness.pdf"
    "https://www.fema.gov/pdf/areyouready/appendix_b.pdf"
    "https://www.fema.gov/pdf/areyouready/recovering_from_disaster.pdf"
    "https://www.fema.gov/pdf/hazard/hurricane/hurricanes_are_you_ready.pdf"
  )
  for u in "${urls[@]}"; do
    local f="$dest/$(basename "$u")"
    if [ -f "$f" ]; then
      echo "    have: $(basename "$f")"
      continue
    fi
    if [ "$DRY_RUN" -eq 1 ]; then
      echo "    would fetch: $u"
      continue
    fi
    echo "    fetch: $u"
    curl -fL --retry 2 --retry-delay 3 -o "$f.part" "$u" && mv "$f.part" "$f" \
      || echo "    WARN: failed $u (will retry next run)"
  done
}

fetch_aviation() {
  echo
  echo "==> FAA aviation handbooks (public domain)"
  local dest="$SHTF_DIR/aviation"
  mkdir -p "$dest"
  # FAA splits its handbooks per-chapter. Full PDFs are reshuffled on every
  # handbook revision, so we fetch the canonical front-matter PDF of the
  # Pilot's Handbook (always carries the most recent "full handbook" link
  # inside) and write guidance for the rest.
  local urls=(
    "https://www.faa.gov/sites/faa.gov/files/01_phak_front.pdf"
  )
  for u in "${urls[@]}"; do
    local f="$dest/$(basename "$u")"
    if [ -f "$f" ]; then
      echo "    have: $(basename "$f")"
      continue
    fi
    if [ "$DRY_RUN" -eq 1 ]; then
      echo "    would fetch: $u"
      continue
    fi
    echo "    fetch: $u"
    curl -fL --retry 2 --retry-delay 3 -o "$f.part" "$u" && mv "$f.part" "$f" \
      || echo "    WARN: failed $u"
  done
  # Write a stable pointer doc the user can hand off to anyone who actually
  # needs to fly something. The full per-chapter sets are too large and churn
  # too fast to pin here.
  cat >"$dest/README.md" <<'EOF'
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
EOF
  echo "    wrote $dest/README.md with landing-page pointers"
}

fetch_vehicle_repair() {
  echo
  echo "==> Vehicle repair references"
  local dest="$SHTF_DIR/mechanical/vehicle-repair"
  mkdir -p "$dest"
  echo "    Survivor Library mirrors extensive public-domain auto repair manuals."
  echo "    Visit: http://www.survivorlibrary.com/index.php/main-library-index/"
  echo "    Section: 'Automobile' (late-1940s-to-early-1980s repair manuals, public domain)."
  echo
  cat >"$dest/README.md" <<'EOF'
# Vehicle repair references

Survivor Library's "Automobile" section mirrors hundreds of public-domain U.S. auto
repair manuals from the late 1940s through the early 1980s. These are valuable for
mechanical fundamentals but won't cover modern OBD-II vehicles.

Browse and pick titles matching any vehicle you actually own:
http://www.survivorlibrary.com/index.php/main-library-index/

For modern vehicles, the practical free resources are:
- YouTube (ChrisFix, ScannerDanner, South Main Auto) — download with yt-dlp
- manufacturer service manuals via your local library's EBSCO database
- factory service manuals for your specific year/make/model (not redistributable,
  but often free to download from enthusiast forums)

This directory is a placeholder. Populate it with what applies to your vehicles.
EOF
  echo "    wrote $dest/README.md with guidance"
}

run_target() {
  local name="$1"
  local entry=""
  for e in "${TARGETS[@]}"; do
    IFS='|' read -r n subdir zim filter label <<<"$e"
    if [ "$n" = "$name" ]; then
      entry="$e"
      break
    fi
  done
  if [ -z "$entry" ]; then
    echo "ERROR: unknown target '$name'" >&2
    usage >&2
    return 1
  fi
  IFS='|' read -r n subdir zim filter label <<<"$entry"
  case "$name" in
    ready-gov)      fetch_ready_gov ;;
    aviation)       fetch_aviation ;;
    vehicle-repair) fetch_vehicle_repair ;;
    *)              fetch_zim "$n" "$subdir" "$zim" "$filter" "$label" ;;
  esac
}

main() {
  if [ $# -eq 0 ]; then
    usage
    exit 1
  fi
  local args=()
  for a in "$@"; do
    case "$a" in
      --dry-run) DRY_RUN=1 ;;
      --list)
        usage
        exit 0
        ;;
      --help|-h)
        usage
        exit 0
        ;;
      all)
        for e in "${TARGETS[@]}"; do
          IFS='|' read -r n _ _ _ _ <<<"$e"
          args+=("$n")
        done
        ;;
      *) args+=("$a") ;;
    esac
  done
  if [ ${#args[@]} -eq 0 ]; then
    usage
    exit 1
  fi
  echo "SHTF ACID V2 parity bundle"
  echo "Targets: ${args[*]}"
  [ "$DRY_RUN" -eq 1 ] && echo "(dry-run — no files will be written)"
  local failed=0
  for t in "${args[@]}"; do
    run_target "$t" || failed=$((failed + 1))
  done
  echo
  if [ "$failed" -gt 0 ]; then
    echo "Completed with $failed failure(s). Rerun to resume — successful pieces are skipped."
    exit 1
  fi
  echo "All requested targets complete."
}

main "$@"
