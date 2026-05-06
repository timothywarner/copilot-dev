# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

Teaching repository for **GitHub Copilot for Developers** — Tim Warner's 4-hour O'Reilly Live Training. Two things ship from here:

1. **Course materials** — slide deck, course plan, tutorials, certification notes, news.
2. **A working FastMCP server** (`/src`) that doubles as the Module 3 / 4 demo for MCP, Coding Agent, and Custom Agents.

Treat the source of truth for "what's current in Copilot" as `README.md` and `COURSE_PLAN_MAY_2026.md`. They are refreshed every delivery (last refresh: May 6, 2026 — AI Credits cutover, GPT-5.5, Claude Opus 4.7, Sonnet 4 deprecation, Autopilot mode, Debugger agent). When updating model names, prices, or feature GAs, update those two files first; this CLAUDE.md should stay structural.

## Repository Layout (May 2026 reorg)

```
/                    README.md, CLAUDE.md, AGENTS.md, COURSE_PLAN_MAY_2026.md, *.pptx
/docs                Tutorials, info articles, reference inputs (NOT code)
  /docs/references   Microsoft Writing Style Guide + fictional-company pool
  /docs/certification GH-300 exam objectives and study notes
/src                 Python FastMCP demo app + tests + sample data
/scripts             Helper scripts (PowerShell metrics report)
/.github             Copilot customization examples (also configures THIS repo)
/archive             Historical course materials — do not maintain unless explicitly asked
```

Convention: course plan + PPTX at root; prose under `/docs`; code under `/src` and `/scripts`. Don't put new tutorials at root.

## Key Architectural Insight: `.github/` is dual-purpose

Every file in `.github/` does **two jobs simultaneously**:

1. It configures GitHub Copilot's behavior for *this* repo (Tim's own workflow).
2. It is the **teaching example** Tim demos live in class.

So when editing anything under `.github/`, optimize for **clarity of demonstration** over brevity. Comments explaining *why* a frontmatter field exists are pedagogical, not noise. The `Copilot Course Teaching Demo.agent.md` agent is the meta-example: it exercises multi-model fallback (`model: ["claude-opus-4-7", "gpt-5.5"]`), `handoffs` for agent chaining, and references all three skills.

The intentional pairings in `.github/`:

- **`agents/*.agent.md`** + **`AGENTS.md`** at root — both formats are recognized as of May 2026; they're shown side-by-side on purpose.
- **`agents/*.agent.md`** + **`chatmodes/new-mode.chatmode.md`** — current vs deprecated format; teaching the rename.
- **`prompts/*.prompt.md`** — all use `agent:` (the `mode:` field is deprecated). Variable syntax is `${input:varName}`.
- **`skills/[name]/SKILL.md`** — required frontmatter is `name` (lowercase-hyphenated) + `description`. As of April 2026 the same SKILL.md works in Copilot, Claude Code, Cursor, and Codex CLI without modification.
- **Tool scoping as security** — `Code Review and Security Expert.agent.md` deliberately omits `editFiles`; this is the live demo for "tool scope = trust boundary."

The `.github/scripts/fetch_news.py` and `.github/workflows/copilot-news-fetcher.yml` write to **`docs/latest-github-news.md`** (not the repo root — that path was changed in the May 2026 reorg). If you edit either file, keep them in sync.

## Demo App (`/src`) — Architectural Notes

Python 3.10+ FastMCP server providing 46 curated Copilot tips across 6 categories.

- **`copilot_tips_server.py`** — single-file server exposing tools (search/filter/random/delete/reset), resources (categories/stats), prompts (task suggestions/learning paths), and elicitations.
- **`data/copilot_tips.json`** — source data; the 46 tips. Treat as data, not config.
- **`data/copilot-metrics-sample.json`** — static sample of the Copilot Metrics API response for offline demos.
- **`test-app.js`** — **contains an intentional bug on line 87** (`if (found = undefined)` instead of `=== undefined`). Do not "fix" this file — it is the live `/fix` target for the Coding Agent walkthrough in `docs/COPILOT_AGENT_TUTORIAL.md`. The bug is documented in the file's header comment.
- Dependencies are managed with `uv` (not pip/poetry). The `pyproject.toml` declares `fastmcp>=2.0.0`, `mcp>=1.0.0`, `pytest`.

## Common Commands

### Set up the demo app

```bash
cd src && pwsh ./setup.ps1   # Windows
cd src && ./setup.sh         # macOS/Linux
# Both wrap: uv venv && uv pip install -e ".[dev]"
```

### Run the MCP server

```bash
cd src && python copilot_tips_server.py        # serve
cd src && python start_inspector.py            # MCP Inspector UI for live demos
```

### Tests

```bash
cd src && pytest test_copilot_tips_server.py -v
cd src && pytest test_copilot_tips_server.py -v -k "test_name"     # single test
cd src && pytest test_copilot_tips_server.py --cov=copilot_tips_server --cov-report=term-missing
```

### Copilot Metrics demo

```powershell
# Live API pull — needs $env:GITHUB_TOKEN with read:org + Copilot metrics access
.\scripts\Get-CopilotMetricsReport.ps1 -Organization 'your-org' -Days 28
```

If no token, demo from `src/data/copilot-metrics-sample.json` (annotated walkthrough at `docs/copilot-metrics-report-sample.md`).

### News fetcher (run locally if testing the workflow)

```bash
python .github/scripts/fetch_news.py    # writes to docs/latest-github-news.md
```

### Markdown lint

The repo enforces `.markdownlint.json` (ATX headings, fenced code blocks, ordered list style). No npm script is wired — run your editor's markdownlint integration or `markdownlint-cli`.

## Editing Conventions

- **Date-sensitive content** (model names, prices, GA dates, deprecation dates): always verify against [Supported AI Models](https://docs.github.com/en/copilot/reference/ai-models/supported-models), the [Annual-plan multiplier table](https://docs.github.com/en/copilot/reference/copilot-billing/model-multipliers-for-annual-plans), and the [GitHub Changelog](https://github.blog/changelog/) before merging. The course is re-delivered monthly; staleness shows.
- **Microsoft house voice**: when authoring slide copy, exercises, or any teaching prose, follow `docs/references/microsoft-style-guide.md` (sentence case, bold UI labels, Oxford commas, input-neutral verbs like "select" not "click", `should` vs `must`).
- **Scenario stems**: pull company names from `docs/references/fictional-companies.md` rather than defaulting to Contoso.
- **Python**: PEP 8, `snake_case`, docstrings written for *learners* (clarity > terseness — this code is read on stage).
- **PowerShell**: follow `.github/instructions/powershell.instructions.md` (Verb-Noun, `[CmdletBinding()]`, `ShouldProcess`, no aliases). The PowerShell custom-instruction file is itself a teaching artifact; `scripts/Get-CopilotMetricsReport.ps1` is the working example of the patterns it codifies.
- **Don't touch `archive/`** unless explicitly refreshing older material — it is preserved for reference, not maintained.
- **Don't fix `src/test-app.js`** — see above, the bug is intentional.

## Workflows

- `codeql-analysis.yml` — security scanning (JavaScript + Python)
- `copilot-news-fetcher.yml` — daily DeepSeek-API-driven refresh of `docs/latest-github-news.md`; archives previous version under `news-archive/`
- `readme-checker.yml` — lychee link checker on Markdown files
- Dependabot (`.github/dependabot.yml`) and CODEOWNERS / SECURITY.md are present.

## Customization-Demo Inventory (for context when editing `.github/`)

| File / dir | What it teaches |
|------------|-----------------|
| `.github/copilot-instructions.md` | Repo-wide instructions baseline |
| `.github/instructions/Python MCP Instructions.instructions.md` | Path-scoped instructions for `**/*.py` |
| `.github/instructions/security-forward-instructions.instructions.md` | Path-scoped security-first overlay |
| `.github/instructions/powershell.instructions.md` | Path-scoped PS cmdlet design rules (`**/*.ps1,**/*.psm1`) |
| `.github/agents/Copilot Course Teaching Demo.agent.md` | Multi-model fallback array, `handoffs`, references all skills |
| `.github/agents/Code Review and Security Expert.agent.md` | Read-only tool scope as a security boundary |
| `.github/agents/Full-Stack Feature Builder.agent.md` | Broadest tool set + 7-phase TDD workflow |
| `.github/agents/Python MCP Server Expert.agent.md` | Domain-specific FastMCP expert |
| `.github/chatmodes/new-mode.chatmode.md` | Deprecated format kept for the rename comparison |
| `.github/skills/webapp-testing/` | Skill with HTML + Playwright spec artifacts |
| `.github/skills/api-endpoint-generator/` | Skill with TS + Python templates |
| `.github/skills/legacy-code-refactor/` | Skill with before/after JS examples |
| `.github/prompts/*.prompt.md` | 9 reusable prompts; `agent:` field, `${input:var}` syntax |

When adding a new agent or skill, mirror the comment style of the existing files — the comments are part of the lesson.
