from __future__ import annotations

import os
from dataclasses import dataclass

from backend.core import constants



@dataclass
class AppSettings:
    """
    Core application settings for app.

    This includes environment, log level and app-related configuration so
    that different deployments can be configured via environment variables.
    """
    env: str = constants.DEFAULT_ENV
    log_level: str = constants.DEFAULT_LOG_LEVEL


def load_settings() -> AppSettings:
    """
    Load application settings from environment variables.

    Returns:
        AppSettings: Fully populated settings object with defaults applied.
    """
    env = os.getenv(constants.ENV_APP_ENV, constants.DEFAULT_ENV)
    log_level = os.getenv(constants.ENV_APP_LOG_LEVEL, constants.DEFAULT_LOG_LEVEL)


    return AppSettings(env=env, log_level=log_level)