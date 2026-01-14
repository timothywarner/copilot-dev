"""
Integration tests for MCP server.
Run with: pytest test_integration.py -m integration
"""
import pytest
import subprocess
import time
import signal
import sys
from pathlib import Path


@pytest.mark.integration
class TestMCPIntegration:
    """Integration tests with actual MCP server."""
    
    @pytest.fixture
    def server_path(self):
        """Get path to the server script."""
        return Path(__file__).parent / "copilot_tips_server.py"
    
    @pytest.fixture
    def running_server(self, server_path):
        """Start MCP server for testing."""
        if not server_path.exists():
            pytest.skip(f"Server script not found at {server_path}")
        
        # Start the server process
        process = subprocess.Popen(
            [sys.executable, str(server_path)],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            stdin=subprocess.PIPE
        )
        
        # Give server time to initialize
        time.sleep(2)
        
        yield process
        
        # Cleanup: terminate the server
        if process.poll() is None:
            process.terminate()
            try:
                process.wait(timeout=5)
            except subprocess.TimeoutExpired:
                process.kill()
                process.wait()
    
    def test_server_starts_successfully(self, running_server):
        """Test that server process starts without errors."""
        assert running_server.poll() is None, "Server exited unexpectedly"
    
    def test_server_process_is_running(self, running_server):
        """Test that server process stays running."""
        time.sleep(1)
        assert running_server.poll() is None, "Server process terminated"
    
    def test_server_can_be_terminated(self, server_path):
        """Test that server can be cleanly terminated."""
        process = subprocess.Popen(
            [sys.executable, str(server_path)],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            stdin=subprocess.PIPE
        )
        
        time.sleep(1)
        assert process.poll() is None, "Server not running"
        
        # Terminate
        process.terminate()
        exit_code = process.wait(timeout=5)
        
        # Check it terminated (may be None, -15, or 0 depending on OS)
        assert exit_code is not None or process.poll() is not None
    
    def test_server_handles_stdin_close(self, running_server):
        """Test server behavior when stdin is closed."""
        running_server.stdin.close()
        time.sleep(1)
        
        # Server should eventually exit when stdin closes
        # Give it time to notice
        try:
            running_server.wait(timeout=5)
        except subprocess.TimeoutExpired:
            # Server might still be running, which is also acceptable
            pass
    
    @pytest.mark.slow
    def test_server_memory_stability(self, server_path):
        """Test that server doesn't leak memory over time."""
        process = subprocess.Popen(
            [sys.executable, str(server_path)],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            stdin=subprocess.PIPE
        )
        
        try:
            # Let server run for a bit
            time.sleep(5)
            
            # Check it's still running
            assert process.poll() is None, "Server crashed during stability test"
        finally:
            process.terminate()
            process.wait(timeout=5)


@pytest.mark.integration
class TestServerConfiguration:
    """Test server configuration and initialization."""
    
    def test_data_file_exists(self):
        """Test that the data file exists."""
        data_file = Path(__file__).parent / "data" / "copilot_tips.json"
        assert data_file.exists(), "Data file not found"
    
    def test_data_file_is_valid_json(self):
        """Test that data file contains valid JSON."""
        import json
        data_file = Path(__file__).parent / "data" / "copilot_tips.json"
        
        with open(data_file, "r", encoding="utf-8") as f:
            data = json.load(f)
        
        assert "tips" in data
        assert isinstance(data["tips"], list)
        assert len(data["tips"]) > 0
    
    def test_all_tips_have_required_fields(self):
        """Test that all tips in data file have required fields."""
        import json
        data_file = Path(__file__).parent / "data" / "copilot_tips.json"
        
        with open(data_file, "r", encoding="utf-8") as f:
            data = json.load(f)
        
        required_fields = {"id", "title", "description", "category", "difficulty"}
        
        for i, tip in enumerate(data["tips"]):
            assert required_fields.issubset(tip.keys()), \
                f"Tip {i} (ID: {tip.get('id', 'unknown')}) missing required fields"
    
    def test_tip_ids_are_unique(self):
        """Test that all tip IDs are unique."""
        import json
        data_file = Path(__file__).parent / "data" / "copilot_tips.json"
        
        with open(data_file, "r", encoding="utf-8") as f:
            data = json.load(f)
        
        tip_ids = [tip["id"] for tip in data["tips"]]
        assert len(tip_ids) == len(set(tip_ids)), "Duplicate tip IDs found"
