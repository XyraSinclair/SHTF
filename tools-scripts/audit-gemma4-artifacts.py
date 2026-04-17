#!/usr/bin/env python3
from __future__ import annotations

import json
import sys
from datetime import datetime, timezone
from pathlib import Path

MODELS = {
    "E2B": {"dir": "gemma-4-E2B-it", "weight_files": ["model.safetensors"]},
    "E4B": {"dir": "gemma-4-E4B-it", "weight_files": ["model.safetensors"]},
    "31B": {
        "dir": "gemma-4-31B-it",
        "weight_files": ["model-00001-of-00002.safetensors", "model-00002-of-00002.safetensors", "model.safetensors.index.json"],
    },
    "26B-A4B": {
        "dir": "gemma-4-26B-A4B-it",
        "weight_files": ["model-00001-of-00002.safetensors", "model-00002-of-00002.safetensors", "model.safetensors.index.json"],
    },
}
COMMON_HF_FILES = [
    "config.json",
    "generation_config.json",
    "processor_config.json",
    "tokenizer.json",
    "tokenizer_config.json",
    "chat_template.jinja",
]


def file_size_gib(path: Path) -> float:
    return round(path.stat().st_size / 1024 / 1024 / 1024, 3)


def dir_size_gib(path: Path) -> float:
    total = sum(f.stat().st_size for f in path.rglob("*") if f.is_file() and "/.cache/" not in str(f))
    return round(total / 1024 / 1024 / 1024, 3)


def main() -> int:
    root = Path(__file__).resolve().parent.parent
    hf_root = root / "models" / "gemma-4"
    gguf_root = root / "models" / "gemma-4-gguf"
    report: dict[str, object] = {
        "timestamp_utc": datetime.now(timezone.utc).isoformat(),
        "hf_root": str(hf_root),
        "gguf_root": str(gguf_root),
        "models": {},
    }
    failures = 0

    for label, meta in MODELS.items():
        model_dir = hf_root / meta["dir"]
        gguf_dir = gguf_root / meta["dir"]
        entry: dict[str, object] = {
            "hf_dir": str(model_dir),
            "gguf_dir": str(gguf_dir),
            "hf_present": model_dir.exists(),
            "gguf_present": gguf_dir.exists(),
            "missing_hf_files": [],
            "hf_files": {},
            "gguf_files": {},
            "ok": True,
        }

        if model_dir.exists():
            expected_hf = COMMON_HF_FILES + list(meta["weight_files"])
            missing_hf = [name for name in expected_hf if not (model_dir / name).exists()]
            entry["missing_hf_files"] = missing_hf
            entry["hf_dir_size_gib"] = dir_size_gib(model_dir)
            for name in expected_hf:
                path = model_dir / name
                if path.exists() and path.is_file():
                    entry["hf_files"][name] = {"size_gib": file_size_gib(path)}
            if missing_hf:
                entry["ok"] = False
        else:
            entry["ok"] = False
            entry["missing_hf_files"] = COMMON_HF_FILES + list(meta["weight_files"])

        if gguf_dir.exists():
            ggufs = sorted(gguf_dir.glob("*.gguf"))
            for path in ggufs:
                entry["gguf_files"][path.name] = {"size_gib": file_size_gib(path)}
            entry["bf16_text_present"] = any(path.name == f"{meta['dir']}-bf16.gguf" for path in ggufs)
            entry["bf16_mmproj_present"] = any(path.name == f"mmproj-{meta['dir']}-bf16.gguf" for path in ggufs)
            if not entry["bf16_text_present"] or not entry["bf16_mmproj_present"]:
                entry["ok"] = False
        else:
            entry["bf16_text_present"] = False
            entry["bf16_mmproj_present"] = False
            entry["ok"] = False

        if not entry["ok"]:
            failures += 1
        report["models"][label] = entry

    print(json.dumps(report, indent=2))
    return 1 if failures else 0


if __name__ == "__main__":
    sys.exit(main())
