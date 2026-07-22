# GitHub Copilot for Developers -- July 2026

> Say the version out loud, demo the pickers instead of reading lists, and let the room watch you verify.

## At a Glance

| Segment | Title | Verb | What You Cover |
|---|---|---|---|
| 1 | Foundations & Core Workflow | **Orient** | Plans, AI Credits, install, completions, NES, the agent picker, prompt craft |
| 2 | Chat Power Features | **Steer** | `#` context, `/` commands, models, custom agents, instructions, prompt files, skills |
| 3 | Agentic | **Delegate** | Agent and Plan agents, Autopilot, subagents, Copilot CLI, cloud agent, MCP |
| 4 | Enterprise & Governance | **Control** | AI Controls, content exclusion gaps, MCP allowlist, audit log, metrics reports |

## Pre-Class Checks

- [ ] **VS Code version** on screen via `code --version`, and re-read the cheat sheet the morning of delivery
- [ ] **Copilot CLI current** -- `npm update -g @github/copilot`, confirm Node 22+ and PowerShell 6+
- [ ] **Demo app runs** -- `cd src && npm start`, browse the tips UI, confirm the `tip-lookup.js` line 35 bug is intact
- [ ] **Cloud agent reachable** -- paid seat active, `.vscode/mcp.json` loads, PAT input prompts

---

## Segment 1: Foundations & Core Workflow (55 min)

> **Orient.**

### MUST TEACH

- [ ] **AI Credits** replaced premium requests June 1, 2026 -- 1 credit = $0.01, token-metered, not per-request
- [ ] **Completions and NES cost zero credits** -- the everyday loop is free on every paid tier
- [ ] **Plan ladder**: Free $0, Pro $10, Pro+ $39, Max $100, Business $19/seat, Enterprise $39/seat
- [ ] **Monthly credits**: Pro 1,500, Pro+ 7,000, Max 20,000, Business 1,900, Enterprise 3,900
- [ ] **Promo through Sep 1, 2026** -- existing Business 3,000 and Enterprise 7,000 credits, existing customers only
- [ ] **Business self-serve signup is paused** for orgs on GitHub Free or Team, banner still live
- [ ] **Agent picker** in the Chat view holds three built-in agents: **Agent**, **Plan**, **Ask**
- [ ] **Ask is agentic now** -- backed by a custom agent definition, it researches your codebase
- [ ] **Keybindings**: Chat view `Ctrl+Alt+I`, inline chat `Ctrl+I`, Quick Chat `Ctrl+Shift+Alt+L`

### DEMO (20 min)

1. Open `src/public/index.html`, type a function signature, accept a completion, then trigger NES.
2. Open the Chat view with `Ctrl+Alt+I` and show the agent picker holding Agent, Plan, Ask.
3. Press `Ctrl+I` in the editor for inline chat, then again in the integrated terminal.
4. Show the billing page live: credits consumed to date, not request counts.
5. Run a vague prompt, then the same goal with a file, an error, and a constraint. Compare output.
6. Point at your VS Code version in the About dialog and say the number out loud.

### LAB (10 min)

Rewrite one weak prompt into goal, context, constraint, example form. Run both against `src/tip-lookup.js` and compare the diffs.

---

## Segment 2: Chat Power Features (55 min)

> **Steer.**

### MUST TEACH

- [ ] **Type `#` to discover context** -- files, folders, symbols, and tools all sit behind one key
- [ ] **`#codebase`** is the sanctioned shorthand for semantic whole-codebase search, still current
- [ ] **Agents run semantic search automatically** -- the docs say you usually do not need `#codebase`
- [ ] **Three chat participants survive**: `@github`, `@terminal`, `@vscode`. That is the entire list
- [ ] **Type `/` to discover commands** -- the lists churn monthly, the picker never lies
- [ ] **`/compact` and `/fork`** are the context-window hygiene commands for long agent runs
- [ ] **Custom agents** are `.agent.md` files in `.github/agents/`, formerly called custom chat modes
- [ ] **`.agent.md` frontmatter**: `description`, `name`, `tools`, `model`, `handoffs`, `target`, `user-invocable`
- [ ] **`model:` accepts an array** for fallback priority in VS Code, though Copilot CLI still rejects that syntax
- [ ] **Instructions layer**: repo-wide `copilot-instructions.md`, path-scoped `.instructions.md`, plus `AGENTS.md`
- [ ] **Precedence is priority, not exclusion** -- GitHub sends every matching instruction set to the model
- [ ] **Prompt files use `agent:`**, values `ask`, `agent`, `plan`, or a custom agent name
- [ ] **SKILL.md needs exactly two fields**, `name` and `description`, and `name` must match its folder

### DEMO (25 min)

1. Type `#` in chat, scroll the picker, then attach a file plus `#codebase` on one prompt.
2. Type `/` and scroll the live command list rather than reading a slide.
3. Open `.github/agents/Code Review and Security Expert.agent.md` and read its scoped `tools` list.
4. Select that agent, request an edit, and watch it decline for lack of `edit/editFiles`.
5. Run `/create-skill`, scaffold a skill, rename its folder, and show it silently fail to load.
6. Open View > Output > GitHub Copilot Chat and point at the instructions actually injected.
7. Swap models mid-conversation with `Ctrl+Alt+.` and name the credit implication.

### LAB (12 min)

Write an `.instructions.md` scoped to `**/*.js` that bans mutation. Regenerate a function in `src/tip-lookup.js` and confirm the rule landed by reading the Output channel.

---

## Segment 3: Agentic (55 min)

> **Delegate.**

### MUST TEACH

- [ ] **Plan agent** builds a structured plan first, saved to `/memories/session/plan.md`, cleared at session end
- [ ] **Autopilot is a permission level**, not a mode -- it sits beside Default Approvals and Bypass Approvals
- [ ] **Autopilot iterates until `task_complete`** -- enable with `chat.autopilot.enabled`
- [ ] **Subagents are agent-initiated** context isolation via `agent/runSubagent`, max nesting depth 5
- [ ] **Copilot CLI install**: `npm install -g @github/copilot`, binary is `copilot`, Node 22+, GA Feb 25, 2026
- [ ] **CLI modes cycle with `Shift+Tab`** -- there is no `/plan` and no `/autopilot` slash command
- [ ] **`/fleet <prompt>`** splits a plan into parallel subagent tasks, each with its own context window
- [ ] **`/delegate` or the `&` prefix** hands work to the cloud agent, which opens a branch and draft PR
- [ ] **Copilot cloud agent** is the current name, runs on Actions infrastructure, requires a paid plan
- [ ] **Agents panel** on github.com is the delegation and monitoring hub, present on every page
- [ ] **VS Code hands off to cloud** via the session type dropdown and the Plan agent's Continue in Cloud
- [ ] **MCP replaced Copilot Extensions**, which were disabled Nov 10, 2025
- [ ] **MCP spec is 2025-11-25** today, with the 2026-07-28 revision shipping in six days
- [ ] **Copilot Memory is public preview** -- removed after 28 unused days, the timer resets on use

### DEMO (25 min)

1. Select the Plan agent, request a feature, then open the plan with Chat: Show Memory Files.
2. Open the permissions picker and switch from Default Approvals to Autopilot.
3. Run `copilot`, press `Shift+Tab` twice, and narrate the modes you actually see on screen.
4. Fire `/fleet` on a multi-part task, then `/tasks` to show the parallel subagents.
5. Type `& fix the id comparison bug in src/tip-lookup.js` and watch the branch and draft PR appear.
6. Open the repository Agents tab, read the live log, and pause the session mid-run.
7. Open `.vscode/mcp.json`, start the GitHub MCP server, and call a tool from chat.

### LAB (12 min)

Delegate the `src/tip-lookup.js` line 35 assignment bug to the cloud agent. Review its PR and leave a `@copilot` comment requesting a regression test.

---

## Segment 4: Enterprise & Governance (55 min)

> **Control.**

### MUST TEACH

- [ ] **AI Controls tab** is the permanent home for Copilot policy -- the old Policies page and its redirect are gone
- [ ] **Content exclusion needs Business or Enterprise** -- no equivalent control exists on Free, Pro, or Pro+
- [ ] **Content exclusion is not honored** by Copilot CLI, cloud agent, Agent mode, or Edit mode. Say it out loud
- [ ] **Exclusion leaks semantically** -- type info, hover definitions, and build config still reach the model
- [ ] **Exclusion skips symlinks and remote filesystems**, and takes up to 30 minutes to reach loaded IDEs
- [ ] **Copilot code review does honor exclusion** -- the one agentic-adjacent surface that respects it
- [ ] **MCP allowlist has two settings**: Allow all, and Registry only
- [ ] **MCP allowlist enforcement is advisory** -- name matching is bypassable by editing config files
- [ ] **MCP conflicts resolve to the more restrictive** setting, with enterprise beating organization
- [ ] **Agentic audit events reuse normal action names** -- filter on `actor_is_agent` and `agent_session_id`
- [ ] **Audit retention is 180 days**; the live Agent sessions view covers only 24 hours
- [ ] **Cloud agent commits carry an `Agent-Logs-Url` trailer** and are signed. Provenance for free
- [ ] **Metrics are report-based** at `/copilot/metrics/reports/*`; legacy endpoints sunset April 2, 2026
- [ ] **Repository-level usage metrics went GA July 17, 2026** -- five days ago, call it brand new
- [ ] **GH-300**: 700 to pass, seven domains, revision effective Aug 7, 2026, one year with free open-book renewal

### DEMO (20 min)

1. Open enterprise settings > AI Controls and walk the policy toggles you actually see.
2. Add a content exclusion rule, then re-open the file to show the propagation lag.
3. Prove the gap: open that excluded file in Agent mode and watch Copilot read it anyway.
4. Set the MCP allowlist to Registry only, then edit a config file to demonstrate the bypass.
5. Filter the enterprise audit log with `actor:Copilot` and open an `agent_session.task` event.
6. Open a cloud agent commit and follow its `Agent-Logs-Url` trailer back to the session log.
7. Run `scripts/Get-CopilotMetricsReport.ps1` and open the returned report.

### LAB (10 min)

Pick one surface content exclusion does not cover. Name the policy toggle plus the audit filter you would use instead. Two lines, no tooling.

---

## Do Not Teach

| Dead thing | What replaced it |
|---|---|
| `@workspace` in VS Code | `#codebase`, or let the agent search on its own. Still valid in Visual Studio only |
| Edit mode as a normal surface | Agent mode. Edit mode is deprecated, visible only where policy disables Agent mode |
| `chat.editMode.hidden` | Nothing. Release notes say removed, docs still list it. Do not assert either on stage |
| Ask / Edit / Agent three-mode dropdown | The agent picker: Agent, Plan, Ask, plus your custom agents |
| The phrase "chat modes" | "Agents", chosen from the agents dropdown |
| `.chatmode.md` files | `.agent.md` in `.github/agents/` |
| "Chat variables" for `#` references | Context items and chat tools |
| `#block` `#class` `#function` `#line` `#path` `#project` | `#` plus a file, folder, or symbol, or a namespaced tool |
| Bare tool names in `.agent.md` tool lists | Namespaced: `search/codebase`, `read/problems`, `edit/editFiles` |
| Autopilot as a fourth chat mode | A permission level in the permissions picker |
| Explore / Task / Code Review as named VS Code subagents | Generic subagents via `agent/runSubagent`, plus your own `.agent.md` |
| `/plan` or `/autopilot` as CLI slash commands | `Shift+Tab` mode cycling, or the `--autopilot` flag |
| `gh extension install github/gh-copilot` | `npm install -g @github/copilot`, binary `copilot` |
| `gh copilot suggest` and `gh copilot explain` | The agentic CLI. `gh copilot` now forwards to `copilot` |
| Node 18 or Node 20 as the CLI floor | Node 22 or later |
| "Copilot coding agent" | "Copilot cloud agent", renamed April 1, 2026 |
| `used_copilot_coding_agent` metrics field | `used_copilot_cloud_agent` |
| Issue assignment as the only delegation path | Agents panel, repo Agents tab, VS Code dropdown, CLI `/delegate` or `&` |
| Cloud agent as PR-only | It also does deep research and standalone planning, no PR required |
| `mode:` in prompt files | `agent:` |
| `license`, `version`, `allowed-tools` in SKILL.md | `name` and `description`, plus `argument-hint` and `user-invocable` |
| `github.copilot.chat.codeGeneration.instructions` settings | File-based `.instructions.md` |
| Precedence framed as override | All matching instruction sets are sent, only conflicts resolve by priority |
| Copilot Extensions | MCP servers |
| Premium requests | AI Credits, token-metered |
| `/orgs/{org}/copilot/metrics` and `/copilot/usage` | `/copilot/metrics/reports/*` |
| Enterprise Copilot > Policies page | AI Controls tab. Redirect fully removed, old bookmarks 404 |
| Microsoft Purview Copilot audit docs | GitHub enterprise audit log, `actor:Copilot`. Purview is M365 Copilot |
| `docs.github.com/en/copilot/reference/cheat-sheet` for VS Code UI | `code.visualstudio.com/docs/agents/reference/ai-features-cheat-sheet` |
| `/docs/copilot/customization/skills` | `/docs/agent-customization/agent-skills` |

## Where To Send Them Next

| Destination | Link |
|---|---|
| Copilot Fundamentals Part 1, 9 modules | learn.microsoft.com/training/paths/copilot/ |
| Copilot Fundamentals Part 2, 6 agentic modules | learn.microsoft.com/training/paths/gh-copilot-2/ |
| Get started with AI-assisted development | learn.microsoft.com/training/paths/accelerate-app-development-using-github-copilot/ |
| Building applications with agent mode | learn.microsoft.com/training/modules/github-copilot-agent-mode/ |
| Accelerate development with Cloud Agent | learn.microsoft.com/training/modules/github-copilot-code-agent/ |
| Introduction to MCP Server | learn.microsoft.com/training/modules/mcp-server/ |
| GH-300 study guide, Aug 7 2026 revision | learn.microsoft.com/credentials/certifications/resources/study-guides/gh-300 |
| VS Code AI features cheat sheet, authoritative | code.visualstudio.com/docs/agents/reference/ai-features-cheat-sheet |
| Copilot CLI docs | docs.github.com/copilot/concepts/agents/about-copilot-cli |
| Content exclusion reference | docs.github.com/copilot/how-tos/configure-content-exclusion/exclude-content-from-copilot |
| Microsoft Learn MCP server | learn.microsoft.com/api/mcp |
