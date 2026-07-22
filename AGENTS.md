# Repository Guidelines

## Project Structure & Module Organization

This repository is a teaching workspace for **GitHub Copilot for Developers** (O'Reilly live training).

- Root: `README.md`, `CLAUDE.md`, `AGENTS.md`, `COURSE_PLAN_*.md`, slide decks (`warner-copilot-*.pptx`), and the cover image. Layout convention: course plan + PPTX at root; tutorials, info articles, and reference material under `docs/`; code under `src/` and `scripts/`.
- Tutorials, info articles, and reference material: `docs/COPILOT_AGENT_TUTORIAL.md`, `docs/COPILOT_CUSTOMIZATION_SAMPLES.md`, `docs/latest-github-news.md`, `docs/copilot-metrics-report-sample.md`, `docs/certification/` (GH-300 exam prep), `docs/references/` (Microsoft Writing Style Guide + fictional-company pool).
- Copilot customization demos: `.github/copilot-instructions.md`, `.github/instructions/*.instructions.md` (Python MCP, Markdown style, PowerShell), `.github/prompts/*.prompt.md`, `.github/agents/*.agent.md`, `.github/skills/*/SKILL.md`, plus workflows under `.github/workflows/`. The singular `AGENTS.md` (this file) is also recognized at the repo root, and GitHub honors the nearest `AGENTS.md` in the directory tree.
- Hands-on demo app: `src/` (Node + Express tips browser; `src/data/` holds tip data and the Copilot metrics sample).
- Helper scripts: `scripts/Get-CopilotMetricsReport.ps1` (live Copilot Metrics API report).
- Historical reference content: `archive/` (not actively maintained unless explicitly refreshing older material).

## Build, Test, and Development Commands

Use commands from the repo root unless noted.

- `cd src && npm install`: install dependencies (requires Node 18 or later).
- `cd src && npm start`: run the tips browser at `http://localhost:3000`. Set `PORT` to override.
- `cd src && npx markdownlint-cli "**/*.md" --ignore node_modules`: lint Markdown against `.markdownlint.json`.

The demo app exposes `GET /api/tips` and `GET /api/random-tip?exclude=<id>`, and serves
`src/public/index.html` as a static front end.

## Coding Style & Naming Conventions

- JavaScript uses ES modules (`"type": "module"`), `camelCase` for functions and variables,
  and small focused handlers so each route reads clearly on screen during a live demo.
- PowerShell scripts (e.g., `scripts/Get-CopilotMetricsReport.ps1`) follow the patterns codified in `.github/instructions/powershell.instructions.md` (Verb-Noun, ShouldProcess, advanced functions, no aliases).
- Markdown should satisfy `.markdownlint.json` rules (ATX headings, fenced code blocks, ordered list style).
- Prose and slide content authored in this repo should match Microsoft house voice — consult `docs/references/microsoft-style-guide.md` (sentence case, bold UI labels, Oxford commas, input-neutral verbs).
- Scenario stems for demos and exercises should pull from `docs/references/fictional-companies.md` rather than defaulting to Contoso.
- Keep examples deterministic, copy/paste-friendly, and aligned with current GitHub Copilot terminology (see `CLAUDE.md` for the July 2026 feature landscape).
- Use GitHub's current names. The async agent is the **Copilot cloud agent**, not the "coding agent". Billing is measured in **AI Credits**, not premium requests. The terminal tool is the standalone `copilot` binary from `@github/copilot`, not the older `gh copilot` extension.

## Testing Guidelines

The demo app currently ships without an automated test suite, by design. It exists to be read
aloud and modified live on camera, so it stays deliberately small.

- Verify changes manually: `cd src && npm start`, then exercise `/api/tips` and
  `/api/random-tip` and confirm the page renders.
- If you add a test suite, use Node's built-in runner (`node --test`) rather than adding a
  dependency. Every dependency is one more thing that can break in front of an audience.
- Name tests `<behavior>_<expected outcome>`.

## Commit & Pull Request Guidelines

- Match existing history style: short, imperative summaries (for example, `Update README`, `Add MCP server`, `Refresh repo for July 2026 delivery`).
- Keep commits scoped by concern (course-content refresh, demo app change, workflow update).
- PRs should include: purpose, impacted files/segments, verification steps run (tests/lint), and screenshots when updating slides or visual teaching assets.

## Security & Content Refresh Notes

- Never commit secrets; use `.env.example` patterns.
- For security reports, follow `.github/SECURITY.md`.
- Date-sensitive Copilot features/models must be verified against official docs/changelog before merging content updates.
