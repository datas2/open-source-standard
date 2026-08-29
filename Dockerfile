FROM python:3.13-slim AS runtime

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    UV_COMPILE_BYTECODE=1 \
    UV_LINK_MODE=copy \
    PORT=8080 \
    BACKEND_PORT=8000

WORKDIR /app

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        curl \
    && rm -rf /var/lib/apt/lists/*

# Install the uv binary in a path available in the PATH.
COPY --from=ghcr.io/astral-sh/uv:0.7.20 /uv /uvx /usr/local/bin/

# First copy the dependency files to take advantage of Docker cache.
COPY pyproject.toml uv.lock README.md ./

# Install dependencies in a reproducible manner.
# --no-install-project prevents installing the project before the code is copied.
RUN uv sync --locked --no-install-project

# Copy only the necessary directories for the application.
COPY backend ./backend
COPY frontend ./frontend
COPY scripts ./scripts

# Install the project, if it is defined as a package in pyproject.toml.
RUN uv sync --locked

RUN chmod +x ./scripts/start.sh

EXPOSE 8080

CMD ["./scripts/start.sh"]