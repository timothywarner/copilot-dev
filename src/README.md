# Copilot Tips MCP Server

A FastMCP server providing GitHub Copilot tips and tricks via the Model Context Protocol. Built for O'Reilly teaching demonstrations.

## Features

- 📚 **46 curated tips** across 6 categories (Prompting, Shortcuts, Code Gen, Chat, Context, Security)
- 🔍 **Resources** — List categories and stats
- 🛠️ **Tools** — Search, filter, random tips, delete/reset
- 💬 **Prompts** — Task suggestions, category exploration, learning paths
- 🎯 **Elicitations** — Interactive guided discovery with real MCP elicitations
- 🧪 **26 unit tests** with pytest

## Quick Start

### 1. Setup Environment

```powershell
# Windows (PowerShell 7+)
cd src
pwsh .\setup.ps1
```

```bash
# macOS/Linux
cd src
chmod +x setup.sh
./setup.sh
```

This creates a `.venv` virtual environment and installs dependencies.

### 2. Run the Server

```bash
python copilot_tips_server.py
```

The server runs via stdio transport (standard MCP protocol).


### 3. Test with MCP Inspector

The MCP Inspector provides a web UI for testing your server interactively:

```bash
python start_inspector.py
```

**Note for Windows users:**
If you are running commands from outside the `src` directory, or if your project is not located at `C:\github\copilot-dev\src`, you may need to adjust the path to match your local setup. For example, if your project is in a different folder, navigate to that directory first:

```powershell
cd path\to\your\copilot-dev\src
python start_inspector.py
```

This will:
- ✅ Check for Node.js 18+ (shows version)
- ✅ Verify the port is actually available before using it
- ✅ Validate server script and Python executable exist
- 🚀 Launch the inspector web UI
- 🔗 Connect to your MCP server automatically

Open the URL shown in the terminal (e.g., `http://localhost:52341`).

### 4. Run Tests

```bash
pytest test_copilot_tips_server.py -v
```

All 26 tests should pass.

## Using the Inspector

### Testing Resources

1. Click **Resources** tab
2. Click `tips://categories` to see all tip categories
3. Click `tips://stats` to see tip counts by category and difficulty

### Testing Tools

1. Click **Tools** tab
2. Select a tool and fill in parameters:

| Tool | Parameters | Description |
|------|------------|-------------|
| `get_tip_by_id` | `tip_id`: e.g., `prompt-001` | Get specific tip |
| `get_tip_by_topic` | `search_term`: e.g., `chat` | Search tips |
| `get_random_tip` | `category`, `difficulty` (optional) | Random tip |
| `delete_tip` | `tip_id` | Delete tip (in-memory) |
| `reset_tips` | (none) | Restore deleted tips |
| `interactive_tip_finder` | (uses elicitation) | Guided tip discovery |
| `guided_random_tip` | (uses elicitation) | Random tip with prompts |

3. Click **Run** to execute

**Note**: The `interactive_tip_finder` and `guided_random_tip` tools use MCP elicitations to prompt you for input. These require client support for elicitations.

### Testing Prompts

1. Click **Prompts** tab
2. Select a prompt template:
   - `tip_suggestion` — Get tips for a specific task
   - `category_explorer` — Deep dive into a category
   - `learning_path` — Personalized learning plan

## VS Code Integration

The server is pre-configured for VS Code:

- **Debug**: Press `F5` and select "🚀 Run MCP Server"
- **Tasks**: `Ctrl+Shift+P` → "Tasks: Run Task" → choose setup/run tasks
- **MCP Client**: The `.vscode/mcp.json` configures the server for Copilot Chat

### Auto-Activate Virtual Environment

VS Code automatically activates the venv in new terminals. If not working:
1. `Ctrl+Shift+P` → "Python: Select Interpreter"
2. Choose `src/.venv/Scripts/python.exe`
3. Reload window

## Project Structure

```
src/
├── copilot_tips_server.py      # Main FastMCP server (resources, tools, prompts)
├── test_copilot_tips_server.py # Pytest test suite (26 tests)
├── start_inspector.py          # Robust inspector launcher
├── setup.ps1                   # Windows setup script (pwsh)
├── setup.sh                    # Unix setup script
├── pyproject.toml              # Python project config
├── README.md                   # This file
└── data/
    └── copilot_tips.json       # Tips database (46 tips, 6 categories)
```

## Data Format

Tips are stored in `data/copilot_tips.json`:

```json
{
  "tips": [
    {
      "id": "prompt-001",
      "title": "Provide Top-Level Comments",
      "description": "Add a high-level comment...",
      "category": "Prompting Techniques",
      "difficulty": "beginner"
    }
  ]
}
```

**Categories**: Prompting Techniques, IDE Shortcuts, Code Generation, Chat Features, Workspace Context, Security & Privacy

**Difficulty levels**: beginner, intermediate, advanced

## Troubleshooting

### "Node.js/npx not found"
Install Node.js 18+ from https://nodejs.org/ and restart your terminal. The inspector shows detailed error messages if npx isn't working.

### Import errors in VS Code
The Python extension may not detect the venv. Select the interpreter manually or reload the window.

### "Port already in use"
The inspector now verifies port availability before use. If issues persist, close other inspector instances or processes using ports in the 49152-65535 range.

### Inspector exits immediately
Check the terminal output for error details. Common issues:
- Server script not found (verify `copilot_tips_server.py` exists)
- Python venv not created (run `setup.ps1` or `setup.sh`)
- Node.js version too old (need 18+)

## Requirements

- Python 3.10+
- Node.js 18+ (for MCP Inspector)
- PowerShell 7+ (Windows) or Bash (Unix)

## Architecture

```
┌─────────────────┐     stdio      ┌──────────────────────┐
│  MCP Inspector  │◄──────────────►│  copilot_tips_server │
│  (Web UI)       │                │  (FastMCP/Python)    │
└─────────────────┘                └──────────┬───────────┘
                                              │
                                              ▼
                                   ┌──────────────────────┐
                                   │  data/copilot_tips   │
                                   │  .json (46 tips)     │
                                   └──────────────────────┘
```

## License

MIT
