from __future__ import annotations

from fastapi import APIRouter

from backend.api.health import router as health_router


def get_api_router() -> APIRouter:
    """
    Create and configure the main API router for Samy.

    This router aggregates all feature-specific routers (health, explain, review,
    optimize) under a single entry point to be included in the FastAPI app.
    """
    api_router = APIRouter()
    api_router.include_router(health_router)
    return api_router