#!/usr/bin/env python3
"""
GitHub Copilot Tips & Tricks MCP Server

A FastMCP server providing CRUD operations for GitHub Copilot tips and tricks.
Built for O'Reilly teaching demonstrations.

Resources:
    - tips://categories - List all tip categories
    - tips://stats - Get tip counts by category

Tools:
    - get_tip_by_id - Retrieve a specific tip by its ID
    - get_tip_by_topic - Search tips by topic/keyword (fuzzy search)
    - get_random_tip - Get a random tip (optionally filtered)
    - delete_tip - Delete a tip by ID (in-memory only)

Prompts:
    - tip_suggestion - Generate prompts for recommending tips
    - category_explorer - Explore tips in a specific category
"""

import json
import random
from pathlib import Path
from typing import Optional
from collections import Counter

from fastmcp import FastMCP

# Initialize FastMCP server
mcp = FastMCP(
    "Copilot Tips Server",
    description="MCP server for GitHub Copilot tips and tricks - O'Reilly teaching example"
)

# Load tips data
DATA_FILE = Path(__file__).parent / "data" / "copilot_tips.json"


def load_tips() -> list[dict]:
    """Load tips from the JSON data file."""
    if DATA_FILE.exists():
        with open(DATA_FILE, "r", encoding="utf-8") as f:
            data = json.load(f)
            return data.get("tips", [])
    return []


# In-memory tips store (allows deletes without modifying source file)
_tips_store: list[dict] = []


def get_tips_store() -> list[dict]:
    """Get the in-memory tips store, initializing from file if needed."""
    global _tips_store
    if not _tips_store:
        _tips_store = load_tips()
    return _tips_store


def reset_tips_store() -> None:
    """Reset the tips store to original data (useful for demos)."""
    global _tips_store
    _tips_store = load_tips()


# =============================================================================
# RESOURCES
# =============================================================================

@mcp.resource("tips://categories")
def list_categories() -> str:
    """
    List all available tip categories.

    Returns a formatted list of unique categories found in the tips database.
    """
    tips = get_tips_store()
    categories = sorted(set(tip["category"] for tip in tips))

    result = "# GitHub Copilot Tip Categories\n\n"
    for i, category in enumerate(categories, 1):
        count = sum(1 for tip in tips if tip["category"] == category)
        result += f"{i}. **{category}** ({count} tips)\n"

    return result


@mcp.resource("tips://stats")
def get_stats() -> str:
    """
    Get statistics about tips by category and difficulty.

    Returns formatted statistics including counts by category and difficulty level.
    """
    tips = get_tips_store()

    # Count by category
    category_counts = Counter(tip["category"] for tip in tips)

    # Count by difficulty
    difficulty_counts = Counter(tip["difficulty"] for tip in tips)

    result = "# GitHub Copilot Tips Statistics\n\n"
    result += f"**Total Tips:** {len(tips)}\n\n"

    result += "## By Category\n\n"
    result += "| Category | Count |\n|----------|-------|\n"
    for category, count in sorted(category_counts.items()):
        result += f"| {category} | {count} |\n"

    result += "\n## By Difficulty\n\n"
    result += "| Difficulty | Count |\n|------------|-------|\n"
    for difficulty in ["beginner", "intermediate", "advanced"]:
        count = difficulty_counts.get(difficulty, 0)
        result += f"| {difficulty.capitalize()} | {count} |\n"

    return result


# =============================================================================
# TOOLS
# =============================================================================

@mcp.tool()
def get_tip_by_id(tip_id: str) -> dict:
    """
    Retrieve a specific tip by its unique ID.

    Args:
        tip_id: The unique identifier for the tip (e.g., 'prompt-001', 'shortcut-002')

    Returns:
        The tip object if found, or an error message if not found.
    """
    tips = get_tips_store()

    for tip in tips:
        if tip["id"].lower() == tip_id.lower():
            return {
                "success": True,
                "tip": tip
            }

    return {
        "success": False,
        "error": f"Tip with ID '{tip_id}' not found",
        "available_ids": [t["id"] for t in tips[:5]] + ["..."]
    }


@mcp.tool()
def get_tip_by_topic(
    search_term: str,
    category: Optional[str] = None,
    difficulty: Optional[str] = None
) -> dict:
    """
    Search for tips by topic or keyword using fuzzy matching.

    Args:
        search_term: The keyword or phrase to search for in tip titles and descriptions
        category: Optional category filter (e.g., 'Prompting Techniques', 'IDE Shortcuts')
        difficulty: Optional difficulty filter ('beginner', 'intermediate', 'advanced')

    Returns:
        List of matching tips sorted by relevance.
    """
    tips = get_tips_store()
    search_lower = search_term.lower()

    matches = []
    for tip in tips:
        # Apply category filter
        if category and tip["category"].lower() != category.lower():
            continue

        # Apply difficulty filter
        if difficulty and tip["difficulty"].lower() != difficulty.lower():
            continue

        # Calculate relevance score
        score = 0
        title_lower = tip["title"].lower()
        desc_lower = tip["description"].lower()

        # Exact match in title (highest priority)
        if search_lower in title_lower:
            score += 10
            if title_lower.startswith(search_lower):
                score += 5

        # Match in description
        if search_lower in desc_lower:
            score += 3

        # Partial word matches
        search_words = search_lower.split()
        for word in search_words:
            if word in title_lower:
                score += 2
            if word in desc_lower:
                score += 1

        if score > 0:
            matches.append({"tip": tip, "relevance": score})

    # Sort by relevance
    matches.sort(key=lambda x: x["relevance"], reverse=True)

    if not matches:
        return {
            "success": False,
            "error": f"No tips found matching '{search_term}'",
            "suggestion": "Try broader search terms or remove filters"
        }

    return {
        "success": True,
        "count": len(matches),
        "tips": [m["tip"] for m in matches[:10]]  # Return top 10
    }


@mcp.tool()
def get_random_tip(
    category: Optional[str] = None,
    difficulty: Optional[str] = None
) -> dict:
    """
    Get a random tip, optionally filtered by category or difficulty.

    Args:
        category: Optional category filter (e.g., 'Chat Features', 'Security & Privacy')
        difficulty: Optional difficulty filter ('beginner', 'intermediate', 'advanced')

    Returns:
        A randomly selected tip matching the filters.
    """
    tips = get_tips_store()

    # Apply filters
    filtered_tips = tips

    if category:
        filtered_tips = [t for t in filtered_tips if t["category"].lower() == category.lower()]

    if difficulty:
        filtered_tips = [t for t in filtered_tips if t["difficulty"].lower() == difficulty.lower()]

    if not filtered_tips:
        return {
            "success": False,
            "error": "No tips match the specified filters",
            "filters_applied": {"category": category, "difficulty": difficulty}
        }

    selected = random.choice(filtered_tips)

    return {
        "success": True,
        "tip": selected,
        "pool_size": len(filtered_tips)
    }


@mcp.tool()
def delete_tip(tip_id: str) -> dict:
    """
    Delete a tip by its ID (in-memory only - does not modify the source file).

    This is useful for demonstrating CRUD operations. Use reset_tips() to restore
    all deleted tips.

    Args:
        tip_id: The unique identifier of the tip to delete

    Returns:
        Confirmation of deletion or error if tip not found.
    """
    tips = get_tips_store()

    for i, tip in enumerate(tips):
        if tip["id"].lower() == tip_id.lower():
            deleted_tip = tips.pop(i)
            return {
                "success": True,
                "message": f"Tip '{tip_id}' deleted successfully",
                "deleted_tip": deleted_tip,
                "remaining_count": len(tips)
            }

    return {
        "success": False,
        "error": f"Tip with ID '{tip_id}' not found"
    }


@mcp.tool()
def reset_tips() -> dict:
    """
    Reset the tips database to its original state.

    Restores all deleted tips by reloading from the source JSON file.
    Useful after demonstrating delete operations.

    Returns:
        Confirmation with the restored tip count.
    """
    reset_tips_store()
    tips = get_tips_store()

    return {
        "success": True,
        "message": "Tips database reset to original state",
        "tip_count": len(tips)
    }


# =============================================================================
# PROMPTS
# =============================================================================

@mcp.prompt()
def tip_suggestion(task_description: str) -> str:
    """
    Generate a prompt for suggesting relevant Copilot tips based on a task.

    Args:
        task_description: Description of what the user is trying to accomplish

    Returns:
        A formatted prompt for the AI to suggest relevant tips.
    """
    return f"""I'm working on the following task with GitHub Copilot:

**Task:** {task_description}

Based on this task, please:
1. Search for relevant tips using the get_tip_by_topic tool
2. Recommend 2-3 tips that would help me accomplish this task more effectively
3. Explain how each tip applies to my specific situation

Focus on practical, actionable advice that I can apply immediately."""


@mcp.prompt()
def category_explorer(category_name: str) -> str:
    """
    Generate a prompt for exploring all tips in a specific category.

    Args:
        category_name: The category to explore (e.g., 'Prompting Techniques')

    Returns:
        A formatted prompt for exploring the category.
    """
    return f"""I want to learn about GitHub Copilot tips in the "{category_name}" category.

Please:
1. Use the get_tip_by_topic tool to find all tips in this category
2. Organize them by difficulty level (beginner → intermediate → advanced)
3. For each tip, provide a brief real-world example of when to use it
4. Suggest a learning path for mastering this category

Help me understand how these tips build upon each other."""


@mcp.prompt()
def learning_path(current_skill_level: str) -> str:
    """
    Generate a personalized learning path based on skill level.

    Args:
        current_skill_level: The user's current skill level ('beginner', 'intermediate', 'advanced')

    Returns:
        A formatted prompt for creating a personalized learning path.
    """
    return f"""I'm currently at the **{current_skill_level}** level with GitHub Copilot.

Please create a personalized learning path for me:
1. First, use get_tip_by_topic to find tips matching my skill level
2. Then find tips at the next level up to help me advance
3. Recommend which tips to focus on first
4. Suggest practical exercises to practice each tip
5. Identify which categories I should prioritize

Create a structured 2-week learning plan with daily goals."""


# =============================================================================
# ELICITATIONS (Basic examples - client support varies)
# =============================================================================

# Note: Elicitations are a newer MCP feature with limited client support.
# These are included as teaching examples but may fall back to prompts.

@mcp.prompt()
def interactive_tip_finder() -> str:
    """
    Interactive prompt that guides users through finding the right tip.

    This serves as a fallback for elicitations where client support is limited.
    """
    return """Let me help you find the perfect GitHub Copilot tip!

Please answer these questions:

1. **What's your experience level?**
   - Beginner (just getting started)
   - Intermediate (comfortable with basics)
   - Advanced (looking for power-user tips)

2. **What area are you interested in?**
   - Prompting Techniques (writing better prompts)
   - IDE Shortcuts (keyboard efficiency)
   - Code Generation (getting better code output)
   - Chat Features (using Copilot Chat effectively)
   - Workspace Context (leveraging project context)
   - Security & Privacy (safe Copilot usage)

3. **What's your specific goal right now?**
   (Describe what you're trying to accomplish)

Once you answer, I'll search for the most relevant tips and provide personalized recommendations!"""


@mcp.prompt()
def quiz_me(category: Optional[str] = None) -> str:
    """
    Generate a quiz prompt to test knowledge of Copilot tips.

    Args:
        category: Optional category to focus the quiz on

    Returns:
        A formatted quiz prompt.
    """
    category_text = f' in the "{category}" category' if category else ""

    return f"""Let's test your GitHub Copilot knowledge{category_text}!

I'll ask you questions about best practices and tips. For each question:
1. I'll describe a scenario
2. You tell me which tip or technique would be most helpful
3. I'll provide feedback and explain the best approach

Ready? Let's start with an easy one!

**Question 1:** You're writing a new function but Copilot's suggestions don't match what you need. What's the FIRST thing you should try?

(Answer, and I'll give you feedback and move to the next question!)"""


# =============================================================================
# MAIN ENTRY POINT
# =============================================================================

def main():
    """Run the MCP server."""
    mcp.run()


if __name__ == "__main__":
    main()
