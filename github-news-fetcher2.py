#!/usr/bin/env python3
"""
GitHub Copilot News Fetcher
A simple tool to fetch the latest GitHub Copilot news from official sources.

Author: Tim Warner
Purpose: Educational demonstration of Python best practices and API usage
"""

import httpx
import feedparser
from datetime import datetime
from rich.console import Console
from rich.table import Table
from typing import List, Dict, Any
import asyncio
from dataclasses import dataclass

@dataclass
class CopilotNews:
    """Represents a single piece of Copilot news"""
    title: str
    date: datetime
    url: str
    source: str

class GitHubNewsFetcher:
    """Fetches and aggregates GitHub Copilot news from multiple sources"""
    
    def __init__(self):
        self.console = Console()
        # Using httpx for modern async HTTP
        self.client = httpx.AsyncClient(
            timeout=30.0,
            follow_redirects=True
        )
        
    async def fetch_blog_posts(self) -> List[CopilotNews]:
        """Fetch Copilot-related posts from GitHub blog"""
        try:
            # GitHub blog feed URL
            response = await self.client.get("https://github.blog/feed/")
            feed = feedparser.parse(response.text)
            
            copilot_news = []
            for entry in feed.entries:
                # Filter for Copilot-related posts
                if "copilot" in entry.title.lower() or "copilot" in entry.description.lower():
                    news = CopilotNews(
                        title=entry.title,
                        date=datetime(*entry.published_parsed[:6]),
                        url=entry.link,
                        source="GitHub Blog"
                    )
                    copilot_news.append(news)
            
            return copilot_news[:5]  # Return latest 5 matches
        except Exception as e:
            self.console.print(f"[red]Error fetching blog posts: {e}[/red]")
            return []

    async def fetch_releases(self) -> List[CopilotNews]:
        """Fetch latest GitHub Copilot releases using GitHub API"""
        try:
            response = await self.client.get(
                "https://api.github.com/repos/github/copilot-docs/releases"
            )
            releases = response.json()
            
            return [
                CopilotNews(
                    title=f"Release: {release['name']}",
                    date=datetime.fromisoformat(release['published_at'].replace('Z', '+00:00')),
                    url=release['html_url'],
                    source="GitHub Releases"
                )
                for release in releases[:3]  # Latest 3 releases
            ]
        except Exception as e:
            self.console.print(f"[red]Error fetching releases: {e}[/red]")
            return []

    def display_news(self, news_items: List[CopilotNews]):
        """Display news items in a formatted table"""
        table = Table(title="Latest GitHub Copilot News")
        
        table.add_column("Date", style="cyan")
        table.add_column("Title", style="green")
        table.add_column("Source", style="yellow")
        table.add_column("URL", style="blue")
        
        # Sort by date, newest first
        sorted_news = sorted(news_items, key=lambda x: x.date, reverse=True)
        
        for item in sorted_news:
            table.add_row(
                item.date.strftime("%Y-%m-%d"),
                item.title,
                item.source,
                item.url
            )
        
        self.console.print(table)

    async def close(self):
        """Clean up resources"""
        await self.client.aclose()

async def main():
    fetcher = GitHubNewsFetcher()
    try:
        # Fetch news from multiple sources concurrently
        blog_posts, releases = await asyncio.gather(
            fetcher.fetch_blog_posts(),
            fetcher.fetch_releases()
        )
        
        # Combine and display results
        all_news = blog_posts + releases
        fetcher.display_news(all_news)
        
    finally:
        await fetcher.close()

if __name__ == "__main__":
    # Run the async main function
    asyncio.run(main())
