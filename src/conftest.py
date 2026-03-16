"""Shared test fixtures and utilities."""
import pytest
from copilot_tips_server import reset_tips_store, get_tips_store


@pytest.fixture(autouse=True)
def reset_store_between_tests(request):
    """Reset the tips store before each test, unless it's a benchmark test."""
    # Skip reset for benchmark tests to avoid interference
    if 'benchmark' not in request.fixturenames:
        reset_tips_store()
        yield
        reset_tips_store()
    else:
        # For benchmark tests, ensure store is loaded but don't reset between iterations
        get_tips_store()
        yield


@pytest.fixture
def sample_tip():
    """Provide a sample tip for testing."""
    return {
        "id": "test-001",
        "title": "Test Tip",
        "description": "This is a test tip for unit testing",
        "category": "Prompting Techniques",
        "difficulty": "beginner",
        "impact": "medium"
    }


@pytest.fixture
def sample_tips_batch():
    """Provide multiple sample tips."""
    return [
        {
            "id": f"test-{i:03d}",
            "title": f"Test Tip {i}",
            "description": f"Description for tip {i}",
            "category": "Prompting Techniques",
            "difficulty": "beginner",
            "impact": "medium"
        }
        for i in range(1, 6)
    ]


@pytest.fixture
def clean_tips_store():
    """Ensure tips store is reset before and after test."""
    reset_tips_store()
    yield
    reset_tips_store()


@pytest.fixture
def empty_tips_store():
    """
    Provide empty tips store for testing edge cases.
    
    Note: This fixture directly accesses _tips_store since it's a module-level
    variable that's part of the server's public API for testing purposes.
    The backup/restore mechanism ensures test isolation.
    """
    from copilot_tips_server import _tips_store
    backup = _tips_store.copy()
    _tips_store.clear()
    yield
    # Restore backup to ensure test isolation
    _tips_store.clear()
    _tips_store.extend(backup)
