# Repository Guidelines

## Project Structure & Module Organization

This repository is a teaching workspace for **GitHub Copilot for Developers** (O'Reilly live training).

- Root course assets: `README.md`, `COURSE_PLAN_*.md`, `COPILOT_AGENT_TUTORIAL.md`, `COPILOT_CUSTOMIZATION_SAMPLES.md`, slide decks (`warner-copilot-*.pptx`), and `latest-github-news.md`.
- Copilot customization demos: `.github/copilot-instructions.md`, `.github/instructions/*.instructions.md`, `.github/prompts/*.prompt.md`, `.github/agents/*.agent.md`, plus workflows under `.github/workflows/`.
- Hands-on demo app: `src/` (Python FastMCP server + tests).
- Historical reference content: `archive/` (not actively maintained unless explicitly refreshing older material).

## Build, Test, and Development Commands

Use commands from the repo root unless noted.

- `cd src && pwsh .\setup.ps1` (Windows) or `cd src && ./setup.sh` (macOS/Linux): create venv and install dev dependencies.
- `cd src && python copilot_tips_server.py`: run the MCP demo server.
- `cd src && python start_inspector.py`: launch MCP Inspector for live demos.
- `cd src && pytest test_copilot_tips_server.py -v`: run unit tests.
- `cd src && pytest test_copilot_tips_server.py --cov=copilot_tips_server --cov-report=term-missing`: run coverage check for demo changes.

## Coding Style & Naming Conventions

- Python follows PEP 8 with `snake_case` for functions/files and clear docstrings for teaching clarity.
- Markdown should satisfy `.markdownlint.json` rules (ATX headings, fenced code blocks, ordered list style).
- Keep examples deterministic, copy/paste-friendly, and aligned with current GitHub Copilot terminology.

## Testing Guidelines

- Framework: `pytest` (`src/test_copilot_tips_server.py`).
- Add/adjust tests whenever `src/copilot_tips_server.py` behavior changes.
- Prefer test names like `test_<behavior>_<expected_outcome>`.

## Commit & Pull Request Guidelines

- Match existing history style: short, imperative summaries (for example, `Update README`, `Add MCP server`, `Freshen repo for Mar 2026 delivery`).
- Keep commits scoped by concern (course-content refresh, demo app change, workflow update).
- PRs should include: purpose, impacted files/segments, verification steps run (tests/lint), and screenshots when updating slides or visual teaching assets.

## Security & Content Refresh Notes

- Never commit secrets; use `.env.example` patterns.
- For security reports, follow `.github/SECURITY.md`.
- Date-sensitive Copilot features/models must be verified against official docs/changelog before merging content updates.
