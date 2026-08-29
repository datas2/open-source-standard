from __future__ import annotations

import os

import httpx
import streamlit as st

from utils.path import ensure_project_root_on_path

ensure_project_root_on_path()


def _backend_base_url() -> str:
    """Resolve backend base URL from .env (BACKEND_BASE_URL) or default."""
    return os.getenv("BACKEND_BASE_URL", "http://127.0.0.1:8000").rstrip("/")

def _inject_bmc_widget() -> None:
    """Show link to Buy Me a Coffee on all pages."""
    st.markdown(
        """
        <div style="position: fixed; right: 18px; bottom: 18px; z-index: 9999;">
            <a href="https://www.buymeacoffee.com/augsmachado" target="_blank"
               style="
                   background-color: #5F7FFF;
                   color: white;
                   padding: 10px 16px;
                   border-radius: 4px;
                   text-decoration: none;
                   font-weight: 600;
                   font-family: system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
               ">
                ☕ Buy me a coffee
            </a>
        </div>
        """,
        unsafe_allow_html=True,
    )


def main() -> None:
    """Home page with backend health check and navigation hints."""
    st.set_page_config(
        page_title="Service Name",
        page_icon="✅",
        layout="wide",
    )

    st.title("Service Name")
    _inject_bmc_widget()
    backend_url = _backend_base_url()

    st.subheader("Backend Status")

    if st.button("Backend check"):
        try:
            resp = httpx.get(f"{backend_url}/health", timeout=5.0)
            resp.raise_for_status()
            st.success(f"Backend OK: {resp.json()}")
        except Exception as exc:  # noqa: BLE001
            st.error(f"Error calling backend at {backend_url}/health: {exc}")

    st.markdown(
        """
        ## Hello World!

        """
    )

main()