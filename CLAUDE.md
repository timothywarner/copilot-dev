# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

Teaching repository for **GitHub Copilot for Developers** — a 4-hour O'Reilly Live Training course delivered by Tim Warner (Microsoft MVP, MCT). Contains course materials, a working Python MCP server demo app, customization examples, certification prep, and an archived history of previous deliveries.

## Key Commands

### Python MCP Server Application (src directory)

```bash
# Set up the virtual environment (first time)
cd src && uv venv && uv pip install -e ".[dev]"

# Run the FastMCP server
cd src && python copilot_tips_server.py

# Launch MCP Inspector UI (browser-based testing)
cd src && python start_inspector.py

# Run tests
cd src && pytest test_copilot_tips_server.py -v

# Run a single test
cd src && pytest test_copilot_tips_server.py -v -k "test_name"

# Run tests with coverage
cd src && pytest test_copilot_tips_server.py --cov=copilot_tips_server --cov-report=term-missing
```

### GitHub Workflows

```bash
# The repo has 3 GitHub Actions workflows:
# - codeql-analysis.yml    — Security scanning
# - copilot-news-fetcher.yml — Automated news updates via DeepSeek API
# - readme-checker.yml     — README validation
```

## Repository Architecture

### Active Course Content (root level)

- **`COURSE_PLAN_*.md`** — Teaching punchlist for each delivery (segments, topics, demos)
- **`COPILOT_AGENT_TUTORIAL.md`** — Step-by-step coding agent walkthrough (issue → PR)
- **`COPILOT_CUSTOMIZATION_SAMPLES.md`** — Examples of instructions, prompts, agents, skills
- **`warner-copilot-*.pptx`** — Course slide deck (large binary, ~100MB)
- **`copilot-metrics.json`** — Sample Copilot Metrics API response for enterprise demos
- **`latest-github-news.md`** — Auto-generated news file (from GitHub Actions workflow)

### Demo Application (`/src`)

Python 3.10+ FastMCP server providing 46 curated Copilot tips across 6 categories. This is the primary hands-on demo for showing MCP server concepts during the course.

- **`copilot_tips_server.py`** — Main server: tools (search, filter, random, delete/reset), resources (categories, stats), prompts (task suggestions, learning paths), and elicitations
- **`test_copilot_tips_server.py`** — 26 pytest tests covering all server functionality
- **`data/copilot_tips.json`** — Source data: 46 tips in Prompting, Shortcuts, Code Gen, Chat, Context, Security categories
- **`start_inspector.py`** — Launches MCP Inspector browser UI for interactive testing
- **`test-app.js`** — Task management utility with intentional bug on line 87 (`if (found = undefined)` assignment instead of `=== undefined`); used for live Coding Agent `/fix` demo in `COPILOT_AGENT_TUTORIAL.md`
- **Dependencies**: `fastmcp>=2.0.0`, `mcp>=1.0.0`, managed via `uv`

### Copilot Customization Demos (`.github/`)

These files are teaching examples — they demonstrate how to configure GitHub Copilot for a real project:

- **`copilot-instructions.md`** — Repository-wide custom instructions (Azure, security-first, TDD focus)
- **`agents/*.agent.md`** — 4 custom agent definitions (see table below); `description` is the only required frontmatter field; `model` accepts arrays for fallback priority; `handoffs` enables agent chaining
- **`instructions/*.instructions.md`** — Path-scoped instructions (Python MCP, security-forward)
- **`prompts/*.prompt.md`** — 9 reusable prompt files; use `agent:` field (`ask`/`agent`/`plan`) — `mode:` is deprecated; variable syntax is `${input:varName}`
- **`skills/[name]/SKILL.md`** — 3 Agent Skills with supporting artifacts; `name` and `description` are required frontmatter; skills auto-load when relevant and can be invoked as `/skillname` in chat
- **`chatmodes/*.chatmode.md`** — Legacy format kept intentionally for side-by-side comparison with `.agent.md`

#### Custom Agents

| File | Model | Tools | Use Case |
|------|-------|-------|----------|
| `Copilot Course Teaching Demo.agent.md` | `["claude-opus-4-6","gpt-5.2"]` | 10 (broad) | Meta-demo: multi-model fallback, handoffs, references all skills |
| `Code Review and Security Expert.agent.md` | `claude-sonnet-4-6` | 6 (read-only, no `editFiles`) | OWASP review, tool scoping as security boundary |
| `Full-Stack Feature Builder.agent.md` | `claude-opus-4-6` | 12 (full) | 7-phase TDD workflow, broadest tool set |
| `Python MCP Server Expert.agent.md` | `claude-sonnet-4-6` | default | FastMCP domain expert |

#### Agent Skills

| Skill | Directory | Artifacts | Invocation |
|-------|-----------|-----------|------------|
| `webapp-testing` | `skills/webapp-testing/` | `sample-login-page.html`, `example-test.spec.ts` | `/webapp-testing` |
| `api-endpoint-generator` | `skills/api-endpoint-generator/` | `endpoint-template.ts`, `endpoint-template.py` | `/api-endpoint-generator` |
| `legacy-code-refactor` | `skills/legacy-code-refactor/` | `legacy-example.js`, `refactored-example.js` | `/legacy-code-refactor` |

### Certification Prep (`/copilot-certification`)

- **`github-copilot-cert-exam-objectives.md`** — GH-300 exam domains and objectives
- **`exam-notes-and-links.md`** — Study resources, practice materials, preparation checklist

### Archive (`/archive`)

Historical course materials from previous deliveries. Contains old modules, exercises, examples, and segment-based course plans. Kept for reference but not actively maintained.

## Course Delivery Context

The course runs as 4 segments (~55 min each) with breaks:

1. **Foundations & Core Workflow** — Tiers, VS Code setup, completions, chat basics, prompt engineering
2. **Chat Power Features** — Chat modes (Ask/Edit/Agent), custom instructions, prompt files, model selection, NES, Vision
3. **Agentic Features** — Agent Mode, Coding Agent, Copilot CLI, Agent Skills, MCP, Extensions, Memory
4. **Enterprise & Governance** — Spaces, Code Review, content exclusions, audit logs, policy enforcement, metrics

## GitHub Copilot Feature Landscape (as of March 2026)

Key features and terminology that appear throughout the materials:

- **Chat Modes**: Ask (Q&A), Edit (controlled multi-file), Agent (autonomous with tool use)
- **Custom Agents** (formerly "chat modes"): `.agent.md` files in `.github/agents/` — define specialized personas with tool access
- **Agent Skills**: `.github/skills/[name]/SKILL.md` — teach Copilot repeatable workflows, auto-loaded when relevant
- **Prompt Files**: `.github/prompts/*.prompt.md` — reusable prompt templates
- **Instructions**: `.github/copilot-instructions.md` (repo-wide) and `.github/instructions/*.instructions.md` (path-scoped)
- **Coding Agent**: Async agent that creates PRs from GitHub Issues (runs in GitHub Actions)
- **Copilot CLI**: `gh copilot` — terminal-native agentic coding (GA Feb 2026)
- **Copilot Spaces**: Persistent context hubs with repos, docs, files (GA Sep 2025, accessible via GitHub MCP server)
- **Copilot Memory**: Repository-level persistent context, auto-expires after 28 days (Pro/Pro+ early access)
- **MCP**: Model Context Protocol — connect Copilot to external tools/data sources; OAuth support for secure integrations
- **Next Edit Suggestions (NES)**: Predictive editing that anticipates your next change location and content
- **Vision**: Attach screenshots/mockups to chat for image-to-code workflows
- **Agentic Code Review**: LLM + CodeQL/ESLint integration with full project context (GHEC)

### Current Model Availability (March 2026)

- **GPT-5.2** / **GPT-5.1** — GA across plans; strong reasoning
- **Claude Opus 4.5/4.6**, **Sonnet 4/4.5/4.6** — GA; excellent for code understanding
- **Gemini 3 Flash/Pro**, **Gemini 3.1 Pro** — Speed-optimized
- **GPT-5 mini** — Included model (no premium request consumption)
- Deprecated (Feb 2026): Claude Opus 4.1, GPT-5, GPT-5-Codex

### Subscription Tiers

| Tier | Price | Premium Requests |
|------|-------|-----------------|
| Free | $0 | 2,000 completions + 50 chats/mo |
| Pro | $10/mo | 300/mo |
| Pro+ | $39/mo | 1,500/mo |
| Business | $19/user/mo | 300/user/mo |
| Enterprise | $39/user/mo | 1,000/user/mo |

### GH-300 Certification Exam (updated Jan 2026)

Seven domains with new weighting: Responsible AI (15-20%), Use Copilot Features (25-30%), Copilot Features (25-30%), Data & Architecture (10-15%), Prompt Engineering (10-15%), Developer Productivity (10-15%), Privacy & Exclusions (10-15%). Now covers Agent Mode, MCP, Plan Mode, Sub-Agents, Spaces, Spark, and Copilot CLI.

## Development Context

- This is a **teaching repository** — prioritize clarity and educational value over production patterns
- The `/src` app is a **FastMCP demo** used to teach MCP server concepts live; keep it self-contained
- Course materials reference features across Free through Enterprise tiers
- The `.github/` customization files serve double duty: they configure this repo AND serve as teaching examples
- When updating course content, verify against [GitHub Copilot docs](https://docs.github.com/en/copilot), [VS Code Copilot docs](https://code.visualstudio.com/docs/copilot/overview), and [GitHub Changelog](https://github.blog/changelog/)
