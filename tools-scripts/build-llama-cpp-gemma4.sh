#!/bin/bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
LLAMA_DIR="$ROOT/kimi-k2.5/llama.cpp"
BUILD_DIR="$LLAMA_DIR/build"
VENV_DIR="$ROOT/.venv-llamacpp"
UPDATE=1
REBUILD=0
BACKEND="metal"

usage() {
  cat <<'EOF'
Usage: ./tools-scripts/build-llama-cpp-gemma4.sh [options]

Options:
  --update       Fast-forward the vendored llama.cpp checkout before building (default)
  --no-update    Build current vendored checkout without pulling upstream
  --rebuild      Delete the existing build directory first
  --metal        Build with Metal support (default on macOS)
  --cuda         Build with CUDA support
  --help         Show this help
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --update) UPDATE=1 ;;
    --no-update) UPDATE=0 ;;
    --rebuild) REBUILD=1 ;;
    --metal) BACKEND="metal" ;;
    --cuda) BACKEND="cuda" ;;
    --help|-h) usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage; exit 1 ;;
  esac
  shift
done

if [[ ! -d "$LLAMA_DIR/.git" ]]; then
  echo "llama.cpp checkout not found at $LLAMA_DIR" >&2
  exit 1
fi

if [[ $UPDATE -eq 1 ]]; then
  echo "==> Updating vendored llama.cpp"
  git -C "$LLAMA_DIR" fetch --all --tags
  current_branch="$(git -C "$LLAMA_DIR" rev-parse --abbrev-ref HEAD)"
  if [[ "$current_branch" == "HEAD" ]]; then
    echo "Detached HEAD detected; switching to origin/master or origin/main" >&2
    if git -C "$LLAMA_DIR" show-ref --verify --quiet refs/remotes/origin/master; then
      git -C "$LLAMA_DIR" checkout -B master origin/master
    else
      git -C "$LLAMA_DIR" checkout -B main origin/main
    fi
  else
    git -C "$LLAMA_DIR" pull --ff-only
  fi
fi

if [[ $REBUILD -eq 1 ]]; then
  rm -rf "$BUILD_DIR"
fi

if command -v uv >/dev/null 2>&1; then
  echo "==> Creating Python 3.11 venv with uv"
  uv venv --python 3.11 --seed --clear "$VENV_DIR"
elif command -v python3.11 >/dev/null 2>&1; then
  python3.11 -m venv "$VENV_DIR"
else
  echo "Need Python 3.11+. Install it or install uv, then rerun this script." >&2
  exit 1
fi

source "$VENV_DIR/bin/activate"
# pip 26 currently chokes on PyTorch's CPU extra index metadata in this workflow.
python -m pip install --upgrade 'pip<26'
python -m pip install -r "$LLAMA_DIR/requirements/requirements-convert_hf_to_gguf.txt"

cmake_args=( -S "$LLAMA_DIR" -B "$BUILD_DIR" )
case "$BACKEND" in
  metal)
    cmake_args+=( -DGGML_METAL=ON )
    ;;
  cuda)
    cmake_args+=( -DGGML_CUDA=ON )
    ;;
esac

echo "==> Configuring llama.cpp ($BACKEND)"
cmake "${cmake_args[@]}"

echo "==> Building llama.cpp"
cmake --build "$BUILD_DIR" --target llama-cli llama-server llama-quantize -j
if cmake --build "$BUILD_DIR" --target llama-mtmd-cli -j >/dev/null 2>&1; then
  echo "Built llama-mtmd-cli"
else
  echo "WARNING: llama-mtmd-cli was not built. Your llama.cpp revision may still be too old for Gemma 4 multimodal validation." >&2
fi

echo ""
echo "Done. Key paths:"
echo "  venv:   $VENV_DIR"
echo "  build:  $BUILD_DIR"
echo "  cli:    $BUILD_DIR/bin/llama-cli"
echo "  server: $BUILD_DIR/bin/llama-server"
echo "  quant:  $BUILD_DIR/bin/llama-quantize"
if [[ -x "$BUILD_DIR/bin/llama-mtmd-cli" ]]; then
  echo "  mtmd:   $BUILD_DIR/bin/llama-mtmd-cli"
fi
