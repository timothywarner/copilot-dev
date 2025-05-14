import axios from 'axios';
import cheerio from 'cheerio';

/**
 * Fetches and parses GitHub Copilot news from GitHub Blog.
 * @returns {Promise<Array>} Array of news articles about GitHub Copilot
 */
async function fetchCopilotNews() {
  try {
    console.log("Fetching GitHub Copilot news...");

    // GitHub Blog URL
    const githubBlogUrl = 'https://github.blog';

    // Fetch GitHub Blog page
    const response = await axios.get(githubBlogUrl);
    const html = response.data;

    // Parse HTML using Cheerio
    const $ = cheerio.load(html);
    const news = [];

    // Fixed the duplicate line here
    $('article').each((index, element) => {
      const title = $(element).find('h2').text().trim();
      const link = $(element).find('a').attr('href');
      const description = $(element).find('p').text().trim();

      if (title.toLowerCase().includes('copilot')) {
        news.push({
          title,
          link: link.startsWith('http') ? link : `${githubBlogUrl}${link}`,
          description,
        });
      }
    });

    if (news.length > 0) {
      console.log("GitHub Copilot News found:");
      news.forEach((item, index) => {
        console.log(`${index + 1}. ${item.title}`);
        console.log(`   Link: ${item.link}`);
        console.log(`   Description: ${item.description}`);
      });
    } else {
      console.log("No GitHub Copilot news found.");
    }

    return news;
  } catch (error) {
    console.error("Error fetching GitHub Copilot news:", error.message);
    throw error;
  }
}

// Run the function
fetchCopilotNews();