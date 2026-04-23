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

from huggingface_hub import HfApi, snapshot_download


MODEL_ID = "Qwen/Qwen3.6-27B"
DEFAULT_DEST = "models/Qwen3.6-27B"
ALLOW_PATTERNS = [
    ".gitattributes",
    "LICENSE",
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
        description="Download Qwen3.6-27B into models/Qwen3.6-27B/ for offline SHTF use."
    )
    parser.add_argument(
        "--dest",
        default=DEFAULT_DEST,
        help="Destination directory, relative to the repo root unless absolute.",
    )
    parser.add_argument(
        "--revision",
        default=None,
        help="Optional Hugging Face revision/commit to pin.",
    )
    parser.add_argument(
        "--workers",
        type=int,
        default=8,
        help="Concurrent file download workers.",
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Show remote file count and size without downloading.",
    )
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    root = repo_root()
    dest = Path(args.dest)
    if not dest.is_absolute():
        dest = root / dest

    token = os.environ.get("HF_TOKEN")
    api = HfApi(token=token)
    info = api.model_info(MODEL_ID, revision=args.revision, files_metadata=True)
    siblings = info.siblings or []
    expected_size = sum((getattr(item, "size", None) or 0) for item in siblings)
    safetensor_count = sum(1 for item in siblings if item.rfilename.endswith(".safetensors"))

    print(f"Model: {MODEL_ID}")
    print(f"Revision: {info.sha}")
    print(f"Remote files: {len(siblings)} ({safetensor_count} safetensor shards/files)")
    print(f"Remote size: {human_size(expected_size)}")
    print(f"Destination: {dest}")

    if args.dry_run:
        return 0

    dest.mkdir(parents=True, exist_ok=True)
    print("")
    print("Downloading. Safe to interrupt and rerun; completed files are reused.")
    snapshot_download(
        repo_id=MODEL_ID,
        revision=args.revision,
        local_dir=str(dest),
        allow_patterns=ALLOW_PATTERNS,
        max_workers=args.workers,
        token=token,
    )

    required = [
        "config.json",
        "chat_template.jinja",
        "model.safetensors.index.json",
        "tokenizer.json",
        "tokenizer_config.json",
    ]
    missing = [name for name in required if not (dest / name).is_file()]
    shard_count = len(list(dest.glob("*.safetensors")))
    if shard_count < 15:
        missing.append(f"expected 15 safetensor shards, found {shard_count}")

    local_size = directory_size(dest)
    print("")
    print(f"Downloaded size: {human_size(local_size)}")
    print(f"Safetensor shards present: {shard_count}")

    if missing:
        print("Download is incomplete:")
        for item in missing:
            print(f"  - {item}")
        return 1

    print("Qwen3.6-27B download is complete.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
