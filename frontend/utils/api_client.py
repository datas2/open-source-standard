from __future__ import annotations

from typing import Any, Dict, Optional

import httpx


class APIClientError(Exception):
    """Generic error raised by the API client."""


class APIClient:
    """HTTP client to interact with the backend API.

    Provides typed helpers for the main operations used by the Streamlit UI
    """

    def __init__(self, base_url: str, timeout: float = 10.0) -> None:
        self.base_url = base_url.rstrip("/")
        self.timeout = timeout

    def _request(
        self,
        method: str,
        path: str,
        *,
        params: Optional[Dict[str, Any]] = None,
        json: Optional[Dict[str, Any]] = None,
    ) -> Any:
        url = f"{self.base_url}{path}"
        try:
            response = httpx.request(
                method=method,
                url=url,
                params=params,
                json=json,
                timeout=self.timeout,
            )
        except httpx.RequestError as exc:
            raise APIClientError(f"Request error when calling {url}: {exc}") from exc

        if response.status_code >= 400:
            detail = None
            try:
                body = response.json()
                detail = body.get("detail")
            except Exception:
                detail = response.text

            raise APIClientError(
                f"API error {response.status_code} for {url}: {detail}"
            )

        try:
            return response.json()
        except ValueError:
            # fallback to raw text if not JSON
            return response.text
