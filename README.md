# GitHub Copilot for Developers

<img src="tim-gh-copilot-cover-slide.png" alt="GitHub Copilot Course Cover" width="800" style="border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.1);"/>

[![Website](https://img.shields.io/badge/Website-techtrainertim.com-blue?logo=firefox&style=for-the-badge)](https://techtrainertim.com)
[![Copilot Vid Course](https://img.shields.io/badge/Copilot-Vid%20Course-brightgreen?style=for-the-badge)](https://github.com/timothywarner-org/copilot)
[![AI Agent Repo](https://img.shields.io/badge/AI%20Agent-Repo-orange?style=for-the-badge)](https://github.com/timothywarner-org/agents2)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/license/MIT)

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
- 🎥 YouTube: [@TechTrainerTim](https://www.youtube.com/@TechTrainerTim)
- 📚 O'Reilly: [Timothy Warner](https://www.oreilly.com/search/?q=author%3A%22Timothy+Warner%22&type=*&rows=100)

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

- GitHub account (Free plan includes Copilot with 2,000 monthly code completions)
- Visual Studio Code 1.129+ (Copilot Chat is built in)
- Basic understanding of Git and GitHub
- Familiarity with at least one programming language

## Copilot Links

Verified 2026-07-22. Grouped for the way you actually use them: **get people running**, **find what others built**, **get certified**.

### 1. Enablement - get up and running

**Sign up and set up**

| Link | What it is |
|------|-----------|
| [Copilot product page](https://github.com/features/copilot) | Marketing overview and the sign-up entry point |
| [Plans and pricing](https://github.com/features/copilot/plans) | Live pricing. Check the sign-up banner before recommending a tier |
| [Compare plans](https://docs.github.com/en/copilot/get-started/plans) | Feature-by-feature comparison across Free through Enterprise |
| [Start with Copilot Free](https://github.com/copilot) | Sign-up entry point. No credit card required |
| [Quickstart](https://docs.github.com/en/copilot/get-started/quickstart) | Fastest zero-to-first-suggestion path |
| [Official documentation](https://docs.github.com/en/copilot) | The docs root |

**IDE and client setup**

| Link | What it is |
|------|-----------|
| [VS Code setup](https://code.visualstudio.com/docs/setup/copilot) | Chat is built in as of 1.129.x; the completions extension is separate |
| [VS Code extension](https://marketplace.visualstudio.com/items?itemName=GitHub.copilot) | Marketplace listing |
| [Visual Studio extension](https://marketplace.visualstudio.com/items?itemName=GitHub.copilotvs) | VS 2022 and 2026 |
| [JetBrains plugin](https://plugins.jetbrains.com/plugin/17718-github-copilot--your-ai-pair-programmer) | IntelliJ, PyCharm, GoLand, and friends |
| [Neovim plugin](https://github.com/github/copilot.vim) | `copilot.vim` |
| [Install the Copilot extension (all IDEs)](https://docs.github.com/en/copilot/how-tos/set-up/install-copilot-extension) | One page covering JetBrains, Visual Studio, Xcode, Eclipse, Vim/Neovim, Azure Data Studio |
| [Copilot desktop app](https://github.com/features/ai/github-app) | macOS, Windows, Linux. Any plan, or bring your own key |
| [Install Copilot CLI](https://docs.github.com/en/copilot/how-tos/copilot-cli/set-up-copilot-cli/install-copilot-cli) | `npm install -g @github/copilot` - **not** `@github/copilot-cli`. Needs Node 22+, and PowerShell 6+ on Windows |

**Hands-on learning**

| Link | What it is |
|------|-----------|
| [Copilot tutorials](https://github.com/features/copilot/tutorials) | Official hands-on examples for chat, CLI, and customization |
| [Getting Started with Copilot (course repo)](https://github.com/skills/getting-started-with-github-copilot) | Interactive course taught inside Issues via Actions. Copy to your account and go |
| [GitHub Learn portal](https://learn.github.com/skills) | Course catalog. Note it is a client-side app, so give it a second to render before you demo it |
| [Copilot CLI for Beginners](https://github.com/github/copilot-cli-for-beginners) | Guided lessons and quizzes covering slash commands, modes, agents, skills, MCP |
| [MS Learn: Copilot Fundamentals Pt. 1](https://learn.microsoft.com/en-us/training/paths/copilot/) | Free learning path |
| [MS Learn: Copilot Fundamentals Pt. 2](https://learn.microsoft.com/en-us/training/paths/gh-copilot-2/) | Free learning path |

**Staying current** (this product changes weekly)

| Link | What it is |
|------|-----------|
| [GitHub Changelog](https://github.blog/changelog/) | The single most useful feed. Filter for Copilot |
| [What is new in Copilot](https://github.com/features/copilot/whats-new) | Curated highlights |
| [Supported AI models](https://docs.github.com/en/copilot/reference/ai-models/supported-models) | The authoritative model roster |
| [Models and pricing](https://docs.github.com/en/copilot/reference/copilot-billing/models-and-pricing) | Per-model token rates. Navigate live; do not memorize |
| [VS Code release notes](https://code.visualstudio.com/updates/) | Monthly, and Copilot features land here first |

> **Billing note**: AI Credits replaced premium requests on **June 1, 2026**. 1 credit = $0.01. The [annual-plan multiplier table](https://docs.github.com/en/copilot/reference/copilot-billing/request-based-billing-legacy/model-multipliers-for-annual-plans) is **legacy** and applies only to Pro and Pro+ annual subscribers who stayed on request-based billing.

### 2. Resources - galleries, collections, and standards

**Awesome Copilot** - the community collection

| Link | What it is |
|------|-----------|
| [Copilot Customization Library](https://docs.github.com/en/copilot/tutorials/customization-library) | **The official one.** GitHub-curated instructions, prompt files, and custom agents |
| [awesome-copilot gallery](https://awesome-copilot.github.com) | Community gallery with search and filtering, plus a Learning Hub |
| [github/awesome-copilot](https://github.com/github/awesome-copilot) | The repo behind it. Agents, instructions, skills, plugins, canvas extensions, cookbook |
| [github/copilot-plugins](https://github.com/github/copilot-plugins) | Official plugins collection: MCP servers, skills, hooks |
| [Canvas extensions](https://awesome-copilot.github.com/extensions/) | 22 interactive extensions for the Copilot app canvas |

Install a plugin bundle straight from the marketplace, which is pre-registered in current CLI and VS Code builds:

```bash
copilot plugin install <plugin-name>@awesome-copilot
```

**Agent Skills** - the open, portable standard

| Link | What it is |
|------|-----------|
| [About Agent Skills](https://docs.github.com/en/copilot/concepts/agents/about-agent-skills) | GitHub concept doc |
| [Add skills (CLI)](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/add-skills) | Where skills live and how they load |
| [VS Code: Agent Skills](https://code.visualstudio.com/docs/agent-customization/agent-skills) | Editor-side behavior |
| [agentskills.io spec](https://agentskills.io/specification) | Frontmatter rules and field limits |
| [agentskills/agentskills](https://github.com/agentskills/agentskills) | Reference implementation of the standard |
| [Skills gallery](https://awesome-copilot.github.com/skills/) | Community Copilot skills you can lift |
| [anthropics/skills](https://github.com/anthropics/skills) | The largest skills collection. GitHub docs cite it, so it is safe to recommend |

> A `SKILL.md` written for Copilot also works in Claude Code, Cursor, and Codex CLI. Originally from Anthropic, now a cross-vendor standard. **GitHub docs assign the feature no GA or preview label** - do not invent one.

**MCP** - connect Copilot to everything else

| Link | What it is |
|------|-----------|
| [GitHub MCP Registry](https://github.com/mcp) | Browsable catalog of MCP servers with install counts. One-click VS Code install |
| [Official MCP Registry](https://registry.modelcontextprotocol.io/) | Cross-vendor registry backed by Anthropic, GitHub, and Microsoft |
| [github/github-mcp-server](https://github.com/github/github-mcp-server) | GitHub own server. Hosted endpoint: `https://api.githubcopilot.com/mcp/` |
| [MCP with Copilot](https://docs.github.com/en/copilot/tutorials/enhance-agent-mode-with-mcp) | Wiring a server into agent mode |
| [MCP specification](https://modelcontextprotocol.io/docs/learn/versioning) | Current finalized spec is `2025-11-25` |
| [modelcontextprotocol/servers](https://github.com/modelcontextprotocol/servers) | Reference server implementations |

> The npm package `@modelcontextprotocol/server-github` is **deprecated**. Use the hosted server or the Go binary.

**Customization reference**

| Link | What it is |
|------|-----------|
| [Custom agents configuration](https://docs.github.com/en/copilot/reference/custom-agents-configuration) | Full `.agent.md` frontmatter schema. Only `description` is required |
| [Repository custom instructions](https://docs.github.com/en/copilot/how-tos/copilot-on-github/customize-copilot/add-custom-instructions/add-repository-instructions) | `copilot-instructions.md`, path-scoped files, and `AGENTS.md` |
| [Prompt files (VS Code)](https://code.visualstudio.com/docs/agent-customization/prompt-files) | Use `agent:`; `mode:` is gone from the docs |
| [VS Code customization overview](https://code.visualstudio.com/docs/agent-customization/overview) | Instructions, skills, agents, MCP, hooks, and plugins in one place |
| [How to write a great AGENTS.md](https://github.blog/ai-and-ml/github-copilot/how-to-write-a-great-agents-md-lessons-from-over-2500-repositories/) | Patterns drawn from 2,500+ repos |
| [Copilot Spaces](https://docs.github.com/en/copilot/concepts/context/spaces) | Persistent context hubs. Replaced Knowledge Bases |
| [Copilot Memory](https://docs.github.com/en/copilot/concepts/agents/copilot-memory) | Public preview. Removed if unused 28 days; timer resets on use |
| [Copilot CLI releases](https://github.com/github/copilot-cli/releases) | Ships weekly. Check `npm view @github/copilot version` |

### 3. Certification - GH-300

**Exam at a glance**

| Item | Detail |
|------|--------|
| Exam code | **GH-300** |
| Level | Intermediate |
| Duration | **100 minutes** |
| Questions | Multiple choice and multiple response. Microsoft does not publish a count |
| Passing score | **700** (scaled) |
| Price | Varies by country or region. Microsoft publishes no fixed figure - check at scheduling |
| Validity | **1 year**, with free unproctored open-book renewal on Microsoft Learn |
| Delivery | Pearson VUE, online proctored or test center |
| Languages | English, Spanish, Portuguese (Brazil), Korean, Japanese |
| Next revision | **August 7, 2026** (English first) |

**Official links**

| Link | What it is |
|------|-----------|
| [Certification page](https://learn.microsoft.com/en-us/credentials/certifications/github-copilot/) | The hub: overview, skills measured, scheduling |
| [GH-300 study guide](https://aka.ms/GH300-StudyGuide) | **Start here.** Skills measured plus a change log of what shifts on Aug 7 |
| [Free practice assessment](https://learn.microsoft.com/en-us/credentials/certifications/github-copilot/practice/assessment?assessment-type=practice&assessmentId=218035372) | Official practice questions matching exam style and difficulty |
| [Exam sandbox](https://GHCertDemo.starttest.com) | Try the real exam UI and question types before test day |
| [Schedule through Pearson VUE](https://learn.microsoft.com/en-us/credentials/certifications/schedule-through-pearson-vue?examUid=exam.GH-300) | Registration |
| [Exam retake policy](https://learn.microsoft.com/en-us/credentials/support/retake-policy) | 24 hours after a first failure; longer for later attempts |
| [Renewal policy](https://learn.microsoft.com/en-us/credentials/certifications/renew-your-microsoft-certification) | **Free, unproctored, open book.** Six-month window, unlimited attempts before expiry |
| [Exam Replay offers](https://learn.microsoft.com/en-us/credentials/certifications/deals) | Discounted retake bundles |
| [Accommodations](https://learn.microsoft.com/en-us/credentials/certifications/accommodations) | Testing accommodations |

**Seven domains** (weightings unchanged for the Aug 7 revision)

| Domain | Weight |
|--------|--------|
| Use GitHub Copilot responsibly | 15-20% |
| Use GitHub Copilot features | 25-30% |
| GitHub Copilot features | 25-30% |
| Understand GitHub Copilot data and architecture | 10-15% |
| Apply prompt engineering and context crafting | 10-15% |
| Improve developer productivity with GitHub Copilot | 10-15% |
| Configure privacy, content exclusions, and safeguards | 10-15% |

> The blueprint really does list both "Use GitHub Copilot features" and "GitHub Copilot features." That is Microsoft own wording, not a typo in this README.

**Study path**

1. [MS Learn: Copilot Fundamentals Pt. 1](https://learn.microsoft.com/en-us/training/paths/copilot/) and [Pt. 2](https://learn.microsoft.com/en-us/training/paths/gh-copilot-2/)
2. [GH-300 study guide](https://aka.ms/GH300-StudyGuide) - map each domain to hands-on practice
3. `docs/certification/` in this repo - exam objectives and study notes
4. [Free practice assessment](https://learn.microsoft.com/en-us/credentials/certifications/github-copilot/practice/assessment?assessment-type=practice&assessmentId=218035372), then the [sandbox](https://GHCertDemo.starttest.com) for UI familiarity

> Exam questions cover GA features, and preview features can appear when they are commonly used. Agent Mode, MCP, Plan Mode, sub-agents, Spaces, Spark, and Copilot CLI are **already in the current objectives** - the August 7 revision is an incremental refresh (three areas marked Minor), not a rewrite.

### Reference inputs (this repo)

- `docs/references/microsoft-style-guide.md` - Microsoft Writing Style Guide for prose matching Microsoft house voice
- `docs/references/fictional-companies.md` - Microsoft fictional companies for scenario stems
- `docs/certification/` - GH-300 exam objectives and study notes
- `COURSE_PLAN_JULY_2026.md` - the presenter run sheet for this delivery

## License

MIT License - See [LICENSE](LICENSE) for details
