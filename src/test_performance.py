"""
Performance tests for the Copilot Tips MCP Server.

Run with: pytest test_performance.py -m performance
"""

import pytest
import time
from copilot_tips_server import (
    get_tip_by_id,
    get_tip_by_topic,
    get_random_tip,
    get_tips_store,
    reset_tips_store,
)


@pytest.mark.performance
class TestPerformance:
    """Performance and benchmark tests."""
    
    def test_search_performance(self, benchmark):
        """Benchmark search operation."""
        result = benchmark(get_tip_by_topic.fn, "chat")
        assert result["success"] is True
    
    def test_random_tip_performance(self, benchmark):
        """Benchmark random tip selection."""
        result = benchmark(get_random_tip.fn)
        assert result["success"] is True
    
    def test_get_tip_by_id_performance(self, benchmark):
        """Benchmark get tip by ID operation."""
        # Ensure tips are loaded before benchmarking
        from copilot_tips_server import get_tips_store
        get_tips_store()
        
        result = benchmark(get_tip_by_id.fn, "agent-001")
        assert result["success"] is True
    
    def test_load_tips_store_performance(self):
        """Test performance of loading tips store."""
        reset_tips_store()
        
        start = time.time()
        tips = get_tips_store()
        elapsed = time.time() - start
        
        assert elapsed < 0.1, f"Loading tips took {elapsed:.3f}s, expected < 0.1s"
        assert len(tips) > 0
    
    def test_search_scalability(self):
        """Test search performance doesn't degrade badly."""
        # Search with increasing result counts
        search_terms = ["a", "e", "i", "o", "u"]
        times = []
        
        for term in search_terms:
            start = time.time()
            get_tip_by_topic.fn(term)
            elapsed = time.time() - start
            times.append(elapsed)
        
        # Performance should be consistent (no exponential growth)
        avg_time = sum(times) / len(times)
        assert all(t < avg_time * 3 for t in times), \
            f"Search times vary too much: {times}"
    
    def test_repeated_searches_are_fast(self):
        """Test that repeated searches maintain performance."""
        iterations = 100
        
        start = time.time()
        for _ in range(iterations):
            result = get_tip_by_topic.fn("copilot")
            assert result["success"] is True
        elapsed = time.time() - start
        
        avg_time = elapsed / iterations
        assert avg_time < 0.01, \
            f"Average search time {avg_time:.4f}s exceeds threshold"
    
    def test_random_tip_selection_speed(self):
        """Test random tip selection is fast."""
        iterations = 100
        
        start = time.time()
        for _ in range(iterations):
            result = get_random_tip.fn()
            assert result["success"] is True
        elapsed = time.time() - start
        
        avg_time = elapsed / iterations
        assert avg_time < 0.005, \
            f"Average random selection {avg_time:.4f}s exceeds threshold"
    
    def test_concurrent_operations_performance(self):
        """Test performance under concurrent access."""
        import threading
        results = []
        errors = []
        
        def perform_operations():
            try:
                for _ in range(10):
                    get_tip_by_id.fn("agent-001")
                    get_tip_by_topic.fn("agent")
                    get_random_tip.fn()
                results.append(True)
            except Exception as e:
                errors.append(e)
        
        num_threads = 5
        start = time.time()
        
        threads = [threading.Thread(target=perform_operations) for _ in range(num_threads)]
        for t in threads:
            t.start()
        for t in threads:
            t.join()
        
        elapsed = time.time() - start
        
        assert len(errors) == 0, f"Errors during concurrent operations: {errors}"
        assert len(results) == num_threads
        assert elapsed < 2.0, \
            f"Concurrent operations took {elapsed:.2f}s, expected < 2.0s"
    
    def test_filter_performance(self):
        """Test performance of filtered searches."""
        iterations = 50
        
        start = time.time()
        for _ in range(iterations):
            result = get_tip_by_topic.fn(
                "copilot",
                category="Agent Mode & Automation",
                difficulty="intermediate"
            )
        elapsed = time.time() - start
        
        avg_time = elapsed / iterations
        assert avg_time < 0.02, \
            f"Average filtered search {avg_time:.4f}s exceeds threshold"
    
    @pytest.mark.slow
    def test_stress_test_rapid_requests(self):
        """Stress test with rapid consecutive requests."""
        iterations = 500
        errors = []
        
        start = time.time()
        for i in range(iterations):
            try:
                if i % 3 == 0:
                    get_tip_by_id.fn("agent-001")
                elif i % 3 == 1:
                    get_tip_by_topic.fn("copilot")
                else:
                    get_random_tip.fn()
            except Exception as e:
                errors.append(e)
        elapsed = time.time() - start
        
        assert len(errors) == 0, f"Errors during stress test: {errors}"
        avg_time = elapsed / iterations
        assert avg_time < 0.01, \
            f"Average request time {avg_time:.4f}s exceeds threshold under stress"
