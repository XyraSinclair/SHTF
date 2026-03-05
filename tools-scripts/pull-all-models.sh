#!/bin/bash
# Pull all recommended small Ollama models for offline inference
# Run this script to download models. They'll be stored in Ollama's default location.
# These are selected for being small enough to run on Mac hardware while still useful.

set -e

echo "=== Pulling Ollama Models for Offline Use ==="
echo "These will be stored in ~/.ollama/models/"
echo ""

models=(
    "llama3.2:3b"        # General purpose, great quality for size (2GB)
    "llama3.2:1b"        # Ultra-lightweight, runs on anything (1.3GB)
    "phi4-mini"          # Microsoft's reasoning model, good for analysis (2.5GB)
    "gemma3:4b"          # Google's model, good general purpose (3GB)
    "qwen2.5-coder:3b"  # Coding assistant, good for programming help (2GB)
    "mistral:7b"         # Classic workhorse, excellent quality (4.1GB)
    "llama3.2-vision:11b" # Vision model - can analyze images/maps (7.9GB)
)

for model in "${models[@]}"; do
    echo ""
    echo ">>> Pulling $model ..."
    ollama pull "$model"
    echo "<<< Done: $model"
done

echo ""
echo "=== All models pulled! ==="
echo ""
echo "Usage: ollama run <model_name>"
echo "Example: ollama run llama3.2:3b"
echo ""
echo "Models available:"
ollama list
