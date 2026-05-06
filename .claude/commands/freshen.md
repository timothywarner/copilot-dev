---
description: Audit course materials for stale Copilot facts (models, prices, GA dates) against today's reality
---

You are auditing this teaching repo for date-sensitive Copilot content that may have drifted since the last delivery. Today's date and the live `README.md` / `COURSE_PLAN_MAY_*.md` define "current" — verify everything else against those plus official sources.

## Your task

1. **Scan** these files for date-sensitive facts (model names, prices, premium-request quotas, GA dates, feature names, deprecation lists):
   - `README.md`
   - The most recent `COURSE_PLAN_*.md` at the repo root
   - `CLAUDE.md`
   - `docs/COPILOT_AGENT_TUTORIAL.md`
   - `docs/COPILOT_CUSTOMIZATION_SAMPLES.md`
   - `docs/latest-github-news.md`
   - `docs/certification/*.md`
   - Any file under `.github/agents/` or `.github/instructions/` that names a specific model

2. **Cross-check** against authoritative sources using WebSearch and WebFetch:
   - https://docs.github.com/en/copilot/reference/ai-models/supported-models
   - https://docs.github.com/en/copilot/reference/copilot-billing/model-multipliers-for-annual-plans
   - https://github.blog/changelog/ (filter for entries since the last delivery)
   - https://github.com/github/copilot-cli/releases (latest CLI version)

3. **Report** findings as a single markdown table:

   | File | Line | Stale claim | Current reality | Suggested edit |
   |------|------|-------------|-----------------|----------------|

   Then a short "Headline since last delivery" summary (3-5 bullets) of what changed and what Tim should lead with on stage.

## Rules

- **Do not edit anything.** Report only. The user will decide which edits to apply.
- If you cannot verify a fact (web search inconclusive), mark it `UNVERIFIED` rather than guessing.
- Skip `archive/` — it is preserved historical material, not current.
- Skip the deliberately-deprecated demo file `.github/chatmodes/new-mode.chatmode.md` (kept for the rename teaching moment).
- Skip the intentional bug in `src/test-app.js` (line 87 — documented in its header).
- The `references/` and `docs/references/` files (Microsoft Style Guide, fictional companies) are not date-sensitive — skip them.

## Output length

Keep the table under 30 rows. If more drift exists, list the top 30 by impact (anything user-visible during a live demo wins over backmatter).
