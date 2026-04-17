#!/bin/bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
LLAMA_DIR="$ROOT/kimi-k2.5/llama.cpp"
VENV_DIR="$ROOT/.venv-llamacpp"
SRC_ROOT="$ROOT/models/gemma-4"
DEST_ROOT="$ROOT/models/gemma-4-gguf"
OUTTYPE="bf16"

usage() {
  cat <<'EOF'
Usage: ./tools-scripts/convert-gemma4-to-gguf.sh [--outtype bf16|f16] [E2B E4B 31B 26B-A4B]

Examples:
  ./tools-scripts/convert-gemma4-to-gguf.sh
  ./tools-scripts/convert-gemma4-to-gguf.sh E2B E4B
  ./tools-scripts/convert-gemma4-to-gguf.sh --outtype f16 E2B
EOF
}

selected=()
while [[ $# -gt 0 ]]; do
  case "$1" in
    --outtype)
      OUTTYPE="${2:-}"
      shift
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    E2B|E4B|31B|26B-A4B)
      selected+=("$1")
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage
      exit 1
      ;;
  esac
  shift
done

if [[ ${#selected[@]} -eq 0 ]]; then
  selected=(E2B E4B 31B 26B-A4B)
fi

if [[ ! -x "$VENV_DIR/bin/python" ]]; then
  echo "Missing $VENV_DIR. Run ./tools-scripts/build-llama-cpp-gemma4.sh first." >&2
  exit 1
fi

source "$VENV_DIR/bin/activate"

model_dir_for() {
  case "$1" in
    E2B) echo "gemma-4-E2B-it" ;;
    E4B) echo "gemma-4-E4B-it" ;;
    31B) echo "gemma-4-31B-it" ;;
    26B-A4B) echo "gemma-4-26B-A4B-it" ;;
  esac
}

mkdir -p "$DEST_ROOT"

for label in "${selected[@]}"; do
  model_dir="$(model_dir_for "$label")"
  src="$SRC_ROOT/$model_dir"
  out_dir="$DEST_ROOT/$model_dir"
  out_file="$out_dir/$model_dir-$OUTTYPE.gguf"
  mmproj_file="$out_dir/mmproj-$model_dir-$OUTTYPE.gguf"

  if [[ ! -d "$src" ]]; then
    echo "Missing source model dir: $src" >&2
    exit 1
  fi

  mkdir -p "$out_dir"
  echo "==> Converting $label text model from $src"
  python "$LLAMA_DIR/convert_hf_to_gguf.py" \
    "$src" \
    --outfile "$out_file" \
    --outtype "$OUTTYPE"

  echo "    wrote: $out_file"

  echo "==> Converting $label mmproj from $src"
  python "$LLAMA_DIR/convert_hf_to_gguf.py" \
    "$src" \
    --outfile "$mmproj_file" \
    --outtype "$OUTTYPE" \
    --mmproj

  echo "    wrote: $mmproj_file"
done

echo ""
echo "All requested Gemma 4 models were converted into $DEST_ROOT"
