---
agent: ask
model: Claude Sonnet 4
description: 'Write a complete Architecture Decision Record (ADR) in standard MADR format'
argument-hint: 'Describe the decision you need to document (e.g., "choosing between SQLite and PostgreSQL for local dev")'
---

Help me write a complete Architecture Decision Record (ADR) for the following decision:

**Decision context:** `${input:decisionContext:Describe the architectural decision you need to document}`

---

## What is an ADR?

An Architecture Decision Record captures an important architectural or technical decision — what was decided, why, and what the consequences are. ADRs are written once and never deleted (only superseded). They create an immutable audit trail of *why* the codebase looks the way it does.

Good ADRs are:

- Written at the time of the decision, not months later
- Concise (300-800 words is typical)
- Opinionated — they record the actual decision made, not just options
- Explicit about trade-offs, not just selling the chosen option

---

## ADR template (MADR format)

I'll produce the ADR in the following format. Fill in any context or constraints you have, and I'll complete the rest:

````markdown
# ADR-[NUMBER]: [Short descriptive title]

**Status:** Proposed | Accepted | Deprecated | Superseded by ADR-[N]
**Date:** YYYY-MM-DD
**Deciders:** [names or roles of people involved]
**Tags:** [backend, frontend, infrastructure, testing, security, data, etc.]

---

## Context and Problem Statement

[1-3 paragraphs describing:
- The situation that requires a decision
- The forces at play (technical constraints, team size, performance needs, cost)
- Why "doing nothing" is not an option]

## Decision Drivers

- [Driver 1 — e.g., "must run locally without a network connection"]
- [Driver 2 — e.g., "team has existing expertise in X"]
- [Driver 3 — e.g., "must support 10k concurrent users within 6 months"]

## Considered Options

- **Option A: [Name]** — [one-line description]
- **Option B: [Name]** — [one-line description]
- **Option C: [Name]** — [one-line description]

## Decision Outcome

**Chosen option:** "[Option Name]"

**Rationale:** [1-2 sentences explaining why this option best satisfies the decision drivers above]

### Positive Consequences

- [Benefit 1]
- [Benefit 2]
- [Benefit 3]

### Negative Consequences and Trade-offs

- [Trade-off 1 — what we're giving up or accepting]
- [Trade-off 2]
- [Mitigation: how we address this trade-off if applicable]

---

## Options Analysis

### Option A: [Name]

**Description:** [What this option entails]

**Pros:**
- [Pro 1]
- [Pro 2]

**Cons:**
- [Con 1]
- [Con 2]

**Why not chosen:** [Specific reason this was rejected]

---

### Option B: [Name]

**Description:** [What this option entails]

**Pros:**
- [Pro 1]
- [Pro 2]

**Cons:**
- [Con 1]
- [Con 2]

**Why not chosen:** [Specific reason this was rejected]

---

### Option C: [Name] ← CHOSEN

**Description:** [What this option entails]

**Pros:**
- [Pro 1]
- [Pro 2]

**Cons / accepted trade-offs:**
- [Con 1]
- [Con 2]

---

## Implementation Notes

[Optional: specific implementation details, commands, or configuration that capture HOW the decision is realized]

```bash
# Example: if the decision is to use uv for Python package management
uv venv && uv pip install -e ".[dev]"
```

## Links and References

- [Link to relevant documentation, RFC, or discussion thread]
- [Link to proof-of-concept or benchmark]
- Supersedes: ADR-[N] (if this replaces a previous decision)
- Related: ADR-[N] (if related to another decision)

````

---

## What I need to write your ADR

To produce the best ADR, share as much as you know:

1. **What decision are you making?** (e.g., "which database to use", "monorepo vs. multi-repo", "REST vs. GraphQL")
2. **What options did you consider?** (even if you've already decided)
3. **What constraints must the decision satisfy?** (team size, budget, performance, existing stack, deadline)
4. **What did you decide?** (or are you still exploring?)
5. **Who was involved?** (engineering, product, ops, security?)
6. **What are the known trade-offs?** (what are you giving up by choosing this option?)

---

## File naming convention for ADRs

Save this file as: `docs/adr/ADR-[three-digit-number]-[kebab-case-title].md`

Examples:

- `docs/adr/ADR-001-use-fastmcp-for-mcp-server.md`
- `docs/adr/ADR-002-sqlite-for-local-development.md`
- `docs/adr/ADR-003-github-actions-for-ci.md`

If this supersedes an existing ADR, update the old ADR's status to:

```markdown
**Status:** Superseded by [ADR-NEW-NUMBER](./ADR-NEW-NUMBER-title.md)
```

---

Describe the decision you need to document and I'll produce a complete, ready-to-commit ADR.
