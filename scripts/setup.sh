#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

echo "Setting up project in: $ROOT_DIR"

command -v uv >/dev/null 2>&1 || {
    echo "Error: uv is not installed."
    echo "Install it with: curl -LsSf https://astral.sh/uv/install.sh | sh"
    exit 1
}

if [[ ! -f pyproject.toml ]]; then
    echo "Error: pyproject.toml not found."
    exit 1
fi

if [[ ! -f uv.lock ]]; then
    echo "uv.lock not found. Creating it with uv lock..."
    uv lock
fi

echo "Installing locked dependencies..."
uv sync --locked

echo "Project setup completed successfully."