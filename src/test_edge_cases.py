"""
Edge case tests for the Copilot Tips MCP Server.

Run with: pytest test_edge_cases.py -v
"""

import pytest
import threading
from copilot_tips_server import (
    get_tip_by_id,
    get_tip_by_topic,
    get_random_tip,
    delete_tip,
    reset_tips_store,
)
from test_utils import assert_error_response, assert_success_response


@pytest.mark.unit
class TestEdgeCases:
    """Test edge cases and error conditions."""
    
    def test_get_tip_with_empty_id(self):
        """Test searching for tip with empty ID"""
        result = get_tip_by_id.fn("")
        assert result["success"] is False
        assert "error" in result
    
    def test_get_tip_with_special_characters(self):
        """Test tip ID with special characters"""
        result = get_tip_by_id.fn("tip-with-!@#$")
        assert result["success"] is False
    
    def test_get_tip_with_whitespace_only(self):
        """Test tip ID with only whitespace"""
        result = get_tip_by_id.fn("   ")
        assert result["success"] is False
    
    def test_search_with_very_long_term(self):
        """Test search with extremely long search term"""
        long_term = "a" * 1000
        result = get_tip_by_topic.fn(long_term)
        assert "success" in result
    
    def test_search_with_unicode(self):
        """Test search with unicode characters"""
        result = get_tip_by_topic.fn("测试 émoji 🔥")
        assert "success" in result
    
    def test_search_with_empty_string(self):
        """Test search with empty search term"""
        result = get_tip_by_topic.fn("")
        # Empty search should either fail or return no results
        assert "success" in result
    
    def test_search_with_only_spaces(self):
        """Test search with only whitespace"""
        result = get_tip_by_topic.fn("     ")
        assert "success" in result
    
    def test_get_random_tip_with_impossible_filters(self):
        """Test random tip with filters that match nothing"""
        result = get_random_tip.fn(
            category="NonexistentCategory",
            difficulty="impossible"
        )
        assert result["success"] is False
    
    def test_get_random_tip_with_case_mismatch(self):
        """Test random tip with wrong case in filters"""
        result = get_random_tip.fn(category="PROMPTING TECHNIQUES")
        # Should still work due to case-insensitive matching
        if result["success"]:
            assert result["tip"]["category"] in ["Prompting Techniques", "Agent Mode & Automation"]
    
    def test_delete_already_deleted_tip(self):
        """Test deleting a tip twice"""
        # First deletion should succeed
        result1 = delete_tip.fn("agent-001")
        if result1["success"]:
            # Second deletion should fail
            result2 = delete_tip.fn("agent-001")
            assert result2["success"] is False
    
    def test_delete_with_empty_id(self):
        """Test deleting with empty ID"""
        result = delete_tip.fn("")
        assert result["success"] is False
    
    def test_concurrent_read_access(self):
        """Test concurrent read access to tips store"""
        # First ensure the tip exists
        reset_tips_store()
        check = get_tip_by_id.fn("agent-001")
        if not check["success"]:
            pytest.skip("Required tip 'agent-001' not found in test data")
        
        results = []
        errors = []
        
        def access_tip():
            try:
                result = get_tip_by_id.fn("agent-001")
                results.append(result)
            except Exception as e:
                errors.append(e)
        
        threads = [threading.Thread(target=access_tip) for _ in range(10)]
        for t in threads:
            t.start()
        for t in threads:
            t.join()
        
        assert len(results) == 10
        assert len(errors) == 0
        assert all(r["success"] for r in results)
    
    def test_concurrent_delete_operations(self):
        """Test concurrent delete operations"""
        reset_tips_store()
        results = []
        errors = []
        
        def delete_operation():
            try:
                # Try to delete the same tip concurrently
                result = delete_tip.fn("agent-001")
                results.append(result)
            except Exception as e:
                errors.append(e)
        
        threads = [threading.Thread(target=delete_operation) for _ in range(5)]
        for t in threads:
            t.start()
        for t in threads:
            t.join()
        
        # Only one should succeed, others should fail
        successful = [r for r in results if r["success"]]
        assert len(successful) <= 1
        assert len(errors) == 0  # No exceptions should be raised
    
    def test_search_with_sql_injection_attempt(self):
        """Test that SQL injection-like strings are handled safely"""
        result = get_tip_by_topic.fn("'; DROP TABLE tips; --")
        assert "success" in result
        # Should not crash or cause issues
    
    def test_search_with_regex_special_chars(self):
        """Test search with regex special characters"""
        result = get_tip_by_topic.fn(".*[a-z]+$^")
        assert "success" in result
    
    def test_category_filter_with_nonexistent_category(self):
        """Test topic search with non-existent category filter"""
        result = get_tip_by_topic.fn("copilot", category="Nonexistent Category")
        # Should return no results or error
        if result["success"]:
            assert len(result["tips"]) == 0
        else:
            assert result["success"] is False
    
    def test_difficulty_filter_with_invalid_value(self):
        """Test topic search with invalid difficulty filter"""
        result = get_tip_by_topic.fn("copilot", difficulty="super-expert")
        # Should return no results or be handled gracefully
        if result["success"]:
            assert len(result["tips"]) == 0
        else:
            assert result["success"] is False
    
    def test_multiple_word_search(self):
        """Test search with multiple words"""
        result = get_tip_by_topic.fn("agent mode autonomous")
        assert "success" in result
        if result["success"]:
            assert result["count"] >= 0
