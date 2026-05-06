# Scripts

Helper scripts for course delivery and demos.

## `Get-CopilotMetricsReport.ps1`

PowerShell script that pulls live data from the GitHub Copilot Metrics API for an organization, then prints a summary report.

Used live in **Segment 4 (Enterprise & Governance)** to demonstrate ROI measurement. The static sample at `src/data/copilot-metrics-sample.json` is what to show when no org token is available; an annotated walkthrough of a real run lives at `docs/copilot-metrics-report-sample.md`.

### Quick usage

```powershell
# Reads token from -Token, $env:GITHUB_TOKEN, $env:GH_TOKEN, or `gh auth token` (in that order)
.\scripts\Get-CopilotMetricsReport.ps1 -Organization 'your-org'

# 14-day window, include raw rows
.\scripts\Get-CopilotMetricsReport.ps1 -Organization 'your-org' -Days 14 -IncludeRaw
```

### Required permissions

- Token scope: `read:org` plus Copilot metrics access in the target org
- Falls back automatically from the legacy `/copilot/metrics` endpoint to the GA `organization-28-day` report endpoint

### Output

Active users, engagement rate, suggestion/line acceptance rate, IDE chat counts, and an estimated time-saved heuristic (acceptances × minutes-per-acceptance + accepted lines × minutes-per-line).

Demonstrates the **`Copilot Metrics GA` (Feb 27, 2026)** capability and serves as a concrete example for the **PowerShell custom instructions** at `.github/instructions/powershell.instructions.md`.

### Sample output

See `docs/copilot-metrics-report-sample.md` for an annotated 28-day report from a real org run (April 2026). Use it as the slide-deck reference when no live token is available during delivery.
