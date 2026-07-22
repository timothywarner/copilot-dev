# GitHub Copilot for Developers — Teaching Punchlist (July 2026)

**Delivery Date**: July 22, 2026
**Last Updated**: 2026-07-21
**Every date-sensitive claim below was verified against docs.github.com, github.blog, code.visualstudio.com, or modelcontextprotocol.io on 2026-07-21.**

## Course Structure

- **Duration**: 4 hours total
- **Segments**: 4 x ~55 minute segments
- **Breaks**: ~9 minute breaks between segments
- **Platform**: ON24 live training

> **Headline of this delivery**: the AI Credits cutover is **done**. It happened **June 1, 2026**, seven weeks ago. Last delivery you taught it as a forecast; today you teach it as the operating reality, and the interesting material is what people learned in the first two billing cycles. Lead with the arithmetic, not the announcement.

---

## PRE-CLASS CHECKLIST (5 minutes, do this before you go live)

This course ages faster than any other in the catalog. Three checks, every delivery.

1. **`npm view @github/copilot version`** — the CLI shipped three stable releases in six days before this delivery. Do not trust a version number baked into a slide.
2. **Open the plans page** at `https://docs.github.com/en/copilot/get-started/plans` and look for the Copilot Business sign-up pause banner. See the note in Segment 1; its status is genuinely ambiguous right now.
3. **Open the models and pricing table** at `https://docs.github.com/en/copilot/reference/copilot-billing/models-and-pricing`. Navigate to it live rather than reciting rates. The Claude Sonnet 5 promotional rate expires August 31, 2026, which is your on-camera reason for not memorizing the grid.

---

### Segment 1: Foundations & Core Workflow (60 min)

- Course goals and what changed since the last delivery
- **Billing opener — AI Credits are the operating model now (lead with this)**
  - Premium requests are **legacy**. Since **June 1, 2026** billing is usage-based on **GitHub AI Credits**
  - **1 AI credit = $0.01 USD** (verbatim on both usage-based billing pages)
  - Metered on **input, output, and cached tokens** at published per-model rates
  - **Code completions and Next Edit Suggestions are unlimited on paid plans and consume zero credits.** Credits are spent by chat, agent mode, code review, cloud agent, CLI, and Copilot Apps
  - **Copilot code review also consumes GitHub Actions minutes** on top of credits
  - **No rollover**: unused credits are forfeited and the allowance resets at 00:00:00 UTC on the first of each month
  - **Base vs flex**: base credits match the subscription price one-for-one and stay stable; the flex allotment "is designed to adapt as the economics of AI evolve"
  - Show the **Usage panel** live in VS Code and the CLI
- **Plans and credit allowances**

  | Plan | Price | Base credits | Flex | Total credits/month | $ value |
  |---|---|---|---|---|---|
  | Free | $0 | not published | not published | **not published** | not published |
  | Student | Free | not published | not published | **not published** | not published |
  | Pro | $10/mo | 1,000 | 500 | **1,500** | $15 |
  | Pro+ | $39/mo | 3,900 | 3,100 | **7,000** | $70 |
  | **Max** | **$100/mo** | 10,000 | 10,000 | **20,000** | $200 |
  | Business | $19/seat/mo | 1,900 | n/a | **1,900** | $19 |
  | Enterprise | $39/seat/mo | 3,900 | n/a | **3,900** | $39 |

  - **Copilot Max at $100/mo is new** since your last delivery. Slot it between Pro+ and enterprise plans
  - **Leave the Free and Student credit cells blank.** GitHub publishes no numeric figure. Free additionally includes **2,000 code completions per month**; Student includes **unlimited completions**. Saying "not published" is a stronger moment than guessing
  - **Teaching line**: "Base credits are matched one-to-one with your subscription price. Ten dollars buys a thousand credits of base. Everything above that is flex. That one sentence turns this table into arithmetic."
- **Promotional allowance active on delivery day**
  - Existing **Business** customers get **3,000** credits/user, existing **Enterprise** **7,000** credits/user, for the first three months of usage-based billing (**June 1 to September 1, 2026**)
  - Three things not to say: the **price did not change**; the last covered month is **August**, not September; it applies to **existing** customers only
  - Credits are **pooled at the billing entity level**, not locked per seat
- **Sign-up status — verify live, this is genuinely ambiguous**
  - The docs plans page still carries: "Starting April 22, 2026, new self-serve sign-ups for Copilot Business for organizations on GitHub Free and GitHub Team plans are temporarily paused"
  - But the originating changelog is now tagged **Retired** on github.blog, and no reopening post exists. Individual plan sign-ups reopened **June 17, 2026**; Business was not named in that announcement
  - **Say**: "Individual plans reopened June 17. Business still shows a pause banner. If you are following along without a paid seat, your path is Copilot Free, or Pro if you want to buy in." Do not promise a Business trial; none is documented
- VS Code setup
  - **VS Code 1.129.1** (released July 15, 2026) is current
  - Copilot Chat is **built in** — no separate extension install for chat
  - **Agent Host**: a dedicated process running agent harnesses including Copilot, Claude, and Codex; one session connects across multiple windows
- Code completions (inline suggestions, ghost text, multi-line) — free, unlimited on paid plans, zero credits
- Chat interface basics (`Ctrl+I` inline, sidebar chat)
- Chat participants (`@workspace`, `@terminal`, `@vscode`, `@github`)
  - For external systems reach for **`#` tool references from MCP servers** instead. The `@`-participant model from Extensions is gone
- Slash commands (`/explain`, `/fix`, `/tests`, `/doc`, `/new`, `/troubleshoot`)
- Context and file references (`#file`, `#selection`, `#changes`, `#codebase` semantic auto-managed index)
- Prompt engineering fundamentals: zero-shot, few-shot, chain-of-thought, role-based prompting, constraint specification
- Responsible AI foundations (hallucinations, bias, license exposure, security)

---

### Segment 2: Chat Power Features & Multi-File Operations (60 min)

- Chat modes (Ask vs Edit vs Agent)
- Copilot Edit mode for controlled multi-file refactoring
- Working sets and file context management
- Custom instructions — **three supported formats, know the precedence**
  - `.github/copilot-instructions.md` (repository-wide)
  - `.github/instructions/NAME.instructions.md` (path-scoped). Frontmatter: **`applyTo` is required** (glob); **`excludeAgent`** is optional and accepts `code-review` or `cloud-agent`
  - **`AGENTS.md`** anywhere in the repo, plus `CLAUDE.md` and `GEMINI.md` at root. **The nearest `AGENTS.md` in the directory tree wins**
  - **Precedence**: personal > repository > organization. All relevant sets are provided to Copilot, not just the winner
  - Demo `powershell.instructions.md` — `applyTo: "**/*.ps1,**/*.psm1"` scopes cleanly
  - **Live teaching moment**: this repo shipped an instructions file with **no frontmatter at all**, so it silently never applied. Missing `applyTo` fails quietly, which is the worst failure mode. Show the fix
- Prompt files (`.github/prompts/*.prompt.md`)
  - **`agent:` is the current field.** `mode:` is gone from the docs entirely, not merely deprecated
  - `agent:` accepts `ask`, `agent`, `plan`, **or a custom agent name**
  - Other keys: `description`, `name`, `argument-hint`, `model`, `tools`
  - Variables: `${input:varName}`, `${input:varName:placeholder}`, `${selection}`
- **Unified chat customization editor** — one pane for instructions, prompts, and agents
- **Model selection strategy under AI Credits**
  - **Auto model selection** is the paradigm now. Free and Student plans get **Auto only, with no manual picker**. Enterprises can set Auto as the org default via `model: auto` in `managed-settings.json`
  - The real question is no longer "which model" but **"when do I override Auto?"**
  - **OpenAI (GA)**: GPT-5 mini, GPT-5.3-Codex, GPT-5.4, GPT-5.4 mini, GPT-5.4 nano, GPT-5.5, **GPT-5.6 Sol / Terra / Luna**
  - **Anthropic (GA)**: **Claude Fable 5** (needs Business/Enterprise enablement), Haiku 4.5, Opus 4.5, 4.6, 4.7, **4.8**, Sonnet 4.5, 4.6, **Sonnet 5**. **Opus 4.8 fast mode is preview**
  - **Google**: Gemini 2.5 Pro (GA, retirement announced), Gemini 3 Flash (preview, retirement announced), Gemini 3.1 Pro (preview), **Gemini 3.5 Flash** (GA), **Gemini 3.6 Flash** (GA, added July 21, 2026)
  - **Other (GA)**: **MAI-Code-1-Flash** (Microsoft), **Raptor mini** (fine-tuned GPT-5 mini), **Kimi K2.7 Code** (Moonshot AI)
  - Several models support **1M-token context** and configurable reasoning levels
  - **Do not put per-model rates on a slide.** Navigate to the models-and-pricing page live
  - **Gone**: GPT-5.2, Claude Sonnet 4 (May 6), Opus 4.1 / GPT-5 / GPT-5-Codex (Feb 17), plus 20+ retirements since Oct 2025
- Debugging workflows (`/fix`, error explanation, iteration loops)
- Attaching files, images, and video to chat
- Next Edit Suggestions (NES) — predictive editing, long-distance NES, Tab to accept, **free and zero-credit**
- **Copilot Vision — GA July 1, 2026**
  - Images (JPEG, PNG, GIF, WebP) **and PDFs**
  - **All tiers including Free**, enabled by default, no admin configuration
  - Works in VS Code chat, github.com chat, and the CLI via image paths
  - Business/Enterprise attachments retained roughly 24 hours

---

### Segment 3: Agentic Features & Advanced Workflows (60 min)

> **Terminology reset for this segment.** GitHub renamed the async agent in April 2026: what you learned as **Copilot coding agent** is now **Copilot cloud agent**. Frame it as renamed, not wrong. And keep the distinction sharp: **agent mode runs in your IDE; cloud agent runs on GitHub's infrastructure.**

- Agent Mode in VS Code
  - **Plan mode**: structured implementation planning before execution
  - **Autopilot mode**: fully autonomous sessions, no per-step confirmation
  - **Sub-agent delegation**: Explore, Task, Code Review, Plan
  - Auto-approval rules for trusted tools
- **Copilot cloud agent** (formerly Copilot coding agent)
  - Assign an issue and it branches, commits, opens a pull request, and writes the description via GitHub Actions
  - Now broader than PR workflows: it researches, plans, and codes on a branch, and you decide whether that becomes a PR
  - Delegate from: the agents panel on github.com, GitHub Issues, VS Code, `@copilot` PR comments, scheduled workflows, and third-party tools (Azure Boards, JIRA, Linear, Slack, Teams)
  - Writing effective issues: the issue body **is** the prompt. A two-line ticket gets a two-line PR
  - Firewall endpoints by plan: Pro/Pro+ `api.individual.githubcopilot.com`, Business `api.business.githubcopilot.com`, Enterprise `api.enterprise.githubcopilot.com`
  - **Metrics API gotcha**: the old `used_copilot_coding_agent` field still works but is **deprecated August 1, 2026** — eleven days after this delivery. The new field is `used_copilot_cloud_agent`
- **Agent HQ, Agents tab, Mission Control — be precise, these do not share one status**
  - **Agent HQ** is GitHub's umbrella name for the agent platform. It appears only in blog vision posts; **GitHub assigns no GA or preview tier to that name**, and it does not appear on docs.github.com
  - **Agents tab**: shipped January 26, 2026, no preview or GA label; gated only on having cloud agent enabled
  - **Mission Control**: shipped October 2025. **The old docs URL now 404s — do not click through in a demo.** Navigate to `github.com/copilot/agents`
  - **Third-party coding agents (Claude, Codex)** are the piece explicitly labeled **public preview**
  - If asked whether Agent HQ is GA: "GitHub has never published a GA or preview label for that name. I check the docs, not the marketing post."
- **GitHub Copilot CLI**
  - **Package is `@github/copilot`**, not `@github/copilot-cli`. The repo slug is `github/copilot-cli`; they intentionally differ, and that mismatch trips people up
  - `npm install -g @github/copilot`; the binary is **`copilot`**
  - **Node.js 22+**; on Windows **PowerShell 6+**
  - Also installable via Homebrew, WinGet, or install script
  - **Check the version live** with `npm view @github/copilot version`. Three stable releases shipped in the six days before this class
  - Plan mode, autopilot mode, sub-agents, `&` prefix to delegate to the cloud agent in the background, Auto model routing, AI-credit session limits, built-in GitHub MCP server
  - **On `gh copilot`, be precise**: the old extension that ran `gh copilot suggest` was retired October 25, 2025. But `gh copilot` **still works** — it was repurposed as a launcher that installs and forwards to the new CLI. Do not say flatly "it is deprecated"; that is the half-right statement that gets you corrected live
- **Custom agents** (`.github/agents/*.agent.md`)
  - **`description` is the only required field**
  - Optional: `name`, `target` (`vscode` or `github-copilot`), `tools`, `model`, `disable-model-invocation`, `user-invocable`, `mcp-servers` and `metadata` (github.com only)
  - **`infer` is retired** — use `disable-model-invocation`
  - Body limit **30,000 characters**
  - **`argument-hint` and `handoffs` are VS Code only** and are ignored by the cloud agent on github.com
- **Agent Skills** (`.github/skills/<name>/SKILL.md`)
  - **Do not assign a maturity label.** GitHub's docs never call the feature preview or GA. What **is** labeled: `gh skill` CLI management is **public preview** (needs GitHub CLI 2.90.0+), and VS Code forked-context execution is **experimental**
  - Required frontmatter: **`name`** (max 64 chars, lowercase/numbers/hyphens, must match the parent directory) and **`description`** (1-1024 chars, non-empty)
  - Optional: `license`, `compatibility` (max 500 chars), `metadata`, `allowed-tools` (**marked experimental in the spec**)
  - Project locations: `.github/skills`, `.claude/skills`, `.agents/skills`. Personal: `~/.copilot/skills`, `~/.agents/skills`
  - Surfaces: cloud agent, code review, CLI, Copilot app, agent mode in VS Code and JetBrains
  - Invoke as `/skill-name`, and they auto-load when judged relevant — which is why **`description` is the highest-leverage line in the file**
  - **Open standard** (agentskills.io): the same SKILL.md works in Claude Code, Cursor, and Codex CLI
- **Model Context Protocol**
  - **Current finalized spec is `2025-11-25`**. The **`2026-07-28` revision is a release candidate that ships in seven days** — a nice credibility beat: "if you are watching this later, that number has already flipped"
  - Do **not** claim GitHub's MCP server targets a "2026-01-26 spec." No such version exists; the server publishes no targeted revision
  - Hosted GitHub MCP server: **`https://api.githubcopilot.com/mcp/`**. The npm package `@modelcontextprotocol/server-github` is **deprecated**
  - **MCP Apps landed in VS Code 1.109** (January 2026) — say VS Code, not Copilot generically. `ui://` scheme, sandboxed iframe. Limits: inline display only, and send-message fills the chat box but does **not** auto-send
  - MCP Registry in the VS Code extensions panel; enterprise allowlists (still **preview**)
- **Copilot Memory — public preview**
  - Two scopes: repository-level facts and user-level preferences
  - **On by default for individual plans; admin-gated for Business and Enterprise**
  - **The 28-day clock resets on successful use.** Say "removed if unused for 28 days," not "auto-expires after 28 days"
- **Copilot SDK — GA June 2, 2026**: the same agent runtime, in TypeScript, Python, Go, .NET, Rust, and Java. Worth a beat for a developer audience
- **Copilot app** — desktop client, GA to all plans July 7, 2026; parallel sessions on isolated git worktrees
- Testing workflows (`/tests`, fixtures, mocking, TDD) and migration scenarios

---

### Segment 4: Enterprise Features, Spaces & Governance (60 min)

- **Copilot Spaces** — GA since September 2025
  - Persistent context hubs: repos, code, PRs, issues, files, images, free text
  - Public (view-only, link-shared) and org-shared (admin/editor/viewer)
  - Reachable through the GitHub MCP server from the IDE
  - Use cases: onboarding, standards enforcement, architecture docs
- Organization-level custom instructions
- **Copilot Code Review**
  - Agentic tool calling with full project context; CodeQL and ESLint integration
  - Hand off findings to the **cloud agent** to turn "here is what is wrong" into "here is the PR that fixes it"
  - **Consumes GitHub Actions minutes** since June 1, 2026, on top of AI Credits. Scope with path filters on monorepos
- **Content exclusions — the governance gotcha, worth a full slide**
  - Verbatim from docs: "GitHub Copilot CLI, Copilot cloud agent, and Agent mode in Copilot Chat in IDEs, do not support content exclusion"
  - **Edit mode is also on that list**, not just Agent mode
  - The cloud agent page goes further: "Copilot will not ignore these files, and will be able to see and update them." **Not just read. Update.**
  - **Cite both pages** — neither alone supports the full list
  - Exclusions protect the **assistive** surfaces (inline completions, Ask-mode chat, and code review as of June 12, 2026), not the **autonomous** ones
  - Additional documented limits: symlinks and remote filesystems not covered, semantic leakage possible, and up to **30 minutes** propagation delay
  - Content exclusion on github.com and GitHub Mobile is **public preview**
- **Enterprise AI Controls / agent control plane — GA February 26, 2026**
  - AI Administrator role and workspace; enterprise custom roles
  - **Agent activity in audit logs**, including who the agent acted on behalf of, plus `agent_session.task` events
  - Custom agent standards with a one-click push rule to protect designated file paths
  - Enterprise agent policies via API
  - **`managed-settings.json` GA July 1, 2026**; MDM push of Copilot settings July 8; enterprise **OpenTelemetry export** for VS Code and CLI July 8
  - **MCP enterprise allowlists are still preview** — GitHub is redesigning them to scale across orgs
- **Copilot Metrics — GA February 27, 2026**
  - **Legacy metrics APIs were closed down January 29, 2026.** Verify `src/data/copilot-metrics-sample.json` against the current schema before demoing
  - **Repository-level metrics GA July 17, 2026**: `GET /enterprises/{enterprise}/copilot/metrics/reports/repos-1-day?day=YYYY-MM-DD` and the `/orgs/{org}/` equivalent
  - **AI credits consumed per user** added to the metrics API June 19, 2026
  - Team-level metrics (May 14), adoption cohorts (May 29), Copilot app in the API (July 17)
  - **Live demo**: `.\scripts\Get-CopilotMetricsReport.ps1 -Organization '<org>'` if a token is available; otherwise walk `docs/copilot-metrics-report-sample.md`
- **AI Credit governance exercise (replaces the May cost-modeling forecast)**
  - The forecast is over; now it is measurement. Pull credits-per-user, find the heaviest repos and models, set per-user budgets and cost centers
  - Cost centers with credit pooling (July 2), per-user budget controls (July 7), credit pools in the billing UI (July 20)
  - Overage bills at **published per-model token rates**, not a flat per-credit fee
- IDE expansion: JetBrains, Eclipse, Xcode, Visual Studio 2026
  - Visual Studio June update (July 14): refreshed Copilot Usage window for usage-based billing with real-time updates and proactive limit alerts; **C++ modernization agent GA**
- **GitHub Spark** (Pro+ and Enterprise) — natural language to full-stack app
- **GH-300 certification**
  - **Seven domains, weightings unchanged.** A revision takes effect **August 7, 2026** with only *Minor* changes in three sub-areas
  - The domain list genuinely contains both "Use GitHub Copilot features" and "GitHub Copilot features" at 25-30% each. **That is GitHub's own wording — do not "fix" it on screen**
  - ~65 questions, 100 minutes, passing 700, $99 USD, 2-year validity, Pearson VUE
  - Now covers Agent Mode, MCP, Plan Mode, sub-agents, Spaces, Spark, and Copilot CLI
  - Exam note: mostly GA features, but "may contain questions on Preview features if those features are commonly used"
- Staying current: changelog, blog, community discussions

---

## What Changed Since the May 2026 Delivery

| Date | Update | Details |
|------|--------|---------|
| **Jun 1** | **AI Credits cutover completed** | Premium requests now legacy. 1 credit = $0.01, token-metered. Completions and NES stay free. Code review also consumes Actions minutes. |
| Jun 1 - Sep 1 | **Business/Enterprise promo credits** | Existing customers get 3,000 (Business) and 7,000 (Enterprise) credits/user. Last covered month is August. |
| **Jun 2** | **Copilot SDK GA** | TypeScript, Python, Go, .NET, Rust, Java. Was technical preview in January. |
| Jun 12 | **Code review honors content exclusion** | The only agentic-adjacent surface where the exclusion gap closed. |
| Jun 17 | **Agent Finder GA** | Implements the Agentic Resource Discovery (ARD) spec via `ai-catalog.json`. All plans. |
| Jun 17 | **Individual plan sign-ups reopened** | Business was **not** named in this announcement. |
| Jun 19 | **AI credits per user in metrics API** | Per-user credit attribution. |
| **Jun 30** | **Claude Sonnet 5 GA** | Replaces Sonnet 4.6 as the efficient everyday choice. Opus 4.8 live; Fable 5 available with enablement. |
| **Jul 1** | **Copilot Vision GA** | Images **and PDFs**, all tiers including Free, on by default. |
| Jul 1 | **Browser tools GA in VS Code**; **Auto as enterprise default** | `model: auto` in `managed-settings.json`. `managed-settings.json` itself GA. |
| **Jul 7** | **Copilot app GA to all plans** | Desktop client, parallel sessions on isolated worktrees. |
| Jul 10 | **Agentic autofix** | Public preview; code scanning alert remediation. |
| **Jul 15** | **VS Code 1.129.1** | Agent Host process for Copilot/Claude/Codex harnesses; session-management tools; `!` terminal prefix. |
| Jul 17 | **Repository-level metrics GA** | Two new endpoints. Copilot app added to the usage metrics API. |
| **Jul 21** | **Gemini 3.6 Flash added** | Same day as this plan was written. |
| **Jul 28** | **MCP spec 2026-07-28 ships** | Release candidate since May 21. Seven days after this delivery. |
| **Aug 1** | **`used_copilot_coding_agent` deprecates** | Metrics API field. Eleven days out. |
| **Aug 7** | **GH-300 revision** | Minor changes in three sub-areas; weightings unchanged. |

---

## Cut From the Previous Delivery

Material that is now wrong. Do not teach these.

- **Copilot Extensions.** GitHub App-based Extensions were **disabled November 10, 2025**. The marketplace pitch (Perplexity, Docker, Sentry, Azure) is dead. **MCP servers replaced them**: build once, works across any compatible agent; tools invoked with `#` rather than `@`-participants.
- **Premium request multipliers** (the 7.5x / 27x table). Applies only to legacy annual subscribers who stayed on request-based billing. Not the current model.
- **"Coding agent"** as the primary term. Renamed to **cloud agent** in April 2026.
- **`gh copilot` as the agentic CLI.** Wrong tool. The agentic CLI is the standalone `copilot` binary from `@github/copilot`.
- **"Memory auto-expires after 28 days."** The timer **resets on successful use**.
- **Sonnet 4 / Opus 4.7 / GPT-5.5 as the headline lineup.** Superseded by Sonnet 5, Opus 4.8, and the GPT-5.6 family.
- **"Background Agent renamed to Copilot CLI Agent."** No primary source supports this. It is false.

---

## Teaching Notes

- **Lead with arithmetic, not announcement.** The cutover is old news; the credits table is the useful artifact. "Base credits match your price one-for-one" is the line that makes it click.
- **The credits-vs-dollars trap.** Pro+ includes **7,000 credits**, which is **$70 of value**. Those are different numbers for the same thing. Mixing them up is the easiest way to get corrected live.
- **Use the exclusion gap as the governance centerpiece.** "Exclusions protect the assistive surfaces, not the autonomous ones" reframes a dry compliance topic into a real risk, and GitHub's own docs say the cloud agent can **update** excluded files.
- **Say "not published" with confidence** for Free and Student credit figures. Blank cells beat guesses.
- **Version numbers are for checking, not memorizing.** Run `npm view @github/copilot version` on stage. It models the behavior you want them to adopt.
- **The MCP spec timing is a gift.** The `2026-07-28` revision ships one week from delivery. Naming that shows you are current to the week.
