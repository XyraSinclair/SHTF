# Local AI models in this repo

One recommended path, one easier fallback, one heavyweight option for people who specifically want it.

## TL;DR — one command

```bash
./tools-scripts/setup-gemma4.sh
```

That downloads the Gemma 4 `E2B` checkpoint, builds llama.cpp, converts to GGUF, and runs a smoke test. About 9 GB on disk. Safe to re-run; completed steps are skipped.

For all four models:

```bash
./tools-scripts/setup-gemma4.sh --all
```

Then run one:

```bash
./tools-scripts/run-gemma4-llamacpp.sh E2B
./tools-scripts/run-gemma4-llamacpp.sh --list
```

## Pick a path

| Situation | Do this | Why |
|---|---|---|
| You just want something that works offline | `setup-gemma4.sh` (E2B) | One command, modest disk, validated end-to-end |
| Tiny laptop, two-minute setup | Ollama + `llama3.2:3b` | ~2 GB, trivial install |
| You want more capability on Apple Silicon / beefy hardware | `setup-gemma4.sh E4B` then `31B` | Better answers, still standard runtime |
| You specifically want Kimi K2.5 | See [`DOWNLOADS.md`](../DOWNLOADS.md#heavyweight-optional-kimi-k25-263-gb) | 263 GB, most people should skip |

## The four Gemma 4 models

- `gemma-4-E2B-it` — ~9 GB. Starter.
- `gemma-4-E4B-it` — ~14 GB. Better answers.
- `gemma-4-31B-it` — ~55 GB. Strongest single model. Needs RAM.
- `gemma-4-26B-A4B-it` — ~55 GB. MoE, ~4B active params per token.

All four pass llama.cpp text smoke tests in BF16 and `Q4_K_M`, and pass multimodal image smoke tests in `Q4_K_M`. See [`gemma4-llamacpp.md`](gemma4-llamacpp.md) for the validated state and manual workflow.

Convert in order: `E2B` → `E4B` → `31B` → `26B-A4B`. That minimizes regret if you run out of disk partway.

## Ollama (the easy fallback)

```bash
brew install ollama
ollama pull llama3.2:3b
ollama pull phi4-mini
ollama pull qwen2.5-coder:3b

ollama run llama3.2:3b
```

- `llama3.2:3b` — general reference
- `phi4-mini` — compact reasoning
- `qwen2.5-coder:3b` — code / shell help

## Running a Gemma 4 model after setup

```bash
# Interactive chat
./tools-scripts/run-gemma4-llamacpp.sh E2B

# One-shot question
./tools-scripts/run-gemma4-llamacpp.sh 31B "Give me 10 shelf-stable protein sources."

# Server mode (OpenAI-compatible at 127.0.0.1:8080)
./tools-scripts/run-gemma4-llamacpp.sh --server E2B

# Image input (multimodal)
./tools-scripts/run-gemma4-llamacpp.sh --image ~/Desktop/test.jpg E2B "Describe the image and end with OK."

# Force a quantized build
./tools-scripts/run-gemma4-llamacpp.sh --quant Q4_K_M E4B
```

## Optional quantization

Setup keeps canonical BF16 first. Add a lighter daily-driver copy only if you want:

```bash
./tools-scripts/quantize-gemma4-gguf.sh E2B Q4_K_M
./tools-scripts/run-gemma4-llamacpp.sh --quant Q4_K_M E2B
```

Recommended first quantization target: `Q4_K_M`. Raise from there if the machine handles it.

## Kimi K2.5 (heavyweight, optional)

Kept for people who specifically want it. Setup is documented in [`DOWNLOADS.md`](../DOWNLOADS.md#heavyweight-optional-kimi-k25-263-gb). 263 GB. For most people, Gemma 4 31B is a better bet.

## Troubleshooting

- **Converter fails with missing Python modules**: run `./tools-scripts/build-llama-cpp-gemma4.sh --no-update`
- **`llama-mtmd-cli` missing**: your vendored llama.cpp is too old — `./tools-scripts/build-llama-cpp-gemma4.sh --update --rebuild`
- **Image mode fails but text works**: make sure the text GGUF and mmproj were converted in the same run
- **GGUF conversion runs out of disk**: do one model at a time; `setup-gemma4.sh E2B` then `E4B`, etc.

## Health check

```bash
./tools-scripts/verify-all.sh --full
```

Reports which Gemma 4 source checkpoints and GGUFs are present. Also runs the audit script on your canonical artifacts.

## If you only remember three commands

```bash
./tools-scripts/setup-gemma4.sh
./tools-scripts/run-gemma4-llamacpp.sh E2B
./tools-scripts/verify-all.sh --full
```
