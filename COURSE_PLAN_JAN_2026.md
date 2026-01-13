# GitHub Copilot for Developers — Teaching Punchlist (Jan 2026)

## Course Structure

- **Duration**: 4 hours total
- **Segments**: 4 x ~55 minute segments
- **Breaks**: ~9 minute breaks between segments
- **Platform**: ON24 live training

---

### Segment 1: Foundations & Core Workflow (60 min)

- Course goals and major changes since last delivery
- GitHub Copilot subscription tiers (Free, Pro, Pro+, Business, Enterprise)
- VS Code setup and extension configuration
- Copilot Free tier (2000 monthly completions, 50 monthly chats)
- Code completions (inline suggestions, ghost text, multi-line)
- Chat interface basics (`Ctrl+I` inline, sidebar chat)
- Chat participants (`@workspace`, `@terminal`, `@vscode`, `@github`)
- Slash commands (`/explain`, `/fix`, `/tests`, `/doc`, `/new`, `/newNotebook`)
- Context awareness and file references (`#file`, `#selection`)
- Prompt engineering fundamentals for Copilot
- Responsible AI foundations (hallucinations, bias, license exposure, security)

---

### Segment 2: Chat Power Features & Multi-File Operations (60 min)

- Chat modes (Ask vs Edits vs Agent)
- Copilot Edits mode for multi-file refactoring
- Working sets and file context management
- Custom instructions (`.github/copilot-instructions.md`)
- Prompt files (`.github/prompts/*.prompt.md`)
- Model selection strategy (GPT-5.2, Claude Opus 4.5, Gemini 3 Flash)
- Model tradeoffs (GPT for reasoning, Claude for code, Gemini for speed)
- Debugging workflows (`/fix` command, error explanation, iteration loops)
- Code review and refactoring workflows
- Attaching files, images, and context to chat
- Next Edit Suggestions (predictive editing)
- Vision for Copilot (screenshot/mockup to code)

---

### Segment 3: Agentic Features & Advanced Workflows (60 min)

- Agent Mode in VS Code (autonomous, iterative coding)
- GitHub Copilot Coding Agent (async PR creation via GitHub Actions)
- Delegating tasks to coding agent (VS Code, GitHub web, Mobile, CLI)
- GitHub Copilot CLI (`gh copilot` — terminal-native agentic coding)
- Agent Skills (`.github/skills/[name]/SKILL.md` — teach Copilot your patterns)
- Model Context Protocol (MCP) server integration (including OAuth support)
- GitHub Copilot Extensions (marketplace: Perplexity, Docker, Sentry, Azure)
- Copilot Memory (Pro/Pro+ — learns your codebase patterns)
- Testing workflows (`/tests`, fixture generation, mocking, TDD)
- Migration scenarios (language ports, framework upgrades, legacy modernization)
- PR reviews with Copilot in GitHub web UI

---

### Segment 4: Enterprise Features, Spaces & Governance (60 min)

- GitHub Copilot Spaces (persistent context, shared knowledge hubs)
- Public spaces, individual sharing, file integration from code viewer
- Accessing Spaces via GitHub MCP server in IDE
- Spaces use cases (onboarding, standards enforcement, query libraries)
- Organization-level custom instructions
- Copilot Code Review with agentic features (CodeQL, ESLint integration)
- Content exclusions and IP filtering
- Audit logs and usage analytics
- Security best practices (secret detection, vulnerability scanning, branch protections)
- Policy enforcement and compliance guardrails (GHEC admin controls)
- ROI measurement and productivity metrics (Copilot Metrics API)
- IDE expansion: JetBrains, Eclipse, Xcode, Visual Studio 2026
- Future roadmap and staying current (changelog, blog, community discussions)

---

## Key Model Updates (Jan 2026)

| Model | Best For | Notes |
|-------|----------|-------|
| GPT-5.2 | Reasoning, novel problem-solving | GA across all plans |
| Claude Opus 4.5 | Code understanding, complex debugging | GA Dec 2025; 10x premium multiplier |
| Gemini 3 Flash | Fast tasks, boilerplate | Preview; great for speed |
| GPT-5 mini / GPT-4.1 | Included models | No premium request consumption |

**Note**: Claude Sonnet 3.5 deprecated Jan 31, 2026 — migrate to Opus 4.5 or Sonnet 4.5

---

## What's New Since Last Delivery

- **Agent Skills** — Teach Copilot repeatable tasks via SKILL.md files
- **Copilot CLI** — Full agentic coding agent in terminal
- **Claude Opus 4.5 GA** — Now generally available across all paid tiers
- **GPT-5.2 GA** — Stronger reasoning for complex edits
- **Gemini 3 Flash Preview** — Fast model option (Jan 6, 2026)
- **MCP OAuth** — Secure third-party integrations (Slack, Jira, custom APIs)
- **Copilot Memory** — Learns codebase patterns (Pro/Pro+)
- **Visual Studio 2026** — New Copilot actions and cloud agent preview
- **Agentic Code Review** — Enterprise code review with tool calling
