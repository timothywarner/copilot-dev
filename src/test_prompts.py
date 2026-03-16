"""
Tests for prompt templates in the Copilot Tips MCP Server.

Run with: pytest test_prompts.py -v
"""

import pytest
from copilot_tips_server import (
    tip_suggestion,
    category_explorer,
    learning_path,
)


@pytest.mark.unit
class TestPrompts:
    """Tests for prompt templates."""
    
    def test_tip_suggestion_returns_string(self):
        """Test tip_suggestion prompt returns a string."""
        result = tip_suggestion.fn("I want to refactor legacy code")
        assert isinstance(result, str)
        assert len(result) > 0
    
    def test_tip_suggestion_includes_task_description(self):
        """Test that tip_suggestion includes the task description."""
        task = "Build a REST API with authentication"
        result = tip_suggestion.fn(task)
        assert task in result
    
    def test_tip_suggestion_mentions_tools(self):
        """Test that tip_suggestion mentions using tools."""
        result = tip_suggestion.fn("Any task")
        assert "get_tip_by_topic" in result or "tool" in result.lower()
    
    def test_category_explorer_returns_string(self):
        """Test category_explorer prompt returns a string."""
        result = category_explorer.fn("Prompting Techniques")
        assert isinstance(result, str)
        assert len(result) > 0
    
    def test_category_explorer_includes_category_name(self):
        """Test that category_explorer includes the category name."""
        category = "IDE Shortcuts"
        result = category_explorer.fn(category)
        assert category in result
    
    def test_category_explorer_mentions_difficulty_levels(self):
        """Test that category_explorer mentions difficulty organization."""
        result = category_explorer.fn("Any Category")
        assert "difficulty" in result.lower() or "beginner" in result.lower()
    
    def test_learning_path_returns_string(self):
        """Test learning_path prompt returns a string."""
        result = learning_path.fn("beginner")
        assert isinstance(result, str)
        assert len(result) > 0
    
    def test_learning_path_includes_skill_level(self):
        """Test that learning_path includes the skill level."""
        skill_level = "intermediate"
        result = learning_path.fn(skill_level)
        assert skill_level in result
    
    def test_learning_path_mentions_tips_search(self):
        """Test that learning_path mentions searching for tips."""
        result = learning_path.fn("advanced")
        assert "get_tip_by_topic" in result or "tip" in result.lower()
    
    def test_learning_path_for_all_levels(self):
        """Test learning_path works for all skill levels."""
        levels = ["beginner", "intermediate", "advanced"]
        for level in levels:
            result = learning_path.fn(level)
            assert isinstance(result, str)
            assert len(result) > 0
            assert level in result
    
    def test_prompts_have_reasonable_length(self):
        """Test that prompts are not too short or too long."""
        prompts = [
            tip_suggestion.fn("Test task"),
            category_explorer.fn("Test category"),
            learning_path.fn("beginner")
        ]
        
        for prompt in prompts:
            # Should be substantial (more than a sentence)
            assert len(prompt) > 50, "Prompt too short"
            # But not excessively long (< 2000 chars is reasonable)
            assert len(prompt) < 2000, "Prompt too long"
    
    def test_tip_suggestion_with_empty_task(self):
        """Test tip_suggestion with empty task description."""
        result = tip_suggestion.fn("")
        assert isinstance(result, str)
        # Should still return valid prompt even with empty input
    
    def test_tip_suggestion_with_long_task(self):
        """Test tip_suggestion with very long task description."""
        long_task = "A" * 500
        result = tip_suggestion.fn(long_task)
        assert isinstance(result, str)
        assert long_task in result
    
    def test_category_explorer_with_special_characters(self):
        """Test category_explorer with special characters in category name."""
        result = category_explorer.fn("Test & Special/Characters")
        assert isinstance(result, str)
    
    def test_learning_path_with_custom_level(self):
        """Test learning_path with custom skill level."""
        result = learning_path.fn("expert")
        assert isinstance(result, str)
        assert "expert" in result
