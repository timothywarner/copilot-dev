# GitHub Copilot for Developers -- July 2026

> Presenter run sheet. Four ~55-minute segments with ~9-minute breaks. Facts verified against primary sources 2026-07-21.

---

## At a Glance

The arc: **Editor to Enterprise**. One verb per block: **Set it up, Steer it, Delegate it, Govern it.**

| Segment | Title | Subtitle | What You Cover |
|---------|-------|----------|----------------|
| **1** | **Foundations & Core Workflow** | Set it up | AI Credits, tiers, VS Code, completions, chat basics, prompting |
| **2** | **Chat Power Features** | Steer it | Ask/Edit/Agent, instructions, prompt files, model selection, NES, Vision |
| **3** | **Agentic Features** | Delegate it | Agent mode, cloud agent, CLI, custom agents, Skills, MCP, Memory |
| **4** | **Enterprise & Governance** | Govern it | Spaces, code review, exclusions, AI Controls, metrics, GH-300 |

> **Headline**: the AI Credits cutover is **done** (June 1, 2026). Last delivery taught it as a forecast. Today it is the operating model, and the useful material is what two billing cycles revealed.

---

## PRE-CLASS CHECKLIST (5 min)

- [ ] `npm view @github/copilot version` -- three releases shipped in the six days before this delivery
- [ ] Open [plans page](https://docs.github.com/en/copilot/get-started/plans) -- confirm whether the Copilot Business sign-up pause banner is still live
- [ ] Open [models and pricing](https://docs.github.com/en/copilot/reference/copilot-billing/models-and-pricing) -- navigate live, do not recite rates

---

## Segment 1: Foundations & Core Workflow (55 min)

> **Subtitle: Set it up.**

### NEED TO COVER (punchlist)

- [ ] **AI Credits are the billing model** -- since June 1, 2026. 1 credit = $0.01, token-metered. Premium requests are legacy.
- [ ] **Completions and NES are free** -- unlimited on paid plans, zero credits. Credits go to chat, agent mode, code review, cloud agent, CLI.
- [ ] **Tiers including Max** -- $100/mo tier is new. Free / Student / Pro / Pro+ / Max / Business / Enterprise.
- [ ] **Credits are counts, not dollars** -- Pro+ is 7,000 credits *worth* $70. Do not conflate these.
- [ ] **VS Code 1.129.x** -- Chat is built in; Agent Host runs Copilot, Claude, and Codex harnesses.
- [ ] **Chat basics**: `Ctrl+I` inline, sidebar, `@workspace` / `@terminal` / `@vscode` / `@github`, `/explain` `/fix` `/tests` `/doc` `/new` `/troubleshoot`.
- [ ] **Context references**: `#file`, `#selection`, `#changes`, `#codebase`.
- [ ] **Prompt engineering**: zero-shot, few-shot, chain-of-thought, role-based, constraint specification.
- [ ] **Responsible AI**: hallucinations, bias, license exposure, security.

### SHOW: AI Credits & Tiers (12 min)

Open the plans page live. Walk the table.

| Plan | Price | Base | Flex | Total credits/mo | $ value |
|------|-------|------|------|------------------|---------|
| Free | $0 | not published | not published | **not published** | -- |
| Student | Free | not published | not published | **not published** | -- |
| Pro | $10/mo | 1,000 | 500 | **1,500** | $15 |
| Pro+ | $39/mo | 3,900 | 3,100 | **7,000** | $70 |
| **Max** | **$100/mo** | 10,000 | 10,000 | **20,000** | $200 |
| Business | $19/seat | 1,900 | n/a | **1,900** | $19 |
| Enterprise | $39/seat | 3,900 | n/a | **3,900** | $39 |

**The line that makes it click**: "Base credits match your subscription price one-for-one. Ten dollars buys a thousand credits of base. Everything above that is flex."

- **No rollover.** Unused credits are forfeited; allowance resets 00:00:00 UTC on the 1st
- **Flex is designed to move**; base stays stable
- **Code review also consumes GitHub Actions minutes**
- **Promo, June 1 - Sep 1, 2026**: existing Business gets **3,000**, Enterprise **7,000** credits/user. Prices unchanged. Last covered month is **August**. Existing customers only
- Free includes 2,000 completions/mo; Student unlimited. **Say "not published" for their credit figures** -- blank beats a guess

> Sign-ups: individual plans reopened June 17. Business still shows a pause banner for orgs on GitHub Free/Team, but the originating changelog is tagged Retired. Verify live; do not promise a Business trial.

### SHOW: VS Code Setup (8 min)

1. Confirm version 1.129.x -- Chat is **built in**, no separate extension
2. Show the **Agent Host** process (Copilot, Claude, Codex harnesses; one session across windows)
3. Open the **Usage panel** -- credit burn in real time

### SHOW: Completions & Chat Basics (12 min)

1. Ghost text, multi-line, Tab to accept -- **free, zero credits**
2. `Ctrl+I` inline vs sidebar chat
3. Participants, then a slash command against real code
4. `#codebase` semantic index vs `#file`

> For external systems reach for **`#` tool references from MCP servers**. The `@`-participant model from Extensions is gone.

### SHOW: Prompt Engineering (10 min)

Same task, four framings, side by side: bare, role-based, constrained, few-shot. Let the quality delta make the argument.

### LAB 1 (10 min)

Students set up VS Code, accept a completion, run `/explain` on `src/server.js`, and open the Usage panel.

---

## Segment 2: Chat Power Features (55 min)

> **Subtitle: Steer it.**

### NEED TO COVER (punchlist)

- [ ] **Ask vs Edit vs Agent** -- and when each is wrong.
- [ ] **Three instruction formats**: `copilot-instructions.md`, path-scoped `*.instructions.md` (**`applyTo` required**, `excludeAgent` optional), and **`AGENTS.md`** (nearest in tree wins).
- [ ] **Precedence**: personal > repository > organization. All relevant sets are sent, not just the winner.
- [ ] **Prompt files use `agent:`** -- `mode:` is *gone from the docs*, not merely deprecated. Accepts `ask` / `agent` / `plan` / custom agent name.
- [ ] **Auto model selection is the paradigm** -- Free and Student get Auto only, no picker. The question is when to *override*.
- [ ] **Current roster** -- GPT-5.6 family, Opus 4.8, Sonnet 5, Gemini 3.6 Flash, MAI-Code-1-Flash, Kimi K2.7.
- [ ] **NES** -- predictive, free, zero credits.
- [ ] **Vision GA** (July 1) -- images **and PDFs**, all tiers including Free.
- [ ] **Lab 2 runs**: students write an instructions file and a prompt file.

### SHOW: Chat Modes (15 min)

One prompt, three modes, same repo:

| Mode | Scope | Use when |
|------|-------|----------|
| **Ask** | Read-only answer | You need understanding, not edits |
| **Edit** | You pick files, it edits | You know exactly what changes |
| **Agent** | It picks files, runs tools, iterates | The blast radius is unknown |

> Agent mode consumes more credits than Edit. Edit is more predictable. Reach for Agent when you cannot enumerate the files yourself.

### SHOW: Instructions & Prompt Files (15 min)

1. Open `.github/copilot-instructions.md` -- repo-wide baseline
2. Open `powershell.instructions.md` -- `applyTo: "**/*.ps1,**/*.psm1"` scopes cleanly
3. Open `AGENTS.md` -- nearest-in-tree wins; `CLAUDE.md` and `GEMINI.md` also honored
4. Open a `.prompt.md` -- `agent:`, `${input:varName}`, `argument-hint`
5. Show the **unified chat customization editor**

> **Live teaching moment**: this repo shipped an instructions file with **no frontmatter**, so it silently never applied. Missing `applyTo` fails quietly -- the worst failure mode. Show the fix.

### SHOW: Model Selection (10 min)

Open the [supported models reference](https://docs.github.com/en/copilot/reference/ai-models/supported-models). Do not recite; navigate.

| Provider | Models |
|----------|--------|
| OpenAI | GPT-5.6 Sol / Terra / Luna, 5.5, 5.4 (+mini/nano), 5.3-Codex, 5 mini |
| Anthropic | Opus 4.8 / 4.7 / 4.6 / 4.5, Sonnet 5 / 4.6 / 4.5, Haiku 4.5, Fable 5 |
| Google | Gemini 3.6 Flash, 3.5 Flash, 2.5 Pro |
| Other | MAI-Code-1-Flash, Raptor mini, Kimi K2.7 Code |

- **Preview**: Opus 4.8 fast mode, Gemini 3.1 Pro, Gemini 3 Flash. **Fable 5** needs Business/Enterprise enablement
- **Gone**: GPT-5.2, Sonnet 4 (May 6), Opus 4.1 / GPT-5 / GPT-5-Codex (Feb 17), 20+ since Oct 2025
- Several models support **1M context** and configurable reasoning

### SHOW: NES & Vision (5 min)

1. NES predicts the *next* edit location, not just the next token -- free
2. Drop a screenshot into chat, then a **PDF**. GA July 1, all tiers including Free

### LAB 2 (10 min)

Students author a path-scoped instructions file with a working `applyTo`, then a prompt file with `${input:}`.

---

## Segment 3: Agentic Features (55 min)

> **Subtitle: Delegate it.**

> **Terminology reset**: what you learned as **Copilot coding agent** is now **Copilot cloud agent** (renamed April 2026). **Agent mode runs in your IDE; cloud agent runs on GitHub's infrastructure.**

### NEED TO COVER (punchlist)

- [ ] **Agent mode**: Plan mode, Autopilot, sub-agents (Explore, Task, Code Review, Plan), auto-approval rules.
- [ ] **Cloud agent**: issue to PR, and it now researches and plans too, not just PRs.
- [ ] **CLI package is `@github/copilot`** -- NOT `@github/copilot-cli`. Binary is `copilot`. Node 22+, PowerShell 6+ on Windows.
- [ ] **`gh copilot` still works** but is a launcher now, not the agentic CLI. Do not say flatly "deprecated."
- [ ] **Custom agents**: only `description` is required. `infer` is retired -> `disable-model-invocation`. 30,000-char body cap.
- [ ] **Agent Skills**: `name` + `description` required. **Assign no maturity label** -- GitHub's docs give it none.
- [ ] **MCP**: current spec `2025-11-25`; `2026-07-28` ships in **one week**. Extensions are dead; MCP replaced them.
- [ ] **Memory is public preview** -- removed if *unused* 28 days; timer **resets on use**.
- [ ] **Lab 3 runs**: students assign an issue to the cloud agent.

### SHOW: Agent Mode & Sub-Agents (10 min)

1. Plan mode -- plan before execution
2. Autopilot -- no per-step confirmation
3. Sub-agent delegation: Explore, Task, Code Review, Plan
4. Auto-approval rules for trusted tools

### SHOW: Cloud Agent (12 min)

1. Assign an issue to Copilot -- it branches, commits, opens a PR
2. Leave a review comment; watch it iterate
3. Show the **Agents tab**

**The issue body IS the prompt.** A two-line ticket gets a two-line PR.

- Delegate from: agents panel, Issues, VS Code, `@copilot` PR comments, scheduled workflows, Azure Boards / JIRA / Linear / Slack / Teams
- Firewall endpoints by plan: Pro/Pro+ `api.individual.`, Business `api.business.`, Enterprise `api.enterprise.githubcopilot.com`
- **Metrics gotcha**: `used_copilot_coding_agent` deprecates **August 1** -- eleven days out. Use `used_copilot_cloud_agent`

> **Agent HQ** is an umbrella brand with **no published GA or preview tier**. The Agents tab shipped unlabeled. Only **third-party coding agents** (Claude, Codex) are explicitly public preview. Mission Control's old docs URL 404s -- navigate to `github.com/copilot/agents`.

### SHOW: Copilot CLI (10 min)

```bash
npm install -g @github/copilot   # NOT @github/copilot-cli
copilot                          # the binary
```

1. `npm view @github/copilot version` -- **teach the check, not the number**
2. Plan mode, then autopilot
3. `&` prefix to delegate to the cloud agent in the background

> The repo slug is `github/copilot-cli`; the package is `@github/copilot`. That mismatch trips people up. Requires **Node 22+**; **PowerShell 6+** on Windows.

### SHOW: Custom Agents & Skills (10 min)

1. Open `.github/agents/*.agent.md` -- `description` required; `target`, `tools`, `model`, `disable-model-invocation`, `user-invocable` optional
2. Open `.github/skills/<name>/SKILL.md` -- `name` (max 64, matches directory) + `description` (1-1024)
3. Invoke a skill as `/skill-name`

- **`argument-hint` and `handoffs` are VS Code only** -- ignored by the cloud agent
- **`description` is the highest-leverage line in a skill** -- it drives auto-loading
- Same SKILL.md works in Claude Code, Cursor, and Codex CLI (open standard)

### SHOW: MCP & Memory (8 min)

1. Open `.vscode/mcp.json` -- hosted server at `https://api.githubcopilot.com/mcp/`
2. Agent mode: "List my open GitHub issues"
3. MCP Registry in the extensions panel

- **`@modelcontextprotocol/server-github` is deprecated** -- use the hosted server
- Spec `2025-11-25` is current; **`2026-07-28` ships July 28** -- "if you are watching this later, that number already flipped"
- **MCP Apps** landed in **VS Code 1.109** -- say VS Code, not Copilot generically
- **Memory**: public preview, on by default for individual plans, **admin-gated for Business/Enterprise**

> Also worth naming: **Copilot SDK GA** (June 2) and the **Copilot app** (GA to all plans July 7).

### LAB 3 (5 min)

Students assign the `src/tip-lookup.js` bug (line 35) to the cloud agent and watch the PR open.

---

## Segment 4: Enterprise & Governance (55 min)

> **Subtitle: Govern it.**

### NEED TO COVER (punchlist)

- [ ] **Spaces** -- GA since Sep 2025; persistent context hubs.
- [ ] **Code review** -- agentic, CodeQL + ESLint, hands off to cloud agent, **burns Actions minutes**.
- [ ] **Content exclusion gap** -- the centerpiece. Exclusions protect assistive surfaces, not autonomous ones.
- [ ] **Enterprise AI Controls** GA; `managed-settings.json` GA July 1; **MCP allowlists still preview**.
- [ ] **Metrics** GA, repo-level GA July 17, credits-per-user in the API. **Legacy metrics APIs closed Jan 29.**
- [ ] **Credit governance** -- cost centers, pooling, per-user budgets.
- [ ] **GH-300** -- seven domains, weightings unchanged, revision effective Aug 7.
- [ ] **Lab 4 runs**: students browse enterprise policies and the metrics report.

### SHOW: Spaces & Code Review (10 min)

1. Build a Space: repos, PRs, issues, files, free text
2. Query it from the IDE via the GitHub MCP server
3. Copilot code review on a live PR, then hand off to the cloud agent for the fix

> Code review consumes **Actions minutes** since June 1. Scope with path filters on monorepos.

### SHOW: Content Exclusion -- The Gap (12 min)

Configure an exclusion, then show what ignores it.

| Surface | Honors exclusion? |
|---------|-------------------|
| Inline completions | Yes |
| Ask-mode chat | Yes |
| Copilot code review | Yes (since June 12, 2026) |
| **Agent mode** | **No** |
| **Edit mode** | **No** |
| **Copilot CLI** | **No** |
| **Cloud agent** | **No** |

Verbatim from docs: *"GitHub Copilot CLI, Copilot cloud agent, and Agent mode in Copilot Chat in IDEs, do not support content exclusion."*

The cloud agent page goes further: *"Copilot will not ignore these files, and will be able to see and update them."* **Not just read. Update.**

**The framing**: "Exclusions protect the assistive surfaces, not the autonomous ones."

- Cite **both** pages -- neither alone supports the full list
- Also: symlinks and remote filesystems not covered, semantic leakage possible, **30-minute** propagation delay
- Exclusion on github.com and Mobile is **public preview**

### SHOW: Enterprise AI Controls (10 min)

1. AI Administrator role and workspace
2. **Agent activity in audit logs** -- who the agent acted on behalf of, `agent_session.task` events
3. Custom agent standards; one-click push rule to protect file paths
4. `managed-settings.json` (GA July 1), MDM push, OpenTelemetry export

> **MCP enterprise allowlists are still preview.** GitHub is redesigning them to scale across orgs.

### SHOW: Metrics & Credit Governance (10 min)

```powershell
.\scripts\Get-CopilotMetricsReport.ps1 -Organization '<org>'
```

No token? Walk `docs/copilot-metrics-report-sample.md`.

- **Legacy metrics APIs closed down Jan 29, 2026** -- verify the sample against the current schema
- Repo-level metrics **GA July 17**; **AI credits per user** added June 19
- Cost centers with pooling (Jul 2), per-user budgets (Jul 7)
- The forecast era is over. This is measurement: find the heaviest repos and models, then set budgets

### SHOW: GH-300 (8 min)

- Seven domains, **weightings unchanged**; revision effective **Aug 7, 2026** (Minor changes only)
- ~65 questions, 100 min, passing 700, $99, 2-year validity, Pearson VUE
- Covers Agent Mode, MCP, Plan Mode, sub-agents, Spaces, Spark, CLI

> The blueprint genuinely lists both "Use GitHub Copilot features" and "GitHub Copilot features" at 25-30%. **That is GitHub's own wording -- do not "fix" it on screen.**

### LAB 4 (5 min)

Students browse org Copilot policies and read the metrics sample.

---

## Instructor Quick Reference

### Talking Points to Hit

- **"Base credits match your price one-for-one."** Turns the pricing table into arithmetic
- **"Credits are counts, not dollars."** Pro+ is 7,000 credits *worth* $70. Easiest way to get corrected live
- **"Exclusions protect the assistive surfaces, not the autonomous ones."** Segment 4's anchor
- **"Teach the check, not the number."** Run `npm view @github/copilot version` on stage
- **MCP spec `2026-07-28` ships in one week.** Being current to the week buys credibility

### Do Not Teach

| Dead material | Reality |
|---|---|
| Copilot Extensions | Disabled **Nov 10, 2025**. MCP replaced them |
| Premium request multipliers | Legacy; annual holdovers only |
| "Coding agent" | Renamed **cloud agent**, April 2026 |
| `gh copilot` as the agentic CLI | Wrong tool. It is a launcher now |
| "Memory auto-expires after 28 days" | Removed if **unused** 28 days; resets on use |
| Sonnet 4 / Opus 4.7 / GPT-5.5 as headline | Superseded by Sonnet 5, Opus 4.8, GPT-5.6 |
| "Background Agent renamed to Copilot CLI Agent" | **False.** No primary source |
| Knowledge Bases | Retired **Nov 1, 2025**. Use Spaces |

### Critical Dates

| Date | Event |
|------|-------|
| Nov 10, 2025 | Copilot Extensions disabled |
| Feb 25, 2026 | Copilot CLI GA |
| Feb 26-27, 2026 | Enterprise AI Controls GA; Metrics GA |
| Apr 2026 | Coding agent renamed **cloud agent** |
| **Jun 1, 2026** | **AI Credits cutover**; code review starts consuming Actions minutes |
| Jun 2, 2026 | Copilot SDK GA |
| Jun 12, 2026 | Code review honors content exclusion |
| Jun 17, 2026 | Agent Finder GA (ARD spec); individual sign-ups reopen |
| Jun 30, 2026 | Claude Sonnet 5 GA |
| Jul 1, 2026 | Vision GA; browser tools GA; `managed-settings.json` GA |
| Jul 7, 2026 | Copilot app GA to all plans |
| Jul 15, 2026 | VS Code 1.129.1 (Agent Host) |
| Jul 17, 2026 | Repository-level metrics GA |
| **Jul 28, 2026** | **MCP spec `2026-07-28` ships** |
| **Aug 1, 2026** | `used_copilot_coding_agent` deprecates |
| Aug 7, 2026 | GH-300 revision effective |
| Aug 31 / Sep 1, 2026 | Sonnet 5 promo rate ends / Business-Enterprise promo credits end |

### Demo Assets in This Repo

| Asset | Segment | Purpose |
|-------|---------|---------|
| `src/server.js` + `public/` | 1, 2 | Node tips browser; `npm start` |
| `src/tip-lookup.js` | 3 | **Intentional bug line 35** -- cloud agent target. Do not fix |
| `.github/instructions/*` | 2 | `applyTo` scoping, incl. the missing-frontmatter lesson |
| `.github/prompts/*` (9) | 2 | `agent:` field, `${input:}` syntax |
| `.github/agents/*` (4) | 3 | Model fallback arrays, tool scoping as trust boundary |
| `.github/skills/*` (3) | 3 | SKILL.md with supporting artifacts |
| `scripts/Get-CopilotMetricsReport.ps1` | 4 | Live metrics report |
| `docs/copilot-metrics-report-sample.md` | 4 | Offline metrics walkthrough |
