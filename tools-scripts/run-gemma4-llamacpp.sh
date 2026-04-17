#!/bin/bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
BUILD_BIN="$ROOT/kimi-k2.5/llama.cpp/build/bin"
GGUF_ROOT="$ROOT/models/gemma-4-gguf"
HF_ROOT="$ROOT/models/gemma-4"
MODE="chat"
MODEL_LABEL=""
PROMPT="Tell me what model you are in one short sentence and end with OK."
IMAGE_PATH=""
QUANT_PREFERENCE=""
CTX_SIZE="8192"
MAX_TOKENS="256"
NGL="999"
HOST="127.0.0.1"
PORT="8080"
TEMP="0"

usage() {
  cat <<'EOF'
Usage:
  ./tools-scripts/run-gemma4-llamacpp.sh [options] <E2B|E4B|31B|26B-A4B> [prompt]

Modes:
  default          Run a text chat prompt with llama-cli
  --image PATH     Run multimodal inference with llama-mtmd-cli
  --server         Launch llama-server for the selected model
  --list           Show available local Gemma 4 GGUF artifacts

Options:
  --quant NAME     Use a specific GGUF suffix such as bf16, f16, or Q4_K_M
  --ctx-size N     Context window (default: 8192)
  --max-tokens N   Max output tokens for chat/image mode (default: 256)
  --ngl N          GPU offload layers (default: 999)
  --temp F         Sampling temperature (default: 0)
  --host HOST      Server host (default: 127.0.0.1)
  --port PORT      Server port (default: 8080)
  --help           Show this help

Examples:
  ./tools-scripts/run-gemma4-llamacpp.sh E2B
  ./tools-scripts/run-gemma4-llamacpp.sh E2B "Give 5 water purification methods."
  ./tools-scripts/run-gemma4-llamacpp.sh --quant bf16 31B
  ./tools-scripts/run-gemma4-llamacpp.sh --quant Q4_K_M E4B
  ./tools-scripts/run-gemma4-llamacpp.sh --image ~/Desktop/test.jpg E4B "Describe the image and end with OK."
  ./tools-scripts/run-gemma4-llamacpp.sh --server E2B
  ./tools-scripts/run-gemma4-llamacpp.sh --list
EOF
}

model_dir_for() {
  case "$1" in
    E2B) echo "gemma-4-E2B-it" ;;
    E4B) echo "gemma-4-E4B-it" ;;
    31B) echo "gemma-4-31B-it" ;;
    26B-A4B) echo "gemma-4-26B-A4B-it" ;;
    *) return 1 ;;
  esac
}

select_text_model() {
  local dir="$1"
  local preferred="${2:-}"
  local candidate

  if [[ -n "$preferred" ]]; then
    candidate="$dir/${MODEL_DIR}-${preferred}.gguf"
    [[ -f "$candidate" ]] && { echo "$candidate"; return 0; }
  fi

  # Canonical default is full-precision BF16 first. Quantization is opt-in.
  for suffix in bf16 f16 Q8_0 Q6_K Q5_K_M Q4_K_M; do
    candidate="$dir/${MODEL_DIR}-${suffix}.gguf"
    [[ -f "$candidate" ]] && { echo "$candidate"; return 0; }
  done

  find "$dir" -maxdepth 1 -type f -name "${MODEL_DIR}-*.gguf" ! -name 'mmproj-*' | sort | head -n 1
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --server) MODE="server" ;;
    --image)
      MODE="image"
      IMAGE_PATH="${2:-}"
      shift
      ;;
    --list) MODE="list" ;;
    --quant)
      QUANT_PREFERENCE="${2:-}"
      shift
      ;;
    --ctx-size)
      CTX_SIZE="${2:-}"
      shift
      ;;
    --max-tokens)
      MAX_TOKENS="${2:-}"
      shift
      ;;
    --ngl)
      NGL="${2:-}"
      shift
      ;;
    --temp)
      TEMP="${2:-}"
      shift
      ;;
    --host)
      HOST="${2:-}"
      shift
      ;;
    --port)
      PORT="${2:-}"
      shift
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    E2B|E4B|31B|26B-A4B)
      MODEL_LABEL="$1"
      ;;
    *)
      if [[ -z "$MODEL_LABEL" ]]; then
        echo "Unknown argument: $1" >&2
        usage
        exit 1
      fi
      if [[ "$PROMPT" == "Tell me what model you are in one short sentence and end with OK." ]]; then
        PROMPT="$1"
      else
        PROMPT+=" $1"
      fi
      ;;
  esac
  shift
done

if [[ "$MODE" == "list" ]]; then
  for label in E2B E4B 31B 26B-A4B; do
    MODEL_DIR="$(model_dir_for "$label")"
    DIR="$GGUF_ROOT/$MODEL_DIR"
    echo "==> $label ($MODEL_DIR)"
    if [[ -d "$DIR" ]]; then
      find "$DIR" -maxdepth 1 -type f \( -name '*.gguf' -o -name '*.json' \) | sed "s#^$ROOT/##" | sort
    else
      echo "  missing: $DIR"
    fi
    echo ""
  done
  exit 0
fi

[[ -n "$MODEL_LABEL" ]] || { usage; exit 1; }
MODEL_DIR="$(model_dir_for "$MODEL_LABEL")"
MODEL_PATH_ROOT="$GGUF_ROOT/$MODEL_DIR"
TEMPLATE="$HF_ROOT/$MODEL_DIR/chat_template.jinja"

if [[ ! -d "$MODEL_PATH_ROOT" ]]; then
  echo "Missing GGUF directory: $MODEL_PATH_ROOT" >&2
  echo "Run ./tools-scripts/convert-gemma4-to-gguf.sh $MODEL_LABEL first." >&2
  exit 1
fi

TEXT_MODEL="$(select_text_model "$MODEL_PATH_ROOT" "$QUANT_PREFERENCE")"
MMPROJ="$(find "$MODEL_PATH_ROOT" -maxdepth 1 -type f -name 'mmproj-*.gguf' | sort | head -n 1 || true)"

if [[ ! -x "$BUILD_BIN/llama-cli" ]]; then
  echo "Missing $BUILD_BIN/llama-cli" >&2
  echo "Run ./tools-scripts/build-llama-cpp-gemma4.sh first." >&2
  exit 1
fi

if [[ ! -f "$TEXT_MODEL" ]]; then
  echo "No Gemma 4 GGUF found for $MODEL_LABEL under $MODEL_PATH_ROOT" >&2
  echo "Run ./tools-scripts/convert-gemma4-to-gguf.sh first. Quantization is optional." >&2
  exit 1
fi

if [[ ! -f "$TEMPLATE" ]]; then
  echo "Missing chat template at $TEMPLATE" >&2
  echo "Download the matching Hugging Face checkpoint into models/gemma-4/ first." >&2
  exit 1
fi

CHAT_COMMON_ARGS=(
  -m "$TEXT_MODEL"
  --chat-template-file "$TEMPLATE"
  -ngl "$NGL"
  -c "$CTX_SIZE"
)

case "$MODE" in
  chat)
    echo "==> Running $MODEL_LABEL with $(basename "$TEXT_MODEL")"
    exec "$BUILD_BIN/llama-cli" \
      "${CHAT_COMMON_ARGS[@]}" \
      -n "$MAX_TOKENS" \
      --temp "$TEMP" \
      -st \
      -p "$PROMPT"
    ;;
  image)
    [[ -x "$BUILD_BIN/llama-mtmd-cli" ]] || {
      echo "Missing $BUILD_BIN/llama-mtmd-cli" >&2
      echo "Rebuild with ./tools-scripts/build-llama-cpp-gemma4.sh --update --rebuild" >&2
      exit 1
    }
    [[ -n "$IMAGE_PATH" ]] || {
      echo "--image requires a file path" >&2
      exit 1
    }
    [[ -f "$IMAGE_PATH" ]] || {
      echo "Image file not found: $IMAGE_PATH" >&2
      exit 1
    }
    [[ -f "$MMPROJ" ]] || {
      echo "Missing mmproj GGUF under $MODEL_PATH_ROOT" >&2
      echo "Re-run ./tools-scripts/convert-gemma4-to-gguf.sh for $MODEL_LABEL" >&2
      exit 1
    }
    echo "==> Running multimodal $MODEL_LABEL with $(basename "$TEXT_MODEL")"
    exec "$BUILD_BIN/llama-mtmd-cli" \
      -m "$TEXT_MODEL" \
      --mmproj "$MMPROJ" \
      --image "$IMAGE_PATH" \
      --jinja \
      -ngl "$NGL" \
      -c "$CTX_SIZE" \
      -n "$MAX_TOKENS" \
      --temp "$TEMP" \
      --flash-attn auto \
      --perf \
      -p "$PROMPT"
    ;;
  server)
    echo "==> Serving $MODEL_LABEL with $(basename "$TEXT_MODEL") on http://$HOST:$PORT"
    if [[ -f "$MMPROJ" ]]; then
      exec "$BUILD_BIN/llama-server" \
        "${CHAT_COMMON_ARGS[@]}" \
        --mmproj "$MMPROJ" \
        --host "$HOST" \
        --port "$PORT"
    else
      exec "$BUILD_BIN/llama-server" \
        "${CHAT_COMMON_ARGS[@]}" \
        --host "$HOST" \
        --port "$PORT"
    fi
    ;;
  *)
    echo "Unknown mode: $MODE" >&2
    exit 1
    ;;
esac
