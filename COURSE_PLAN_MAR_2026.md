# GitHub Copilot for Developers — Teaching Punchlist (Mar 2026)

**Delivery Date**: March 3, 2026
**Last Updated**: March 3, 2026

## Course Structure

- **Duration**: 4 hours total
- **Segments**: 4 x ~55 minute segments
- **Breaks**: ~9 minute breaks between segments
- **Platform**: ON24 live training

---

### Segment 1: Foundations & Core Workflow (60 min)

- Course goals and major changes since last delivery (Feb 2026)
- GitHub Copilot subscription tiers (Free, Pro, Pro+, Business, Enterprise)
  - Free tier: 2,000 monthly completions, 50 monthly chats
  - Pro: $10/mo, 300 premium requests
  - Pro+: $39/mo, 1,500 premium requests, all models including Claude Opus 4.6
  - Business: $19/user/mo, org management, audit logs, IP indemnity
  - Enterprise: $39/user/mo, fine-tuned models, knowledge bases, advanced security
- VS Code setup and extension configuration
  - Minimum VS Code version: 1.109+; recommend latest 1.110 insiders for cutting-edge features
- Code completions (inline suggestions, ghost text, multi-line)
- Chat interface basics (`Ctrl+I` inline, sidebar chat)
- Chat participants (`@workspace`, `@terminal`, `@vscode`, `@github`)
- Slash commands (`/explain`, `/fix`, `/tests`, `/doc`, `/new`, `/newNotebook`)
- Context awareness and file references (`#file`, `#selection`, `#changes`)
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
- Prompt files (`.github/prompts/*.prompt.md`)
- Model selection strategy and premium request management
  - GPT-5.3-Codex (agentic tasks, up to 25% faster than GPT-5.2-Codex) — **GA Feb 9, 2026**; requires admin policy enable for Business/Enterprise
  - GPT-5.2 (reasoning, novel problem-solving) — GA across all plans
  - GPT-5.1 (strong general-purpose coding) — GA across all plans
  - Claude Opus 4.5/4.6, Sonnet 4/4.5/4.6 (code understanding, complex debugging)
  - Claude Haiku 4.5 (fast, lightweight tasks)
  - Gemini 3 Flash/Pro, 3.1 Pro (fast tasks, boilerplate, large context)
  - Gemini 2.5 Pro (still available, strong reasoning)
  - GPT-5 mini (included model, no premium request consumption)
  - **Deprecated Feb 17, 2026**: Claude Opus 4.1, GPT-5, GPT-5-Codex — removed from model picker
- Debugging workflows (`/fix` command, error explanation, iteration loops)
- Code review and refactoring workflows
- Attaching files, images, and context to chat
- Next Edit Suggestions (NES)
  - Predictive editing based on recent changes
  - **Long-distance NES** (Feb 26, 2026): predicts edits anywhere in the file, not just near cursor
  - Tab to accept, Esc to dismiss; works across languages
- Vision for Copilot (screenshot/mockup to code)
  - Attach screenshots, wireframes, or design mockups directly to chat
  - Copilot generates matching HTML/CSS/component code

---

### Segment 3: Agentic Features & Advanced Workflows (60 min)

- Agent Mode in VS Code (autonomous, iterative coding)
  - Plan mode: structured implementation planning before execution
  - Autopilot mode: fully autonomous tool execution without confirmation prompts
  - Sub-agent delegation (Explore, Task, Code Review, Plan)
  - Auto-approval rules: configure trusted tools/actions to skip confirmation (VS Code 1.110)
- GitHub Copilot Coding Agent (async PR creation via GitHub Actions)
  - Delegating via: VS Code, GitHub web, Mobile, CLI, Agents panel
  - Writing effective issues for the agent
  - Monitoring progress and providing feedback on PRs
  - Firewall and networking configuration for enterprise environments
- GitHub Copilot CLI — **GA Feb 25, 2026** (`gh copilot`)
  - Terminal-native agentic coding for all paid subscribers
  - Plan mode and Autopilot mode (same concepts as VS Code Agent Mode)
  - Sub-agent delegation from the terminal
  - Built-in GitHub MCP server (issues, PRs, repos, search)
  - Custom MCP server support (connect any MCP-compatible service)
  - Session management and context persistence across invocations
  - Works alongside existing `gh copilot suggest` and `gh copilot explain`
- Custom Agents (`.github/agents/*.agent.md` — formerly `.chatmode.md`)
  - Specify tools, MCP servers, and instructions per agent
  - Interactive wizard or manual `.agent.md` authoring
  - Scoped to repository; activated from the model/agent picker in chat
  - **Note**: legacy `.chatmode.md` files still work but `.agent.md` is the current format; this repo contains both for teaching purposes (`.github/agents/` and `.github/chatmodes/`)
- Agent Skills (`.github/skills/[name]/SKILL.md`)
  - Teach Copilot repeatable workflows with markdown + YAML frontmatter
  - Auto-loaded when relevant across Coding Agent, CLI, and VS Code
  - Project skills (`.github/skills/`) vs personal skills (`~/.copilot/skills/`)
  - Skills can reference tool outputs, file templates, and multi-step procedures
  - **Invoke directly as slash commands** in chat (e.g., `/webapp-testing for the login page`)
  - Community skill library: [github/awesome-copilot](https://github.com/github/awesome-copilot)
- Model Context Protocol (MCP) server integration
  - OAuth support for secure third-party integrations (Slack, Jira, custom APIs)
  - MCP server names now support npm-style naming: dots, slashes, @ characters
  - Enterprise MCP governance: admin allowlists for org-approved servers (VS 2026, VS Code)
  - Streamable HTTP transport support alongside SSE
- GitHub Copilot Extensions (marketplace: Perplexity, Docker, Sentry, Azure)
- Copilot Memory (Pro/Pro+ early access)
  - Repository-level persistent context that grows as you work
  - Shared across Coding Agent, Code Review, and CLI
  - Auto-expires after 28 days; validated memories persist longer
  - Faster code search integration in VS Code 1.110
- Testing workflows (`/tests`, fixture generation, mocking, TDD)
- Migration scenarios (language ports, framework upgrades, legacy modernization)

---

### Segment 4: Enterprise Features, Spaces & Governance (60 min)

- GitHub Copilot Spaces — **GA Sep 2025**
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
- Content exclusions and IP filtering
- Audit logs and usage analytics
- Security best practices (secret detection, vulnerability scanning, branch protections)
- Policy enforcement and compliance guardrails (GHEC admin controls)
  - MCP server allowlists for organizations
  - Model availability restrictions per org policy
- ROI measurement and productivity metrics (Copilot Metrics API)
  - **Copilot Metrics GA** (Feb 27, 2026): dashboards + API now production-ready for all orgs/enterprises
  - Acceptance rates, time saved, lines suggested, active users
  - **Plan mode telemetry** (Mar 2, 2026): metrics now break out plan mode usage separately (`chat_panel_plan_mode`); visible in Insights dashboard under AI Controls
  - Enterprise Cloud with data residency support; custom enterprise roles for fine-grained dashboard access
- IDE expansion: JetBrains, Eclipse, Xcode, Visual Studio 2026
  - VS 2026: find_symbol tool for agent mode, enterprise MCP governance, proxy support
  - JetBrains: Agent Mode available, MCP support in progress
- GitHub Spark (Pro+ and Enterprise — AI-powered full-stack app builder)
  - Natural language to full-stack app with live preview; no setup required
  - Embeds AI features (chatbots, content generation, smart automation) without complex integrations
  - Open in VS Code agent mode or create a GitHub repo in one click
  - Covered in GH-300 exam; mention alongside Copilot Spaces as a next-generation interface
- Coding Agent network configuration changes (effective Feb 27, 2026)
  - Plan-specific endpoints now required for self-hosted/private-network runners
  - Business: `api.business.githubcopilot.com`, Enterprise: `api.enterprise.githubcopilot.com`, Pro/Pro+: `api.individual.githubcopilot.com`
  - Affects orgs using self-hosted runners or Azure private networking (standard runners unaffected)
- GH-300 Certification exam overview (updated Jan 2026)
  - 7 domains, new weighting, ~65 questions in 100 minutes
  - Now covers Agent Mode, MCP, Spaces, CLI, Custom Agents, Skills, Spark
  - Passing score: 700 (scaled), $99 USD, 2-year validity; delivered via Pearson VUE (OnVUE online proctoring)
- Future roadmap and staying current (changelog, blog, community discussions)

---

## What's New Since Feb 2026 Delivery

| Date | Update | Details |
|------|--------|---------|
| Mar 2 | **Copilot Metrics: plan mode telemetry** | Plan mode usage now reported separately in metrics dashboards and API (`chat_panel_plan_mode`). Available in Insights under AI Controls. Orgs on VS Code Insiders, JetBrains, Eclipse, Xcode now; stable VS Code coming soon. |
| Mar 2 | **Coding Agent network changes in effect** | Plan-specific network endpoints now active (announced Feb 13, effective Feb 27). Affects self-hosted/private-network runner orgs. Enterprise: `api.enterprise.githubcopilot.com`, Business: `api.business.githubcopilot.com`, Pro/Pro+: `api.individual.githubcopilot.com`. |
| Feb 27 | **Copilot Metrics GA** | Usage metrics dashboards and API now production-ready for all orgs and enterprises. Includes fine-grained access controls, GHEC data residency support, and custom enterprise roles for dashboard sharing. |
| Feb 25 | **Copilot CLI GA** | Terminal-native coding agent now production-ready for all paid subscribers. Includes Plan mode, Autopilot mode, sub-agent delegation, built-in GitHub MCP server, and custom MCP support. |
| Feb 26 | **Long-distance NES** | Next Edit Suggestions now predict edits anywhere in the file, not just near the cursor position. |
| Feb 17 | **Model deprecations** | Claude Opus 4.1, GPT-5, and GPT-5-Codex removed from model picker. Migrate to Opus 4.5/4.6 or GPT-5.1/5.2. |
| Feb 9 | **GPT-5.3-Codex GA** | OpenAI's latest agentic model now in Copilot. Up to 25% faster than GPT-5.2-Codex on agentic tasks. Available in VS Code, GitHub Mobile, CLI, and Coding Agent on Pro, Pro+, Business, and Enterprise. Requires admin policy enable for Business/Enterprise. |
| Feb 5 | **Claude Opus 4.6 GA** | Latest Anthropic model now available across all paid tiers (alongside Opus 4.5, Sonnet 4.6, etc.). |
| Ongoing | **VS Code v1.110 cycle** | Native browser integration for agents (page interaction, screenshots, console logs), Copilot Memory improvements, faster code search, auto-approval rules for agent actions. |
| Jan | **VS Code v1.109** | Claude agent support in preview, faster streaming, improved reasoning model handling. |
| Jan | **Enterprise MCP governance** | Admin allowlists for MCP servers now available in VS 2026; coming to VS Code. |
| Jan | **GH-300 exam restructured** | 7 domains with new weighting; now covers Agent Mode, MCP, Spaces, CLI, Custom Agents, Skills, and Spark. |
| Ongoing | **Copilot Memory expanding** | Now shared across Coding Agent, Code Review, and CLI. Repository-level persistence with 28-day auto-expiry. |
| Ongoing | **Custom Agents terminology** | `.chatmode.md` files renamed to `.agent.md`. Same functionality, updated naming convention. |
| Ongoing | **Agent Skills slash commands** | Skills invokable directly via `/skillname` in chat alongside automatic activation. Community library at github/awesome-copilot. |

---

## Current Model Landscape (Mar 2026)

| Model Family | Models Available | Best For | Premium? |
|-------------|-----------------|----------|----------|
| **OpenAI GPT** | GPT-5.3-Codex | Agentic coding tasks, up to 25% faster than 5.2-Codex; GA Feb 9, 2026 | Yes (admin enable req. for Biz/Ent) |
| **OpenAI GPT** | GPT-5.2, GPT-5.1 | Reasoning, novel problem-solving | Yes |
| **OpenAI GPT** | GPT-5 mini | General-purpose, included model | No (included) |
| **Anthropic Claude** | Opus 4.5, Opus 4.6 | Deep code understanding, complex debugging | Yes (high multiplier) |
| **Anthropic Claude** | Sonnet 4, Sonnet 4.5, Sonnet 4.6 | Balanced code tasks | Yes |
| **Anthropic Claude** | Haiku 4.5 | Fast, lightweight tasks | Yes (low multiplier) |
| **Google Gemini** | 3 Flash, 3 Pro | Speed-optimized, large context | Yes |
| **Google Gemini** | 3.1 Pro | Enhanced reasoning | Yes |
| **Google Gemini** | 2.5 Pro | Strong reasoning (legacy) | Yes |

**Removed Feb 17, 2026**: Claude Opus 4.1, GPT-5 (base), GPT-5-Codex

---

## Key Demo Assets in This Repo

### Core Application & Tutorials

| Asset | Location | Purpose | Segment |
|-------|----------|---------|---------|
| MCP Server | `src/copilot_tips_server.py` | Live MCP server demo | 3 |
| Coding Agent Bug Demo | `src/test-app.js` | Intentional bug on line 87 (`=` vs `===`) — Coding Agent `/fix` demo | 3 |
| Agent Tutorial | `COPILOT_AGENT_TUTORIAL.md` | Coding Agent walkthrough (issue → PR) | 3 |
| Customization Samples | `COPILOT_CUSTOMIZATION_SAMPLES.md` | Reference examples for all customization types | 2-3 |
| Metrics JSON | `copilot-metrics.json` | Enterprise metrics API response demo | 4 |
| Cert Objectives | `copilot-certification/` | GH-300 exam prep (Jan 2026 update, Pearson VUE) | 4 |

### Custom Instructions

| Asset | Location | Purpose | Segment |
|-------|----------|---------|---------|
| Repo-wide Instructions | `.github/copilot-instructions.md` | Baseline repo-wide instructions demo | 2 |
| Python MCP Instructions | `.github/instructions/Python MCP Instructions.instructions.md` | Path-scoped instructions (Python files) | 2 |
| Security-forward Instructions | `.github/instructions/security-forward-instructions.instructions.md` | Path-scoped security instructions | 2 |

### Custom Agents (`.agent.md` format)

| Agent | Location | Teaching Focus | Segment |
|-------|----------|---------------|---------|
| Copilot Course Teaching Demo | `.github/agents/Copilot Course Teaching Demo.agent.md` | Multi-model array fallback, `handoffs`, references all 3 skills; every YAML field commented | 3 |
| Code Review & Security Expert | `.github/agents/Code Review and Security Expert.agent.md` | Narrow read-only tool scope (no `editFiles`) as security boundary; CRITICAL/HIGH/MEDIUM/LOW output | 3 |
| Full-Stack Feature Builder | `.github/agents/Full-Stack Feature Builder.agent.md` | Broadest tool set, mandatory 7-phase TDD workflow, handoffs chain | 3 |
| Python MCP Server Expert | `.github/agents/Python MCP Server Expert.agent.md` | Domain-specific expert agent, FastMCP patterns | 3 |
| Legacy Chatmode | `.github/chatmodes/new-mode.chatmode.md` | Side-by-side comparison: deprecated `.chatmode.md` vs current `.agent.md` format | 3 |

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

## Teaching Notes

- **Opening hook**: Lead with the Copilot CLI GA announcement (Feb 25) as the headline change since last month. Demo `gh copilot` in a terminal early to set the agentic tone.
- **GPT-5.3-Codex**: Highlight this as the newest model addition (Feb 9). It targets agentic workflows specifically and is 25% faster than GPT-5.2-Codex on those tasks. Business/Enterprise admins must explicitly enable the policy before users see it in the picker.
- **Model deprecation callout**: Remind attendees to update their model picker if they were using Claude Opus 4.1, GPT-5, or GPT-5-Codex (the old one). These are gone as of Feb 17.
- **Long-distance NES**: Show a before/after of NES predicting edits far from the cursor. This is a tangible improvement attendees can try immediately.
- **Copilot Metrics GA + plan mode telemetry**: Good enterprise-segment talking point. Metrics are now fully GA (Feb 27) and plan mode has its own telemetry category (Mar 2). Enterprise admins can now track who's using plan mode vs. other chat modes.
- **Coding Agent network changes**: Flag for enterprise admins only — if their org uses self-hosted runners or Azure private networking, they need to update allowlists to the plan-specific endpoints. Standard GitHub-hosted runners are unaffected.
- **VS Code version**: Ensure demo machine runs VS Code 1.109+ stable. The 1.110 insiders channel has browser integration and auto-approval rules for agents if you want to preview those.
- **CLI vs Agent Mode**: Clarify that Copilot CLI and VS Code Agent Mode share the same underlying agentic capabilities (Plan mode, Autopilot, sub-agents) but operate in different environments (terminal vs editor).
- **Agent Skills as slash commands**: New framing — skills aren't just auto-loaded anymore; learners can invoke them directly with `/skillname` in chat. Point to the community library at github/awesome-copilot for ready-made examples.
- **Custom Agents vs. legacy chatmodes**: The repo contains both `.github/agents/Python MCP Server Expert.agent.md` (new format) and `.github/chatmodes/new-mode.chatmode.md` (legacy format). Use this as a live side-by-side teaching example of the terminology transition.
- **GitHub Spark**: Briefly touch on Spark (Pro+/Enterprise) in Segment 4 as the "what's next" glimpse. It's on the GH-300 exam and represents GitHub's vision for AI-native app development.
- **Exam prep**: Emphasize the Jan 2026 GH-300 restructuring. Students preparing for certification need to study the new domains covering Agent Mode, MCP, Spaces, CLI, Skills, and Spark. Exam is now proctored via **Pearson VUE** (OnVUE) — not PSI.
- **Agent Skills demo flow**: Open `src/test-app.js`, show the bug comment on line 87, run `/webapp-testing` on `sample-login-page.html` to generate Playwright tests, then run `/legacy-code-refactor` on `legacy-example.js` to show the before/after transformation. Each skill has its own supporting artifacts — no setup required.
- **Agent chaining demo**: Open the Course Teaching Demo agent → delegate to Full-Stack Feature Builder → chain to Code Review & Security Expert. The `handoffs` field in each `.agent.md` enables this flow — walk through it live to explain agent orchestration.
- **Prompt file schema callout**: The `mode:` frontmatter field is **deprecated**. All new prompt files use `agent:` (values: `ask`, `agent`, `plan`). Point to the old `oreilly-api-help.prompt.md` git history vs the updated version as a concrete before/after.
- **Tool scoping as a teaching moment**: Compare Code Review agent (6 read-only tools, no `editFiles`) vs Full-Stack Feature Builder (12 tools including `editFiles` and `runCommands`). This illustrates how tool scope defines trust boundary and agentic capability.
