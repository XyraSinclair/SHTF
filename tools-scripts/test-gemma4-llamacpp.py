#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import re
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
DEFAULT_IMAGE_PROMPT = "Describe the main subject in the image and end with OK."
PERF_RE = re.compile(r"Prompt:\s*([0-9]+(?:\.[0-9]+)?)\s*t/s\s*\|\s*Generation:\s*([0-9]+(?:\.[0-9]+)?)\s*t/s")
LLAMA_PERF_RE = re.compile(r"prompt eval time = .*?\(\s*([0-9]+(?:\.[0-9]+)?)\s+tokens per second\).*?eval time = .*?\(\s*([0-9]+(?:\.[0-9]+)?)\s+tokens per second\)", re.S)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Smoke-test Gemma 4 GGUFs with llama.cpp.")
    parser.add_argument("models", nargs="*", help="Subset of models to test: E2B, E4B, 31B, 26B-A4B.")
    parser.add_argument("--prompt", default=DEFAULT_PROMPT)
    parser.add_argument("--image", help="Optional image path for multimodal validation.")
    parser.add_argument("--image-prompt", default=DEFAULT_IMAGE_PROMPT)
    parser.add_argument("--max-tokens", type=int, default=64)
    parser.add_argument("--ctx-size", type=int, default=8192)
    parser.add_argument("--ngl", default="999")
    parser.add_argument(
        "--quant",
        help="Exact GGUF suffix to test, such as bf16, f16, or Q4_K_M. Default is canonical BF16-first selection.",
    )
    parser.add_argument(
        "--flash-attn",
        choices=["on", "off", "auto"],
        default="auto",
        help="llama.cpp flash attention setting.",
    )
    parser.add_argument(
        "--results-file",
        default="models/gemma-4-gguf/llamacpp-smoke-test-results.json",
        help="JSON report output path, relative to repo root unless absolute.",
    )
    args = parser.parse_args()
    invalid = [label for label in args.models if label not in MODEL_DIRS]
    if invalid:
        parser.error(
            "unknown model label(s): "
            + ", ".join(invalid)
            + "; choose from "
            + ", ".join(MODEL_DIRS)
        )
    return args


def repo_root() -> Path:
    return Path(__file__).resolve().parent.parent


def run_command(cmd: list[str]) -> tuple[int, str, str, float]:
    started = time.perf_counter()
    completed = subprocess.run(cmd, capture_output=True, text=True, check=False)
    elapsed = round(time.perf_counter() - started, 3)
    return completed.returncode, completed.stdout.strip(), completed.stderr.strip(), elapsed


def select_text_model(gguf_dir: Path, model_dir: str, quant: str | None) -> Path | None:
    if quant:
        candidate = gguf_dir / f"{model_dir}-{quant}.gguf"
        return candidate if candidate.exists() else None

    for suffix in ("bf16", "f16", "Q8_0", "Q6_K", "Q5_K_M", "Q4_K_M"):
        candidate = gguf_dir / f"{model_dir}-{suffix}.gguf"
        if candidate.exists():
            return candidate

    candidates = sorted(p for p in gguf_dir.glob(f"{model_dir}-*.gguf") if not p.name.startswith("mmproj-"))
    return candidates[0] if candidates else None


def parse_perf_metrics(text: str) -> dict[str, float] | None:
    matches = PERF_RE.findall(text)
    if matches:
        prompt_tps, generation_tps = matches[-1]
        return {
            "prompt_tokens_per_second": float(prompt_tps),
            "generation_tokens_per_second": float(generation_tps),
        }
    llama_perf = LLAMA_PERF_RE.findall(text)
    if llama_perf:
        prompt_tps, generation_tps = llama_perf[-1]
        return {
            "prompt_tokens_per_second": float(prompt_tps),
            "generation_tokens_per_second": float(generation_tps),
        }
    return None


def main() -> int:
    args = parse_args()
    root = repo_root()
    build_bin = root / "kimi-k2.5" / "llama.cpp" / "build" / "bin"
    cli = build_bin / "llama-cli"
    mtmd = build_bin / "llama-mtmd-cli"
    gguf_root = root / "models" / "gemma-4-gguf"
    hf_root = root / "models" / "gemma-4"

    if not cli.exists():
        print(f"Missing llama-cli at {cli}", file=sys.stderr)
        return 1

    labels = args.models or list(MODEL_DIRS)
    results: list[dict] = []
    failures = 0

    for label in labels:
        model_dir = MODEL_DIRS[label]
        gguf_dir = gguf_root / model_dir
        hf_dir = hf_root / model_dir
        template = hf_dir / "chat_template.jinja"
        text_model = select_text_model(gguf_dir, model_dir, args.quant)
        mmproj = next(iter(sorted(gguf_dir.glob("mmproj*.gguf"))), None)

        payload: dict = {
            "label": label,
            "model_dir": model_dir,
            "template": str(template),
            "text_model": str(text_model) if text_model else None,
            "mmproj": str(mmproj) if mmproj else None,
            "requested_quant": args.quant,
            "flash_attn": args.flash_attn,
        }

        if text_model:
            payload["resolved_quant"] = text_model.stem.replace(f"{model_dir}-", "")

        if not text_model or not template.exists():
            payload["ok"] = False
            payload["error"] = "missing text GGUF or chat template"
            results.append(payload)
            failures += 1
            print(f"{label}: missing text GGUF or chat template")
            continue

        text_cmd = [
            str(cli),
            "-m", str(text_model),
            "--chat-template-file", str(template),
            "-ngl", str(args.ngl),
            "-c", str(args.ctx_size),
            "-n", str(args.max_tokens),
            "--temp", "0",
            "--flash-attn", args.flash_attn,
            "--perf",
            "-st",
            "-p", args.prompt,
        ]
        rc, stdout, stderr, elapsed = run_command(text_cmd)
        combined = "\n".join(part for part in (stdout, stderr) if part)
        payload["text_ok"] = rc == 0
        payload["text_elapsed_seconds"] = elapsed
        payload["text_stdout"] = stdout
        payload["text_stderr"] = stderr
        perf = parse_perf_metrics(combined)
        if perf:
            payload.update(perf)

        if rc != 0:
            payload["ok"] = False
            results.append(payload)
            failures += 1
            print(f"{label}: text FAILED")
            continue

        perf_note = ""
        if perf:
            perf_note = f", gen {perf['generation_tokens_per_second']:.1f} t/s, prompt {perf['prompt_tokens_per_second']:.1f} t/s"
        print(f"{label}: text OK in {elapsed}s using {payload['resolved_quant']}{perf_note}")

        if args.image:
            if not mtmd.exists() or not mmproj:
                payload["image_ok"] = False
                payload["image_error"] = "missing llama-mtmd-cli or mmproj GGUF"
                payload["ok"] = False
                results.append(payload)
                failures += 1
                print(f"{label}: image FAILED (missing llama-mtmd-cli or mmproj)")
                continue
            image_cmd = [
                str(mtmd),
                "-m", str(text_model),
                "--mmproj", str(mmproj),
                "--image", args.image,
                "--jinja",
                "-ngl", str(args.ngl),
                "-c", str(args.ctx_size),
                "-n", str(args.max_tokens),
                "--temp", "0",
                "--flash-attn", args.flash_attn,
                "--perf",
                "-p", args.image_prompt,
            ]
            rc, stdout, stderr, elapsed = run_command(image_cmd)
            combined = "\n".join(part for part in (stdout, stderr) if part)
            payload["image_ok"] = rc == 0
            payload["image_elapsed_seconds"] = elapsed
            payload["image_stdout"] = stdout
            payload["image_stderr"] = stderr
            image_perf = parse_perf_metrics(combined)
            if image_perf:
                payload["image_prompt_tokens_per_second"] = image_perf["prompt_tokens_per_second"]
                payload["image_generation_tokens_per_second"] = image_perf["generation_tokens_per_second"]
            payload["ok"] = rc == 0
            if rc == 0:
                perf_note = ""
                if image_perf:
                    perf_note = (
                        f", gen {image_perf['generation_tokens_per_second']:.1f} t/s"
                        f", prompt {image_perf['prompt_tokens_per_second']:.1f} t/s"
                    )
                print(f"{label}: image OK in {elapsed}s{perf_note}")
            else:
                print(f"{label}: image FAILED")
                failures += 1
        else:
            payload["ok"] = True

        results.append(payload)

    report = {
        "timestamp_utc": datetime.now(timezone.utc).isoformat(),
        "results": results,
    }
    results_path = Path(args.results_file)
    if not results_path.is_absolute():
        results_path = root / results_path
    results_path.parent.mkdir(parents=True, exist_ok=True)
    results_path.write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
    print(f"\nWrote results to {results_path}")
    return 1 if failures else 0


if __name__ == "__main__":
    raise SystemExit(main())
