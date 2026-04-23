#!/usr/bin/env python3
"""
Set the project-local default OpenCode model in opencode.json.
"""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Set the default model and small_model in the repo-local opencode.json."
    )
    parser.add_argument(
        "model",
        help="Model in provider/model form, for example shtf-ollama/qwen3.6-27b-coding-nvfp4",
    )
    parser.add_argument(
        "--config",
        default="opencode.json",
        help="Path to the OpenCode config file (default: opencode.json in the repo root).",
    )
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    if "/" not in args.model:
      print("model must be in provider/model form", file=sys.stderr)
      return 1

    provider_id, model_id = args.model.split("/", 1)
    config_path = Path(args.config).resolve()

    if not config_path.exists():
        print(f"config file not found: {config_path}", file=sys.stderr)
        return 1

    payload = json.loads(config_path.read_text(encoding="utf-8"))
    providers = payload.get("provider", {})
    provider = providers.get(provider_id)
    if not provider:
        print(f"provider not found in {config_path.name}: {provider_id}", file=sys.stderr)
        return 1

    models = provider.get("models", {})
    if model_id not in models:
        print(f"model not found under provider {provider_id}: {model_id}", file=sys.stderr)
        return 1

    payload["model"] = args.model
    payload["small_model"] = args.model
    config_path.write_text(json.dumps(payload, indent=2) + "\n", encoding="utf-8")

    print(f"Updated {config_path} -> model={args.model}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
