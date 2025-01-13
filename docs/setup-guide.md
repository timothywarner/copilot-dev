# Environment Setup Guide

## Prerequisites
1. GitHub Account Setup
   - Create or use existing GitHub account
   - Enable GitHub Copilot subscription
   - Configure GitHub authentication

2. Visual Studio Code Installation
   - Download and install VS Code
   - Install GitHub Copilot extension
   - Install GitHub Copilot Chat extension
   - Configure VS Code settings for optimal Copilot use

3. Git Configuration
   - Install Git
   - Configure Git credentials
   - Basic Git commands review

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