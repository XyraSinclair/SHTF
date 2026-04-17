#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.11"
# dependencies = [
#   "mlx-vlm @ git+https://github.com/Blaizzy/mlx-vlm.git@23e1dffd224488141a4f022b6d21d6a730f11507",
# ]
# ///

from __future__ import annotations

import argparse
import json
import subprocess
import sys
import time
from datetime import datetime, timezone
from pathlib import Path


MODEL_DIRS = {
    "E2B": "gemma-4-E2B-it",
    "E4B": "gemma-4-E4B-it",
    "31B": "gemma-4-31B-it",
    "26B-A4B": "gemma-4-26B-A4B-it",
}

DEFAULT_PROMPT = "In one short sentence, identify yourself as a Gemma 4 model and end with OK."


def repo_root() -> Path:
    return Path(__file__).resolve().parent.parent


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Run a local MLX smoke test against the downloaded Gemma 4 checkpoints."
    )
    parser.add_argument(
        "--models",
        nargs="+",
        choices=list(MODEL_DIRS),
        default=list(MODEL_DIRS),
        help="Subset of Gemma 4 checkpoints to test.",
    )
    parser.add_argument(
        "--models-root",
        default="models/gemma-4",
        help="Model directory root, relative to the repo root unless absolute.",
    )
    parser.add_argument(
        "--prompt",
        default=DEFAULT_PROMPT,
        help="Prompt used for the smoke test.",
    )
    parser.add_argument(
        "--max-tokens",
        type=int,
        default=48,
        help="Maximum generation length for each model.",
    )
    parser.add_argument(
        "--temperature",
        type=float,
        default=0.0,
        help="Sampling temperature.",
    )
    parser.add_argument(
        "--results-file",
        default="models/gemma-4/smoke-test-results.json",
        help="Where to write the JSON test report.",
    )
    parser.add_argument("--single-model", help=argparse.SUPPRESS)
    parser.add_argument("--label", help=argparse.SUPPRESS)
    return parser.parse_args()


def single_model_run(args: argparse.Namespace) -> int:
    from mlx_vlm import apply_chat_template, generate, load

    model_dir = Path(args.single_model).resolve()
    started = time.perf_counter()
    model, processor = load(str(model_dir))
    formatted_prompt = apply_chat_template(
        processor,
        model.config,
        [{"role": "user", "content": [{"type": "text", "text": args.prompt}]}],
        add_generation_prompt=True,
    )
    result = generate(
        model,
        processor,
        formatted_prompt,
        max_tokens=args.max_tokens,
        temperature=args.temperature,
        verbose=False,
    )
    payload = {
        "label": args.label,
        "path": str(model_dir),
        "ok": True,
        "elapsed_seconds": round(time.perf_counter() - started, 3),
        "text": result.text.strip(),
        "prompt_tokens": result.prompt_tokens,
        "generation_tokens": result.generation_tokens,
        "total_tokens": result.total_tokens,
        "prompt_tps": result.prompt_tps,
        "generation_tps": result.generation_tps,
        "peak_memory_gb": result.peak_memory,
    }
    print(json.dumps(payload, ensure_ascii=True))
    return 0


def main() -> int:
    args = parse_args()
    if args.single_model:
        return single_model_run(args)

    root = repo_root()
    models_root = Path(args.models_root)
    if not models_root.is_absolute():
        models_root = root / models_root

    results_file = Path(args.results_file)
    if not results_file.is_absolute():
        results_file = root / results_file
    results_file.parent.mkdir(parents=True, exist_ok=True)

    results = []
    failures = 0

    for label in args.models:
        model_dir = models_root / MODEL_DIRS[label]
        if not model_dir.exists():
            results.append(
                {
                    "label": label,
                    "path": str(model_dir),
                    "ok": False,
                    "error": "model directory does not exist",
                }
            )
            failures += 1
            print(f"{label}: missing model directory at {model_dir}")
            continue

        cmd = [
            sys.executable,
            str(Path(__file__).resolve()),
            "--single-model",
            str(model_dir),
            "--label",
            label,
            "--prompt",
            args.prompt,
            "--max-tokens",
            str(args.max_tokens),
            "--temperature",
            str(args.temperature),
        ]
        completed = subprocess.run(
            cmd,
            capture_output=True,
            text=True,
            check=False,
        )
        if completed.returncode != 0:
            failures += 1
            stderr = completed.stderr.strip() or completed.stdout.strip()
            results.append(
                {
                    "label": label,
                    "path": str(model_dir),
                    "ok": False,
                    "error": stderr,
                }
            )
            print(f"{label}: FAILED")
            if stderr:
                print(stderr)
            continue

        payload = json.loads(completed.stdout.strip())
        results.append(payload)
        print(
            f"{label}: OK in {payload['elapsed_seconds']}s, "
            f"peak {payload['peak_memory_gb']:.2f} GB"
        )
        print(f"    {payload['text']}")

    report = {
        "timestamp_utc": datetime.now(timezone.utc).isoformat(),
        "models_root": str(models_root),
        "prompt": args.prompt,
        "results": results,
    }
    results_file.write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
    print("")
    print(f"Wrote results to {results_file}")

    return 1 if failures else 0


if __name__ == "__main__":
    sys.exit(main())
