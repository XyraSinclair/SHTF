# Local AI models in this repo

This repo now has a real local-model ladder instead of a single huge-model story.

Use the lightest thing that solves your problem.

## Fast model chooser

| Need | Best path | Why | Disk reality |
|---|---|---|---|
| Fastest offline chat on almost any laptop | Ollama + `llama3.2:3b` | Tiny, simple, good enough for general reference | ~2 GB |
| Small offline reasoning helper | Ollama + `phi4-mini` | Better structured reasoning in a compact package | ~2.5 GB |
| Small offline coding helper | Ollama + `qwen2.5-coder:3b` | Better code help than the tiny general models | ~2 GB |
| Stronger local Gemma path on Apple Silicon | native Gemma 4 checkpoints + `mlx-vlm` | Best fit when you already have the full checkpoints in this repo | ~131 GB for all four checkpoints |
| Portable GGUF path with llama.cpp | Gemma 4 GGUFs via `llama.cpp` | Lets you run Gemma 4 through a standard local runtime with quantization | source checkpoints + GGUF copies |
| Maximum capability in this repo | Kimi K2.5 | Biggest local option documented here | ~263 GB |

## What is actually supported here

If you are entering this repo cold, start with:

```bash
./tools-scripts/get-squared-away.sh
./tools-scripts/get-squared-away.sh --json
```

Documented and scripted paths:

1. Small Ollama models for quick offline use
2. Native Gemma 4 checkpoints in `models/gemma-4/`
3. Gemma 4 GGUF conversion and testing with llama.cpp
4. Kimi K2.5 as the heavyweight path

Today the best-scripted llama.cpp workflow in this repo is Gemma 4.
That is the path to use when you want bigger local models but still want a standard GGUF runtime.

## Small models: fastest path with Ollama

```bash
brew install ollama
ollama pull llama3.2:3b
ollama pull phi4-mini
ollama pull qwen2.5-coder:3b
```

Quick use:

```bash
ollama run llama3.2:3b
ollama run phi4-mini
ollama run qwen2.5-coder:3b
```

Suggested use:
- `llama3.2:3b` for general survival reference and how-to questions
- `phi4-mini` for compact reasoning
- `qwen2.5-coder:3b` for code or shell help

## Gemma 4: two supported paths

### Path A: native checkpoints on Apple Silicon

The source checkpoints live in:

```text
models/gemma-4/
```

Download them:

```bash
uv run tools-scripts/download-gemma4-models.py
```

Smoke-test them:

```bash
uv run tools-scripts/test-gemma4-models.py
```

Use this path when:
- you are on Apple Silicon
- you want to validate the original checkpoints directly
- you are not trying to standardize on GGUF yet

### Path B: Gemma 4 with llama.cpp

Use this path when:
- you want GGUF artifacts
- you want quantization
- you want one standard local runtime
- you want text mode now and optional multimodal mode when `mmproj` is available

Core workflow:

```bash
./tools-scripts/build-llama-cpp-gemma4.sh --update
./tools-scripts/convert-gemma4-to-gguf.sh
./tools-scripts/audit-gemma4-artifacts.py
./tools-scripts/test-gemma4-llamacpp.py
```

That path keeps the canonical artifacts full-precision BF16 first. Quantization is optional and explicit.

For the full walkthrough, read:

```text
docs/gemma4-llamacpp.md
```

## New convenience runner for Gemma 4 GGUFs

This repo now includes:

```text
tools-scripts/run-gemma4-llamacpp.sh
```

It finds the matching chat template, picks a local GGUF, and runs the right llama.cpp binary. By default it picks BF16/F16 before any quantized copy.

### List what you have locally

```bash
./tools-scripts/run-gemma4-llamacpp.sh --list
```

### Quick text run

```bash
./tools-scripts/run-gemma4-llamacpp.sh E2B
./tools-scripts/run-gemma4-llamacpp.sh 31B "Give me 10 shelf-stable protein sources."
```

### Force a quantized build

```bash
./tools-scripts/run-gemma4-llamacpp.sh --quant Q4_K_M E4B
```

### Multimodal image run

```bash
./tools-scripts/run-gemma4-llamacpp.sh --image ~/Desktop/test.jpg E2B "Describe the image and end with OK."
```

### Server mode

```bash
./tools-scripts/run-gemma4-llamacpp.sh --server E2B
```

Then hit the local server:

```bash
curl http://127.0.0.1:8080/v1/chat/completions \
  -H 'Content-Type: application/json' \
  -d '{
    "model": "gemma-4-E2B-it",
    "messages": [{"role": "user", "content": "Summarize water purification basics in 5 bullets."}],
    "max_tokens": 180,
    "temperature": 0
  }'
```

## Hardware guidance that is actually useful

Start in this order:

1. `E2B`
2. `E4B`
3. `31B`
4. `26B-A4B`

That order minimizes regret.

Practical defaults:
- Keep the canonical downloaded and converted artifacts in full precision first
- Use `E2B` first if you are unsure
- Use `31B` only when you know you have the RAM, disk, and patience
- Add `Q4_K_M` only as an extra derived artifact when you want a lighter daily-driver copy

## Recommended workflow by machine class

### Average laptop
- Use Ollama first
- If you insist on Gemma 4, start with `E2B` and quantize it

### Apple Silicon machine with more headroom
- Validate native Gemma 4 with `test-gemma4-models.py`
- Then convert `E2B` or `E4B` to GGUF
- Use the convenience runner for repeated local use

### Big workstation
- Build llama.cpp once
- Convert selectively, not everything at once
- Keep a quantized daily-driver copy and only retain BF16 where you really need it

## Sharp edges

- The vendored `kimi-k2.5/llama.cpp` tree may be too old unless you refresh it with `--update`
- Gemma 4 GGUF conversion needs large extra disk headroom
- Multimodal mode depends on matching `mmproj` output and the matching `chat_template.jinja`
- `llama-cli` smoke tests should use `-st` so the process exits cleanly after one answer

## If you only remember three commands

```bash
./tools-scripts/build-llama-cpp-gemma4.sh --update
./tools-scripts/convert-gemma4-to-gguf.sh E2B
./tools-scripts/run-gemma4-llamacpp.sh E2B
```
