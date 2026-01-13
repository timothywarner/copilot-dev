#!/usr/bin/env python3
"""
MCP Inspector Launcher

Launches the MCP Inspector web UI with a random port to avoid conflicts.
Automatically starts the Copilot Tips MCP server for inspection.

Usage:
    python start_inspector.py

Requirements:
    - Node.js and npx must be installed
    - The virtual environment should be activated
"""

import os
import random
import shutil
import subprocess
import sys
import webbrowser
from pathlib import Path


def check_node_installed() -> bool:
    """Check if Node.js and npx are available."""
    npx_path = shutil.which("npx")
    if npx_path is None:
        return False

    # Verify it actually works
    try:
        result = subprocess.run(
            ["npx", "--version"],
            capture_output=True,
            text=True,
            timeout=10
        )
        return result.returncode == 0
    except (subprocess.TimeoutExpired, FileNotFoundError):
        return False


def get_random_port() -> int:
    """Generate a random port in the dynamic/private range."""
    # Use dynamic/private port range: 49152-65535
    return random.randint(49152, 65535)


def get_python_executable() -> str:
    """Get the path to the Python executable in the virtual environment."""
    # Check if we're in a venv
    if sys.prefix != sys.base_prefix:
        return sys.executable

    # Try to find venv Python
    src_dir = Path(__file__).parent
    venv_dir = src_dir / ".venv"

    if sys.platform == "win32":
        venv_python = venv_dir / "Scripts" / "python.exe"
    else:
        venv_python = venv_dir / "bin" / "python"

    if venv_python.exists():
        return str(venv_python)

    # Fall back to current Python
    return sys.executable


def main():
    """Launch MCP Inspector with the Copilot Tips server."""
    print("=" * 60)
    print("  MCP Inspector Launcher - Copilot Tips Server")
    print("=" * 60)
    print()

    # Check for Node.js
    print("🔍 Checking for Node.js and npx...")
    if not check_node_installed():
        print()
        print("❌ ERROR: Node.js/npx not found!")
        print()
        print("The MCP Inspector requires Node.js to run.")
        print("Please install Node.js from: https://nodejs.org/")
        print()
        print("After installing, restart your terminal and try again.")
        sys.exit(1)

    print("   ✅ Node.js and npx are available")
    print()

    # Generate random port
    port = get_random_port()
    print(f"🎲 Using random port: {port}")
    print()

    # Get paths
    src_dir = Path(__file__).parent
    server_script = src_dir / "copilot_tips_server.py"
    python_exe = get_python_executable()

    print(f"📁 Server script: {server_script}")
    print(f"🐍 Python executable: {python_exe}")
    print()

    # Build the inspector command
    # The inspector runs the MCP server and provides a web UI for testing
    inspector_cmd = [
        "npx",
        "@anthropic-ai/mcp-inspector@latest",
        "--",
        python_exe,
        str(server_script)
    ]

    # Set environment variables
    env = os.environ.copy()
    env["MCP_INSPECTOR_PORT"] = str(port)

    print("🚀 Starting MCP Inspector...")
    print()
    print(f"   Web UI will be available at: http://localhost:{port}")
    print()
    print("   Press Ctrl+C to stop the inspector")
    print()
    print("-" * 60)
    print()

    try:
        # Open browser after a short delay (give server time to start)
        # We'll let the user open it manually for now since the inspector
        # prints its own URL

        # Run the inspector
        subprocess.run(
            inspector_cmd,
            env=env,
            cwd=str(src_dir)
        )
    except KeyboardInterrupt:
        print()
        print()
        print("👋 Inspector stopped.")
    except FileNotFoundError:
        print("❌ ERROR: Failed to start MCP Inspector")
        print("   Try running: npx @anthropic-ai/mcp-inspector@latest --help")
        sys.exit(1)


if __name__ == "__main__":
    main()
