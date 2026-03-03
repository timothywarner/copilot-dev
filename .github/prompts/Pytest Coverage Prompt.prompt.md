---
agent: agent
model: Claude Sonnet 4
description: 'Analyze pytest coverage gaps and generate tests to reach 80%+ coverage'
argument-hint: 'Optionally specify a module name or test file to target (e.g., "copilot_tips_server")'
tools: ['read', 'edit', 'runCommand']
---

Your goal is to analyze the current pytest test coverage for this project and add tests to bring all modules to at least **80% line coverage** — the minimum standard for this codebase.

## Step 1: Run the coverage report

Run the annotated coverage report so we can see exactly which lines are uncovered:

```bash
# For the whole project
pytest --cov --cov-report=annotate:cov_annotate --cov-report=term-missing -v

# For a specific module (replace MODULE_NAME if provided)
pytest --cov=${input:module:copilot_tips_server} --cov-report=annotate:cov_annotate --cov-report=term-missing -v

# For a specific test file only
pytest ${input:testfile:tests/} --cov --cov-report=term-missing -v
```

## Step 2: Interpret the results

In the `cov_annotate/` directory, each source file has an annotated copy:

- Lines starting with `>` are **executed** (covered)
- Lines starting with `!` are **NOT covered** — these need tests
- Lines starting with `-` are excluded (comments, blanks)

In the terminal report, focus on the `Miss` column — those are the uncovered line numbers.

## Step 3: Generate missing tests

For each uncovered section, generate tests following these patterns:

### Basic test structure (pytest style)

```python
import pytest
from your_module import the_function_under_test


class TestFunctionName:
    """Tests for the_function_under_test."""

    def test_happy_path(self):
        """Verify normal operation with valid inputs."""
        result = the_function_under_test("valid_input")
        assert result == "expected_output"

    def test_edge_case_empty_input(self):
        """Verify behavior with empty/None input."""
        result = the_function_under_test("")
        assert result == ""  # or pytest.raises(ValueError)

    def test_error_condition(self):
        """Verify correct exception is raised for invalid input."""
        with pytest.raises(ValueError, match="meaningful message"):
            the_function_under_test(None)
```

### Fixtures — prefer fixtures over repetition

```python
@pytest.fixture
def sample_data():
    """Reusable test data for tip-related tests."""
    return {
        "id": "tip-001",
        "title": "Use Tab to accept",
        "category": "Shortcuts",
        "description": "Press Tab to accept an inline suggestion."
    }

def test_something_with_fixture(sample_data):
    result = process_tip(sample_data)
    assert result["id"] == "tip-001"
```

### Parametrize — test multiple cases concisely

```python
@pytest.mark.parametrize("category,expected_count", [
    ("Shortcuts", 5),
    ("Prompting", 10),
    ("Code Generation", 8),
    ("nonexistent", 0),
])
def test_filter_by_category(category, expected_count):
    """Verify tip counts per category match data file."""
    results = filter_tips_by_category(category)
    assert len(results) == expected_count
```

### Mocking external dependencies

```python
from unittest.mock import patch, MagicMock


def test_api_call_handles_network_error():
    """Verify graceful handling when external API is unavailable."""
    with patch("your_module.requests.get") as mock_get:
        mock_get.side_effect = ConnectionError("Network unreachable")
        with pytest.raises(RuntimeError, match="Could not reach"):
            call_external_api()


def test_file_read_uses_correct_path():
    """Verify data is loaded from the expected file location."""
    mock_data = '{"tips": []}'
    with patch("builtins.open", MagicMock(return_value=MagicMock(
        __enter__=MagicMock(return_value=MagicMock(read=MagicMock(return_value=mock_data))),
        __exit__=MagicMock(return_value=False)
    ))):
        result = load_tips_from_file()
        assert result == {"tips": []}
```

### Async tests (for FastMCP / async functions)

```python
import pytest


@pytest.mark.asyncio
async def test_async_tool_returns_results():
    """Verify async MCP tool returns correctly shaped data."""
    result = await search_tips("keyboard")
    assert isinstance(result, list)
    assert all("title" in tip for tip in result)


@pytest.mark.asyncio
async def test_async_tool_empty_query():
    """Verify empty query returns all tips or raises ValueError."""
    result = await search_tips("")
    assert len(result) > 0  # or assert raises
```

## Step 4: What makes a good assertion

Always assert the **meaningful outcome**, not just that the function ran:

```python
# WEAK — only proves the function didn't crash
assert result is not None

# STRONG — proves correctness
assert result["category"] == "Shortcuts"
assert len(result) == 5
assert "keyboard shortcut" in result["description"].lower()
assert result["id"].startswith("tip-")
```

## Step 5: Verify coverage improved

After adding tests, re-run to confirm improvement:

```bash
pytest --cov --cov-report=term-missing -v
```

Target output for each module:

- `TOTAL` line should show **80%+** coverage
- Ideally, critical business logic (search, filter, data loading) should be at **90%+**
- Generated code or boilerplate may be left at lower coverage

## Step 6: Run until green

Keep iterating — add tests, run coverage, check the annotated files for remaining `!` lines — until all modules meet the 80% threshold.

Now examine the current coverage report and tell me which files are below 80% so we can prioritize.
