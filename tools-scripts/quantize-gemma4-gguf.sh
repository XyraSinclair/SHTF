#!/bin/bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
BUILD_DIR="$ROOT/kimi-k2.5/llama.cpp/build/bin"
SRC_ROOT="$ROOT/models/gemma-4-gguf"

usage() {
  cat <<'EOF'
Usage: ./tools-scripts/quantize-gemma4-gguf.sh <E2B|E4B|31B|26B-A4B|ALL> [QUANT]

Examples:
  ./tools-scripts/quantize-gemma4-gguf.sh E2B Q4_K_M
  ./tools-scripts/quantize-gemma4-gguf.sh ALL Q4_K_M
EOF
}

label="${1:-}"
quant="${2:-Q4_K_M}"
[[ -n "$label" ]] || { usage; exit 1; }

if [[ ! -x "$BUILD_DIR/llama-quantize" ]]; then
  echo "Missing llama-quantize at $BUILD_DIR/llama-quantize" >&2
  echo "Run ./tools-scripts/build-llama-cpp-gemma4.sh first." >&2
  exit 1
fi

labels=()
case "$label" in
  ALL) labels=(E2B E4B 31B 26B-A4B) ;;
  E2B|E4B|31B|26B-A4B) labels=("$label") ;;
  *) usage; exit 1 ;;
esac

model_dir_for() {
  case "$1" in
    E2B) echo "gemma-4-E2B-it" ;;
    E4B) echo "gemma-4-E4B-it" ;;
    31B) echo "gemma-4-31B-it" ;;
    26B-A4B) echo "gemma-4-26B-A4B-it" ;;
  esac
}

for label in "${labels[@]}"; do
  model_dir="$(model_dir_for "$label")"
  dir="$SRC_ROOT/$model_dir"
  src="$dir/$model_dir-bf16.gguf"
  dst="$dir/$model_dir-$quant.gguf"
  if [[ ! -f "$src" ]]; then
    echo "Missing source GGUF: $src" >&2
    exit 1
  fi
  echo "==> Quantizing $label to $quant"
  "$BUILD_DIR/llama-quantize" "$src" "$dst" "$quant"
  echo "    wrote: $dst"
done
