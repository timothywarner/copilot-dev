# Copilot Tips MCP Server

A FastMCP server providing GitHub Copilot tips and tricks via the Model Context Protocol. Built for O'Reilly teaching demonstrations.

## Features

- 📚 **46 curated tips** across 6 categories (Prompting, Shortcuts, Code Gen, Chat, Context, Security)
- 🔍 **Resources** — List categories and stats
- 🛠️ **Tools** — Search, filter, random tips, delete/reset
- 💬 **Prompts** — Task suggestions, category exploration, learning paths
- 🎯 **Elicitations** — Interactive guided discovery with real MCP elicitations
- 🧪 **Comprehensive test suite** with 90%+ coverage (unit, integration, performance tests)

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
# Run all tests with coverage
pytest

# Run specific test types
pytest -m unit              # Unit tests only
pytest -m integration       # Integration tests only  
pytest -m performance       # Performance tests only

# Generate HTML coverage report
pytest --cov=copilot_tips_server --cov-report=html
# Open htmlcov/index.html to view coverage

# Run tests in parallel
pytest -n auto
```

See the [Testing](#testing) section below for more details.

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

1. Click **Run** to execute

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

```text
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

## Testing

### Running Tests

This project has comprehensive test coverage (90%+) with multiple test types:

```bash
# Run all tests with coverage
pytest

# Run with detailed coverage report
pytest --cov=copilot_tips_server --cov-report=html --cov-report=term-missing

# Run specific test types
pytest -m unit              # Fast, isolated unit tests
pytest -m integration       # Full server integration tests
pytest -m performance       # Performance/benchmark tests

# Run tests in parallel (faster)
pytest -n auto

# Run without coverage checks (faster for development)
pytest --no-cov

# Run specific test file
pytest test_edge_cases.py -v
```

### Test Organization

The test suite is organized into multiple files:

- **`test_copilot_tips_server.py`** — Core functionality tests (26 tests)
  - Data loading and store management
  - Resource endpoints (categories, stats)
  - Tool functions (search, random, delete, reset)
  - Server configuration

- **`test_edge_cases.py`** — Edge cases and error conditions (18 tests)
  - Empty/invalid inputs
  - Unicode and special characters
  - Concurrent access patterns
  - Security (SQL injection, regex handling)

- **`test_prompts.py`** — Prompt template tests (17 tests)
  - All three prompt templates (tip_suggestion, category_explorer, learning_path)
  - Input validation and edge cases

- **`test_async_functions.py`** — Async elicitation tests (9 tests)
  - Interactive tip finder with mocked user inputs
  - Guided random tip with various scenarios
  - Cancellation handling

- **`test_integration.py`** — Integration tests (9 tests)
  - Server startup and lifecycle
  - Process management
  - Data file validation

- **`test_performance.py`** — Performance/benchmark tests (10 tests)
  - Search operation speed
  - Concurrent access performance
  - Stress testing with 500+ rapid requests

### Test Markers

Tests are organized with pytest markers:

```bash
# Unit tests - fast, isolated
pytest -m unit

# Integration tests - slower, test full server
pytest -m integration

# Performance tests - benchmark operations
pytest -m performance

# Slow tests - take extra time
pytest -m slow
```

### Coverage Goals

- **Target:** 90%+ code coverage
- **Current:** 97% coverage achieved
- **Check coverage:** After running tests, open `htmlcov/index.html` in your browser

### Continuous Integration

Tests run automatically on every push via GitHub Actions:
- Matrix testing across Python 3.10, 3.11, and 3.12
- Unit tests, integration tests, and coverage reporting
- Coverage artifacts uploaded for Python 3.12

View workflow: `.github/workflows/test-mcp-server.yml`

### Test Fixtures

Reusable test fixtures are available in `conftest.py`:

- `sample_tip` — Single test tip
- `sample_tips_batch` — Multiple test tips
- `clean_tips_store` — Reset store before/after test
- `empty_tips_store` — Empty store for edge case testing

### Test Utilities

Helper functions in `test_utils.py`:

- `assert_valid_tip(tip)` — Validate tip structure
- `assert_success_response(response)` — Check success response
- `assert_error_response(response, msg)` — Check error response
- `create_test_tip(id, **overrides)` — Create test tip data

## Architecture

```text
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
