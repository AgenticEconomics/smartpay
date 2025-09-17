# Repository Guidelines

## Project Structure & Module Organization
Core protocol models live in `src/ap2/types`. Sample agents reside under `samples/python/src` with shared helpers in `common` and individual services in `roles`. Scenario runbooks and assets sit in `samples/python/scenarios/<name>`, while the Android client is under `samples/android`. Reference material and diagrams are published from `docs/`, and automation helpers live in `scripts/`. Copy `env.template` to a private `.env` before invoking agents.

## Build, Test, and Development Commands
Run `make build` then `make up` to assemble and launch the Docker stack; `make dev` layers `docker-compose.override.yml` for iterative local work. Use `make status` and `make logs` to monitor running services, and `make down` when you are finished. For direct Python execution, run `bash run_smartpay.sh` or scenario launchers such as `bash samples/python/scenarios/demo/run.sh`. Quick service verification is available via `make test`.

## Coding Style & Naming Conventions
Python sources follow 4-space indentation, snake_case module names (e.g., `contact_picker.py`), and type-hinted Pydantic models exported from `ap2.types`. Consolidate reusable constants in `common/` and surface new protocol objects through the package `__init__.py`. Keep bash scripts consistent: lowercase filenames, `set -euo pipefail`, and trap-based cleanup. JSON payload keys remain camelCase to stay aligned with the public protocol.

## Testing Guidelines
Place automated tests next to the code they validate, such as `samples/python/src/roles/tests/` for agent logic or scenario-specific `tests/` folders. Prefer `pytest` and mirror sample payloads in fixtures. Extend the `make test` health check when adding services, and document manual verification (expected status codes, CLI commands) in each scenario README. Capture logs from `.logs/` when reporting failures.

## Commit & Pull Request Guidelines
Use the Conventional Commit prefixes seen in history (`feat:`, `fix:`, `docs:`) with subjects under 72 characters. Each PR should link its issue, summarize functional changes, list verification commands, and attach screenshots or curl traces when UI or API flows change. Update relevant docs or scenario guides in the same PR and confirm CLA compliance per `CONTRIBUTING.md`.

## Security & Configuration Tips
Keep credentials out of the repo by loading them from `.env` or your shell; never commit keys used in local scripts. Follow `SECURITY.md` for disclosure handling. When adding dependencies, update the appropriate `pyproject.toml` and refresh `uv.lock` so collaborators receive reproducible environments.
