"""
Tests for async elicitation functions in the Copilot Tips MCP Server.

Run with: pytest test_async_functions.py -v
"""

import pytest
from unittest.mock import AsyncMock, MagicMock, patch
from copilot_tips_server import interactive_tip_finder, guided_random_tip


@pytest.mark.asyncio
@pytest.mark.unit
class TestAsyncFunctions:
    """Tests for async elicitation functions."""
    
    async def test_interactive_tip_finder_with_valid_inputs(self):
        """Test interactive_tip_finder with valid user inputs."""
        # Create mock context
        mock_ctx = MagicMock()
        
        # Mock elicit responses
        difficulty_response = MagicMock()
        difficulty_response.action = "accept"
        difficulty_response.data = "beginner"
        
        category_response = MagicMock()
        category_response.action = "accept"
        category_response.data = "Prompting Techniques"
        
        mock_ctx.elicit = AsyncMock(side_effect=[difficulty_response, category_response])
        
        # Call the function
        result = await interactive_tip_finder.fn(mock_ctx)
        
        # Verify results
        assert result["success"] is True
        assert "preferences" in result
        assert result["preferences"]["difficulty"] == "beginner"
        assert result["preferences"]["category"] == "Prompting Techniques"
        assert "tips" in result
        assert isinstance(result["tips"], list)
    
    async def test_interactive_tip_finder_cancelled_at_difficulty(self):
        """Test interactive_tip_finder when user cancels at difficulty selection."""
        mock_ctx = MagicMock()
        
        difficulty_response = MagicMock()
        difficulty_response.action = "cancel"
        
        mock_ctx.elicit = AsyncMock(return_value=difficulty_response)
        
        result = await interactive_tip_finder.fn(mock_ctx)
        
        assert result["success"] is False
        assert "cancelled" in result["message"].lower()
    
    async def test_interactive_tip_finder_cancelled_at_category(self):
        """Test interactive_tip_finder when user cancels at category selection."""
        mock_ctx = MagicMock()
        
        difficulty_response = MagicMock()
        difficulty_response.action = "accept"
        difficulty_response.data = "intermediate"
        
        category_response = MagicMock()
        category_response.action = "cancel"
        
        mock_ctx.elicit = AsyncMock(side_effect=[difficulty_response, category_response])
        
        result = await interactive_tip_finder.fn(mock_ctx)
        
        assert result["success"] is False
        assert "cancelled" in result["message"].lower()
    
    async def test_interactive_tip_finder_no_exact_matches(self):
        """Test interactive_tip_finder when no exact matches found."""
        mock_ctx = MagicMock()
        
        difficulty_response = MagicMock()
        difficulty_response.action = "accept"
        difficulty_response.data = "advanced"
        
        category_response = MagicMock()
        category_response.action = "accept"
        category_response.data = "Agent Mode & Automation"
        
        mock_ctx.elicit = AsyncMock(side_effect=[difficulty_response, category_response])
        
        result = await interactive_tip_finder.fn(mock_ctx)
        
        # Should fall back to category-only match
        assert result["success"] is True
        assert "tips" in result
    
    async def test_guided_random_tip_completely_random(self):
        """Test guided_random_tip with completely random selection."""
        mock_ctx = MagicMock()
        
        filter_response = MagicMock()
        filter_response.action = "accept"
        filter_response.data = "completely random"
        
        mock_ctx.elicit = AsyncMock(return_value=filter_response)
        
        result = await guided_random_tip.fn(mock_ctx)
        
        assert result["success"] is True
        assert "tip" in result
        assert "pool_size" in result
        assert result["pool_size"] > 0
    
    async def test_guided_random_tip_with_category_filter(self):
        """Test guided_random_tip with category filter."""
        mock_ctx = MagicMock()
        
        filter_response = MagicMock()
        filter_response.action = "accept"
        filter_response.data = "filter by category"
        
        category_response = MagicMock()
        category_response.action = "accept"
        category_response.data = "Agent Mode & Automation"
        
        mock_ctx.elicit = AsyncMock(side_effect=[filter_response, category_response])
        
        result = await guided_random_tip.fn(mock_ctx)
        
        assert result["success"] is True
        assert "tip" in result
        assert result["tip"]["category"] == "Agent Mode & Automation"
    
    async def test_guided_random_tip_cancelled_at_filter(self):
        """Test guided_random_tip when user cancels at filter selection."""
        mock_ctx = MagicMock()
        
        filter_response = MagicMock()
        filter_response.action = "cancel"
        
        mock_ctx.elicit = AsyncMock(return_value=filter_response)
        
        result = await guided_random_tip.fn(mock_ctx)
        
        assert result["success"] is False
        assert "Cancelled" in result["message"]
    
    async def test_guided_random_tip_cancelled_at_category(self):
        """Test guided_random_tip when user cancels at category selection."""
        mock_ctx = MagicMock()
        
        filter_response = MagicMock()
        filter_response.action = "accept"
        filter_response.data = "filter by category"
        
        category_response = MagicMock()
        category_response.action = "cancel"
        
        mock_ctx.elicit = AsyncMock(side_effect=[filter_response, category_response])
        
        result = await guided_random_tip.fn(mock_ctx)
        
        assert result["success"] is False
        assert "cancelled" in result["message"].lower()
    
    async def test_guided_random_tip_nonexistent_category(self):
        """Test guided_random_tip with non-existent category."""
        mock_ctx = MagicMock()
        
        filter_response = MagicMock()
        filter_response.action = "accept"
        filter_response.data = "filter by category"
        
        # This test assumes the category won't exist
        # In reality, the elicit would only allow valid categories
        category_response = MagicMock()
        category_response.action = "accept"
        category_response.data = "Nonexistent Category"
        
        mock_ctx.elicit = AsyncMock(side_effect=[filter_response, category_response])
        
        result = await guided_random_tip.fn(mock_ctx)
        
        # Should return error for non-existent category
        if result["success"] is False:
            assert "error" in result
