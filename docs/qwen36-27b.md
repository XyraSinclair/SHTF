# Qwen3.6-27B

Qwen3.6-27B is the priority high-capability checkpoint to cache for offline SHTF use when internet and disk are available.

If you want the least-friction daily local runtime, start with [`local-ai-models.md`](local-ai-models.md) and the chooser script first. This page is about the raw Hugging Face checkpoint, not the easiest day-to-day Mac/Ollama path.

## Download

```bash
./tools-scripts/download-qwen36-27b.py
```

The script downloads `Qwen/Qwen3.6-27B` from Hugging Face into:

```text
models/Qwen3.6-27B/
```

Expected shape:

- about 56 GB in Hugging Face format
- 15 `*.safetensors` shards
- `config.json`, `chat_template.jinja`, tokenizer files, and `model.safetensors.index.json`

Safe to interrupt and rerun; completed files are reused.

## Serving Reality

This is not the tiny emergency laptop path. It is the capable model cache. Running it well may require a serious GPU setup or a serving engine such as SGLang, vLLM, KTransformers, or Transformers.

The model card lists a native context length of 262,144 tokens. Do not assume your machine can serve that length; reduce context if memory is the limiting factor.

## Example Serving Commands

These are starting points, not guaranteed laptop commands.

```bash
# SGLang
python -m sglang.launch_server \
  --model-path models/Qwen3.6-27B \
  --port 8000 \
  --tp-size 8 \
  --context-length 262144 \
  --reasoning-parser qwen3
```

```bash
# vLLM
vllm serve models/Qwen3.6-27B \
  --port 8000 \
  --tensor-parallel-size 8 \
  --max-model-len 262144 \
  --reasoning-parser qwen3
```

For a text-only vLLM run, add `--language-model-only`.

## Safety Use

Use local AI for summarizing, search help, rough planning, and navigating the offline library. Do not treat it as a medical, legal, electrical, structural, or radio authority. Use the primary references in this repo and official/local instructions when available.
