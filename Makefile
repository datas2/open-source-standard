# ---------------------------------------------------------------------------
# Makefile for managing the open-source-standard project
#
# make install-uv
# make init-uv
# make install
# make add-dev-dependency PACKAGE=pytest
# make run-backend
# make run-frontend
# make run-tests
# make build-package
# make deploy
# 
# After any changes to dependencies
# uv lock
# uv sync --locked
# git add pyproject.toml uv.lock
# ---------------------------------------------------------------------------

# ---------------------------------------------------------------------------
# Google Cloud configuration
# ---------------------------------------------------------------------------
PROJECT_ID ?= $(shell gcloud config get-value project 2>/dev/null)
REGION ?= us-central1
REPO_NAME ?= app-repository
SERVICE_NAME ?= app
IMAGE_NAME ?= app
IMAGE_TAG ?= latest
AR_PATH := $(REGION)-docker.pkg.dev/$(PROJECT_ID)/$(REPO_NAME)/$(IMAGE_NAME):$(IMAGE_TAG)
LOCALHOST := 127.0.0.1
PORT ?= 8000

export PROJECT_ID REGION REPO_NAME SERVICE_NAME IMAGE_NAME IMAGE_TAG AR_PATH

# ---------------------------------------------------------------------------
# UV / local development
# ---------------------------------------------------------------------------

install-uv:
	python3 -m pip install --upgrade uv

init-uv:
	uv init
	uv sync

install:
	uv add -r requirements.txt

sync:
	uv sync --locked

add-dependency:
	@test -n "$(PACKAGE)" || (echo "Usage: make add-dependency PACKAGE=package-name"; exit 1)
	uv add "$(PACKAGE)"
	uv lock

add-dev-dependency:
	@test -n "$(PACKAGE)" || (echo "Usage: make add-dev-dependency PACKAGE=package-name"; exit 1)
	uv add --dev "$(PACKAGE)"
	uv lock

run-uv:
	uv run uvicorn backend.main:app \
		--reload \
		--host $(LOCALHOST) \
		--port $(PORT)

clean-build:
	rm -rf dist build *.egg-info

build-package: clean-build
	uv build


# ---------------------------------------------------------------------------
# Tests
# ---------------------------------------------------------------------------

run-tests:
	uv sync --locked
	@if [ -d backend/tests/unit ]; then uv run pytest backend/tests/unit; else echo "No unit tests found in backend/tests/unit, skipping."; fi
	@if [ -d backend/tests/integration ]; then uv run pytest backend/tests/integration; else echo "No integration tests found in backend/tests/integration, skipping."; fi
	@if [ -d backend/tests/e2e ]; then uv run pytest backend/tests/e2e; else echo "No e2e tests found in backend/tests/e2e, skipping."; fi


# ---------------------------------------------------------------------------
# Local dev commands
# ---------------------------------------------------------------------------
run-backend:
	uv run uvicorn backend.main:app \
		--reload \
		--host $(LOCALHOST) \
		--port $(PORT)

run-frontend:
	BACKEND_BASE_URL=http://$(LOCALHOST):$(PORT) \
		uv run streamlit run frontend/app.py


# ---------------------------------------------------------------------------
# Cloud Run commands
# ---------------------------------------------------------------------------
login-artifact-registry:
	gcloud auth configure-docker $(REGION)-docker.pkg.dev

build-image:
	docker buildx build \
		--platform linux/amd64 \
		-t $(AR_PATH) \
		--push \
		.

create-repository:
	gcloud artifacts repositories create $(REPO_NAME) \
		--repository-format=docker \
		--location=$(REGION) \
		--description="Docker repository for $(REPO_NAME)" \
		|| echo "Repository $(REPO_NAME) may already exist."

push-image:
	docker push $(AR_PATH)

deploy-cloudrun:
	gcloud run deploy $(SERVICE_NAME) \
		--image $(AR_PATH) \
		--project $(PROJECT_ID) \
		--region $(REGION) \
		--set-env-vars BACKEND_BASE_URL=http://$(LOCALHOST):$(PORT),BACKEND_PORT=$(PORT) \
		--memory 256Mi \
		--cpu 1 \
		--max-instances 1 \
		--timeout 60 \
		--allow-unauthenticated \
		--port 8080

deploy: validate-config login-artifact-registry create-repository build-image deploy-cloudrun

validate-config:
	@test -n "$(PROJECT_ID)" || (echo "PROJECT_ID is required"; exit 1)
	@test -n "$(REGION)" || (echo "REGION is required"; exit 1)
	@test -f pyproject.toml || (echo "pyproject.toml is required"; exit 1)
	@test -f uv.lock || (echo "uv.lock is required; run 'uv lock'"; exit 1)
	@test -n "$(LOCALHOST)" || (echo "LOCALHOST is required"; exit 1)
	@test -n "$(PORT)" || (echo "PORT is required"; exit 1)