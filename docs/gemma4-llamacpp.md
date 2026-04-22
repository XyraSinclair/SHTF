# Gemma 4 with llama.cpp

This is the manual walkthrough. Most people should skip this and run:

```bash
./tools-scripts/setup-gemma4.sh
```

That does download + build + convert + smoke-test in one go. Read on only if something broke, or you want to understand what's happening, or you need a step the one-shot script doesn't cover.

## What's supported

- Text inference on all four Gemma 4 instruction models (validated in BF16 and `Q4_K_M`)
- Multimodal image inference in `Q4_K_M` (once `mmproj` conversion succeeds)
- Experimental audio-input smoke tests pass for `E2B` and `E4B` in `Q4_K_M`

Not promised: audio or video inference as supported features; tiny-footprint runtime on weak hardware.

## The four models

- `gemma-4-E2B-it`
- `gemma-4-E4B-it`
- `gemma-4-31B-it`
- `gemma-4-26B-A4B-it`

Source checkpoints live in `models/gemma-4/`. GGUF output goes to `models/gemma-4-gguf/`.

## Manual workflow (what setup-gemma4.sh wraps)

### 1. Build llama.cpp

```bash
./tools-scripts/build-llama-cpp-gemma4.sh --update
```

Variants:

```bash
./tools-scripts/build-llama-cpp-gemma4.sh --no-update   # use the vendored tree as-is
./tools-scripts/build-llama-cpp-gemma4.sh --cuda        # CUDA instead of Metal
./tools-scripts/build-llama-cpp-gemma4.sh --rebuild     # wipe build/ and rebuild
```

### 2. Convert HF checkpoints to GGUF

```bash
./tools-scripts/convert-gemma4-to-gguf.sh                 # all four, BF16 + mmproj
./tools-scripts/convert-gemma4-to-gguf.sh E2B E4B         # subset
./tools-scripts/convert-gemma4-to-gguf.sh --outtype f16 E2B
```

Output layout:

```text
models/gemma-4-gguf/
  gemma-4-E2B-it/
    gemma-4-E2B-it-bf16.gguf
    mmproj-gemma-4-E2B-it-bf16.gguf
  ...
```

### 3. Optional quantization

Canonical artifacts stay BF16. Quantization is a separate, opt-in derived copy.

```bash
./tools-scripts/quantize-gemma4-gguf.sh E2B Q4_K_M
./tools-scripts/quantize-gemma4-gguf.sh ALL Q4_K_M
```

Starting point: `Q4_K_M` for everything; raise only if your hardware handles it.

### 4. Smoke test

```bash
./tools-scripts/test-gemma4-llamacpp.py              # text-only, all converted models, BF16
./tools-scripts/test-gemma4-llamacpp.py E2B          # one model
./tools-scripts/test-gemma4-llamacpp.py --image /path/to/test.jpg
```

Writes a JSON report to `models/gemma-4-gguf/llamacpp-smoke-test-results.json`.

### 5. Run it

```bash
./tools-scripts/run-gemma4-llamacpp.sh --list
./tools-scripts/run-gemma4-llamacpp.sh E2B
./tools-scripts/run-gemma4-llamacpp.sh --server E2B
./tools-scripts/run-gemma4-llamacpp.sh --image /path/to/test.jpg E2B "Describe and end with OK."
./tools-scripts/run-gemma4-llamacpp.sh --quant Q4_K_M 31B
```

Defaults: picks the matching chat template, prefers canonical BF16/F16, switches to `llama-mtmd-cli` when `--image` is set.

## Raw llama.cpp commands (for reference)

### Text chat

```bash
kimi-k2.5/llama.cpp/build/bin/llama-cli \
  -m models/gemma-4-gguf/gemma-4-E2B-it/gemma-4-E2B-it-bf16.gguf \
  --chat-template-file models/gemma-4/gemma-4-E2B-it/chat_template.jinja \
  -ngl 999 -c 8192 -n 96 --temp 0 -st \
  -p "In one short sentence, identify yourself as a Gemma 4 model and end with OK."
```

### Multimodal image

```bash
kimi-k2.5/llama.cpp/build/bin/llama-mtmd-cli \
  -m models/gemma-4-gguf/gemma-4-E2B-it/gemma-4-E2B-it-Q4_K_M.gguf \
  --mmproj models/gemma-4-gguf/gemma-4-E2B-it/mmproj-gemma-4-E2B-it-bf16.gguf \
  --image /path/to/test-image.jpg \
  --jinja \
  -ngl 999 -c 8192 -n 96 --temp 0 --flash-attn auto --perf \
  -p "Describe the main subject and end with OK."
```

For `llama-mtmd-cli`: do not pass `--chat-template-file` or `-st`; use `--jinja` so the Gemma 4 template embedded in the GGUF metadata is applied.

### Server

```bash
kimi-k2.5/llama.cpp/build/bin/llama-server \
  -m models/gemma-4-gguf/gemma-4-E2B-it/gemma-4-E2B-it-bf16.gguf \
  --mmproj models/gemma-4-gguf/gemma-4-E2B-it/mmproj-gemma-4-E2B-it-bf16.gguf \
  --chat-template-file models/gemma-4/gemma-4-E2B-it/chat_template.jinja \
  -c 8192 -ngl 999
```

## Disk reality

Plan for three copies:
- HF checkpoints in `models/gemma-4/`
- BF16 GGUFs in `models/gemma-4-gguf/`
- Any quantized copies you produce

Convert in stages if you're tight on disk: `E2B` → `E4B` → `31B` → `26B-A4B`.

## Note on the vendored path

llama.cpp lives at `kimi-k2.5/llama.cpp/` for historical reasons — that directory name is cosmetic, the Gemma 4 tooling uses it regardless of whether you have Kimi K2.5 itself.

## Troubleshooting

**Converter fails with missing Python modules** — `./tools-scripts/build-llama-cpp-gemma4.sh --no-update`

**No Gemma 4 support in llama.cpp** — `./tools-scripts/build-llama-cpp-gemma4.sh --update`

**`llama-mtmd-cli` missing** — vendored tree too old or build incomplete: `./tools-scripts/build-llama-cpp-gemma4.sh --update --rebuild`

**Text works but image mode fails** — keep the text model and mmproj from the same conversion run; use the matching `chat_template.jinja` from the corresponding HF model directory
