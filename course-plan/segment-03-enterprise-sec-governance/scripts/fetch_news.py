import os
import requests
from datetime import datetime
import json

def query_deepseek(prompt):
    api_key = os.environ.get('DEEPSEEK_API_KEY')
    if not api_key:
        raise ValueError("DEEPSEEK_API_KEY environment variable is not set")

    headers = {
        "Authorization": f"Bearer {api_key}",
        "Content-Type": "application/json"
    }
    
    data = {
        "model": "deepseek-chat",
        "messages": [{"role": "user", "content": prompt}],
        "temperature": 0.3,  # Reduced for more focused, factual responses
        "max_tokens": 2500   # Increased for more comprehensive coverage
    }
    
    response = requests.post(
        "https://api.deepseek.com/v1/chat/completions",
        headers=headers,
        json=data
    )
    
    if response.status_code != 200:
        raise Exception(f"API request failed with status {response.status_code}: {response.text}")
    
    return response.json()['choices'][0]['message']['content']

def main():
    today = datetime.now().strftime('%Y-%m-%d')
    
    prompt = f"""Act as an expert technical researcher and educator specializing in GitHub Copilot. Your task is to compile a comprehensive update on GitHub Copilot developments that would be valuable for IT professionals and developers. Focus on the following areas, with special attention to practical applications and educational value:

Key Areas to Cover:
1. Latest Features and Updates
   - New capabilities in GitHub Copilot
   - Changes to existing features
   - Updates to the API or integration points
   - Performance improvements

2. Best Practices and Tips
   - New discovered patterns for effective prompting
   - Workflow optimization techniques
   - Integration tips with different IDEs and tools
   - Security best practices

3. Educational Resources
   - New tutorials or learning materials
   - Notable blog posts or documentation updates
   - Community-contributed guides
   - Training opportunities

4. Enterprise and Professional Use
   - Updates relevant to enterprise deployments
   - Compliance and security updates
   - Team collaboration features
   - License and pricing changes

5. Technical Deep Dives
   - API changes and developer tools
   - Integration possibilities
   - Performance optimization techniques
   - Advanced usage patterns

Prioritize information from:
- Official GitHub and Microsoft sources
- GitHub Blog and documentation
- Microsoft Learn and documentation
- Notable community contributors and GitHub staff

Format Requirements:
- Use clear Markdown formatting
- Include links to sources where available
- Organize content with clear headings
- Focus on actionable insights
- Include specific examples where relevant

Only include verifiable information from the past few days. If certain categories have no recent updates, you may omit them."""

    try:
        news_content = query_deepseek(prompt)
        
        # Add header with date and branding
        full_content = f"""<div align="center">

# 🤖 GitHub Copilot News Update ({today})

[![TechTrainerTim.com](https://img.shields.io/badge/🌐_TechTrainerTim.com-Visit_Website-2ea44f)](https://TechTrainerTim.com)

</div>

> This update is auto-generated using AI to compile recent GitHub Copilot developments, focusing on practical information for IT professionals and developers.

{news_content}

---

<div align="center">

### Stay Updated with More Tech Training Content

- 🌐 [TechTrainerTim.com](https://TechTrainerTim.com)
- 📚 Expert-led training and consulting
- 🤖 Specialized in AI and GitHub Copilot
- 💡 Custom workshops and courses available

</div>

---
*Note: This content is AI-generated based on recent developments. Always verify information from official sources.*

<div align="right">
<sub>Generated with ❤️ by Tim Warner's AI News System</sub>
</div>"""
        
        # Write to file
        with open('latest-github-news.md', 'w', encoding='utf-8') as f:
            f.write(full_content)
            
    except Exception as e:
        print(f"Error occurred: {str(e)}")
        exit(1)

if __name__ == "__main__":
    main() 