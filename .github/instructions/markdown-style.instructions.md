---
applyTo: "**/*.md"
---

# Markdown Authoring Instructions

Course content in this repository is projected on screen during live training and read by
learners afterward. Formatting problems that are invisible in a rendered preview become
obvious on a projector, so treat these as hard requirements rather than preferences.

These rules align with `.markdownlint.json` at the repository root. When the two disagree,
`.markdownlint.json` wins because it is enforced mechanically.

## Spacing

- Insert a blank line between headings, paragraphs, lists, and code blocks.
- Add a blank line before and after every list, table, and fenced code block.
- Never leave two consecutive blank lines.

## Structure

- Use ATX headings (`##`), never Setext underlines.
- Do not skip heading levels. An `h2` is followed by an `h3`, not an `h4`.
- Exactly one `h1` per file, as the first line.

## Code blocks

- Always fence with triple backticks and declare a language (` ```powershell `, ` ```json `).
  The language tag drives syntax highlighting on the projector.
- Use `text` for terminal output that has no meaningful syntax.

## Links and accessibility

- Write descriptive link text. "See the [supported models reference](https://docs.github.com/en/copilot/reference/ai-models/supported-models)"
  beats "click [here](https://docs.github.com/en/copilot/reference/ai-models/supported-models)".
- Every image needs alt text describing its content, not its filename.
- Never rely on color alone to convey meaning. Pair it with a label, shape, or position,
  because a meaningful share of any audience cannot distinguish red from green.

## Date-sensitive content

GitHub Copilot ships changes weekly, so undated claims rot silently.

- Anchor version-specific claims to a date: "as of July 2026" or "GA February 25, 2026".
- Cite the primary source (`docs.github.com`, `github.blog/changelog`) for any model name,
  price, tier, or version number.
- Prefer "current as of <date>" over "latest", which is never true for long.
