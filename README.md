# GitHub Copilot Dev Repository

## Overview
This repository is a collection of resources, examples, and exercises for mastering GitHub Copilot and related technologies.

## Repository Structure
- **assets/**: Images and other media assets.
- **blackbeard-extension-main/**: A sample extension project.
- **data/**: Example datasets for exercises.
- **docs/**: Documentation and guides.
- **examples/**: Code examples and templates.
- **exercises/**: Hands-on exercises for learning.
- **modules/**: Structured learning modules.
- **resources/**: Additional learning resources.
- **server-2025-learning-lab/**: A server-side learning lab project.

## Getting Started
1. Clone the repository: `git clone <repo-url>`
2. Navigate to the desired folder and follow the instructions in the README files.

## Contributing
See [CONTRIBUTING.md](server-2025-learning-lab/CONTRIBUTING.md) for guidelines.

## License
This project is licensed under the terms of the MIT license. See [LICENSE](LICENSE) for details.

# GitHub Copilot News Fetcher

A modern Python example demonstrating how to fetch and display GitHub Copilot news from official sources. This educational example showcases several Python best practices and modern development patterns.

## Learning Objectives

1. **Modern Python Features**
   - Type hints with `typing` module
   - Dataclasses for clean data structures
   - Async/await for concurrent operations
   - Resource management with context managers

2. **Best Practices**
   - Clean code organization with classes
   - Error handling with try/except
   - Resource cleanup in finally blocks
   - Strong typing for better maintainability
   - Concurrent operations for better performance

3. **Real-world Integration**
   - HTTP requests with modern `httpx` library
   - RSS feed parsing
   - GitHub API integration
   - Beautiful console output with `rich`

## Installation

```bash
# Create and activate a virtual environment (recommended)
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt
```

## Usage

Simply run the script:

```bash
python github-news-fetcher2.py
```

The script will:
1. Fetch the latest Copilot-related posts from the GitHub blog
2. Fetch the latest Copilot releases from GitHub
3. Display the combined results in a nicely formatted table

## Code Structure

- `CopilotNews`: Dataclass representing a single news item
- `GitHubNewsFetcher`: Main class handling news fetching and display
  - `fetch_blog_posts()`: Fetches and filters GitHub blog posts
  - `fetch_releases()`: Fetches latest GitHub Copilot releases
  - `display_news()`: Formats and displays results

## Error Handling

The script includes robust error handling:
- Timeouts for HTTP requests
- Exception catching for API and parsing errors
- Graceful degradation (continues even if one source fails)
- Resource cleanup with async context management

## Dependencies

- `httpx`: Modern async HTTP client
- `feedparser`: RSS/Atom feed parser
- `rich`: Terminal formatting and tables

## Extension Ideas

1. Add more news sources (Twitter, YouTube, etc.)
2. Implement caching for API responses
3. Add filtering options for specific topics
4. Create a web interface using FastAPI
5. Add unit tests with pytest

## Contributing

Feel free to submit issues and enhancement requests!


