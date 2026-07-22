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

## Course Structure (July 2026)

### Segment 1: Foundations & Core Workflow

- **AI Credits are the billing model** (since June 1, 2026; premium requests are legacy; 1 credit = $0.01 USD; token-metered on input, output, and cached tokens)
- Code completions and Next Edit Suggestions are **unlimited on paid plans and consume zero credits**
- Subscription tiers including the new **Copilot Max ($100/mo)** and Student plan
- Copilot Business self-serve sign-ups show a pause banner for orgs on GitHub Free/Team — verify live
- VS Code 1.129.x setup — Copilot Chat is built in; Agent Host runs Copilot, Claude, and Codex harnesses
- Chat interface basics (`Ctrl+I` inline, sidebar chat)
- Chat participants (`@workspace`, `@terminal`, `@vscode`, `@github`)
- Slash commands (`/explain`, `/fix`, `/tests`, `/doc`, `/new`, `/troubleshoot`)
- Context and file references (`#file`, `#selection`, `#changes`, `#codebase`)
- Prompt engineering fundamentals
- Responsible AI foundations

### Segment 2: Chat Power Features & Multi-File Operations

- Chat modes (Ask vs Edit vs Agent)
- Copilot Edit mode for controlled multi-file refactoring
- Custom instructions: `.github/copilot-instructions.md`, path-scoped `.github/instructions/*.instructions.md` (`applyTo` required, `excludeAgent` optional), and **`AGENTS.md`** (nearest in the tree wins)
- Prompt files (`.github/prompts/*.prompt.md`) — use `agent:`; `mode:` is gone from the docs
- **Unified chat customization editor**
- **Auto model selection** as the default paradigm — Free and Student get Auto only; enterprises can set Auto as the org default
- Current model lineup: GPT-5.6 family, GPT-5.5/5.4, Claude Opus 4.8, Sonnet 5, Fable 5, Gemini 3.5/3.6 Flash, MAI-Code-1-Flash, Kimi K2.7 Code
- Debugging workflows and iteration loops
- Next Edit Suggestions (free, zero credits)
- **Copilot Vision — GA July 1, 2026**: images **and PDFs**, all tiers including Free

### Segment 3: Agentic Features & Advanced Workflows

- Agent Mode in VS Code with Plan mode, Autopilot mode, and sub-agent delegation (Explore, Task, Code Review, Plan)
- **Copilot cloud agent** (renamed from "coding agent" in April 2026) — async work on GitHub's infrastructure
- **GitHub Copilot CLI** — install `@github/copilot` (not `@github/copilot-cli`); binary is `copilot`; Node 22+; PowerShell 6+ on Windows
- Custom Agents (`.github/agents/*.agent.md`) — `description` required; `target`, `disable-model-invocation`, `user-invocable` optional; `infer` retired; 30,000-char body limit
- Agent Skills (`.github/skills/<name>/SKILL.md`) — portable open standard; `name` and `description` required
- Model Context Protocol — current finalized spec `2025-11-25`; the `2026-07-28` revision ships July 28, 2026
- **MCP servers replaced Copilot Extensions**, which were disabled November 10, 2025
- **Copilot Memory** (public preview) — removed if unused for 28 days; the timer resets on use
- **Copilot SDK GA** (June 2, 2026) and the **Copilot app** (GA to all plans July 7, 2026)
- Testing workflows, TDD, and migration scenarios

### Segment 4: Enterprise Features, Spaces & Governance

- GitHub Copilot Spaces (GA Sep 2025; persistent context hubs)
- Organization-level custom instructions
- Copilot Code Review — agentic tool calling, CodeQL and ESLint, hand-off to the cloud agent; **consumes GitHub Actions minutes** since June 1, 2026
- **Content exclusion gap**: CLI, cloud agent, and Agent mode (plus Edit mode) **do not support content exclusion**. The cloud agent can see *and update* excluded files
- **Enterprise AI Controls / agent control plane** (GA Feb 26, 2026), `managed-settings.json` (GA July 1, 2026), MCP allowlists (still preview)
- Audit logs with agent attribution and `agent_session.task` events
- **Copilot Metrics** (GA Feb 27, 2026); repository-level metrics GA July 17, 2026; AI credits per user in the API
- **AI Credit governance**: cost centers, credit pooling, per-user budgets
- IDE expansion: JetBrains, Eclipse, Xcode, Visual Studio 2026
- GH-300 Certification overview — seven domains, weightings unchanged; revision effective August 7, 2026

## Model Options (July 2026)

Navigate to the [supported models reference](https://docs.github.com/en/copilot/reference/ai-models/supported-models) and the [models and pricing table](https://docs.github.com/en/copilot/reference/copilot-billing/models-and-pricing) live rather than reciting rates. The roster changes often.

| Provider | Models | Notes |
| -------- | ------ | ----- |
| OpenAI | GPT-5.6 Sol / Terra / Luna, GPT-5.5, GPT-5.4 (+ mini, nano), GPT-5.3-Codex, GPT-5 mini | All GA |
| Anthropic | Claude Opus 4.8, 4.7, 4.6, 4.5; Sonnet 5, 4.6, 4.5; Haiku 4.5; Fable 5 | GA. Opus 4.8 fast mode is preview; Fable 5 needs Business/Enterprise enablement |
| Google | Gemini 3.6 Flash, 3.5 Flash, 2.5 Pro | GA. Gemini 3.1 Pro and 3 Flash are preview; 2.5 Pro and 3 Flash have retirement announced |
| Microsoft | MAI-Code-1-Flash | GA |
| Other | Raptor mini (fine-tuned GPT-5 mini), Kimi K2.7 Code (Moonshot AI) | GA |

**Auto model selection** picks per request unless you pin. Several models support 1M-token context and configurable reasoning levels.

**Retired**: GPT-5.2, Claude Sonnet 4 (May 6, 2026), Claude Opus 4.1 / GPT-5 / GPT-5-Codex (Feb 17, 2026), plus 20+ models since October 2025.

## What's New (July 2026)

- **AI Credits cutover completed June 1, 2026** — premium requests are legacy. 1 credit = $0.01, token-metered. No rollover; allowance resets at 00:00:00 UTC monthly.
- **Copilot Max** — new $100/mo tier with 20,000 credits.
- **Business/Enterprise promotional credits** — existing customers get 3,000 and 7,000 credits per user for June 1 to September 1, 2026. Last covered month is August.
- **Claude Sonnet 5 GA** (June 30) and **Copilot app GA to all plans** (July 7).
- **Copilot SDK GA** (June 2) — TypeScript, Python, Go, .NET, Rust, Java.
- **Copilot Vision GA** (July 1) — images and PDFs, all tiers including Free.
- **Agent Finder GA** (June 17) — implements the Agentic Resource Discovery (ARD) spec.
- **Repository-level usage metrics GA** (July 17); AI credits per user added to the metrics API (June 19).
- **VS Code 1.129.1** (July 15) — Agent Host process, session-management tools, `!` terminal prefix.
- **Gemini 3.6 Flash** added July 21, 2026.
- **Coming**: MCP spec `2026-07-28` ships July 28; `used_copilot_coding_agent` metrics field deprecates August 1; GH-300 revision effective August 7.

## Subscription Tiers (July 2026)

Billing is usage-based on **GitHub AI Credits**. **1 AI credit = $0.01 USD.** Base credits match the subscription price one-for-one; the flex allotment sits on top and is designed to change as AI economics change. Credits do **not** roll over, and the allowance resets at 00:00:00 UTC on the first of each month.

**Code completions and Next Edit Suggestions are unlimited on paid plans and consume zero credits.** Credits are spent by chat, agent mode, code review, cloud agent, CLI, and Copilot Apps.

| Tier | Price | Base credits | Flex | Total credits/mo | $ value |
|------|-------|--------------|------|------------------|---------|
| Free | $0 | not published | not published | **not published** | not published |
| Student | Free | not published | not published | **not published** | not published |
| Pro | $10/mo | 1,000 | 500 | **1,500** | $15 |
| Pro+ | $39/mo | 3,900 | 3,100 | **7,000** | $70 |
| **Max** | **$100/mo** | 10,000 | 10,000 | **20,000** | $200 |
| Business | $19/seat/mo | 1,900 | n/a | **1,900** | $19 |
| Enterprise | $39/seat/mo | 3,900 | n/a | **3,900** | $39 |

GitHub publishes no numeric credit figure for Free or Student. Free includes **2,000 code completions per month**; Student includes **unlimited completions**.

**Promotional allowance, June 1 to September 1, 2026**: existing **Business** customers receive **3,000** credits per user and existing **Enterprise** customers **7,000** credits per user. Seat prices did not change, the last covered month is **August**, and it applies to existing customers only.

**Verified July 21, 2026.** Overage bills at published per-model token rates, not a flat per-credit fee. See [models and pricing](https://docs.github.com/en/copilot/reference/copilot-billing/models-and-pricing).

## Prerequisites

- GitHub account (Free tier includes Copilot with 2,000 monthly completions — note new sign-ups paused since April 20, 2026)
- Visual Studio Code 1.115+ (Copilot Chat is built in)
- Basic understanding of Git and GitHub
- Familiarity with at least one programming language

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
