# GitHub Copilot for Developers

<img src="tim-gh-copilot-cover-slide.png" alt="GitHub Copilot Course Cover" width="800" style="border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.1);"/>

[![Website](https://img.shields.io/badge/Website-techtrainertim.com-blue?logo=firefox&style=for-the-badge)](https://techtrainertim.com)
[![Copilot Vid Course](https://img.shields.io/badge/Copilot-Vid%20Course-brightgreen?style=for-the-badge)](https://github.com/timothywarner-org/copilot)
[![AI Agent Repo](https://img.shields.io/badge/AI%20Agent-Repo-orange?style=for-the-badge)](https://github.com/timothywarner-org/agents2)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)

Gain experience with an AI-based pair programmer right now!

## Course Information

**Instructor**: Tim Warner - Microsoft MVP, MCT

**Duration**: 4 hours (4 x ~55 minute segments with breaks)

**Platform**: O'Reilly Live Training (ON24)

## Connect with Tim

- 📧 Email: [tim@techtrainertim.com](mailto:tim@techtrainertim.com)
- 🌐 Website: [TechTrainerTim.com](https://techtrainertim.com)
- 🐦 Bluesky: [@techtrainertim.bsky.social](https://bsky.app/profile/techtrainertim.bsky.social)
- 💼 LinkedIn: [Timothy Warner](https://www.linkedin.com/in/timothywarner)
- 🎥 YouTube: [@TechTrainerTim](https://youtube.com/@TechTrainerTim)
- 📚 O'Reilly: [Timothy Warner](https://learning.oreilly.com/search/?q=author%3A%22Timothy+Warner%22&type=*&rows=100)

## Course Structure (May 2026)

### Segment 1: Foundations & Core Workflow

- **AI Credits transition** (effective June 1, 2026; replaces premium requests; 1 credit = $0.01 USD; token-metered)
- GitHub Copilot subscription tiers (Free, Pro, Pro+, Business, Enterprise) — note Pro/Pro+/Student sign-ups paused April 20, 2026
- VS Code 1.115/1.116 setup — Copilot Chat is built in (no separate extension)
- Code completions (free across all plans), inline suggestions, ghost text, multi-line
- Chat interface basics (`Ctrl+I` inline, sidebar chat)
- Chat participants (`@workspace`, `@terminal`, `@vscode`, `@github`)
- Slash commands (`/explain`, `/fix`, `/tests`, `/doc`, `/new`, `/troubleshoot`)
- Context awareness and file references (`#file`, `#selection`, `#changes`, `#codebase` — single semantic auto-managed index)
- Prompt engineering fundamentals
- Responsible AI foundations

### Segment 2: Chat Power Features & Multi-File Operations

- Chat modes (Ask vs Edit vs Agent)
- Copilot Edit mode for controlled multi-file refactoring
- Working sets and file context management
- Custom instructions (`.github/copilot-instructions.md`) and path-scoped instructions (`.github/instructions/*.instructions.md`)
- Prompt files (`.github/prompts/*.prompt.md`) — `mode:` deprecated, use `agent:`
- **Unified chat customization editor** (single pane for instructions, prompts, chat modes)
- Model selection strategy (GPT-5.5, GPT-5.4, GPT-5.3-Codex, Claude Opus 4.7, Sonnet 4.5/4.6, Gemini 3.1 Pro)
- Debugging workflows and iteration loops
- Next Edit Suggestions (predictive editing, long-distance NES — free across all plans)
- Vision for Copilot (screenshot/mockup/**video** to code — video added April 2026)

### Segment 3: Agentic Features & Advanced Workflows

- Agent Mode in VS Code with **Autopilot mode** (public preview, fully autonomous), Plan mode, sub-agent delegation (Explore, Task, Code Review, Plan)
- `send_to_terminal` for background terminals; auto-approval rules for trusted tools
- GitHub Copilot Coding Agent (async PR creation; cloud agent startup >20% faster as of April 2026)
- **Cloud agent sessions launchable from Visual Studio** + new **Debugger agent** (validates fixes against live runtime)
- GitHub Copilot CLI — v1.0.42 (`gh copilot`); new since March: `/chronicle`, `/compact`, `/context`, `/usage`, `/env`, ACP permission-mode, experimental MCP Tasks
- Custom Agents (`.github/agents/*.agent.md`) plus singular `AGENTS.md` at repo root; **user-level custom agents** (April 2026)
- Agent Skills (`.github/skills/[name]/SKILL.md`) — **portable open standard as of April 2026** (same SKILL.md works in GitHub Copilot, Claude Code, Cursor, and Codex CLI)
- Model Context Protocol (MCP) server integration (OAuth, enterprise governance)
- GitHub Copilot Extensions (Perplexity, Docker, Sentry, Azure)
- Copilot Memory (Pro/Pro+ — persistent repository-level context; shared across Coding Agent, Code Review, CLI; 28-day auto-expiry)
- Testing workflows and TDD
- Migration scenarios (language ports, framework upgrades)

### Segment 4: Enterprise Features, Spaces & Governance

- GitHub Copilot Spaces (GA Sep 2025; persistent context hubs, public/org sharing)
- Organization-level custom instructions
- Copilot Code Review with agentic features (CodeQL, ESLint, hand-off to Coding Agent, data residency) — **starts consuming GitHub Actions minutes June 1, 2026**
- Enterprise MCP governance (admin allowlists)
- Content exclusions and IP filtering
- Audit logs and usage analytics
- Security best practices (secret detection, vulnerability scanning)
- Policy enforcement and compliance guardrails
- ROI measurement and productivity metrics (Copilot Metrics API — GA Feb 27, 2026; live demo via `scripts/Get-CopilotMetricsReport.ps1`)
- **AI Credits cost-modeling exercise** — walk through realistic team scenario, compare against current premium-request quota, examine multiplier table (Opus 4.7: 7.5× → 27×)
- IDE expansion: JetBrains, Eclipse, Xcode, Visual Studio 2026 (cloud agent sessions, Debugger agent, find_symbol, enterprise MCP, proxy support)
- GH-300 Certification exam overview (still on Jan 2026 blueprint; covers Agent Mode, MCP, Spaces, CLI, Skills, Spark)

## Model Options (May 2026)

| Model | Best For | Notes |
| ----- | -------- | ----- |
| GPT-5.5 | Current flagship; reasoning + agentic | GA April 2026 |
| GPT-5.4 | General-purpose flagship | Annual multiplier 1× → 6× transition |
| GPT-5.3-Codex | Agentic coding tasks | GA Feb 9, 2026; admin enable for Biz/Ent |
| GPT-5.2 / GPT-5.1 | Reasoning, novel problem-solving | GA across plans |
| GPT-5 mini | Everyday completions | **Included model — no AI Credit consumption** |
| Claude Opus 4.7 | Code understanding, complex debugging | **Pro+ only** (removed from Pro). Annual multiplier 7.5× → 27× transition |
| Claude Opus 4.5 / 4.6 | Premium reasoning | High multiplier |
| Claude Sonnet 4.5 / 4.6 | Balanced code tasks | GA across paid tiers |
| Claude Haiku 4.5 | Fast lightweight tasks | Low-cost option |
| Gemini 3 Flash / 3 Pro | Speed-optimized | Large context windows |
| Gemini 3.1 Pro | Enhanced reasoning | Annual multiplier 1× → 6× transition |
| Gemini 2.5 Pro | Strong reasoning (legacy) | Still available |

**Deprecated**: Claude Sonnet 4 (May 6, 2026); Claude Opus 4.1, GPT-5, GPT-5-Codex (Feb 17, 2026)
**Not in lineup**: There is no "Gemini 3.5" — current Gemini family is 3.1 Pro / 3 Flash / 2.5 Pro.

## What's New (May 2026)

- **AI Credits replace premium requests** (June 1, 2026) — 1 credit = $0.01 USD, token-metered at API rates. Code completions and NES remain free. Code reviews start consuming GitHub Actions minutes the same day.
- **Plan base prices unchanged** — Pro $10 (incl. $10 in credits), Pro+ $39 (incl. $39 in credits), Business $19/user, Enterprise $39/user.
- **Pro/Pro+/Student sign-ups paused** (April 20, 2026) — no announced end date; existing accounts unaffected.
- **Opus removed from Pro** — Opus 4.7 available in Pro+ and above only.
- **Claude Sonnet 4 deprecated** (May 6, 2026 — today). Migrate to Sonnet 4.5/4.6.
- **GPT-5.5 GA** (April 2026) — current flagship OpenAI model in Copilot.
- **Agent Skills SKILL.md is now a portable open standard** (April 2026) — same file works in GitHub Copilot, Claude Code, Cursor, and Codex CLI.
- **VS Code 1.115/1.116** — Autopilot mode (public preview, fully autonomous agent sessions); Copilot Chat is built in (no separate extension); `/troubleshoot`; `send_to_terminal`; image and **video** in chat; unified chat customization editor; `#codebase` is a single semantic auto-managed index.
- **Cloud agent sessions in Visual Studio + Debugger agent** (April 2026) — VS-side parity with VS Code, plus runtime-validated fixes.
- **User-level custom agents** (April 2026) — define agents at the user level in addition to repo-level.
- **Cloud agent startup >20% faster** (custom Actions runner images).
- **Copilot CLI v1.0.42** (May 6) — `/chronicle` for all users, ACP permission-mode toggling, experimental MCP Tasks support, Azure DevOps detection, shell-completions auto-install.
- **Cloud agent model picker** (April 14) — choose Claude or Codex model for cloud sessions on github.com.
- **Usage limits visible in VS Code and CLI**.
- **Copilot Metrics GA** (Feb 27, 2026) plus plan-mode telemetry (Mar 2, 2026).

## Subscription Tiers (May 2026)

| Tier | Price | Quota (current → AI Credits June 1) | Key Features |
|------|-------|-------------------------------------|--------------|
| Free | $0/mo | 2,000 completions + 50 chats — sign-ups paused | Basic completions and chat |
| Pro | $10/mo | 300 premium req/mo → $10 in AI Credits | All models **except Opus**, unlimited completions. Sign-ups paused April 20, 2026. |
| Pro+ | $39/mo | 1,500 premium req/mo → $39 in AI Credits | All premium models including Opus 4.7, Memory. Sign-ups paused April 20, 2026. |
| Business | $19/user/mo | 300/user/mo → per-seat AI Credits | Org management, audit logs, IP indemnity, Coding Agent |
| Enterprise | $39/user/mo | 1,000/user/mo → per-seat AI Credits | Fine-tuned models, knowledge bases, advanced security |

## Prerequisites

- GitHub account (Free tier includes Copilot with 2,000 monthly completions — note new sign-ups paused since April 20, 2026)
- Visual Studio Code 1.115+ (Copilot Chat is built in)
- Basic understanding of Git and GitHub
- Familiarity with at least one programming language

## Demo tips API CRUD endpoints

The demo server in `/src/server.js` now supports complete in-memory CRUD for tips:

- `GET /api/tips` — list tips, metadata, and categories.
- `GET /api/random-tip` — return one random tip (optionally excluding an ID via `?exclude=`).
- `POST /api/tips` — create a tip with required fields: `id`, `title`, `description`, `category`, `difficulty`, `impact`.
- `PATCH /api/tips/:tipId` — partially update a tip by ID and return before/after plus changed fields.

Validation rules:

- `category` must match one of the categories in `src/data/copilot_tips.json`.
- `difficulty` must be `beginner`, `intermediate`, or `advanced`.
- `impact` must be `low`, `medium`, `high`, or `critical`.
- Duplicate IDs are rejected.

## Core Resources

### Official Documentation

- [GitHub Copilot Product Page](https://github.com/features/copilot)
- [Official Documentation](https://docs.github.com/en/copilot)
- [GitHub Copilot Quickstart](https://docs.github.com/en/copilot/get-started/quickstart)
- [GitHub Copilot What's New](https://github.com/features/copilot/whats-new)
- [GitHub Changelog](https://github.blog/changelog/)
- [Supported AI Models](https://docs.github.com/en/copilot/reference/ai-models/supported-models)
- [Annual-plan model multipliers](https://docs.github.com/en/copilot/reference/copilot-billing/model-multipliers-for-annual-plans)
- [Usage-based billing announcement (April 2026)](https://github.blog/news-insights/company-news/github-copilot-is-moving-to-usage-based-billing/)

### IDE Extensions

- [VS Code Extension](https://marketplace.visualstudio.com/items?itemName=GitHub.copilot)
- [Visual Studio Extension](https://marketplace.visualstudio.com/items?itemName=GitHub.copilotvs)
- [JetBrains Extension](https://plugins.jetbrains.com/plugin/17718-github-copilot)
- [Neovim Extension](https://github.com/github/copilot.vim)

### Customization & Agents

- [About Agent Skills (open portable standard)](https://docs.github.com/en/copilot/concepts/agents/about-agent-skills)
- [VS Code: Use Agent Skills](https://code.visualstudio.com/docs/copilot/customization/agent-skills)
- [Creating Agent Skills](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/coding-agent/create-skills)
- [MCP with Copilot](https://docs.github.com/en/copilot/tutorials/enhance-agent-mode-with-mcp)
- [Copilot Spaces](https://docs.github.com/en/copilot/concepts/context/spaces)
- [Copilot Memory](https://docs.github.com/en/copilot/concepts/agents/copilot-memory)
- [Copilot CLI Releases](https://github.com/github/copilot-cli/releases)

### Reference Inputs (this repo)

- `docs/references/microsoft-style-guide.md` — Microsoft Writing Style Guide for any prose meant to match Microsoft house voice
- `docs/references/fictional-companies.md` — 54 Microsoft fictional companies for scenario stems
- `docs/certification/` — GH-300 exam objectives and study notes

### Certification

- [GH-300 Study Guide (Jan 2026 blueprint, current)](https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/gh-300)
- [GitHub Copilot Certification](https://learn.microsoft.com/en-us/credentials/certifications/github-copilot/)
- [MS Learn Path: Copilot Fundamentals Part 1](https://learn.microsoft.com/en-us/training/paths/copilot/)
- [MS Learn Path: Copilot Fundamentals Part 2](https://learn.microsoft.com/en-us/training/paths/gh-copilot-2/)

### Pricing & Plans

- [Plans & Pricing](https://github.com/features/copilot/plans)
- [Compare Plans](https://docs.github.com/en/copilot/get-started/plans)

## License

MIT License - See [LICENSE](LICENSE) for details
