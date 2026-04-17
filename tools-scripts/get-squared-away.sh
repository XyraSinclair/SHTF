#!/bin/bash
set -u -o pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
VERIFY_MODE="essential"
REPORT_PATH="$ROOT/.shtf-squared-away-report.txt"
JSON_MODE=0
JSON_PATH="$ROOT/.shtf-squared-away-report.json"
RUN_LLAMA_SMOKE=0

VERIFY_RC=""
AUDIT_RC=""
INVENTORY_RC=""
LLAMA_SMOKE_RC="skipped"

usage() {
  cat <<'EOF'
Usage: ./tools-scripts/get-squared-away.sh [options]

Purpose:
  Give a fresh downloader or AI agent the fastest honest orientation path for this repo.
  It prints what SHTF is, what is ready now, what is optional, and the exact next commands.

Options:
  --essential          Run essential verification only (default)
  --full               Run full verification, including optional large resources/models when present
  --with-llama-smoke   If local Gemma 4 llama.cpp artifacts already exist, run the fast Q4_K_M smoke test too
  --json               Also write a machine-readable JSON summary for agents
  --json-path PATH     Where to write the JSON summary (default: .shtf-squared-away-report.json)
  --report-path PATH   Where to write the text report (default: .shtf-squared-away-report.txt)
  --help               Show this help
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --essential) VERIFY_MODE="essential" ;;
    --full) VERIFY_MODE="full" ;;
    --with-llama-smoke) RUN_LLAMA_SMOKE=1 ;;
    --json) JSON_MODE=1 ;;
    --json-path)
      JSON_MODE=1
      JSON_PATH="${2:-}"
      shift
      ;;
    --report-path)
      REPORT_PATH="${2:-}"
      shift
      ;;
    --help|-h) usage; exit 0 ;;
    *)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
  shift
done

if [[ -z "$REPORT_PATH" ]]; then
  echo "--report-path requires a non-empty path" >&2
  exit 1
fi

if [[ $JSON_MODE -eq 1 && -z "$JSON_PATH" ]]; then
  echo "--json-path requires a non-empty path" >&2
  exit 1
fi

mkdir -p "$(dirname "$REPORT_PATH")"
if [[ $JSON_MODE -eq 1 ]]; then
  mkdir -p "$(dirname "$JSON_PATH")"
fi

log() {
  printf '%s\n' "$*" | tee -a "$REPORT_PATH"
}

run_logged() {
  local title="$1"
  shift
  log ""
  log "### $title"
  log ">$*"
  "$@" 2>&1 | tee -a "$REPORT_PATH"
  local rc=${PIPESTATUS[0]}
  log "[exit=$rc]"
  return $rc
}

path_status() {
  local path="$1"
  if [[ -e "$path" ]]; then
    echo true
  else
    echo false
  fi
}

: > "$REPORT_PATH"

log "============================================================"
log "SHTF squared-away bootstrap"
log "============================================================"
log "Repo: $ROOT"
log "Report: $REPORT_PATH"
if [[ $JSON_MODE -eq 1 ]]; then
  log "JSON: $JSON_PATH"
fi
log ""
log "What this repo is:"
log "- an offline survival/reference library"
log "- a practical local-AI bundle with Gemma 4 and llama.cpp workflows"
log "- a laptop/Kindle/household preparedness kit, not just a document dump"
log ""
log "Canonical orientation path in this repo:"
log "1. ./tools-scripts/get-squared-away.sh"
log "2. START-HERE.md"
log "3. FIELD-INDEX.md"
log "4. USAGE.md"
log "5. DOWNLOADS.md"
log ""
log "Immediate emergency priorities inside this repo:"
log "- medical/Where_There_Is_No_Doctor_FULL.pdf"
log "- survival-guides/FM4-25.11_First_Aid_Manual.pdf"
log "- survival-guides/Emergency_Water_Purification_Guide.pdf"
log "- survival-guides/sanitation/Emergency_Toilet_Guidebook.pdf"
log "- radio/UV-5R_Quick_Reference_Card.pdf"
log "- power-electrical/NREL_Off_Grid_Solar_Installation_Maintenance.pdf"

if [[ "$VERIFY_MODE" == "full" ]]; then
  run_logged "Repo verification (full)" "$ROOT/tools-scripts/verify-all.sh" --full
  VERIFY_RC=$?
else
  run_logged "Repo verification (essential)" "$ROOT/tools-scripts/verify-all.sh" --essential
  VERIFY_RC=$?
fi

if command -v python3 >/dev/null 2>&1 && [[ -f "$ROOT/tools-scripts/audit-gemma4-artifacts.py" ]]; then
  run_logged "Gemma 4 artifact audit" python3 "$ROOT/tools-scripts/audit-gemma4-artifacts.py"
  AUDIT_RC=$?
else
  log ""
  log "### Gemma 4 artifact audit"
  log "Skipped: python3 or tools-scripts/audit-gemma4-artifacts.py missing"
  AUDIT_RC="skipped"
fi

if [[ -x "$ROOT/tools-scripts/run-gemma4-llamacpp.sh" ]]; then
  run_logged "Local Gemma 4 GGUF inventory" "$ROOT/tools-scripts/run-gemma4-llamacpp.sh" --list
  INVENTORY_RC=$?
else
  log ""
  log "### Local Gemma 4 GGUF inventory"
  log "Skipped: tools-scripts/run-gemma4-llamacpp.sh missing or not executable"
  INVENTORY_RC="skipped"
fi

if [[ $RUN_LLAMA_SMOKE -eq 1 ]]; then
  if command -v python3 >/dev/null 2>&1 && [[ -x "$ROOT/tools-scripts/test-gemma4-llamacpp.py" ]]; then
    run_logged "Fast llama.cpp smoke test" python3 "$ROOT/tools-scripts/test-gemma4-llamacpp.py" --quant Q4_K_M --max-tokens 12 --ctx-size 4096 --flash-attn auto
    LLAMA_SMOKE_RC=$?
  else
    log ""
    log "### Fast llama.cpp smoke test"
    log "Skipped: python3 or tools-scripts/test-gemma4-llamacpp.py missing"
    LLAMA_SMOKE_RC="skipped"
  fi
fi

log ""
log "Next commands by goal:"
log ""
log "If you need emergency docs right now:"
log "  open medical/Where_There_Is_No_Doctor_FULL.pdf"
log "  open survival-guides/Emergency_Water_Purification_Guide.pdf"
log "  ./tools-scripts/launch-wikipedia.sh"
log "  ./tools-scripts/launch-maps.sh"
log ""
log "If you want the fastest local AI path:"
log "  less docs/local-ai-models.md"
log "  ./tools-scripts/run-gemma4-llamacpp.sh --list"
log "  ./tools-scripts/run-gemma4-llamacpp.sh --quant Q4_K_M E2B"
log ""
log "If you want to rebuild/verify the Gemma 4 llama.cpp stack:"
log "  ./tools-scripts/build-llama-cpp-gemma4.sh --update"
log "  ./tools-scripts/convert-gemma4-to-gguf.sh"
log "  ./tools-scripts/quantize-gemma4-gguf.sh ALL Q4_K_M"
log "  python3 tools-scripts/test-gemma4-llamacpp.py --quant Q4_K_M"
log ""
log "If you are missing large optional datasets:"
log "  less DOWNLOADS.md"
log ""
log "What an AI agent should understand before doing more work here:"
log "- core life-support docs matter more than ornamental repo cleanup"
log "- verify what is actually present instead of assuming large downloads exist"
log "- Gemma 4 in llama.cpp is a first-class path here, not a side note"
log "- BF16 is the canonical conversion artifact; Q4_K_M is the fast daily-driver path"
log "- the fastest honest onboarding command is this script, not random file browsing"
log ""
log "Finished. Read the saved report if you want the full transcript:"
log "  $REPORT_PATH"

if [[ $JSON_MODE -eq 1 ]]; then
  if ! command -v python3 >/dev/null 2>&1; then
    echo "--json requested but python3 is unavailable" >&2
    exit 1
  fi

  export ROOT VERIFY_MODE REPORT_PATH JSON_PATH RUN_LLAMA_SMOKE VERIFY_RC AUDIT_RC INVENTORY_RC LLAMA_SMOKE_RC
  export START_HERE_PRESENT="$(path_status "$ROOT/START-HERE.md")"
  export FIELD_INDEX_PRESENT="$(path_status "$ROOT/FIELD-INDEX.md")"
  export USAGE_PRESENT="$(path_status "$ROOT/USAGE.md")"
  export DOWNLOADS_PRESENT="$(path_status "$ROOT/DOWNLOADS.md")"
  export AGENTS_PRESENT="$(path_status "$ROOT/AGENTS.md")"
  export VERIFY_SCRIPT_PRESENT="$(path_status "$ROOT/tools-scripts/verify-all.sh")"
  export GEMMA_AUDIT_PRESENT="$(path_status "$ROOT/tools-scripts/audit-gemma4-artifacts.py")"
  export GEMMA_RUNNER_PRESENT="$(path_status "$ROOT/tools-scripts/run-gemma4-llamacpp.sh")"
  export GEMMA_TEST_PRESENT="$(path_status "$ROOT/tools-scripts/test-gemma4-llamacpp.py")"
  export MEDICAL_CORE_PRESENT="$(path_status "$ROOT/medical/Where_There_Is_No_Doctor_FULL.pdf")"
  export WATER_CORE_PRESENT="$(path_status "$ROOT/survival-guides/Emergency_Water_Purification_Guide.pdf")"
  export SANITATION_CORE_PRESENT="$(path_status "$ROOT/survival-guides/sanitation/Emergency_Toilet_Guidebook.pdf")"
  export RADIO_CORE_PRESENT="$(path_status "$ROOT/radio/UV-5R_Quick_Reference_Card.pdf")"
  export POWER_CORE_PRESENT="$(path_status "$ROOT/power-electrical/NREL_Off_Grid_Solar_Installation_Maintenance.pdf")"
  export GEMMA_E2B_PRESENT="$(path_status "$ROOT/models/gemma-4/gemma-4-E2B-it")"
  export GEMMA_E4B_PRESENT="$(path_status "$ROOT/models/gemma-4/gemma-4-E4B-it")"
  export GEMMA_31B_PRESENT="$(path_status "$ROOT/models/gemma-4/gemma-4-31B-it")"
  export GEMMA_26B_PRESENT="$(path_status "$ROOT/models/gemma-4/gemma-4-26B-A4B-it")"
  export GEMMA_E2B_Q4_PRESENT="$(path_status "$ROOT/models/gemma-4-gguf/gemma-4-E2B-it/gemma-4-E2B-it-Q4_K_M.gguf")"
  export GEMMA_E4B_Q4_PRESENT="$(path_status "$ROOT/models/gemma-4-gguf/gemma-4-E4B-it/gemma-4-E4B-it-Q4_K_M.gguf")"
  export GEMMA_31B_Q4_PRESENT="$(path_status "$ROOT/models/gemma-4-gguf/gemma-4-31B-it/gemma-4-31B-it-Q4_K_M.gguf")"
  export GEMMA_26B_Q4_PRESENT="$(path_status "$ROOT/models/gemma-4-gguf/gemma-4-26B-A4B-it/gemma-4-26B-A4B-it-Q4_K_M.gguf")"

  python3 - <<'PY'
import json
import os
from pathlib import Path

def as_bool(name: str) -> bool:
    return os.environ[name].lower() == "true"

root = Path(os.environ["ROOT"])
payload = {
    "repo": "SHTF",
    "root": str(root),
    "canonical_bootstrap_command": "./tools-scripts/get-squared-away.sh",
    "mode": os.environ["VERIFY_MODE"],
    "with_llama_smoke": os.environ["RUN_LLAMA_SMOKE"] == "1",
    "reports": {
        "text": os.environ["REPORT_PATH"],
        "json": os.environ["JSON_PATH"],
    },
    "status": {
        "verify_exit_code": os.environ["VERIFY_RC"],
        "gemma_audit_exit_code": os.environ["AUDIT_RC"],
        "gguf_inventory_exit_code": os.environ["INVENTORY_RC"],
        "llama_smoke_exit_code": os.environ["LLAMA_SMOKE_RC"],
    },
    "orientation_path": [
        "./tools-scripts/get-squared-away.sh",
        "START-HERE.md",
        "FIELD-INDEX.md",
        "USAGE.md",
        "DOWNLOADS.md",
    ],
    "core_emergency_paths": [
        "medical/Where_There_Is_No_Doctor_FULL.pdf",
        "survival-guides/FM4-25.11_First_Aid_Manual.pdf",
        "survival-guides/Emergency_Water_Purification_Guide.pdf",
        "survival-guides/sanitation/Emergency_Toilet_Guidebook.pdf",
        "radio/UV-5R_Quick_Reference_Card.pdf",
        "power-electrical/NREL_Off_Grid_Solar_Installation_Maintenance.pdf",
    ],
    "presence": {
        "docs": {
            "start_here": as_bool("START_HERE_PRESENT"),
            "field_index": as_bool("FIELD_INDEX_PRESENT"),
            "usage": as_bool("USAGE_PRESENT"),
            "downloads": as_bool("DOWNLOADS_PRESENT"),
            "agents": as_bool("AGENTS_PRESENT"),
        },
        "bootstrap": {
            "verify_script": as_bool("VERIFY_SCRIPT_PRESENT"),
            "gemma_audit": as_bool("GEMMA_AUDIT_PRESENT"),
            "gemma_runner": as_bool("GEMMA_RUNNER_PRESENT"),
            "gemma_llama_test": as_bool("GEMMA_TEST_PRESENT"),
        },
        "core_capabilities": {
            "medical_core": as_bool("MEDICAL_CORE_PRESENT"),
            "water_core": as_bool("WATER_CORE_PRESENT"),
            "sanitation_core": as_bool("SANITATION_CORE_PRESENT"),
            "radio_core": as_bool("RADIO_CORE_PRESENT"),
            "power_core": as_bool("POWER_CORE_PRESENT"),
        },
        "gemma4_models": {
            "E2B_source": as_bool("GEMMA_E2B_PRESENT"),
            "E4B_source": as_bool("GEMMA_E4B_PRESENT"),
            "31B_source": as_bool("GEMMA_31B_PRESENT"),
            "26B_A4B_source": as_bool("GEMMA_26B_PRESENT"),
            "E2B_Q4_K_M": as_bool("GEMMA_E2B_Q4_PRESENT"),
            "E4B_Q4_K_M": as_bool("GEMMA_E4B_Q4_PRESENT"),
            "31B_Q4_K_M": as_bool("GEMMA_31B_Q4_PRESENT"),
            "26B_A4B_Q4_K_M": as_bool("GEMMA_26B_Q4_PRESENT"),
        },
    },
    "next_commands": {
        "emergency_docs": [
            "open medical/Where_There_Is_No_Doctor_FULL.pdf",
            "open survival-guides/Emergency_Water_Purification_Guide.pdf",
            "./tools-scripts/launch-wikipedia.sh",
            "./tools-scripts/launch-maps.sh",
        ],
        "fast_local_ai": [
            "less docs/local-ai-models.md",
            "./tools-scripts/run-gemma4-llamacpp.sh --list",
            "./tools-scripts/run-gemma4-llamacpp.sh --quant Q4_K_M E2B",
        ],
        "rebuild_gemma4_llamacpp": [
            "./tools-scripts/build-llama-cpp-gemma4.sh --update",
            "./tools-scripts/convert-gemma4-to-gguf.sh",
            "./tools-scripts/quantize-gemma4-gguf.sh ALL Q4_K_M",
            "python3 tools-scripts/test-gemma4-llamacpp.py --quant Q4_K_M",
        ],
        "missing_large_downloads": [
            "less DOWNLOADS.md",
        ],
    },
    "agent_principles": [
        "core life-support docs matter more than ornamental repo cleanup",
        "verify what is actually present instead of assuming large downloads exist",
        "Gemma 4 in llama.cpp is a first-class path here, not a side note",
        "BF16 is the canonical conversion artifact; Q4_K_M is the fast daily-driver path",
        "the fastest honest onboarding command is this script, not random file browsing",
    ],
}

Path(os.environ["JSON_PATH"]).write_text(json.dumps(payload, indent=2) + "\n", encoding="utf-8")
PY

  log ""
  log "Machine-readable JSON summary written to:"
  log "  $JSON_PATH"
fi
