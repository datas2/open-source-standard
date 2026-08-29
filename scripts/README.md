# Project scripts

This directory contains helper scripts for local development, testing, linting,
startup, deployment, and cleanup.

All scripts resolve the project root automatically, so they can be executed
from any working directory.

## Available scripts

### `setup.sh`

Creates or updates the project environment using `uv`.

- Verifies that `uv` is installed.
- Creates `uv.lock` if it does not exist.
- Installs dependencies with `uv sync --locked`.

Usage:

```bash
./scripts/setup.sh
```

### `lint.sh`
Runs Ruff checks and verifies code formatting.
Ruff must be declared as a development dependency:

```bash
uv add --dev ruff
uv lock
```

Usage:
```bash
./scripts/lint.sh
```

## Making scripts executable
After cloning the repository, run:
```bash
chmod +x scripts/*.sh
```

The executable permission should also be committed to Git:
```bash
git add --chmod=+x scripts/*.sh
```