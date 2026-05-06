# GitHub Copilot for Developers — Teaching Punchlist (May 2026)

**Delivery Date**: May 2026
**Last Updated**: 2026-05-06

## Course Structure

- **Duration**: 4 hours total
- **Segments**: 4 x ~55 minute segments
- **Breaks**: ~9 minute breaks between segments
- **Platform**: ON24 live training

> **Headline of this delivery**: GitHub Copilot is mid-pivot from premium-request counting to **AI Credits** ($0.01 each, token-metered). Cutover is **June 1, 2026** — about three weeks after this class. Frame the whole course around helping attendees plan for that shift.

---

### Segment 1: Foundations & Core Workflow (60 min)

- Course goals and major changes since last delivery (Mar/Apr 2026)
- **Billing transition opener (NEW — must lead with this)**
  - Premium requests → **AI Credits** (effective June 1, 2026; 1 credit = $0.01 USD; token-metered at API rates)
  - Code completions and NES stay free; **code reviews start consuming GitHub Actions minutes** same date
  - Annual subscribers keep request model until renewal — but multipliers spike (Opus 4.7: 7.5× → **27×**; GPT-5.4 and Gemini 3.1 Pro: 1× → **6×**)
  - Usage limits now visible in VS Code and CLI — show the panel live
- GitHub Copilot subscription tiers (Free, Pro, Pro+, Business, Enterprise)
  - Free tier: 2,000 monthly completions, 50 monthly chats — **sign-ups paused April 20, 2026**
  - Pro: $10/mo, 300 premium requests — **sign-ups paused April 20, 2026; Opus removed from Pro tier**
  - Pro+: $39/mo, 1,500 premium requests, all models including **Claude Opus 4.7** — **sign-ups paused April 20, 2026**
  - Business: $19/user/mo, org management, audit logs, IP indemnity (still available for new orgs)
  - Enterprise: $39/user/mo, fine-tuned models, knowledge bases, advanced security (still available)
  - **Workaround for paused tiers**: Business trial for new attendees who do not already have Pro/Pro+
- VS Code setup and extension configuration
  - **VS Code 1.115/1.116**: Copilot Chat is **built in** — no separate extension install for the chat experience (the inline-completions extension is still discrete; clarify on stage)
  - Minimum VS Code version for the May delivery: 1.115+
- Code completions (inline suggestions, ghost text, multi-line) — still free across all plans
- Chat interface basics (`Ctrl+I` inline, sidebar chat)
- Chat participants (`@workspace`, `@terminal`, `@vscode`, `@github`)
- Slash commands (`/explain`, `/fix`, `/tests`, `/doc`, `/new`, `/newNotebook`, `/troubleshoot`)
- Context awareness and file references (`#file`, `#selection`, `#changes`, `#codebase` — now a single semantic auto-managed index)
- Prompt engineering fundamentals for Copilot
  - Zero-shot, few-shot, and chain-of-thought patterns
  - Role-based prompting and constraint specification
- Responsible AI foundations (hallucinations, bias, license exposure, security)

---

### Segment 2: Chat Power Features & Multi-File Operations (60 min)

- Chat modes (Ask vs Edit vs Agent)
- Copilot Edit mode for controlled multi-file refactoring
- Working sets and file context management
- Custom instructions (`.github/copilot-instructions.md`)
- Path-scoped instructions (`.github/instructions/*.instructions.md`)
  - Demo the **`powershell.instructions.md`** file (newly added) — show how `applyTo: "**/*.ps1,**/*.psm1"` scopes to PowerShell only
- Prompt files (`.github/prompts/*.prompt.md`) — `mode:` is deprecated, use `agent:`
- **Unified chat customization editor** — single pane to manage instructions, prompts, and chat modes (April 2026)
- Model selection strategy and AI Credit / premium-request management
  - **GPT-5.5** (current flagship; GA April 2026)
  - **GPT-5.4** (annual-plan multiplier table)
  - **GPT-5.3-Codex** (agentic tasks, ~25% faster than GPT-5.2-Codex; GA Feb 9, 2026; admin policy enable for Business/Enterprise)
  - **GPT-5.2 / GPT-5.1** — general-purpose reasoning
  - **GPT-5 mini** — included model (no credit consumption)
  - **Claude Opus 4.7** — premium tier only (Pro+, Business, Enterprise); 7.5×/27× multiplier transition
  - **Claude Opus 4.5 / 4.6** — high multiplier
  - **Claude Sonnet 4.5 / 4.6** — balanced; **Sonnet 4 deprecated May 6, 2026 (today)** — flag this on screen
  - **Claude Haiku 4.5** — low-cost
  - **Gemini 3 Flash/Pro / 3.1 Pro / 2.5 Pro** — speed and reasoning options
  - **Deprecated and gone**: Sonnet 4 (May 6), Opus 4.1 / GPT-5 / GPT-5-Codex (Feb 17)
  - Show the **multi-model picker for cloud Claude/Codex agents on github.com** (April 14, 2026)
- Debugging workflows (`/fix` command, error explanation, iteration loops)
- Code review and refactoring workflows
- Attaching files, images, **and video** to chat (video added April 2026)
- Next Edit Suggestions (NES)
  - Predictive editing based on recent changes
  - Long-distance NES (Feb 2026): predicts edits anywhere in the file
  - Tab to accept, Esc to dismiss; works across languages; **free across all plans**
- Vision for Copilot (screenshot/mockup to code) + new video attachment

---

### Segment 3: Agentic Features & Advanced Workflows (60 min)

- Agent Mode in VS Code (autonomous, iterative coding)
  - Plan mode: structured implementation planning before execution
  - **Autopilot mode** (public preview, April 2026): fully autonomous agent sessions — no per-step confirmation
  - Sub-agent delegation (Explore, Task, Code Review, Plan)
  - Auto-approval rules: configure trusted tools/actions to skip confirmation
- **`send_to_terminal`** for background terminal sessions (April 2026) — show how the agent runs long jobs without blocking the chat
- GitHub Copilot Coding Agent (async PR creation via GitHub Actions)
  - Delegating via: VS Code, GitHub web, Mobile, CLI, Agents panel
  - Writing effective issues for the agent
  - Monitoring progress and providing feedback on PRs
  - **Cloud agent startup >20% faster** (April 2026) — custom Actions runner images
  - Firewall and networking configuration for enterprise environments (plan-specific endpoints from Feb 27, 2026)
- **Cloud agent sessions launchable from Visual Studio** (April 2026) — show side-by-side with VS Code
- **Debugger agent** (April 2026) — validates fixes against the live runtime, not just the static code
- GitHub Copilot CLI — `gh copilot` (GA Feb 25, 2026; **v1.0.42** as of May 6)
  - Terminal-native agentic coding for all paid subscribers
  - Plan mode and Autopilot mode
  - Sub-agent delegation from the terminal
  - Built-in GitHub MCP server (issues, PRs, repos, search)
  - **`/chronicle`** (April 2026) — replay an agent session as a structured timeline; now available to all users
  - **`/compact`**, **`/context`**, **`/usage`**, **`/env`** slash commands (v1.0.39+)
  - **ACP permission-mode toggling** — switch trust levels mid-session
  - **Experimental MCP Tasks support** — chain MCP server actions
  - Azure DevOps detection in the working directory
  - Shell completions auto-install
  - Custom MCP server support (connect any MCP-compatible service)
- Custom Agents (`.github/agents/*.agent.md`) plus the **singular `AGENTS.md`** at the repo root (May 2026 pattern)
  - Specify tools, MCP servers, and instructions per agent
  - **Custom agents are now user-level** in addition to repo-level (April 2026 — VS update)
  - Scoped to repository or user; activated from the model/agent picker in chat
  - Note: legacy `.chatmode.md` files still work but `.agent.md` is the current format; this repo contains both for teaching purposes
- Agent Skills (`.github/skills/[name]/SKILL.md`)
  - Teach Copilot repeatable workflows with markdown + YAML frontmatter
  - Auto-loaded when relevant across Coding Agent, CLI, and VS Code
  - Project skills (`.github/skills/`) vs personal skills (`~/.copilot/skills/`)
  - Invoke directly as slash commands (e.g., `/webapp-testing for the login page`)
  - **NEW STORY for May 2026: SKILL.md is an open, portable standard.** A SKILL.md authored for GitHub Copilot **also works in Claude Code, Cursor, and Codex CLI** — the same file, no rewriting. This is the headline open-standard moment for the agentic ecosystem. Required frontmatter: `name` (lowercase-hyphenated, unique), `description`. Optional: `license`.
  - Community skill library: [github/awesome-copilot](https://github.com/github/awesome-copilot)
- Model Context Protocol (MCP) server integration
  - OAuth support for secure third-party integrations (Slack, Jira, custom APIs)
  - MCP server names support npm-style naming (dots, slashes, @ characters)
  - Enterprise MCP governance: admin allowlists for org-approved servers (VS 2026, VS Code)
  - Streamable HTTP transport support alongside SSE
- GitHub Copilot Extensions (marketplace: Perplexity, Docker, Sentry, Azure)
- Copilot Memory (Pro/Pro+ early access)
  - Repository-level persistent context that grows as you work
  - Shared across Coding Agent, Code Review, and CLI
  - Auto-expires after 28 days; validated memories persist longer
- Testing workflows (`/tests`, fixture generation, mocking, TDD)
- Migration scenarios (language ports, framework upgrades, legacy modernization)

---

### Segment 4: Enterprise Features, Spaces & Governance (60 min)

- GitHub Copilot Spaces — GA Sep 2025
  - Persistent context hubs: repos, code, PRs, issues, files, images, free text
  - Public spaces (view-only, link-shared), org-shared spaces (admin/editor/viewer)
  - Accessible via GitHub MCP server in IDE (query spaces from chat)
  - Use cases: onboarding, standards enforcement, query libraries, architecture docs
  - Spaces content informs Coding Agent and CLI when accessed via MCP
- Organization-level custom instructions
- Copilot Code Review with agentic features
  - Rich agentic tool calling for full project context
  - CodeQL, ESLint, and deterministic tool integration
  - Hand-off from Code Review to Coding Agent for auto-fixes
  - Enterprise Cloud with data residency support
  - **Starts consuming GitHub Actions minutes June 1, 2026** — flag for finance-conscious enterprise admins
- Content exclusions and IP filtering
- Audit logs and usage analytics
- Security best practices (secret detection, vulnerability scanning, branch protections)
- Policy enforcement and compliance guardrails (GHEC admin controls)
  - MCP server allowlists for organizations
  - Model availability restrictions per org policy
- ROI measurement and productivity metrics (Copilot Metrics API)
  - Copilot Metrics GA (Feb 27, 2026): dashboards + API production-ready
  - Plan mode telemetry (Mar 2, 2026): `chat_panel_plan_mode` reported separately
  - **Live demo**: run `.\scripts\Get-CopilotMetricsReport.ps1 -Organization '<org>'` if a token is available; otherwise show `src/data/copilot-metrics-sample.json` (annotated walkthrough at `docs/copilot-metrics-report-sample.md`)
  - Acceptance rates, time saved, lines suggested, active users
  - Enterprise Cloud with data residency support; custom enterprise roles for fine-grained dashboard access
- **AI Credits cost-modeling exercise** (NEW for May 2026)
  - Walk through a realistic scenario: 10-developer team, 60% Opus 4.7 usage, average session token counts
  - Compare projected June+ AI Credit burn against current premium-request quota
  - Show the model multiplier table — pricing now varies up to 27× by model
- IDE expansion: JetBrains, Eclipse, Xcode, Visual Studio 2026
  - VS 2026: cloud agent sessions, debugger agent, find_symbol tool, enterprise MCP governance, proxy support
  - JetBrains: Agent Mode available, MCP support in progress
- GitHub Spark (Pro+ and Enterprise — AI-powered full-stack app builder)
  - Natural language to full-stack app with live preview
  - Embeds AI features (chatbots, content generation, smart automation)
  - Open in VS Code agent mode or create a GitHub repo in one click
- Coding Agent network configuration (effective Feb 27, 2026)
  - Plan-specific endpoints required for self-hosted/private-network runners
  - Business: `api.business.githubcopilot.com`, Enterprise: `api.enterprise.githubcopilot.com`, Pro/Pro+: `api.individual.githubcopilot.com`
- GH-300 Certification exam overview (still on the Jan 2026 blueprint as of May 2026)
  - 7 domains, ~65 questions in 100 minutes; passing 700; $99 USD; 2-year validity
  - Delivered via Pearson VUE (OnVUE online proctoring)
  - Covers Agent Mode, MCP, Spaces, CLI, Custom Agents, Skills, Spark
- Future roadmap and staying current (changelog, blog, community discussions)

---

## What's Changed Since the March 2026 Delivery

| Date | Update | Details |
|------|--------|---------|
| **June 1 (upcoming)** | **AI Credits cutover** | Premium requests replaced by AI Credits ($0.01 each, token-metered). Completions/NES stay free. Code reviews start consuming Actions minutes. |
| May 6 | **Claude Sonnet 4 deprecation** | Sonnet 4 removed from Copilot today. Use Sonnet 4.5/4.6 going forward. |
| May 6 | **Copilot CLI v1.0.42** | Latest CLI release; `/chronicle` available to all users, ACP permission-mode toggling, experimental MCP Tasks support. |
| Apr 30 | **Cloud agent in Visual Studio + Debugger agent** | Launch cloud agent sessions from VS; new Debugger agent validates fixes against live runtime. Custom agents are now user-level (in addition to repo-level). Cloud agent startup >20% faster. |
| Apr 28 | **Usage-based billing announcement** | GitHub Blog: Copilot moving to AI Credits June 1, 2026. Plan base prices unchanged. |
| Apr 27 | **Code review → Actions minutes** | Code reviews will consume GitHub Actions minutes starting June 1, 2026. |
| Apr 20 | **Pro/Pro+/Student sign-ups paused** | New sign-ups paused with no announced end date. Existing accounts unaffected. **Opus removed from Pro tier** (Pro+ only). |
| Apr 16 | **VS Code 1.115/1.116** | Autopilot mode public preview, Copilot Chat built in (no separate extension install for chat), `/troubleshoot`, `send_to_terminal`, image+video in chat, unified chat customization editor, `#codebase` semantic auto-managed index. |
| Apr 14 | **Cloud agent model picker** | Choose Claude or Codex model for cloud agent sessions on github.com. |
| April | **GPT-5.5 available** | Current flagship OpenAI model in Copilot; appears in the model picker and the multiplier table. |
| April | **Agent Skills SKILL.md is now portable** | Same `.github/skills/[name]/SKILL.md` file works across GitHub Copilot, Claude Code, Cursor, and Codex CLI — open standard moment. Required frontmatter: `name`, `description`. Optional: `license`. |
| Mar 31 | **Sonnet 4 deprecation announced** | Effective May 6, 2026 (today's delivery). |
| Mar 2 | **Plan mode telemetry** | `chat_panel_plan_mode` reported separately in metrics. |
| Feb 27 | **Copilot Metrics GA** | Dashboards + API production-ready. |
| Feb 25 | **Copilot CLI GA** | Terminal-native agent for all paid subscribers. |
| Feb 17 | **Model deprecations** | Claude Opus 4.1, GPT-5, GPT-5-Codex removed. |

---

## Current Model Landscape (May 2026)

| Model Family | Models Available | Best For | Premium / Multiplier |
|-------------|-----------------|----------|----------------------|
| **OpenAI GPT** | GPT-5.5 | Current flagship; reasoning + agentic | Yes (high multiplier in annual table) |
| **OpenAI GPT** | GPT-5.4 | General-purpose flagship | Yes (1× → **6×** in annual table) |
| **OpenAI GPT** | GPT-5.3-Codex | Agentic coding tasks | Yes (admin enable for Biz/Ent) |
| **OpenAI GPT** | GPT-5.2, GPT-5.1 | Reasoning, novel problem-solving | Yes |
| **OpenAI GPT** | GPT-5 mini | General-purpose, included | **No (free)** |
| **Anthropic Claude** | Opus 4.7 | Deep code understanding (Pro+ only — removed from Pro) | Yes (7.5× → **27×** in annual table) |
| **Anthropic Claude** | Opus 4.5, Opus 4.6 | Complex debugging | Yes (high multiplier) |
| **Anthropic Claude** | Sonnet 4.5, Sonnet 4.6 | Balanced code tasks | Yes |
| **Anthropic Claude** | Haiku 4.5 | Fast, lightweight tasks | Yes (low multiplier) |
| **Google Gemini** | 3 Flash, 3 Pro | Speed-optimized, large context | Yes |
| **Google Gemini** | 3.1 Pro | Enhanced reasoning | Yes (1× → **6×** in annual table) |
| **Google Gemini** | 2.5 Pro | Strong reasoning (legacy) | Yes |

**Removed**: Sonnet 4 (May 6, 2026), Opus 4.1 / GPT-5 / GPT-5-Codex (Feb 17, 2026)
**Not in lineup**: There is no "Gemini 3.5" yet — current Gemini is 3.1 Pro / 3 Flash / 2.5 Pro.

---

## Key Demo Assets in This Repo

### Core Application & Tutorials

| Asset | Location | Purpose | Segment |
|-------|----------|---------|---------|
| MCP Server | `src/copilot_tips_server.py` | Live MCP server demo (FastMCP) | 3 |
| Coding Agent Bug Demo | `src/test-app.js` | Intentional bug on line 87 (`=` vs `===`) — Coding Agent `/fix` demo | 3 |
| Agent Tutorial | `docs/COPILOT_AGENT_TUTORIAL.md` | Coding Agent walkthrough (issue → PR) | 3 |
| Customization Samples | `docs/COPILOT_CUSTOMIZATION_SAMPLES.md` | Reference examples for all customization types | 2-3 |
| Metrics JSON (static) | `src/data/copilot-metrics-sample.json` | Sample API response for offline demo | 4 |
| Metrics PowerShell (live) | `scripts/Get-CopilotMetricsReport.ps1` | Live API pull + summary report | 4 |
| Metrics Sample Output | `docs/copilot-metrics-report-sample.md` | Annotated 28-day report (April 2026 run) | 4 |
| Cert Objectives | `docs/certification/` | GH-300 exam prep (Jan 2026 blueprint, Pearson VUE) | 4 |

### Reference Inputs

| Asset | Location | Purpose | When to use |
|-------|----------|---------|-------------|
| Microsoft Style Guide | `docs/references/microsoft-style-guide.md` | Sentence case, bold UI labels, Oxford commas, input-neutral verbs | Authoring slides, exercises, prose meant to match Microsoft house voice |
| Fictional Companies | `docs/references/fictional-companies.md` | 54 Microsoft fictional companies | Picking scenario stems for demos so the room does not default to Contoso |

### Custom Instructions

| Asset | Location | Purpose | Segment |
|-------|----------|---------|---------|
| Repo-wide Instructions | `.github/copilot-instructions.md` | Baseline repo-wide instructions demo | 2 |
| Python MCP Instructions | `.github/instructions/Python MCP Instructions.instructions.md` | Path-scoped instructions (Python files) | 2 |
| Security-forward Instructions | `.github/instructions/security-forward-instructions.instructions.md` | Path-scoped security instructions | 2 |
| **PowerShell Instructions** | `.github/instructions/powershell.instructions.md` | Path-scoped PS1/PSM1 instructions (cmdlet design, ShouldProcess, pipeline) | 2 |

### Custom Agents (`.agent.md` format)

| Agent | Location | Teaching Focus | Segment |
|-------|----------|---------------|---------|
| Copilot Course Teaching Demo | `.github/agents/Copilot Course Teaching Demo.agent.md` | Multi-model array fallback (`["claude-opus-4-7","gpt-5.5"]`), `handoffs`, references all 3 skills | 3 |
| Code Review & Security Expert | `.github/agents/Code Review and Security Expert.agent.md` | Narrow read-only tool scope (no `editFiles`) as security boundary | 3 |
| Full-Stack Feature Builder | `.github/agents/Full-Stack Feature Builder.agent.md` | Broadest tool set, mandatory 7-phase TDD workflow | 3 |
| Python MCP Server Expert | `.github/agents/Python MCP Server Expert.agent.md` | Domain-specific expert agent, FastMCP patterns | 3 |
| Legacy Chatmode | `.github/chatmodes/new-mode.chatmode.md` | Side-by-side comparison: deprecated `.chatmode.md` vs current `.agent.md` | 3 |

### Agent Skills (`.github/skills/`)

| Skill | Directory | Artifacts | Invoke With | Segment |
|-------|-----------|-----------|-------------|---------|
| `webapp-testing` | `.github/skills/webapp-testing/` | `sample-login-page.html`, `example-test.spec.ts` | `/webapp-testing` | 3 |
| `api-endpoint-generator` | `.github/skills/api-endpoint-generator/` | `endpoint-template.ts`, `endpoint-template.py` | `/api-endpoint-generator` | 3 |
| `legacy-code-refactor` | `.github/skills/legacy-code-refactor/` | `legacy-example.js`, `refactored-example.js` | `/legacy-code-refactor` | 3 |

### Prompt Files (`.github/prompts/`) — use `agent:` field, not deprecated `mode:`

| Prompt | Mode | Best For | Segment |
|--------|------|----------|---------|
| `generate-react-component.prompt.md` | `agent` | Scaffold TS React component + companion test | 2 |
| `api-endpoint-review.prompt.md` | `ask` | REST endpoint security & correctness review | 2 |
| `generate-migration-plan.prompt.md` | `agent` | Codebase migration analysis (JS→TS, React, Py) | 2-3 |
| `write-adr.prompt.md` | `ask` | Architecture Decision Record (MADR format) | 2 |
| `security-scan.prompt.md` | `agent` | OWASP Top 10 scan with severity table | 2-3 |
| `document-public-api.prompt.md` | `agent` | JSDoc / Google-style docstrings | 2 |
| `oreilly-api-help.prompt.md` | `ask` | GitHub REST/GraphQL API guidance | 2 |
| `Pytest Coverage Prompt.prompt.md` | `agent` | Pytest 80%+ coverage workflow | 2 |
| `testing-prompt-file.prompt.md` | `ask` | Test structure, AAA pattern, fixtures | 2 |

---

## Teaching Notes for the May 2026 Delivery

- **Lead with billing.** AI Credits + the Actions-minutes metering for code review go live ~3 weeks after this class. Frame the entire 4 hours around "what changes June 1, what does not, and how to plan for it." Walk through the multiplier table (Opus 4.7 jumping to 27× is the most striking number).
- **Pro/Pro+/Student sign-ups are paused (April 20).** If attendees do not already hold Pro/Pro+, suggest a Business trial or have them follow along with screenshots. Acknowledge the friction explicitly — students will ask.
- **Sonnet 4 deprecation is today (May 6).** Show the model picker before/after if you have a screenshot from a March recording. Migrate to Sonnet 4.5/4.6 in any live demo.
- **Agent Skills as an open standard.** This is the most pedagogically valuable change of April 2026. Author one SKILL.md, demo it auto-loading in Copilot, then literally drop the same file into Claude Code or Cursor and show it working unchanged. This is the "one prompt, four hosts" demo.
- **Autopilot mode (public preview) — show it once, then explain why you would not leave it on.** Use it to scaffold a feature in the demo, then talk about trust boundaries, audit trails, and why production teams gate it behind code review.
- **Cloud agent in Visual Studio + Debugger agent.** Quick screenshot tour for VS users in the audience. Debugger agent is the more interesting story — it validates a fix against the live runtime instead of just reading the code.
- **CLI demo flow.** `gh copilot` (v1.0.42), then a quick `/chronicle` to replay a session, then `/usage` to show AI Credit consumption. The slash commands make a nice cluster.
- **`AGENTS.md` (singular, root) AND `.github/agents/*.agent.md`** — both formats are recognized. Show the singular file as the simpler entry point and the directory as the multi-agent pattern.
- **Cite the references directory.** When a student asks "how should I write my own custom instructions?" point at `docs/references/microsoft-style-guide.md` as the voice template and `docs/references/fictional-companies.md` as the scenario pool. These were migrated in May from the cert-prep repo.
- **PowerShell instructions file is new.** Use it in the metrics-script demo (Segment 4): show that `Get-CopilotMetricsReport.ps1` is itself a working example of the patterns in `.github/instructions/powershell.instructions.md`.
- **Coding Agent network endpoints (still active from Feb 27).** Flag for enterprise admins with self-hosted runners or Azure private networking. Standard GitHub-hosted runners are unaffected.
- **CLI vs Agent Mode.** Same agentic capabilities (Plan, Autopilot, sub-agents), different environment (terminal vs editor). Pick one demo per segment, not both.
- **Tool scoping as a teaching moment.** Code Review agent (6 read-only tools, no `editFiles`) vs Full-Stack Feature Builder (12 tools including `editFiles` and `runCommands`). Tool scope = trust boundary.
- **Exam prep.** GH-300 is still on the Jan 2026 blueprint with no May 2026 revision. Recommend students study Agent Mode, MCP, Spaces, CLI, Skills, and Spark. Exam is **Pearson VUE** (OnVUE), not PSI.
- **De-emphasize "premium request" terminology.** It is sunsetting in 25 days. Call it out as the old model when it appears in screenshots.
