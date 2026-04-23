# Local AI models in this repo

Start with the chooser, not with blind downloading.

## TL;DR

```bash
./tools-scripts/choose-local-model.sh
```

That script recommends a sane local-model path from:

- platform
- RAM
- free disk for repo-local storage
- free disk for Ollama storage

It also prints the exact next steps to copy and run.

The rough policy is:

| Situation | Do this | Why |
|---|---|---|
| Apple Silicon with plenty of RAM/disk | Ollama + `qwen3.6:27b-coding-nvfp4` or `qwen3.6:27b-coding-mxfp8` | Best current local coding/tool path in this repo |
| Non-Mac / Intel Mac with enough headroom | Ollama + `qwen3.6:27b` | Cross-platform current Qwen path |
| Modest laptop, lower drama | `./tools-scripts/setup-gemma4.sh E2B` | Self-contained repo-local runtime |
| Tight hardware | Ollama + `qwen2.5-coder:3b` | Smallest coding-oriented fallback |
| You want the full raw checkpoint cached while online | `./tools-scripts/download-qwen36-27b.py` | Highest-capability source checkpoint cache |

## Current default lane: Ollama + Qwen3.6

The chooser is responsible for picking the model tag. The main ones are:

- `qwen3.6:27b-coding-nvfp4` — smaller Apple Silicon coding build
- `qwen3.6:27b-coding-mxfp8` — larger Apple Silicon coding build
- `qwen3.6:27b` — cross-platform default

Do not guess. Pull the tag the chooser recommended.

### One-time Ollama context setup by platform

Ollama defaults are often too small for coding tools and agent loops. Ollama's docs recommend at least 64K context for agents and coding tools. Set that once, then verify with `ollama ps`.

macOS app:

```bash
launchctl setenv OLLAMA_CONTEXT_LENGTH 65536
osascript -e 'quit app "Ollama"' 2>/dev/null || true
open -a Ollama
```

Linux systemd service:

```bash
sudo systemctl edit ollama.service
# add:
# [Service]
# Environment="OLLAMA_CONTEXT_LENGTH=65536"
sudo systemctl daemon-reload
sudo systemctl restart ollama
```

Windows app:

- Quit Ollama from the tray
- Set user environment variable `OLLAMA_CONTEXT_LENGTH=65536`
- Start Ollama again from the Start menu

CLI fallback when you are not using an app/service wrapper:

```bash
OLLAMA_CONTEXT_LENGTH=65536 ollama serve
```

Then pull the model the chooser recommended.

Common picks:

```bash
# Apple Silicon default
ollama pull qwen3.6:27b-coding-nvfp4

# Bigger Apple Silicon option
ollama pull qwen3.6:27b-coding-mxfp8

# Cross-platform default
ollama pull qwen3.6:27b
```

Check what actually loaded:

```bash
ollama ps
```

Why this matters: coding tools and agents need a real context window. Leaving Ollama at a tiny default defeats the point.

## OpenCode and Hermes

Both tools can use the same local Ollama endpoint:

```text
http://localhost:11434/v1
```

- `OpenCode`: the repo-local `opencode.json` is pointed at Ollama
- `Hermes`: use a custom OpenAI-compatible endpoint and point it at the same URL

If the chooser recommended an Apple-specific Qwen tag, update the project default model so `opencode` uses the model you actually pulled:

```bash
python3 ./tools-scripts/set-opencode-model.py shtf-ollama/qwen3.6-27b-coding-nvfp4
```

Swap in `qwen3.6-27b-coding-mxfp8` or `qwen3.6-27b` if that is what you installed.

Do not assume a model that "fits" at 4K context will still behave well for coding tools at 64K.

## Qwen3.6-27B raw checkpoint cache

```bash
./tools-scripts/download-qwen36-27b.py
```

Use this when you have time, power, internet, and about 56 GB of repo disk. It stores the public `Qwen/Qwen3.6-27B` checkpoint under `models/Qwen3.6-27B/`. For serving notes, see [`qwen36-27b.md`](qwen36-27b.md).

This is the "cache it while online" path, not the lowest-friction day-to-day runtime path.

## Gemma 4 self-contained repo-local path

Gemma 4 stays in the repo because it is the self-contained local runtime lane here. This is the right answer when you want less provider drift or the chooser decides a 27B Qwen lane is too optimistic for the machine.

```bash
./tools-scripts/setup-gemma4.sh         # E2B starter
./tools-scripts/setup-gemma4.sh --all   # all four models
```

Then run one:

```bash
./tools-scripts/run-gemma4-llamacpp.sh E2B
./tools-scripts/run-gemma4-llamacpp.sh --list
```

The four models:

- `gemma-4-E2B-it` — ~9 GB source. Starter.
- `gemma-4-E4B-it` — ~14 GB source. Better answers.
- `gemma-4-31B-it` — ~55 GB source. Strongest single model.
- `gemma-4-26B-A4B-it` — ~55 GB source. MoE variant.

All four pass llama.cpp text smoke tests in BF16 and `Q4_K_M`, and pass multimodal image smoke tests in `Q4_K_M`. See [`gemma4-llamacpp.md`](gemma4-llamacpp.md) for the validated state and manual workflow.

Convert in order: `E2B` -> `E4B` -> `31B` -> `26B-A4B`.

## Tiny fallback

If the machine cannot honestly support the main recommendations:

```bash
ollama pull qwen2.5-coder:3b
ollama run qwen2.5-coder:3b
```

Useful for short shell/code help. Do not confuse this with a strong agentic coding setup.

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

Recommended first quantization target: `Q4_K_M`.

## Kimi K2.5 (heavyweight, optional)

Kept for people who specifically want it. Setup is documented in [`DOWNLOADS.md`](../DOWNLOADS.md#heavyweight-optional-kimi-k25-263-gb). 263 GB. For most people, current `Qwen3.6` or `Gemma 4` is the better SHTF choice.

## Troubleshooting

- **OpenCode feels crippled**: make sure Ollama was started with `OLLAMA_CONTEXT_LENGTH=65536`
- **`ollama ps` shows a tiny context**: restart Ollama with a larger context before judging the model
- **Gemma converter fails with missing Python modules**: run `./tools-scripts/build-llama-cpp-gemma4.sh --no-update`
- **`llama-mtmd-cli` missing**: your vendored llama.cpp is too old — `./tools-scripts/build-llama-cpp-gemma4.sh --update --rebuild`
- **Image mode fails but text works**: make sure the text GGUF and mmproj were converted in the same run
- **GGUF conversion runs out of disk**: do one model at a time; `setup-gemma4.sh E2B` then `E4B`, etc.

## Health check

```bash
./tools-scripts/verify-all.sh --full
```

Reports which optional local-model assets are present and whether Ollama is installed.

## If you only remember three commands

```bash
./tools-scripts/choose-local-model.sh
OLLAMA_CONTEXT_LENGTH=65536 ollama serve
./tools-scripts/verify-all.sh --full
```
