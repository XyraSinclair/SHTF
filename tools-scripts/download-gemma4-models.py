#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.11"
# dependencies = [
#   "huggingface_hub>=0.32.0",
# ]
# ///

from __future__ import annotations

import argparse
import os
import sys
from pathlib import Path

from huggingface_hub import snapshot_download


MODEL_IDS = {
    "E2B": "google/gemma-4-E2B-it",
    "E4B": "google/gemma-4-E4B-it",
    "31B": "google/gemma-4-31B-it",
    "26B-A4B": "google/gemma-4-26B-A4B-it",
}

ALLOW_PATTERNS = [
    "*.json",
    "*.jinja",
    "*.md",
    "*.model",
    "*.py",
    "*.safetensors",
    "*.txt",
]


def repo_root() -> Path:
    return Path(__file__).resolve().parent.parent


def human_size(num_bytes: int) -> str:
    size = float(num_bytes)
    for unit in ("B", "KB", "MB", "GB", "TB"):
        if size < 1024.0 or unit == "TB":
            return f"{size:.1f} {unit}"
        size /= 1024.0
    return f"{size:.1f} TB"


def directory_size(path: Path) -> int:
    total = 0
    for child in path.rglob("*"):
        if child.is_file():
            total += child.stat().st_size
    return total


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Download the four Gemma 4 instruction-tuned checkpoints into models/gemma-4/."
    )
    parser.add_argument(
        "--models",
        nargs="+",
        choices=list(MODEL_IDS),
        default=list(MODEL_IDS),
        help="Subset of Gemma 4 checkpoints to download.",
    )
    parser.add_argument(
        "--dest-root",
        default="models/gemma-4",
        help="Destination directory, relative to the repo root unless absolute.",
    )
    parser.add_argument(
        "--workers",
        type=int,
        default=8,
        help="Concurrent file download workers per model.",
    )
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    root = repo_root()
    dest_root = Path(args.dest_root)
    if not dest_root.is_absolute():
        dest_root = root / dest_root
    dest_root.mkdir(parents=True, exist_ok=True)

    token = os.environ.get("HF_TOKEN")
    failures: list[str] = []

    print(f"Downloading Gemma 4 checkpoints into {dest_root}")
    print("")
    for name in args.models:
        repo_id = MODEL_IDS[name]
        local_dir = dest_root / repo_id.split("/", 1)[1]
        print(f"==> {name}: {repo_id}")
        print(f"    destination: {local_dir}")
        try:
            snapshot_download(
                repo_id=repo_id,
                local_dir=str(local_dir),
                allow_patterns=ALLOW_PATTERNS,
                max_workers=args.workers,
                token=token,
            )
        except Exception as exc:  # pragma: no cover - CLI error path
            failures.append(f"{repo_id}: {exc}")
            print(f"    FAILED: {exc}")
            print("")
            continue

        config_path = local_dir / "config.json"
        if not config_path.exists():
            failures.append(f"{repo_id}: missing config.json after download")
            print("    FAILED: config.json missing after download")
            print("")
            continue

        size_bytes = directory_size(local_dir)
        print(f"    complete: {human_size(size_bytes)}")
        print("")

    if failures:
        print("Download completed with errors:")
        for failure in failures:
            print(f"  - {failure}")
        return 1

    print("All requested Gemma 4 checkpoints were downloaded successfully.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
