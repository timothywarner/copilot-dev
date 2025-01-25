# Setup Guide

## Prerequisites
1. GitHub Account Setup
   * Create or login to your GitHub account
   * Enable GitHub Copilot subscription

2. IDE Installation
   * Install Visual Studio Code
   * Install GitHub Copilot extension
   * Configure Copilot settings

3. Git Configuration
   * Install Git
   * Configure basic Git settings
   * Clone this repository

4. Verify Installation
   * Test Copilot suggestions
   * Test Copilot Chat
   * Verify access to all features

## VS Code Configuration
### Required Extensions
- GitHub Copilot
- GitHub Copilot Chat
- GitHub Pull Requests and Issues (recommended)
- Git History (recommended)

### Recommended Settings
```json
{
    "github.copilot.enable": {
        "*": true,
        "plaintext": true,
        "markdown": true,
        "scminput": false
    },
    "github.copilot.editor.enableAutoCompletions": true
}
```

## Testing Your Setup
1. Create a new file
2. Type a comment describing what you want to do
3. Wait for Copilot suggestions
4. Accept or modify suggestions using:
   - Tab to accept
   - Alt+] or Alt+[ to cycle through suggestions
   - Ctrl+Enter to see all suggestions

## Troubleshooting
- Verify GitHub authentication
- Check Copilot subscription status
- Ensure VS Code is up to date
- Clear VS Code cache if needed 