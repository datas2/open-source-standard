#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

command -v uv >/dev/null 2>&1 || {
    echo "Error: uv is not installed."
    exit 1
}

if ! uv run ruff --version >/dev/null 2>&1; then
    echo "Error: ruff is not installed in the project."
    echo "Install it with: uv add --dev ruff"
    exit 1
fi

uv run ruff check .
uv run ruff format --check .