# GitHub Copilot News — March 2026

---

## Major Milestones

### Copilot CLI Reaches General Availability (Feb 25, 2026)

After five months of public preview since September 2025, GitHub Copilot CLI (`gh copilot`) is now production-ready for all paid Copilot subscribers. The terminal-native coding agent can plan complex tasks, execute multistep workflows, edit files, run tests, and iterate autonomously. Ships with GitHub's MCP server built in and supports custom MCP servers.

- [GitHub Changelog: Copilot CLI GA](https://github.blog/changelog/2026-02-25-github-copilot-cli-is-now-generally-available/)

### Model Deprecations (Feb 17, 2026)

Claude Opus 4.1, GPT-5, and GPT-5-Codex have been deprecated across all Copilot experiences (Chat, inline edits, agent modes, code completions). Newer replacements include Claude Opus 4.5/4.6 and GPT-5.1/5.2.

- [GitHub Changelog: Model Deprecations](https://github.blog/changelog/2025-10-23-selected-claude-openai-and-gemini-copilot-models-are-now-deprecated/)

---

## AI Model Updates

### Current Model Roster (March 2026)

| Model Family | Available Models | Notes |
|-------------|-----------------|-------|
| OpenAI GPT | GPT-5.2, GPT-5.1, GPT-5.1-Codex, GPT-5 mini | GPT-5 mini is included (no premium requests) |
| Anthropic Claude | Opus 4.5/4.6, Sonnet 4/4.5/4.6, Haiku 4.5 | Opus models have higher premium multiplier |
| Google Gemini | 3 Flash, 3 Pro, 3.1 Pro, 2.5 Pro | Flash optimized for speed |

### Premium Request System

All tiers except Free get monthly premium request allocations. Extra requests cost $0.04 each. Different models consume different amounts — larger models like Claude Opus have higher multipliers.

---

## VS Code Updates

### VS Code v1.109 (January Release, published Feb 4, 2026)

- **Claude Agent Support** — Public preview of Anthropic Claude Agent SDK integration for delegating tasks using Claude models from your Copilot subscription
- **Faster Chat** — Improved streaming responsiveness and higher-quality reasoning results
- **MCP Improvements** — Richer tool-driven, interactive Copilot experiences in chat

### VS Code v1.110 Cycle (In Progress)

- **Native Browser Integration** — AI agents can interact with page elements, capture screenshots, and pull real-time console logs from inside the editor
- **Copilot Memory** — Agents retain relevant context across interactions
- **Faster Code Search** — External indexing improves retrieval speed for large repos
- **Auto-Approval Rules** — Better safety controls for agent-driven actions

- [GitHub Changelog: VS Code v1.109](https://github.blog/changelog/2026-02-04-github-copilot-in-visual-studio-code-v1-109-january-release/)

### Long-Distance Next Edit Suggestions (Feb 26, 2026)

NES can now predict and suggest edits anywhere in your file, not just near your current cursor position. Uses new data pipelines, reinforcement learning, and continuous model updates.

- [VS Code Blog: Long-Distance NES](https://code.visualstudio.com/blogs/2026/02/26/long-distance-nes)

---

## Agent & Agentic Features

### Copilot CLI Features

- **Plan Mode** — Analyze requests, ask clarifying questions, build structured implementation plans before writing code
- **Autopilot Mode** — Fully autonomous execution without stopping for approval
- **Sub-Agent Delegation** — Automatically delegates to Explore, Task, Code Review, and Plan agents
- **Built-in GitHub MCP Server** — Access GitHub data natively
- **Custom MCP Server Support** — Connect any external tool or service

- [GitHub Changelog: CLI Enhanced Agents](https://github.blog/changelog/2026-01-14-github-copilot-cli-enhanced-agents-context-management-and-new-ways-to-install/)

### Agent Skills Update

Skills now work across Copilot Coding Agent, Copilot CLI, and VS Code agent mode. Project skills go in `.github/skills/`, personal skills in `~/.copilot/skills/`. Each skill has a `SKILL.md` with YAML frontmatter (name, description) and optional scripts/resources.

- [GitHub Docs: Agent Skills](https://docs.github.com/en/copilot/concepts/agents/about-agent-skills)

### Custom Agents (Terminology Update)

"Custom chat modes" have been renamed to "Custom Agents." The `.chatmode.md` extension is replaced by `.agent.md`. Files go in `.github/agents/`. Agents can specify their own tools, MCP servers, and instructions.

- [VS Code Docs: Custom Agents](https://code.visualstudio.com/docs/copilot/customization/custom-agents)

### Copilot Memory Expansion

Memory is now used by Coding Agent, Code Review, and CLI. Memories are repository-scoped, auto-expire after 28 days, and persist longer when validated through use. Available in early access for Pro and Pro+ plans.

- [GitHub Blog: Building an Agentic Memory System](https://github.blog/ai-and-ml/github-copilot/building-an-agentic-memory-system-for-github-copilot/)

---

## Enterprise & Governance

### Enterprise MCP Governance (Visual Studio 2026)

Admins can now specify allowlists for which MCP servers are permitted within their organizations, enforced in Visual Studio 2026.

- [VS 2026 Release Notes](https://learn.microsoft.com/en-us/visualstudio/releases/2026/release-notes)

### Agentic Code Review Updates

Code Review now supports rich agentic tool calling for full project context, integration with CodeQL and ESLint, and seamless hand-off to Coding Agent for auto-fixing issues found during review. Available for Enterprise Cloud with data residency.

- [GitHub Docs: Code Review](https://docs.github.com/en/copilot/concepts/agents/code-review)

### Spaces Generally Available

Anyone with a Copilot license (including Free) can create and use Spaces. Recent additions: public spaces, individual sharing, file integration from code viewer, and IDE access via the GitHub MCP server.

- [GitHub Changelog: Spaces GA](https://github.blog/changelog/2025-09-24-copilot-spaces-is-now-generally-available/)

---

## GH-300 Certification Exam Update (January 2026)

The exam has been significantly restructured with new domains, reworded objectives, and coverage of Agent Mode, MCP, Plan Mode, Sub-Agents, Copilot CLI, Spaces, and Spark. See `copilot-certification/` in this repo for updated objectives.

- [GH-300 Study Guide](https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/gh-300)

---

## Pricing & Plans (Current)

| Tier | Price | Premium Requests |
|------|-------|-----------------|
| Free | $0 | 2,000 completions + 50 chats/mo |
| Pro | $10/mo | 300/mo |
| Pro+ | $39/mo | 1,500/mo |
| Business | $19/user/mo | 300/user/mo |
| Enterprise | $39/user/mo | 1,000/user/mo |

- [Plans & Pricing](https://github.com/features/copilot/plans)
