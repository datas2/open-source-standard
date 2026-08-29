from __future__ import annotations

import sys
from pathlib import Path


def ensure_project_root_on_path() -> None:
    """Ensure the project root (parent of frontend) is in sys.path.

    When running `streamlit run frontend/app.py`, this makes it possible to
    import modules like `utils.api_client` and `components.forms` from pages.
    """
    project_root = Path(__file__).resolve().parents[2]
    path_str = str(project_root)
    if path_str not in sys.path:
        sys.path.insert(0, path_str)