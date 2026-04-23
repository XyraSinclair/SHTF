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
MODEL_CHOOSER_RC="skipped"
MODEL_CHOOSER_JSON_PATH=""

usage() {
  cat <<'EOF'
Usage: ./tools-scripts/get-squared-away.sh [options]

Purpose:
  Give a fresh downloader or AI agent the fastest honest orientation path for this repo.
  It prints what SHTF is, what is ready now, what is optional, and the exact next commands.
  By default it writes a local text report in the repo root and does not use the network.

Options:
  --essential          Run essential verification only (default; skips optional local-AI audits)
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
log "This writes local report files only; it does not phone home."
log ""
log "What this repo is:"
log "- an offline survival/reference library"
log "- optional local-AI lanes: Ollama + current Qwen, or validated Gemma 4 + llama.cpp"
log "- a laptop/Kindle/household resource library, not a personalized plan"
log ""
log "Canonical orientation path in this repo:"
log "1. ./tools-scripts/build-envelope.sh     (the manila envelope — the one thing)"
log "2. START-HERE.md                         (three doors: emergency / tonight / full kit)"
log "3. ./tools-scripts/get-squared-away.sh   (this script)"
log "4. playbooks/README.md                   (playbook index)"
log "5. FIELD-INDEX.md                        (file-level map)"
log "6. USAGE.md                              (resource use by problem)"
log "7. DOWNLOADS.md                          (optional large downloads)"
log ""
log "Playbooks (what to DO):"
log "- playbooks/tier-1-setup/00-first-weekend.md   # one-weekend foundation"
log "- playbooks/scenarios/                         # 11 scenario runbooks"
log "- playbooks/frameworks/stay-or-go.md           # movement/shelter decision framework"
log "- playbooks/frameworks/myths-that-kill.md      # bad advice to unlearn"
log "- playbooks/cards/                             # print-ready single-page refs"
log ""
log "Library (what the playbooks point INTO):"
log "- medical/Where_There_Is_No_Doctor_FULL.pdf"
log "- survival-guides/FM4-25.11_First_Aid_Manual.pdf"
log "- survival-guides/Emergency_Water_Purification_Guide.pdf"
log "- survival-guides/sanitation/Emergency_Toilet_Guidebook.pdf"
log "- survival-guides/Nuclear_War_Survival_Skills.pdf"
log "- radio/UV-5R_Quick_Reference_Card.pdf"
log "- power-electrical/NREL_Off_Grid_Solar_Installation_Maintenance.pdf"

if [[ "$VERIFY_MODE" == "full" ]]; then
  if run_logged "Repo verification (full)" "$ROOT/tools-scripts/verify-all.sh" --full; then
    VERIFY_RC=0
  else
    VERIFY_RC=$?
  fi
else
  if run_logged "Repo verification (essential)" "$ROOT/tools-scripts/verify-all.sh" --essential; then
    VERIFY_RC=0
  else
    VERIFY_RC=$?
  fi
fi

if [[ "$VERIFY_MODE" == "full" ]]; then
  if command -v python3 >/dev/null 2>&1 && [[ -f "$ROOT/tools-scripts/audit-gemma4-artifacts.py" ]]; then
    if run_logged "Gemma 4 artifact audit" python3 "$ROOT/tools-scripts/audit-gemma4-artifacts.py"; then
      AUDIT_RC=0
    else
      AUDIT_RC=$?
    fi
  else
    log ""
    log "### Gemma 4 artifact audit"
    log "Skipped: python3 or tools-scripts/audit-gemma4-artifacts.py missing"
    AUDIT_RC="skipped"
  fi

  if [[ -x "$ROOT/tools-scripts/run-gemma4-llamacpp.sh" ]]; then
    if run_logged "Local Gemma 4 GGUF inventory" "$ROOT/tools-scripts/run-gemma4-llamacpp.sh" --list; then
      INVENTORY_RC=0
    else
      INVENTORY_RC=$?
    fi
  else
    log ""
    log "### Local Gemma 4 GGUF inventory"
    log "Skipped: tools-scripts/run-gemma4-llamacpp.sh missing or not executable"
    INVENTORY_RC="skipped"
  fi
else
  log ""
  log "### Optional local AI checks"
  log "Skipped in --essential mode: rerun with --full if you want Gemma artifact and GGUF inventory checks"
  AUDIT_RC="skipped"
  INVENTORY_RC="skipped"
fi

if [[ $RUN_LLAMA_SMOKE -eq 1 ]]; then
  if command -v python3 >/dev/null 2>&1 && [[ -x "$ROOT/tools-scripts/test-gemma4-llamacpp.py" ]]; then
    if run_logged "Fast llama.cpp smoke test" python3 "$ROOT/tools-scripts/test-gemma4-llamacpp.py" --quant Q4_K_M --max-tokens 12 --ctx-size 4096 --flash-attn auto; then
      LLAMA_SMOKE_RC=0
    else
      LLAMA_SMOKE_RC=$?
    fi
  else
    log ""
    log "### Fast llama.cpp smoke test"
    log "Skipped: python3 or tools-scripts/test-gemma4-llamacpp.py missing"
    LLAMA_SMOKE_RC="skipped"
  fi
fi

if [[ -x "$ROOT/tools-scripts/choose-local-model.sh" ]]; then
  if run_logged "Local AI model chooser" "$ROOT/tools-scripts/choose-local-model.sh"; then
    MODEL_CHOOSER_RC=0
  else
    MODEL_CHOOSER_RC=$?
  fi
else
  log ""
  log "### Local AI model chooser"
  log "Skipped: tools-scripts/choose-local-model.sh missing or not executable"
  MODEL_CHOOSER_RC="skipped"
fi

log ""
log "Next commands by goal:"
log ""
log "If this is your first session (not an emergency):"
log "  ./tools-scripts/build-envelope.sh        # generate the print-once manila envelope"
log "  less START-HERE.md                       # three doors: emergency / tonight / full kit"
log "  less playbooks/README.md                 # playbook index"
log "  less FIELD-INDEX.md                      # file-level map"
log "  less USAGE.md                            # resource use by problem"
log "  less DOWNLOADS.md                        # optional large downloads"
log "  ./tools-scripts/household-setup.sh       # optional blank private templates"
log "  ./tools-scripts/print-cards.sh           # full-deck printable (not just envelope)"
log ""
log "If something is happening RIGHT NOW:"
log "  less START-HERE.md                       # problem → open-this table"
log "  less playbooks/frameworks/stay-or-go.md  # movement/shelter decision framework"
log ""
log "If you need emergency docs right now:"
log "  open medical/Where_There_Is_No_Doctor_FULL.pdf"
log "  open survival-guides/Emergency_Water_Purification_Guide.pdf"
log "  ./tools-scripts/launch-wikipedia.sh"
log "  ./tools-scripts/launch-maps.sh"
log ""
log "If you want local AI:"
log "  ./tools-scripts/choose-local-model.sh # pick a sane local model from this machine"
log "  less docs/local-ai-models.md            # one-time Ollama context setup and manual paths"
log "  python3 ./tools-scripts/set-opencode-model.py shtf-ollama/qwen3.6-27b"
log "  ./tools-scripts/download-qwen36-27b.py  # advanced: raw high-capability cache"
log "  ./tools-scripts/setup-gemma4.sh         # advanced: self-contained repo-local fallback"
log "  ./tools-scripts/setup-gemma4.sh --all   # advanced: all four Gemma 4 models"
log "  ./tools-scripts/run-gemma4-llamacpp.sh --list"
log "  ./tools-scripts/run-gemma4-llamacpp.sh E2B"
log ""
log "If you are missing large optional datasets:"
log "  less DOWNLOADS.md"
log ""
log "What an AI agent should understand before doing more work here:"
log "- core life-support docs matter more than ornamental repo cleanup"
log "- survival defaults must stay easy to adapt for real households"
log "- verify what is actually present instead of assuming large downloads exist"
log "- for local AI, choose the model before downloading it"
log "- Qwen3.6-27B is the priority capable checkpoint to cache while online"
log "- Ollama + current Qwen is the easiest current path; Gemma 4 is the validated repo-local path"
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

  export ROOT VERIFY_MODE REPORT_PATH JSON_PATH RUN_LLAMA_SMOKE VERIFY_RC AUDIT_RC INVENTORY_RC LLAMA_SMOKE_RC MODEL_CHOOSER_RC MODEL_CHOOSER_JSON_PATH
  export START_HERE_PRESENT="$(path_status "$ROOT/START-HERE.md")"
  export FIELD_INDEX_PRESENT="$(path_status "$ROOT/FIELD-INDEX.md")"
  export USAGE_PRESENT="$(path_status "$ROOT/USAGE.md")"
  export DOWNLOADS_PRESENT="$(path_status "$ROOT/DOWNLOADS.md")"
  export AGENTS_PRESENT="$(path_status "$ROOT/AGENTS.md")"
  export PLAYBOOKS_README_PRESENT="$(path_status "$ROOT/playbooks/README.md")"
  export PLAYBOOKS_TIER1_PRESENT="$(path_status "$ROOT/playbooks/tier-1-setup/00-first-weekend.md")"
  export PLAYBOOKS_SCENARIOS_PRESENT="$(path_status "$ROOT/playbooks/scenarios")"
  export PLAYBOOKS_FRAMEWORKS_PRESENT="$(path_status "$ROOT/playbooks/frameworks/stay-or-go.md")"
  export PLAYBOOKS_CARDS_PRESENT="$(path_status "$ROOT/playbooks/cards/first-aid.md")"
  export HOUSEHOLD_SETUP_PRESENT="$(path_status "$ROOT/tools-scripts/household-setup.sh")"
  export PRINT_CARDS_PRESENT="$(path_status "$ROOT/tools-scripts/print-cards.sh")"
  export VERIFY_SCRIPT_PRESENT="$(path_status "$ROOT/tools-scripts/verify-all.sh")"
  export MODEL_CHOOSER_PRESENT="$(path_status "$ROOT/tools-scripts/choose-local-model.sh")"
  export QWEN_DOWNLOAD_PRESENT="$(path_status "$ROOT/tools-scripts/download-qwen36-27b.py")"
  export QWEN_MODEL_PRESENT="$(path_status "$ROOT/models/Qwen3.6-27B/model.safetensors.index.json")"
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

  MODEL_CHOOSER_JSON_PATH="$(mktemp "${TMPDIR:-/tmp}/shtf-local-model-choice.XXXXXX.json")"
  if [[ -x "$ROOT/tools-scripts/choose-local-model.sh" ]]; then
    if "$ROOT/tools-scripts/choose-local-model.sh" --json >"$MODEL_CHOOSER_JSON_PATH"; then
      export MODEL_CHOOSER_JSON_PRESENT=true
    else
      rm -f "$MODEL_CHOOSER_JSON_PATH"
      export MODEL_CHOOSER_JSON_PRESENT=false
    fi
  else
    export MODEL_CHOOSER_JSON_PRESENT=false
  fi

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
        "local_model_chooser_exit_code": os.environ["MODEL_CHOOSER_RC"],
    },
    "orientation_path": [
        "./tools-scripts/get-squared-away.sh",
        "START-HERE.md",
        "FIELD-INDEX.md",
        "USAGE.md",
        "DOWNLOADS.md",
        "./tools-scripts/print-cards.sh",
        "./tools-scripts/household-setup.sh",
    ],
    "playbooks": {
        "root": "playbooks/",
        "tier_1_first_weekend": "playbooks/tier-1-setup/00-first-weekend.md",
        "scenarios_dir": "playbooks/scenarios/",
        "frameworks_dir": "playbooks/frameworks/",
        "cards_dir": "playbooks/cards/",
        "scenarios": [
            "playbooks/scenarios/01-house-fire.md",
            "playbooks/scenarios/02-severe-weather.md",
            "playbooks/scenarios/03-earthquake-cascadia.md",
            "playbooks/scenarios/04-wildfire-evacuation.md",
            "playbooks/scenarios/05-grid-down-extended.md",
            "playbooks/scenarios/06-pandemic.md",
            "playbooks/scenarios/07-cyber-collapse.md",
            "playbooks/scenarios/08-nuclear.md",
            "playbooks/scenarios/09-civil-unrest-bug-in.md",
            "playbooks/scenarios/10-stranded-or-lost.md",
            "playbooks/scenarios/11-lookup-drill.md",
        ],
    },
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
            "playbooks_readme": as_bool("PLAYBOOKS_README_PRESENT"),
            "playbooks_tier1_first_weekend": as_bool("PLAYBOOKS_TIER1_PRESENT"),
            "playbooks_scenarios_dir": as_bool("PLAYBOOKS_SCENARIOS_PRESENT"),
            "playbooks_frameworks_stay_or_go": as_bool("PLAYBOOKS_FRAMEWORKS_PRESENT"),
            "playbooks_cards_first_aid": as_bool("PLAYBOOKS_CARDS_PRESENT"),
        },
        "bootstrap": {
            "verify_script": as_bool("VERIFY_SCRIPT_PRESENT"),
            "household_setup": as_bool("HOUSEHOLD_SETUP_PRESENT"),
            "print_cards": as_bool("PRINT_CARDS_PRESENT"),
            "local_model_chooser": as_bool("MODEL_CHOOSER_PRESENT"),
            "qwen36_downloader": as_bool("QWEN_DOWNLOAD_PRESENT"),
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
            "qwen36_27b_checkpoint": as_bool("QWEN_MODEL_PRESENT"),
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
        "first_session_not_emergency": [
            "./tools-scripts/build-envelope.sh",
            "less START-HERE.md",
            "less playbooks/README.md",
            "less FIELD-INDEX.md",
            "less USAGE.md",
            "less DOWNLOADS.md",
            "./tools-scripts/household-setup.sh",
            "./tools-scripts/print-cards.sh",
        ],
        "happening_right_now": [
            "less START-HERE.md",
            "less playbooks/frameworks/stay-or-go.md",
        ],
        "emergency_docs": [
            "open medical/Where_There_Is_No_Doctor_FULL.pdf",
            "open survival-guides/Emergency_Water_Purification_Guide.pdf",
            "./tools-scripts/launch-wikipedia.sh",
            "./tools-scripts/launch-maps.sh",
        ],
        "fast_local_ai": [
            "./tools-scripts/choose-local-model.sh",
            "less docs/local-ai-models.md",
            "python3 ./tools-scripts/set-opencode-model.py shtf-ollama/qwen3.6-27b",
            "./tools-scripts/download-qwen36-27b.py",
            "./tools-scripts/setup-gemma4.sh",
            "./tools-scripts/setup-gemma4.sh --all",
            "./tools-scripts/run-gemma4-llamacpp.sh --list",
            "./tools-scripts/run-gemma4-llamacpp.sh E2B",
        ],
        "missing_large_downloads": [
            "less DOWNLOADS.md",
        ],
    },
    "agent_principles": [
        "core life-support docs matter more than ornamental repo cleanup",
        "survival defaults must stay easy to adapt for real households",
        "verify what is actually present instead of assuming large downloads exist",
        "for local AI, choose the model before downloading it",
        "Qwen3.6-27B is the priority capable checkpoint to cache while online",
        "Ollama + current Qwen is the easiest current path; Gemma 4 is the validated repo-local path",
        "BF16 is the canonical conversion artifact; Q4_K_M is the fast daily-driver path",
        "the fastest honest onboarding command is this script, not random file browsing",
    ],
}

if os.environ.get("MODEL_CHOOSER_JSON_PRESENT", "").lower() == "true":
    chooser_path = Path(os.environ["MODEL_CHOOSER_JSON_PATH"])
    if chooser_path.exists():
        payload["local_model_guidance"] = json.loads(chooser_path.read_text(encoding="utf-8"))

Path(os.environ["JSON_PATH"]).write_text(json.dumps(payload, indent=2) + "\n", encoding="utf-8")
PY

  rm -f "$MODEL_CHOOSER_JSON_PATH"

  log ""
  log "Machine-readable JSON summary written to:"
  log "  $JSON_PATH"
fi
