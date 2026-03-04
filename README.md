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

## Course Structure (Mar 2026)

### Segment 1: Foundations & Core Workflow

- GitHub Copilot subscription tiers (Free, Pro, Pro+, Business, Enterprise)
- VS Code setup and extension configuration
- Code completions (inline suggestions, ghost text, multi-line)
- Chat interface basics (`Ctrl+I` inline, sidebar chat)
- Chat participants (`@workspace`, `@terminal`, `@vscode`, `@github`)
- Slash commands (`/explain`, `/fix`, `/tests`, `/doc`, `/new`, `/newNotebook`)
- Context awareness and file references (`#file`, `#selection`, `#changes`)
- Prompt engineering fundamentals
- Responsible AI foundations

### Segment 2: Chat Power Features & Multi-File Operations

- Chat modes (Ask vs Edit vs Agent)
- Copilot Edit mode for controlled multi-file refactoring
- Working sets and file context management
- Custom instructions (`.github/copilot-instructions.md`) and path-scoped instructions (`.github/instructions/*.instructions.md`)
- Prompt files (`.github/prompts/*.prompt.md`)
- Model selection strategy (GPT-5.2, Claude Opus 4.5/4.6, Gemini 3 Flash/Pro)
- Debugging workflows and iteration loops
- Next Edit Suggestions (predictive editing, long-distance NES)
- Vision for Copilot (screenshot/mockup to code)

### Segment 3: Agentic Features & Advanced Workflows

- Agent Mode in VS Code (Plan mode, Autopilot mode, sub-agent delegation: Explore, Task, Code Review, Plan)
- GitHub Copilot Coding Agent (async PR creation via GitHub Actions; delegate via VS Code, GitHub web, Mobile, CLI)
- GitHub Copilot CLI — **GA Feb 25, 2026** (`gh copilot` — terminal-native agentic coding, built-in GitHub MCP server)
- Custom Agents (`.github/agents/*.agent.md` — formerly "chat modes"; specify tools, MCP servers, instructions per agent)
- Agent Skills (`.github/skills/[name]/SKILL.md` — teach Copilot your patterns; project or personal `~/.copilot/skills/`)
- Model Context Protocol (MCP) server integration (OAuth, enterprise governance)
- GitHub Copilot Extensions (Perplexity, Docker, Sentry, Azure)
- Copilot Memory (Pro/Pro+ — persistent repository-level context; shared across Coding Agent, Code Review, CLI)
- Testing workflows and TDD
- Migration scenarios (language ports, framework upgrades)

### Segment 4: Enterprise Features, Spaces & Governance

- GitHub Copilot Spaces — **GA** (persistent context hubs, public/org sharing)
- Organization-level custom instructions
- Copilot Code Review with agentic features (CodeQL, ESLint, hand-off to Coding Agent, data residency)
- Enterprise MCP governance (admin allowlists)
- Content exclusions and IP filtering
- Audit logs and usage analytics
- Security best practices (secret detection, vulnerability scanning)
- Policy enforcement and compliance guardrails
- ROI measurement and productivity metrics (Copilot Metrics API — legacy; new Usage Metrics API GA Feb 27, 2026)
- IDE expansion: JetBrains, Eclipse, Xcode, Visual Studio 2026 (find_symbol, enterprise MCP, proxy support)
- GH-300 Certification exam overview (7 domains, updated Jan 2026; covers Agent Mode, MCP, Spaces, CLI)

## Model Options (Mar 2026)

| Model | Best For | Notes |
| ----- | -------- | ----- |
| GPT-5.2 | Reasoning, novel problem-solving | GA across all plans |
| GPT-5.1 | General-purpose coding | GA across paid tiers |
| GPT-5 mini | Everyday completions | Included model; no premium request consumption |
| Claude Opus 4.5/4.6 | Code understanding, complex debugging | GA; premium multiplier |
| Claude Sonnet 4/4.5/4.6 | Balanced code tasks | GA across paid tiers |
| Claude Haiku 4.5 | Fast lightweight tasks | Low-cost option |
| Gemini 3 Flash/Pro | Fast tasks, boilerplate | Speed-optimized |
| Gemini 3.1 Pro | Enhanced reasoning | Latest Gemini |

**Deprecated Feb 17, 2026**: Claude Opus 4.1, GPT-5, GPT-5-Codex -- migrate to Opus 4.5/4.6 or GPT-5.1/5.2

## What's New (Mar 2026)

- **Copilot CLI GA** (Feb 25, 2026) -- Terminal-native agentic coding with built-in GitHub MCP server, now production-ready
- **Model deprecations** (Feb 17, 2026) -- Claude Opus 4.1, GPT-5, GPT-5-Codex removed; use Opus 4.5/4.6 or GPT-5.1/5.2
- **Claude Opus 4.6 / Sonnet 4.6** -- Latest Anthropic models available across paid tiers
- **Long-distance NES** (Feb 26, 2026) -- Next Edit Suggestions predict edits anywhere in file, not just near cursor
- **Enterprise MCP governance** -- Admin allowlists for org-approved MCP servers (VS Code and VS 2026)
- **Custom Agents** -- `.agent.md` files replace `.chatmode.md` (same functionality, new terminology)
- **Agent Skills** -- Teach Copilot repeatable workflows via SKILL.md (project or personal, across CLI, VS Code, Coding Agent)
- **Copilot Memory expanding** -- Now shared across Coding Agent, Code Review, and CLI (Pro/Pro+ early access)
- **Agentic Code Review** -- LLM + CodeQL/ESLint with hand-off to Coding Agent; Enterprise Cloud data residency
- **GH-300 exam overhaul** (Jan 2026) -- 7 domains with new weighting; now covers Agent Mode, MCP, Spaces, CLI
- **VS Code v1.109** (Jan 2026) -- Claude agent support in preview, faster streaming, improved reasoning
- **VS Code v1.110 cycle** -- Native browser integration for agents (page interaction, screenshots, console logs)

## Subscription Tiers

| Tier | Price | Premium Requests | Key Features |
|------|-------|-----------------|--------------|
| Free | $0/mo | 2,000 completions + 50 chats | Basic completions and chat |
| Pro | $10/mo | 300/mo | All models, unlimited completions |
| Pro+ | $39/mo | 1,500/mo | All premium models, Memory |
| Business | $19/user/mo | 300/user/mo | Org management, audit logs, IP indemnity, Coding Agent |
| Enterprise | $39/user/mo | 1,000/user/mo | Fine-tuned models, knowledge bases, advanced security |

## Prerequisites

- GitHub account (Free tier includes Copilot with 2,000 monthly completions)
- Visual Studio Code with GitHub Copilot extension
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

### IDE Extensions

- [VS Code Extension](https://marketplace.visualstudio.com/items?itemName=GitHub.copilot)
- [Visual Studio Extension](https://marketplace.visualstudio.com/items?itemName=GitHub.copilotvs)
- [JetBrains Extension](https://plugins.jetbrains.com/plugin/17718-github-copilot)
- [Neovim Extension](https://github.com/github/copilot.vim)

### Customization & Agents

- [Creating Agent Skills](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/coding-agent/create-skills)
- [About Agent Skills](https://docs.github.com/en/copilot/concepts/agents/about-agent-skills)
- [MCP with Copilot](https://docs.github.com/en/copilot/tutorials/enhance-agent-mode-with-mcp)
- [Copilot Spaces](https://docs.github.com/en/copilot/concepts/context/spaces)
- [Copilot Memory](https://docs.github.com/en/copilot/concepts/agents/copilot-memory)

### Certification

- [GH-300 Study Guide](https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/gh-300)
- [GitHub Copilot Certification](https://learn.microsoft.com/en-us/credentials/certifications/github-copilot/)
- [MS Learn Path: Copilot Fundamentals Part 1](https://learn.microsoft.com/en-us/training/paths/copilot/)
- [MS Learn Path: Copilot Fundamentals Part 2](https://learn.microsoft.com/en-us/training/paths/gh-copilot-2/)

### Pricing & Plans

- [Plans & Pricing](https://github.com/features/copilot/plans)
- [Compare Plans](https://docs.github.com/en/copilot/get-started/plans)

## License

MIT License - See [LICENSE](LICENSE) for details
