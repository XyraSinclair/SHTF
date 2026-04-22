#!/bin/bash
# setup-gemma4.sh — one command to take Gemma 4 from nothing to "it works here."
#
# Default run (E2B only, the safe starter): about 9 GB download + GGUF conversion.
#   ./tools-scripts/setup-gemma4.sh
#
# All four models (~131 GB of source checkpoints + GGUF output):
#   ./tools-scripts/setup-gemma4.sh --all
#
# Specific models:
#   ./tools-scripts/setup-gemma4.sh E2B E4B
#
# Flags:
#   --all              Run all four: E2B, E4B, 31B, 26B-A4B
#   --skip-download    Skip the Hugging Face snapshot download (use what's already on disk)
#   --skip-build       Skip the llama.cpp build (use the existing vendored build)
#   --skip-convert     Skip GGUF conversion (use whatever GGUFs are already there)
#   --skip-test        Skip the llama.cpp smoke test
#   --help             Show this help
#
# What it does, in order:
#   1. Download Hugging Face checkpoints to models/gemma-4/
#   2. Build llama.cpp with Gemma 4 support (cached after the first run)
#   3. Convert checkpoints to BF16 GGUF in models/gemma-4-gguf/
#   4. Run a llama.cpp text smoke test and report pass/fail

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

RED=$'\033[0;31m'
GREEN=$'\033[0;32m'
YELLOW=$'\033[1;33m'
BOLD=$'\033[1m'
NC=$'\033[0m'

MODELS=(E2B)
DO_DOWNLOAD=1
DO_BUILD=1
DO_CONVERT=1
DO_TEST=1

usage() { sed -n '3,26p' "$0" | sed 's/^# \{0,1\}//'; }

while [[ $# -gt 0 ]]; do
  case "$1" in
    --all)           MODELS=(E2B E4B 31B 26B-A4B) ;;
    --skip-download) DO_DOWNLOAD=0 ;;
    --skip-build)    DO_BUILD=0 ;;
    --skip-convert)  DO_CONVERT=0 ;;
    --skip-test)     DO_TEST=0 ;;
    --help|-h)       usage; exit 0 ;;
    E2B|E4B|31B|26B-A4B)
      if [[ "${CUSTOM_SET:-0}" -ne 1 ]]; then
        MODELS=()
        CUSTOM_SET=1
      fi
      MODELS+=("$1")
      ;;
    *) echo "Unknown argument: $1" >&2; usage; exit 1 ;;
  esac
  shift
done

step() { printf '\n%s==> %s%s\n' "$BOLD" "$1" "$NC"; }
ok()   { printf '   %sOK%s %s\n' "$GREEN" "$NC" "$1"; }
warn() { printf '   %s!!%s %s\n' "$YELLOW" "$NC" "$1"; }
fail() { printf '   %sXX%s %s\n' "$RED" "$NC" "$1"; }

printf '%s%sSetting up Gemma 4%s\n' "$BOLD" "$GREEN" "$NC"
printf 'Models: %s\n' "${MODELS[*]}"
printf 'Repo root: %s\n' "$ROOT"

if ! command -v uv >/dev/null 2>&1; then
  fail "uv not found. Install it from https://docs.astral.sh/uv/ and rerun."
  exit 1
fi

# 1. DOWNLOAD
if [[ $DO_DOWNLOAD -eq 1 ]]; then
  step "1/4 Downloading Hugging Face checkpoints"
  uv run "$ROOT/tools-scripts/download-gemma4-models.py" --models "${MODELS[@]}"
  ok "Checkpoints in models/gemma-4/"
else
  step "1/4 Downloading — skipped"
fi

# 2. BUILD
BUILD_BIN="$ROOT/kimi-k2.5/llama.cpp/build/bin"
if [[ $DO_BUILD -eq 1 ]]; then
  step "2/4 Building llama.cpp (first run takes a while; cached after)"
  # Always run the build script unless --skip-build was passed. The build script
  # itself is a no-op when the tree is already up-to-date, and running it keeps
  # the vendored llama.cpp tree fresh enough for current Gemma 4 support. A
  # stale build that predates Gemma 4's converter or mmproj support is silently
  # wrong — we will not skip that just because llama-cli exists on disk.
  "$ROOT/tools-scripts/build-llama-cpp-gemma4.sh" --update
  ok "Build current at $BUILD_BIN"
else
  step "2/4 Building — skipped (--skip-build)"
  if [[ ! -x "$BUILD_BIN/llama-cli" ]]; then
    warn "llama-cli not found at $BUILD_BIN — conversion and smoke test will fail"
    warn "Remove --skip-build or run ./tools-scripts/build-llama-cpp-gemma4.sh --update yourself"
  fi
fi

# 3. CONVERT to GGUF
if [[ $DO_CONVERT -eq 1 ]]; then
  step "3/4 Converting to GGUF (BF16, one per model)"
  for label in "${MODELS[@]}"; do
    case "$label" in
      E2B)     dir="gemma-4-E2B-it" ;;
      E4B)     dir="gemma-4-E4B-it" ;;
      31B)     dir="gemma-4-31B-it" ;;
      26B-A4B) dir="gemma-4-26B-A4B-it" ;;
    esac
    out="$ROOT/models/gemma-4-gguf/$dir/$dir-bf16.gguf"
    if [[ -f "$out" ]]; then
      ok "$label GGUF already present ($out)"
    else
      "$ROOT/tools-scripts/convert-gemma4-to-gguf.sh" "$label"
      ok "$label converted → $out"
    fi
  done
else
  step "3/4 Converting — skipped"
fi

# 4. SMOKE TEST
if [[ $DO_TEST -eq 1 ]]; then
  step "4/4 Smoke-testing with llama.cpp"
  if ! python3 "$ROOT/tools-scripts/test-gemma4-llamacpp.py" "${MODELS[@]}"; then
    fail "Smoke test reported failures — see models/gemma-4-gguf/llamacpp-smoke-test-results.json"
    exit 1
  fi
  ok "Smoke test passed for: ${MODELS[*]}"
else
  step "4/4 Smoke-testing — skipped"
fi

printf '\n%s%sDone.%s\n' "$BOLD" "$GREEN" "$NC"
printf 'Run a model:     ./tools-scripts/run-gemma4-llamacpp.sh %s\n' "${MODELS[0]}"
printf 'List what you have: ./tools-scripts/run-gemma4-llamacpp.sh --list\n'
printf 'Add more models: ./tools-scripts/setup-gemma4.sh E4B   (or --all)\n'
