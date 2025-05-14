# Setup Guide

## Prerequisites
- Git installed on your machine.
- Python 3.8+ and Node.js 14+ installed.
- A GitHub account.

## Steps
1. Clone the repository:
   ```bash
   git clone <repo-url>
   ```
2. Navigate to the project directory:
   ```bash
   cd copilot-dev-2
   ```
3. Install dependencies:
   - For Python:
     ```bash
     pip install -r requirements.txt
     ```
   - For Node.js:
     ```bash
     npm install
     ```
4. Run the application or scripts as needed.

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