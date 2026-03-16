"""Utilities for testing."""
from typing import Any, Dict


def assert_valid_tip(tip: Dict[str, Any]) -> None:
    """Assert that a tip has all required fields."""
    required_fields = ["id", "title", "description", "category", "difficulty", "impact"]
    for field in required_fields:
        assert field in tip, f"Missing field: {field}"
        assert tip[field], f"Empty field: {field}"


def assert_success_response(response: Dict[str, Any]) -> None:
    """Assert response indicates success."""
    assert "success" in response
    assert response["success"] is True


def assert_error_response(response: Dict[str, Any], error_msg: str = None) -> None:
    """Assert response indicates error."""
    assert "success" in response
    assert response["success"] is False
    assert "error" in response
    if error_msg:
        assert error_msg.lower() in response["error"].lower()


def create_test_tip(tip_id: str = "test-001", **overrides) -> Dict[str, Any]:
    """Create a test tip with optional field overrides."""
    base_tip = {
        "id": tip_id,
        "title": "Test Tip",
        "description": "Test description",
        "category": "Prompting Techniques",
        "difficulty": "beginner",
        "impact": "medium"
    }
    base_tip.update(overrides)
    return base_tip
