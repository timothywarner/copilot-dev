#!/usr/bin/env pwsh
# Advisory markdownlint hook for Claude Code.
# Invoked as a PostToolUse hook on Edit|Write|MultiEdit. Reads the tool payload
# from stdin, lints the edited .md file against .markdownlint.json, and surfaces
# findings back to Claude as additionalContext (non-blocking).

$ErrorActionPreference = 'Stop'

try {
    $raw = [Console]::In.ReadToEnd()
    if (-not $raw) { exit 0 }

    $payload = $raw | ConvertFrom-Json
    $file = $payload.tool_input.file_path
    if (-not $file) { exit 0 }
    if ($file -notmatch '\.md$') { exit 0 }
    if (-not (Test-Path $file)) { exit 0 }

    $cwd = if ($payload.cwd) { $payload.cwd } else { (Get-Location).Path }
    $config = Join-Path $cwd '.markdownlint.json'
    if (-not (Test-Path $config)) { exit 0 }

    if (-not (Get-Command markdownlint -ErrorAction SilentlyContinue)) {
        Write-Error "markdownlint not on PATH; run 'npm install' in src/ or install markdownlint-cli globally."
        exit 0
    }

    $out = & markdownlint --config $config -- $file 2>&1
    if ($LASTEXITCODE -eq 0) { exit 0 }

    $body = ($out | Out-String).TrimEnd()
    $msg = "markdownlint findings for $file (advisory — fix when convenient):`n$body"

    @{
        hookSpecificOutput = @{
            hookEventName     = 'PostToolUse'
            additionalContext = $msg
        }
    } | ConvertTo-Json -Compress | Write-Output

    exit 0
}
catch {
    # Never break the user's workflow because of a hook failure.
    Write-Error "lint-markdown hook error: $($_.Exception.Message)"
    exit 0
}
