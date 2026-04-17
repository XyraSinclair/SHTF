# Gemma 4 with llama.cpp

This repo now has two Gemma 4 paths:

1. Native Hugging Face checkpoints under `models/gemma-4/`
2. A llama.cpp workflow for converting them to GGUF and running them locally

## What is in scope

Supported target in this repo:
- Text inference on all four Gemma 4 instruction models
- Multimodal image inference once `--mmproj` conversion succeeds

Current validated state in this checkout:
- All four models pass llama.cpp text smoke tests in BF16
- All four models pass llama.cpp text smoke tests in `Q4_K_M`
- All four models pass multimodal image smoke tests in `Q4_K_M`
- `E2B` and `E4B` also pass experimental audio-input smoke tests in `Q4_K_M`

Not promised yet:
- Audio or video inference
- Tiny-footprint runtime on weak hardware

## The four local models

- `gemma-4-E2B-it`
- `gemma-4-E4B-it`
- `gemma-4-31B-it`
- `gemma-4-26B-A4B-it`

Source checkpoints live in `models/gemma-4/`.
GGUF output will be written to `models/gemma-4-gguf/`.

## Why this doc exists

The older vendored `kimi-k2.5/llama.cpp` tree can be too stale for Gemma 4.
Use the build script below with `--update` so the vendored tree is refreshed to a modern upstream revision before conversion.

## 1. Build llama.cpp with Gemma 4 support

```bash
./tools-scripts/build-llama-cpp-gemma4.sh --update
```

What it does:
- optionally fast-forwards `kimi-k2.5/llama.cpp`
- creates `.venv-llamacpp/`
- installs conversion dependencies
- builds `llama-cli`, `llama-server`, `llama-quantize`, and `llama-mtmd-cli` when available

Useful variants:

```bash
./tools-scripts/build-llama-cpp-gemma4.sh --no-update
./tools-scripts/build-llama-cpp-gemma4.sh --cuda
./tools-scripts/build-llama-cpp-gemma4.sh --rebuild
```

## 2. Convert the four HF checkpoints to GGUF

```bash
./tools-scripts/convert-gemma4-to-gguf.sh
```

Defaults:
- converts all four models
- writes canonical BF16 GGUF files first
- also writes multimodal projector GGUF files with `--mmproj`
- does not quantize unless you explicitly ask for it later

Examples:

```bash
./tools-scripts/convert-gemma4-to-gguf.sh E2B E4B
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

## 3. Optional quantization

Start with BF16 conversion first. Then quantize the text model only:

```bash
./tools-scripts/quantize-gemma4-gguf.sh E2B Q4_K_M
./tools-scripts/quantize-gemma4-gguf.sh ALL Q4_K_M
```

Recommended starting point:
- `E2B`, `E4B`: `Q4_K_M`
- `31B`, `26B-A4B`: `Q4_K_M` first, then raise if hardware allows

## 4. Smoke-test the llama.cpp path

Text-only on all converted models, using BF16 by default:

```bash
./tools-scripts/test-gemma4-llamacpp.py
```

With image validation too:

```bash
./tools-scripts/test-gemma4-llamacpp.py --image /path/to/test-image.jpg
```

This writes a JSON report to:

```text
models/gemma-4-gguf/llamacpp-smoke-test-results.json
```

## 5. Fast runner for repeated use

If you do not want to remember the full llama.cpp command lines, use the convenience wrapper:

```bash
./tools-scripts/run-gemma4-llamacpp.sh --list
./tools-scripts/run-gemma4-llamacpp.sh E2B
./tools-scripts/run-gemma4-llamacpp.sh --server E2B
./tools-scripts/run-gemma4-llamacpp.sh --image /path/to/test-image.jpg E2B "Describe the main subject and end with OK."
```

The wrapper:
- picks the matching chat template
- prefers canonical BF16/F16 GGUFs by default
- only uses quantized GGUFs when you explicitly pass `--quant`
- switches to `llama-mtmd-cli` automatically for image mode

## 6. Manual run examples

### Text chat

```bash
kimi-k2.5/llama.cpp/build/bin/llama-cli \
  -m models/gemma-4-gguf/gemma-4-E2B-it/gemma-4-E2B-it-bf16.gguf \
  --chat-template-file models/gemma-4/gemma-4-E2B-it/chat_template.jinja \
  -ngl 999 -c 8192 -n 96 --temp 0 -st \
  -p "In one short sentence, identify yourself as a Gemma 4 model and end with OK."
```

### Multimodal image run

```bash
kimi-k2.5/llama.cpp/build/bin/llama-mtmd-cli \
  -m models/gemma-4-gguf/gemma-4-E2B-it/gemma-4-E2B-it-Q4_K_M.gguf \
  --mmproj models/gemma-4-gguf/gemma-4-E2B-it/mmproj-gemma-4-E2B-it-bf16.gguf \
  --image /path/to/test-image.jpg \
  --jinja \
  -ngl 999 -c 8192 -n 96 --temp 0 --flash-attn auto --perf \
  -p "Describe the main subject in the image and end with OK."
```

Notes for current upstream `llama-mtmd-cli`:
- do not pass `--chat-template-file` here
- do not pass `-st` here
- use `--jinja` so the Gemma 4 template embedded in GGUF metadata is applied

### Server mode

```bash
kimi-k2.5/llama.cpp/build/bin/llama-server \
  -m models/gemma-4-gguf/gemma-4-E2B-it/gemma-4-E2B-it-bf16.gguf \
  --mmproj models/gemma-4-gguf/gemma-4-E2B-it/mmproj-gemma-4-E2B-it-bf16.gguf \
  --chat-template-file models/gemma-4/gemma-4-E2B-it/chat_template.jinja \
  -c 8192 -ngl 999
```

## Disk and hardware reality

Converting all four models is heavy.
Plan for:
- the original HF checkpoints in `models/gemma-4/`
- full-size GGUF outputs in `models/gemma-4-gguf/`
- extra space for quantized copies

Do the workflow in stages if you are tight on disk:
1. `E2B`
2. `E4B`
3. `31B`
4. `26B-A4B`

## Quick troubleshooting

### Converter fails with missing Python modules
Run:

```bash
./tools-scripts/build-llama-cpp-gemma4.sh --no-update
```

### No Gemma 4 support in llama.cpp
Run:

```bash
./tools-scripts/build-llama-cpp-gemma4.sh --update
```

### `llama-mtmd-cli` missing
Your checked-out llama.cpp revision is too old or your build is incomplete.
Re-run the build with `--update --rebuild`.

### Text works but image mode fails
Keep the text model and mmproj in sync for the same model and conversion run.
Use the matching `chat_template.jinja` from the corresponding HF model directory.
