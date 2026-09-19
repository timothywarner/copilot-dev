function Get-RepositorySecurityEvents {
<#
.SYNOPSIS
    Fetches and displays recent security-relevant events from a GitHub repository.

.DESCRIPTION
    Queries the GitHub API for repository events (pushes, PRs, branch operations, etc.)
    and displays them in a formatted console table. Demonstrates:
    - Bearer token authentication from environment variables
    - Modern PowerShell error handling with ErrorRecord
    - Pipeline support for downstream processing

.PARAMETER Owner
    Repository owner (user or organization).

.PARAMETER Repo
    Repository name.

.EXAMPLE
    Get-RepositorySecurityEvents -Owner 'timothywarner' -Repo 'copilot-dev'

.EXAMPLE
    Get-RepositorySecurityEvents -Owner 'timothywarner' -Repo 'copilot-dev' -PassThru | Export-Csv events.csv -NoTypeInformation

.NOTES
    Reads PAT from GITHUB_API_KEY environment variable (system or user scope).
    Required scopes: repo (public_repo for public repos).
#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [string]$Owner,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [string]$Repo,

        [Parameter()]
        [switch]$PassThru
    )

    process {
        # --- Auth from environment variable ---
        $token = [System.Environment]::GetEnvironmentVariable('GITHUB_API_KEY', 'Machine')
        if ([string]::IsNullOrWhiteSpace($token)) {
            $token = $env:GITHUB_API_KEY
        }

        if ([string]::IsNullOrWhiteSpace($token)) {
            $errorRecord = [System.Management.Automation.ErrorRecord]::new(
                [System.Exception]::new('GITHUB_API_KEY not found in environment variables.'),
                'MissingToken',
                [System.Management.Automation.ErrorCategory]::AuthenticationError,
                $null
            )
            $PSCmdlet.ThrowTerminatingError($errorRecord)
        }

        $headers = @{
            'Authorization'        = "Bearer $token"
            'Accept'               = 'application/vnd.github+json'
            'X-GitHub-Api-Version' = '2022-11-28'
        }

        $url = "https://api.github.com/repos/$Owner/$Repo/events?per_page=30"

        try {
            $response = Invoke-RestMethod -Uri $url -Headers $headers -Method Get -ErrorAction Stop
        }
        catch {
            $errorRecord = [System.Management.Automation.ErrorRecord]::new(
                $_.Exception,
                'ApiCallFailed',
                [System.Management.Automation.ErrorCategory]::ConnectionError,
                $url
            )
            $PSCmdlet.ThrowTerminatingError($errorRecord)
        }

        # --- Filter for security-relevant events ---
        $events = @()

        foreach ($event in $response) {
            $actor = $event.actor.login
            $timestamp = $event.created_at
            $type = $event.type

            $description = switch ($type) {
                'PushEvent' {
                    $branch = $event.payload.ref -split '/' | Select-Object -Last 1
                    $commits = $event.payload.commits.Count
                    "Pushed $commits commit(s) to $branch"
                }
                'PullRequestEvent' {
                    $action = $event.payload.action
                    $title = $event.payload.pull_request.title
                    "$action PR: $title"
                }
                'DeleteEvent' {
                    "Deleted $($event.payload.ref_type): $($event.payload.ref)"
                }
                'CreateEvent' {
                    "Created $($event.payload.ref_type): $($event.payload.ref)"
                }
                'MemberEvent' {
                    "Added collaborator: $($event.payload.member.login)"
                }
                default {
                    $type
                }
            }

            $events += [PSCustomObject]@{
                Timestamp   = $timestamp
                Actor       = $actor
                EventType   = $type
                Description = $description
            }
        }

        # --- Display ---
        Write-Host "`n🔐 Security Events: $Owner/$Repo`n" -ForegroundColor Cyan

        if ($events.Count -eq 0) {
            Write-Host "No events found." -ForegroundColor Yellow
            return
        }

        $events | Format-Table -AutoSize `
            @{ Label = 'Time'; Expression = { $_.Timestamp } },
            @{ Label = 'Actor'; Expression = { $_.Actor }; Width = 20 },
            @{ Label = 'Event'; Expression = { $_.EventType }; Width = 18 },
            @{ Label = 'Description'; Expression = { $_.Description } }

        Write-Host "Total: $($events.Count) events`n" -ForegroundColor Gray

        if ($PassThru.IsPresent) {
            Write-Output $events
        }
    }
}

