from __future__ import annotations

from importlib.metadata import PackageNotFoundError, version

from fastapi import FastAPI

from backend.api.routes import get_api_router
from backend.core.config import load_settings
from backend.core.logger import get_logger

APP_TITLE = "Backend API"
try:
    APP_VERSION = version("backend")
except PackageNotFoundError:
    APP_VERSION = "0.0.0"

logger = get_logger("backend.app")


def create_app() -> FastAPI:
    """Create and configure the FastAPI application for the backend."""
    settings = load_settings()
    
    logger.info(
        f"Starting Backend API - version={APP_VERSION}, env={settings.env}"
    )

    app = FastAPI(title=APP_TITLE, version=APP_VERSION)

    # Register main API router
    app.include_router(get_api_router())

    return app


app = create_app()