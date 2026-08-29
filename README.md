# project_name
This an open-source project maintained by Data S2.

Contributions, ideas, experiments, bug reports, architectural discussions, and improvements are welcome.

The project evolves through practical engineering challenges, research, and continuous experimentation.

## 1. What problem does it solve?

## 2. How do I run it locally?

## 3. How do I deploy it?
This project uses three GitHub Actions workflows to ensure quality and automate releases: `test.yml`, `build.yml`, and `deploy.yml`. The `test.yml` workflow runs unit, integration, and end-to-end tests on every push and pull request targeting `main`, using `uv` to install dependencies and `pytest` to execute tests in `tests/unit`, `tests/integration`, and `tests/e2e` (when those folders exist).

After tests, the `build.yml` workflow runs on every push to `main` and automatically generates a new semantic version tag based on conventional commits, using `mathieudutour/github-tag-action`. Whenever a tag matching `v*.*.*` is created, the `deploy.yml` workflow is triggered: it checks out the code, installs dependencies with `uv sync`, and runs `uv build` to generate distributable artifacts for the tagged release. In summary, the logic order is: **test in each push/PR → automatic tag in the main → build/deploy triggered by tag**.

## 4. How do I contribute?
Contributions are welcome. If you find a bug, have an idea, or want to improve the code, you can:

1. Open an issue describing the problem or proposal.
2. Fork the repository and create a feature branch.
3. Install dependencies with `uv sync` and run tests with `uv run pytest`.
4. Open a pull request against the `master` branch.

Please keep commits focused and include context in the PR description.

## 5. What architecture was adopted?