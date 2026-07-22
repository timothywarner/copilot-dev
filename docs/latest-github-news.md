# GitHub Copilot News — July 2026

**Last updated**: 2026-07-21
**Maintenance**: this file is now maintained **by hand**. The former `copilot-news-fetcher.yml` workflow depended on a third-party API key and last ran in March 2026. Every claim below was verified against a primary source on the date above.

---

## Headline: AI Credits are the billing model

The cutover completed **June 1, 2026**. Premium requests are legacy.

- **1 AI credit = $0.01 USD**, metered on input, output, and cached tokens at published per-model rates
- **Code completions and Next Edit Suggestions are unlimited on paid plans and consume zero credits**
- Credits are spent by chat, agent mode, code review, cloud agent, CLI, and Copilot Apps
- **Copilot code review also consumes GitHub Actions minutes**
- **No rollover.** Unused credits are forfeited and the allowance resets at 00:00:00 UTC on the first of each month
- Base credits match the subscription price one-for-one; the flex allotment sits on top and is expected to change as AI economics change

Sources: [usage-based billing for individuals](https://docs.github.com/en/copilot/concepts/billing/usage-based-billing-for-individuals), [for organizations and enterprises](https://docs.github.com/en/copilot/concepts/billing/usage-based-billing-for-organizations-and-enterprises), [changelog](https://github.blog/changelog/2026-06-01-updates-to-github-copilot-billing-and-plans/)

### Plans and credit allowances

| Plan | Price | Base | Flex | Total credits/mo | $ value |
|------|-------|------|------|------------------|---------|
| Free | $0 | not published | not published | not published | not published |
| Student | Free | not published | not published | not published | not published |
| Pro | $10/mo | 1,000 | 500 | **1,500** | $15 |
| Pro+ | $39/mo | 3,900 | 3,100 | **7,000** | $70 |
| **Max** | **$100/mo** | 10,000 | 10,000 | **20,000** | $200 |
| Business | $19/seat/mo | 1,900 | n/a | **1,900** | $19 |
| Enterprise | $39/seat/mo | 3,900 | n/a | **3,900** | $39 |

**Copilot Max is a new tier.** GitHub publishes no numeric credit figure for Free or Student; Free includes 2,000 code completions per month and Student includes unlimited completions.

**Promotion, June 1 to September 1, 2026**: existing Business customers receive **3,000** credits per user and existing Enterprise customers **7,000**. Seat prices did not change. The last covered month is **August**. Existing customers only.

Per-model token rates: [models and pricing](https://docs.github.com/en/copilot/reference/copilot-billing/models-and-pricing). The Claude Sonnet 5 promotional rate expires August 31, 2026.

---

## Model roster (July 2026)

| Provider | Models | Notes |
|----------|--------|-------|
| OpenAI | GPT-5.6 Sol / Terra / Luna, GPT-5.5, GPT-5.4 (+ mini, nano), GPT-5.3-Codex, GPT-5 mini | All GA |
| Anthropic | Opus 4.8, 4.7, 4.6, 4.5; Sonnet 5, 4.6, 4.5; Haiku 4.5; Fable 5 | GA. Opus 4.8 fast mode is preview. Fable 5 needs Business/Enterprise enablement |
| Google | Gemini 3.6 Flash, 3.5 Flash, 2.5 Pro | GA. 3.1 Pro and 3 Flash are preview. 2.5 Pro and 3 Flash have retirement announced |
| Microsoft | MAI-Code-1-Flash | GA |
| Other | Raptor mini, Kimi K2.7 Code (Moonshot AI) | GA |

**Auto model selection** picks per request unless pinned. **Free and Student plans get Auto only, with no manual picker.** Enterprises can set Auto as the org default via `model: auto` in `managed-settings.json`.

**Retired**: GPT-5.2, Claude Sonnet 4 (May 6, 2026), Claude Opus 4.1 / GPT-5 / GPT-5-Codex (Feb 17, 2026), plus 20+ models since October 2025.

Source: [supported AI models](https://docs.github.com/en/copilot/reference/ai-models/supported-models)

---

## What shipped since the last delivery

| Date | Update |
|------|--------|
| Jun 1 | **AI Credits cutover completed.** Code review begins consuming Actions minutes |
| Jun 2 | **Copilot SDK GA** — TypeScript, Python, Go, .NET, Rust, Java |
| Jun 12 | Copilot code review now respects content exclusion |
| Jun 17 | **Agent Finder GA** — implements the Agentic Resource Discovery (ARD) spec via `ai-catalog.json` |
| Jun 17 | Individual plan sign-ups reopened |
| Jun 19 | AI credits consumed per user added to the usage metrics API |
| Jun 30 | **Claude Sonnet 5 GA**; Opus 4.8 in the picker |
| Jul 1 | **Copilot Vision GA** — images and **PDFs**, all tiers including Free, on by default |
| Jul 1 | Browser tools GA in VS Code; `managed-settings.json` GA; Auto as enterprise default |
| Jul 7 | **Copilot app GA to all plans** — parallel sessions on isolated git worktrees |
| Jul 8 | MDM push of Copilot settings; enterprise OpenTelemetry export for VS Code and CLI |
| Jul 10 | Agentic autofix (public preview) for code scanning alerts |
| Jul 15 | **VS Code 1.129.1** — Agent Host process, session-management tools, `!` terminal prefix |
| Jul 17 | **Repository-level usage metrics GA**; Copilot app added to the metrics API |
| Jul 21 | Gemini 3.6 Flash added |

### Coming up

| Date | Event |
|------|-------|
| Jul 28 | **MCP spec `2026-07-28` ships** (release candidate since May 21) |
| Aug 1 | `used_copilot_coding_agent` metrics field deprecates; use `used_copilot_cloud_agent` |
| Aug 7 | GH-300 revision takes effect (Minor changes, weightings unchanged) |
| Aug 31 | Claude Sonnet 5 promotional token rate expires |
| Sep 1 | Business/Enterprise promotional credits end |

---

## Terminology and corrections

- **Copilot cloud agent**, not "coding agent". Renamed April 2026. It is no longer limited to pull request workflows: it researches, plans, and writes code on a branch. **Cloud agent runs on GitHub's infrastructure; agent mode runs in your IDE.**
- **Copilot Extensions are gone.** GitHub App-based Extensions were disabled **November 10, 2025**. MCP servers replaced them: tools are invoked with `#` rather than `@`-participants, and can be called autonomously by agent mode and the cloud agent.
- **The CLI package is `@github/copilot`**, not `@github/copilot-cli`. Install with `npm install -g @github/copilot`; the binary is `copilot`. Requires **Node 22+** and, on Windows, **PowerShell 6+**. The repo slug is `github/copilot-cli`, which intentionally differs from the package name.
- **`gh copilot` still works**, but it is not the agentic CLI. The old `gh copilot suggest` extension retired October 25, 2025; the command was repurposed as a launcher that installs and forwards to the new CLI. Avoid saying flatly that it is deprecated.
- **Copilot Memory is public preview.** Entries are removed after **28 days without use**, and the timer **resets each time Copilot successfully uses one**. On by default for individual plans; admin-gated for Business and Enterprise.
- **Agent Skills carry no maturity label.** GitHub's docs never call the feature GA or preview. The `gh skill` CLI surface *is* labeled public preview.
- **Agent HQ has no published status tier.** The Agents tab shipped January 2026 with no label; third-party coding agents (Claude, Codex) are the piece explicitly in public preview. The old Mission Control docs URL now 404s — navigate to `github.com/copilot/agents`.

---

## Governance note: the content exclusion gap

Content exclusions protect the **assistive** surfaces, not the **autonomous** ones.

Verbatim from [GitHub Docs](https://docs.github.com/en/copilot/how-tos/configure-content-exclusion/exclude-content-from-copilot): "GitHub Copilot CLI, Copilot cloud agent, and Agent mode in Copilot Chat in IDEs, do not support content exclusion." [Edit mode is also excluded](https://docs.github.com/en/copilot/concepts/context/content-exclusion).

The [cloud agent page](https://docs.github.com/en/copilot/concepts/agents/cloud-agent/about-cloud-agent) goes further: "Copilot will not ignore these files, and will be able to see and update them." Not just read. Update.

Additional documented limits: symlinks and remote filesystems are not covered, semantic information can leak indirectly, and changes take up to **30 minutes** to propagate. Content exclusion on github.com and GitHub Mobile is public preview.

---

## MCP status

- **Current finalized spec: `2025-11-25`.** The **`2026-07-28`** revision has been a release candidate since May 21 and publishes July 28, 2026
- Hosted GitHub MCP server: **`https://api.githubcopilot.com/mcp/`**. The npm package `@modelcontextprotocol/server-github` is **deprecated**
- **MCP Apps landed in VS Code 1.109** (January 2026) via the `ui://` scheme in a sandboxed iframe. Inline display only; send-message fills the chat box but does not auto-send
- Enterprise MCP allowlists remain **preview**; GitHub is redesigning them to scale across organizations
- GitHub's MCP server does not publish a targeted protocol revision in its docs
