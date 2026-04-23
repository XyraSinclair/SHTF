#!/bin/bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
JSON_MODE=0
PLATFORM_OVERRIDE=""
RAM_GB_OVERRIDE=""
FREE_GB_OVERRIDE=""
CONTEXT_TOKENS=65536

usage() {
  cat <<'EOF'
Usage: ./tools-scripts/choose-local-model.sh [options]

Purpose:
  Recommend a local model path for SHTF from platform, RAM, and free disk.
  Defaults to auto-detection and does not use the network.

Options:
  --json            Print machine-readable JSON instead of text
  --platform ID     Override platform detection
                    (mac-apple-silicon | mac-intel | linux | windows | other)
  --ram-gb N        Override detected RAM in GB
  --free-gb N       Override detected free disk in GB for both repo and Ollama storage
  --help            Show this help
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --json) JSON_MODE=1 ;;
    --platform)
      PLATFORM_OVERRIDE="${2:-}"
      shift
      ;;
    --ram-gb)
      RAM_GB_OVERRIDE="${2:-}"
      shift
      ;;
    --free-gb)
      FREE_GB_OVERRIDE="${2:-}"
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

is_integer() {
  [[ "$1" =~ ^[0-9]+$ ]]
}

if [[ -n "$RAM_GB_OVERRIDE" ]] && ! is_integer "$RAM_GB_OVERRIDE"; then
  echo "--ram-gb must be an integer" >&2
  exit 1
fi

if [[ -n "$FREE_GB_OVERRIDE" ]] && ! is_integer "$FREE_GB_OVERRIDE"; then
  echo "--free-gb must be an integer" >&2
  exit 1
fi

detect_platform() {
  local uname_s uname_m
  uname_s="$(uname -s 2>/dev/null || echo unknown)"
  uname_m="$(uname -m 2>/dev/null || echo unknown)"

  case "$uname_s" in
    Darwin)
      if [[ "$uname_m" == "arm64" || "$uname_m" == "arm64e" ]]; then
        PLATFORM_ID="mac-apple-silicon"
        PLATFORM_LABEL="macOS (Apple Silicon)"
      else
        PLATFORM_ID="mac-intel"
        PLATFORM_LABEL="macOS (Intel)"
      fi
      ;;
    Linux)
      PLATFORM_ID="linux"
      PLATFORM_LABEL="Linux"
      ;;
    MINGW*|MSYS*|CYGWIN*)
      PLATFORM_ID="windows"
      PLATFORM_LABEL="Windows"
      ;;
    *)
      PLATFORM_ID="other"
      PLATFORM_LABEL="Other / unknown"
      ;;
  esac
}

set_platform_from_override() {
  case "$PLATFORM_OVERRIDE" in
    mac-apple-silicon)
      PLATFORM_ID="mac-apple-silicon"
      PLATFORM_LABEL="macOS (Apple Silicon)"
      ;;
    mac-intel)
      PLATFORM_ID="mac-intel"
      PLATFORM_LABEL="macOS (Intel)"
      ;;
    linux)
      PLATFORM_ID="linux"
      PLATFORM_LABEL="Linux"
      ;;
    windows)
      PLATFORM_ID="windows"
      PLATFORM_LABEL="Windows"
      ;;
    other)
      PLATFORM_ID="other"
      PLATFORM_LABEL="Other / unknown"
      ;;
    *)
      echo "--platform must be one of: mac-apple-silicon, mac-intel, linux, windows, other" >&2
      exit 1
      ;;
  esac
}

detect_ram_gb() {
  local bytes kb
  case "$PLATFORM_ID" in
    mac-apple-silicon|mac-intel)
      bytes="$(sysctl -n hw.memsize 2>/dev/null || echo 0)"
      ;;
    linux)
      kb="$(awk '/MemTotal:/ {print $2}' /proc/meminfo 2>/dev/null || echo 0)"
      bytes=$((kb * 1024))
      ;;
    windows)
      if command -v powershell.exe >/dev/null 2>&1; then
        bytes="$(powershell.exe -NoProfile -Command "[int64](Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory" 2>/dev/null | tr -d '\r' || echo 0)"
      else
        bytes=0
      fi
      ;;
    *)
      bytes=0
      ;;
  esac

  if ! is_integer "${bytes:-0}"; then
    bytes=0
  fi
  RAM_GB=$((bytes / 1024 / 1024 / 1024))
}

existing_path_for_df() {
  local path="$1"
  while [[ ! -e "$path" && "$path" != "/" ]]; do
    path="$(dirname "$path")"
  done
  printf '%s\n' "$path"
}

free_gb_for_path() {
  local path="$1"
  local kb
  path="$(existing_path_for_df "$path")"
  kb="$(df -Pk "$path" 2>/dev/null | awk 'NR==2 {print $4}')"
  if ! is_integer "${kb:-0}"; then
    echo 0
    return
  fi
  echo $((kb / 1024 / 1024))
}

if [[ -n "$PLATFORM_OVERRIDE" ]]; then
  set_platform_from_override
else
  detect_platform
fi

if [[ -n "$RAM_GB_OVERRIDE" ]]; then
  RAM_GB="$RAM_GB_OVERRIDE"
else
  detect_ram_gb
fi

REPO_STORAGE_PATH="$ROOT"
OLLAMA_STORAGE_PATH="${OLLAMA_MODELS:-${HOME:-$ROOT}/.ollama}"

if [[ -n "$FREE_GB_OVERRIDE" ]]; then
  REPO_FREE_GB="$FREE_GB_OVERRIDE"
  OLLAMA_FREE_GB="$FREE_GB_OVERRIDE"
else
  REPO_FREE_GB="$(free_gb_for_path "$REPO_STORAGE_PATH")"
  OLLAMA_FREE_GB="$(free_gb_for_path "$OLLAMA_STORAGE_PATH")"
fi

OLLAMA_INSTALLED="false"
if command -v ollama >/dev/null 2>&1; then
  OLLAMA_INSTALLED="true"
fi

BREW_INSTALLED="false"
if command -v brew >/dev/null 2>&1; then
  BREW_INSTALLED="true"
fi

OPENCODE_INSTALLED="false"
if command -v opencode >/dev/null 2>&1; then
  OPENCODE_INSTALLED="true"
fi

LINUX_SYSTEMD_OLLAMA="false"
if [[ "$PLATFORM_ID" == "linux" ]] && command -v systemctl >/dev/null 2>&1; then
  if systemctl cat ollama.service >/dev/null 2>&1; then
    LINUX_SYSTEMD_OLLAMA="true"
  fi
fi

REC_ID=""
REC_LABEL=""
REC_REASON=""
REC_CATEGORY=""
REC_INSTALL_KIND=""
REC_MODEL_TAG=""
REC_MIN_RAM_GB=0
REC_MIN_FREE_GB=0

SECONDARY_LABEL=""
SECONDARY_REASON=""

FALLBACK_LABEL=""
FALLBACK_REASON=""

COMMANDS=()
NOTES=()

if [[ "$PLATFORM_ID" == "mac-apple-silicon" && "$RAM_GB" -ge 96 && "$OLLAMA_FREE_GB" -ge 40 ]]; then
  REC_ID="ollama-qwen36-coding-mxfp8"
  REC_LABEL="Ollama + qwen3.6:27b-coding-mxfp8"
  REC_REASON="Apple Silicon with a lot of RAM and free disk. This is the highest-headroom Qwen3.6 coding choice on Ollama for this class of Mac."
  REC_CATEGORY="best_apple_silicon_coding"
  REC_INSTALL_KIND="ollama"
  REC_MODEL_TAG="qwen3.6:27b-coding-mxfp8"
  REC_MIN_RAM_GB=96
  REC_MIN_FREE_GB=40
  SECONDARY_LABEL="Ollama + qwen3.6:27b-coding-nvfp4"
  SECONDARY_REASON="Use this if you want a smaller and usually faster Qwen3.6 coding pull on the same Mac."
  FALLBACK_LABEL="Gemma 4 E2B (repo-local)"
  FALLBACK_REASON="This remains the safest validated repo-local runtime if you want the least surprise."
elif [[ "$PLATFORM_ID" == "mac-apple-silicon" && "$RAM_GB" -ge 48 && "$OLLAMA_FREE_GB" -ge 28 ]]; then
  REC_ID="ollama-qwen36-coding-nvfp4"
  REC_LABEL="Ollama + qwen3.6:27b-coding-nvfp4"
  REC_REASON="Apple Silicon with enough headroom for the smaller Qwen3.6 coding variant. This is the default Mac recommendation in this repo."
  REC_CATEGORY="default_apple_silicon_coding"
  REC_INSTALL_KIND="ollama"
  REC_MODEL_TAG="qwen3.6:27b-coding-nvfp4"
  REC_MIN_RAM_GB=48
  REC_MIN_FREE_GB=28
  SECONDARY_LABEL="Ollama + qwen3.6:27b"
  SECONDARY_REASON="Cross-platform 27B Qwen3.6 if you want one model name that also works off-Mac."
  FALLBACK_LABEL="Gemma 4 E2B (repo-local)"
  FALLBACK_REASON="Validated repo-local fallback if you do not want to depend on Ollama."
elif [[ "$RAM_GB" -ge 48 && "$OLLAMA_FREE_GB" -ge 24 ]]; then
  REC_ID="ollama-qwen36-27b"
  REC_LABEL="Ollama + qwen3.6:27b"
  REC_REASON="Enough headroom for the cross-platform Qwen3.6 27B build. Use this on Linux, Windows, or Intel Mac when the Apple-only coding tags do not apply."
  REC_CATEGORY="cross_platform_qwen36"
  REC_INSTALL_KIND="ollama"
  REC_MODEL_TAG="qwen3.6:27b"
  REC_MIN_RAM_GB=48
  REC_MIN_FREE_GB=24
  SECONDARY_LABEL="Gemma 4 E4B (repo-local)"
  SECONDARY_REASON="A stronger validated repo-local path when you prefer the SHTF llama.cpp tooling over Ollama."
  FALLBACK_LABEL="Gemma 4 E2B (repo-local)"
  FALLBACK_REASON="Safer starter if you want to keep RAM and disk pressure down."
elif [[ "$RAM_GB" -ge 24 && "$REPO_FREE_GB" -ge 35 ]]; then
  REC_ID="gemma4-e4b"
  REC_LABEL="Gemma 4 E4B (repo-local)"
  REC_REASON="Not enough headroom for a 27B Qwen lane with healthy context, but enough for the stronger validated Gemma 4 path in this repo."
  REC_CATEGORY="validated_midrange"
  REC_INSTALL_KIND="gemma"
  REC_MODEL_TAG="E4B"
  REC_MIN_RAM_GB=24
  REC_MIN_FREE_GB=35
  SECONDARY_LABEL="Gemma 4 E2B (repo-local)"
  SECONDARY_REASON="Smaller validated starter if you want less disk pressure."
  FALLBACK_LABEL="Ollama + qwen2.5-coder:3b"
  FALLBACK_REASON="Only for tight hardware; useful for small shell/code help, not serious agent loops."
elif [[ "$RAM_GB" -ge 16 && "$REPO_FREE_GB" -ge 24 ]]; then
  REC_ID="gemma4-e2b"
  REC_LABEL="Gemma 4 E2B (repo-local)"
  REC_REASON="This is the safest validated local path in the repo for modest laptops and households that want one command and predictable behavior."
  REC_CATEGORY="validated_starter"
  REC_INSTALL_KIND="gemma"
  REC_MODEL_TAG="E2B"
  REC_MIN_RAM_GB=16
  REC_MIN_FREE_GB=24
  SECONDARY_LABEL="Ollama + qwen2.5-coder:3b"
  SECONDARY_REASON="Smaller and simpler, but it is a real downgrade from the larger Qwen and Gemma paths."
  FALLBACK_LABEL=""
  FALLBACK_REASON=""
elif [[ "$RAM_GB" -ge 8 && "$OLLAMA_FREE_GB" -ge 5 ]]; then
  REC_ID="ollama-qwen25-coder-3b"
  REC_LABEL="Ollama + qwen2.5-coder:3b"
  REC_REASON="Hardware is tight. This is the smallest coding-oriented fallback that still gives you a usable local shell/code helper."
  REC_CATEGORY="smallest_coding_fallback"
  REC_INSTALL_KIND="ollama"
  REC_MODEL_TAG="qwen2.5-coder:3b"
  REC_MIN_RAM_GB=8
  REC_MIN_FREE_GB=5
  SECONDARY_LABEL="./tools-scripts/setup-gemma4.sh E2B"
  SECONDARY_REASON="Prefer this instead if the machine can afford more RAM and repo disk."
  FALLBACK_LABEL=""
  FALLBACK_REASON=""
else
  REC_ID="not-enough-headroom"
  REC_LABEL="No honest local-model recommendation from this hardware snapshot"
  REC_REASON="The detected RAM and free disk are too tight for the repo's safer local-model paths. Start with the offline PDFs, maps, Kiwix, and cards instead."
  REC_CATEGORY="none"
  REC_INSTALL_KIND="none"
  REC_MODEL_TAG=""
fi

if [[ "$REC_INSTALL_KIND" == "ollama" ]]; then
  if [[ "$REC_MODEL_TAG" == "qwen2.5-coder:3b" ]]; then
    if [[ "$OLLAMA_INSTALLED" == "true" ]]; then
      case "$PLATFORM_ID" in
        windows) COMMANDS+=("Open the Ollama app from the Start menu if it is not already running") ;;
        mac-apple-silicon|mac-intel) COMMANDS+=("open -a Ollama") ;;
        *) COMMANDS+=("ollama serve") ;;
      esac
    else
      case "$PLATFORM_ID" in
        mac-apple-silicon|mac-intel)
          if [[ "$BREW_INSTALLED" == "true" ]]; then
            COMMANDS+=("brew install --cask ollama")
          else
            COMMANDS+=("Download Ollama: https://ollama.com/download/mac")
          fi
          COMMANDS+=("open -a Ollama")
          ;;
        linux)
          COMMANDS+=("curl -fsSL https://ollama.com/install.sh | sh")
          COMMANDS+=("ollama serve")
          ;;
        windows)
          COMMANDS+=("Download and run OllamaSetup.exe from https://ollama.com/download/windows")
          COMMANDS+=("Open the Ollama app from the Start menu")
          ;;
        *)
          COMMANDS+=("Install Ollama: https://ollama.com/download")
          COMMANDS+=("ollama serve")
          ;;
      esac
    fi

    COMMANDS+=("ollama pull $REC_MODEL_TAG")
    COMMANDS+=("ollama run $REC_MODEL_TAG")

    NOTES+=("Treat this as a compact local helper, not as a serious OpenCode or Hermes tool-calling setup.")
    NOTES+=("If you later move to a larger machine, rerun the chooser and step up to Qwen3.6 or the Gemma path.")
  else
    if [[ "$OLLAMA_INSTALLED" == "true" ]]; then
      case "$PLATFORM_ID" in
        mac-apple-silicon|mac-intel)
          COMMANDS+=("launchctl setenv OLLAMA_CONTEXT_LENGTH $CONTEXT_TOKENS")
          COMMANDS+=("osascript -e 'quit app \"Ollama\"' 2>/dev/null || true")
          COMMANDS+=("open -a Ollama")
          ;;
        linux)
          if [[ "$LINUX_SYSTEMD_OLLAMA" == "true" ]]; then
            COMMANDS+=("sudo systemctl edit ollama.service")
            COMMANDS+=("Add under [Service]: Environment=\"OLLAMA_CONTEXT_LENGTH=$CONTEXT_TOKENS\"")
            COMMANDS+=("sudo systemctl daemon-reload")
            COMMANDS+=("sudo systemctl restart ollama")
          else
            COMMANDS+=("OLLAMA_CONTEXT_LENGTH=$CONTEXT_TOKENS ollama serve")
          fi
          ;;
        windows)
          COMMANDS+=("Quit Ollama from the system tray")
          COMMANDS+=("Set user env var OLLAMA_CONTEXT_LENGTH=$CONTEXT_TOKENS in Windows Environment Variables")
          COMMANDS+=("Start Ollama again from the Start menu")
          ;;
        *)
          COMMANDS+=("OLLAMA_CONTEXT_LENGTH=$CONTEXT_TOKENS ollama serve")
          ;;
      esac
    else
      case "$PLATFORM_ID" in
        mac-apple-silicon|mac-intel)
          if [[ "$BREW_INSTALLED" == "true" ]]; then
            COMMANDS+=("brew install --cask ollama")
          else
            COMMANDS+=("Download Ollama: https://ollama.com/download/mac")
          fi
          COMMANDS+=("launchctl setenv OLLAMA_CONTEXT_LENGTH $CONTEXT_TOKENS")
          COMMANDS+=("open -a Ollama")
          ;;
        linux)
          COMMANDS+=("curl -fsSL https://ollama.com/install.sh | sh")
          if command -v systemctl >/dev/null 2>&1 && systemctl cat ollama.service >/dev/null 2>&1; then
            COMMANDS+=("sudo systemctl edit ollama.service")
            COMMANDS+=("Add under [Service]: Environment=\"OLLAMA_CONTEXT_LENGTH=$CONTEXT_TOKENS\"")
            COMMANDS+=("sudo systemctl daemon-reload")
            COMMANDS+=("sudo systemctl restart ollama")
          else
            COMMANDS+=("OLLAMA_CONTEXT_LENGTH=$CONTEXT_TOKENS ollama serve")
          fi
          ;;
        windows)
          COMMANDS+=("Download and run OllamaSetup.exe from https://ollama.com/download/windows")
          COMMANDS+=("Quit Ollama from the system tray after install")
          COMMANDS+=("Set user env var OLLAMA_CONTEXT_LENGTH=$CONTEXT_TOKENS in Windows Environment Variables")
          COMMANDS+=("Start Ollama again from the Start menu")
          ;;
        *)
          COMMANDS+=("Install Ollama: https://ollama.com/download")
          COMMANDS+=("OLLAMA_CONTEXT_LENGTH=$CONTEXT_TOKENS ollama serve")
          ;;
      esac
    fi

    COMMANDS+=("ollama pull $REC_MODEL_TAG")
    COMMANDS+=("ollama ps")
    if command -v python3 >/dev/null 2>&1 && [[ -f "$ROOT/tools-scripts/set-opencode-model.py" ]]; then
      local_model_id="${REC_ID#ollama-}"
      case "$REC_MODEL_TAG" in
        qwen3.6:27b) local_model_id="qwen3.6-27b" ;;
        qwen3.6:27b-coding-nvfp4) local_model_id="qwen3.6-27b-coding-nvfp4" ;;
        qwen3.6:27b-coding-mxfp8) local_model_id="qwen3.6-27b-coding-mxfp8" ;;
      esac
      COMMANDS+=("python3 ./tools-scripts/set-opencode-model.py shtf-ollama/$local_model_id")
    fi
    if [[ "$OPENCODE_INSTALLED" == "true" ]]; then
      COMMANDS+=("opencode")
    else
      COMMANDS+=("ollama launch opencode")
    fi

    NOTES+=("OpenCode and Hermes both need a real context window. Do not leave Ollama at the small default if you want coding tools or agent loops.")
    NOTES+=("This context setting is the model's working memory. Agents and coding tools need at least 64K to avoid falling over on larger repos and documents.")
    NOTES+=("Check the CONTEXT column in 'ollama ps'. If it is not around $CONTEXT_TOKENS, fix that before blaming the model.")
    NOTES+=("Run OpenCode from this repo root. The project opencode.json is loaded here and can override your global OpenCode config.")
    if [[ "$PLATFORM_ID" == "mac-apple-silicon" ]]; then
      NOTES+=("Apple-only tag guide: nvfp4 is the smaller, easier-to-fit coding build; mxfp8 is the larger, higher-headroom Apple Silicon build.")
    else
      NOTES+=("Skip the Apple-only MXFP8 and NVFP4 tags on non-Apple-Silicon machines.")
    fi
    NOTES+=("Hermes can use the same local endpoint at http://localhost:11434/v1 with a custom provider.")
  fi
else
  if [[ "$REC_INSTALL_KIND" == "gemma" ]]; then
    COMMANDS+=("./tools-scripts/setup-gemma4.sh $REC_MODEL_TAG")
    COMMANDS+=("./tools-scripts/run-gemma4-llamacpp.sh $REC_MODEL_TAG")
    NOTES+=("Gemma 4 is the repo's validated offline runtime lane when you want to avoid provider drift.")
    NOTES+=("This path stores checkpoints and GGUF output under the repo, so watch repo disk headroom, not just ~/.ollama.")
    NOTES+=("Gemma docs use full names like google/gemma-4-E2B-it. The setup script accepts the short tags E2B, E4B, 31B, and 26B-A4B.")
  else
    NOTES+=("Do not waste time forcing a too-large model onto a machine that cannot hold it cleanly.")
  fi
fi

if [[ "$REPO_FREE_GB" -ge 60 ]]; then
  NOTES+=("If you want the raw high-capability checkpoint cached in-repo while the internet is up: ./tools-scripts/download-qwen36-27b.py")
fi

COMMANDS_TEXT="$(printf '%s\n' "${COMMANDS[@]}")"
NOTES_TEXT="$(printf '%s\n' "${NOTES[@]}")"

if [[ $JSON_MODE -eq 1 ]]; then
  if ! command -v python3 >/dev/null 2>&1; then
    echo "--json requested but python3 is unavailable" >&2
    exit 1
  fi

  export PLATFORM_ID PLATFORM_LABEL RAM_GB REPO_FREE_GB OLLAMA_FREE_GB REPO_STORAGE_PATH OLLAMA_STORAGE_PATH
  export OLLAMA_INSTALLED BREW_INSTALLED OPENCODE_INSTALLED LINUX_SYSTEMD_OLLAMA REC_ID REC_LABEL REC_REASON REC_CATEGORY REC_INSTALL_KIND REC_MODEL_TAG
  export REC_MIN_RAM_GB REC_MIN_FREE_GB SECONDARY_LABEL SECONDARY_REASON FALLBACK_LABEL FALLBACK_REASON
  export COMMANDS_TEXT NOTES_TEXT

  python3 - <<'PY'
import json
import os

def lines(name: str):
    value = os.environ.get(name, "")
    return [line for line in value.splitlines() if line.strip()]

payload = {
    "platform": {
        "id": os.environ["PLATFORM_ID"],
        "label": os.environ["PLATFORM_LABEL"],
    },
    "hardware": {
        "ram_gb": int(os.environ["RAM_GB"]),
        "repo_free_gb": int(os.environ["REPO_FREE_GB"]),
        "ollama_free_gb": int(os.environ["OLLAMA_FREE_GB"]),
        "repo_storage_path": os.environ["REPO_STORAGE_PATH"],
        "ollama_storage_path": os.environ["OLLAMA_STORAGE_PATH"],
    },
    "software": {
        "ollama_installed": os.environ["OLLAMA_INSTALLED"] == "true",
        "brew_installed": os.environ["BREW_INSTALLED"] == "true",
    },
    "recommendation": {
        "id": os.environ["REC_ID"],
        "label": os.environ["REC_LABEL"],
        "reason": os.environ["REC_REASON"],
        "category": os.environ["REC_CATEGORY"],
        "install_kind": os.environ["REC_INSTALL_KIND"],
        "model_tag": os.environ["REC_MODEL_TAG"],
        "minimums": {
            "ram_gb": int(os.environ["REC_MIN_RAM_GB"]),
            "free_gb": int(os.environ["REC_MIN_FREE_GB"]),
        },
    },
    "secondary": {
        "label": os.environ.get("SECONDARY_LABEL", ""),
        "reason": os.environ.get("SECONDARY_REASON", ""),
    },
    "fallback": {
        "label": os.environ.get("FALLBACK_LABEL", ""),
        "reason": os.environ.get("FALLBACK_REASON", ""),
    },
    "commands": lines("COMMANDS_TEXT"),
    "notes": lines("NOTES_TEXT"),
}

print(json.dumps(payload, indent=2))
PY
  exit 0
fi

printf '============================================================\n'
printf 'SHTF local model chooser\n'
printf '============================================================\n'
printf 'Detected:\n'
printf -- '- platform: %s\n' "$PLATFORM_LABEL"
printf -- '- RAM: %s GB\n' "$RAM_GB"
printf -- '- repo free space (%s): %s GB\n' "$REPO_STORAGE_PATH" "$REPO_FREE_GB"
printf -- '- Ollama free space (%s): %s GB\n' "$OLLAMA_STORAGE_PATH" "$OLLAMA_FREE_GB"
printf -- '- Ollama installed: %s\n' "$OLLAMA_INSTALLED"
printf '\n'

printf 'Recommendation:\n'
printf -- '- Primary: %s\n' "$REC_LABEL"
printf '  %s\n' "$REC_REASON"
if [[ -n "$SECONDARY_LABEL" ]]; then
  printf -- '- Secondary: %s\n' "$SECONDARY_LABEL"
  printf '  %s\n' "$SECONDARY_REASON"
fi
if [[ -n "$FALLBACK_LABEL" ]]; then
  printf -- '- Fallback: %s\n' "$FALLBACK_LABEL"
  printf '  %s\n' "$FALLBACK_REASON"
fi
printf '\n'

if [[ ${#COMMANDS[@]} -gt 0 ]]; then
printf 'Exact next steps:\n'
  for cmd in "${COMMANDS[@]}"; do
    printf '  %s\n' "$cmd"
  done
  printf '\n'
fi

if [[ ${#NOTES[@]} -gt 0 ]]; then
  printf 'Notes:\n'
  for note in "${NOTES[@]}"; do
    printf -- '- %s\n' "$note"
  done
fi
