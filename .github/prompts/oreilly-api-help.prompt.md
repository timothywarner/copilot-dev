---
agent: ask
model: Claude Sonnet 4
description: 'Get help finding the right GitHub REST or GraphQL API endpoint for your goal'
argument-hint: 'Describe what you want to do programmatically (e.g., "list open PRs", "create an issue", "get org members")'
---

I want to help you find and use the right GitHub API endpoint for your goal.

## Tell me what you're trying to accomplish

If you haven't already described your goal, please share it now. For example:

- "I want to list all open pull requests in a repository"
- "I want to create a GitHub Issue via the API"
- "I want to fetch all members of a GitHub organization"

---

## What I'll provide

For your goal, I'll give you:

### 1. The recommended endpoint

I'll tell you whether to use the **GitHub REST API** or **GitHub GraphQL API** and explain why, then give you the full endpoint path.

**REST API** is best for:

- Simple CRUD operations on a single resource
- When you don't need fine-grained field selection
- Webhooks, Actions, and most automation tasks

**GraphQL API** is best for:

- Fetching related data in a single request (e.g., PR + reviews + comments)
- Reducing over-fetching when only a few fields are needed
- Complex queries across multiple resource types

### 2. Working curl examples

**REST example (listing open pull requests):**

```bash
# Using a Personal Access Token (classic)
curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "https://api.github.com/repos/OWNER/REPO/pulls?state=open&per_page=30"
```

**GraphQL example (same data, fewer round trips):**

```bash
curl -H "Authorization: bearer YOUR_TOKEN" \
     -H "Content-Type: application/json" \
     -X POST \
     -d '{"query": "{ repository(owner: \"OWNER\", name: \"REPO\") { pullRequests(states: OPEN, first: 30) { nodes { number title author { login } createdAt } } } }"}' \
     https://api.github.com/graphql
```

### 3. Authentication options

| Method | Best for | How to use |
|--------|----------|------------|
| **Personal Access Token (classic)** | Personal scripts, local tools | `Authorization: Bearer ghp_...` |
| **Fine-grained PAT** | Scoped access to specific repos | `Authorization: Bearer github_pat_...` |
| **GitHub App + Installation Token** | Production apps, CI/CD | Exchange JWT for installation token |
| **OAuth App** | Third-party integrations | OAuth 2.0 flow, user-delegated scopes |
| **GITHUB_TOKEN** | GitHub Actions workflows | Available automatically in Actions env |

For GitHub Actions, use the built-in `GITHUB_TOKEN`:

```yaml
- name: Call GitHub API
  env:
    GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
  run: |
    gh api repos/${{ github.repository }}/pulls --jq '.[].title'
```

### 4. Rate limits to know

| Tier | REST limit | GraphQL limit |
|------|-----------|---------------|
| Unauthenticated | 60 req/hour | Not available |
| Authenticated (PAT) | 5,000 req/hour | 5,000 points/hour |
| GitHub App | 15,000 req/hour | 15,000 points/hour |
| GITHUB_TOKEN in Actions | 1,000 req/hour per repo | Same |

**Check your remaining rate limit:**

```bash
curl -H "Authorization: Bearer YOUR_TOKEN" \
     https://api.github.com/rate_limit
```

**Handle rate limits gracefully:**

```bash
# Check X-RateLimit-Remaining header; if 0, check X-RateLimit-Reset (Unix timestamp)
curl -I -H "Authorization: Bearer YOUR_TOKEN" \
     https://api.github.com/repos/OWNER/REPO/issues
```

### 5. Pagination

GitHub REST API uses link headers for pagination. Always page through results:

```bash
# Get page 2 with 100 items per page
curl -H "Authorization: Bearer YOUR_TOKEN" \
     "https://api.github.com/repos/OWNER/REPO/issues?per_page=100&page=2"

# Or use the gh CLI which handles pagination automatically
gh api --paginate repos/OWNER/REPO/issues --jq '.[].title'
```

### 6. Useful docs references

- REST API reference: https://docs.github.com/en/rest
- GraphQL API reference: https://docs.github.com/en/graphql
- GraphQL Explorer (interactive): https://docs.github.com/en/graphql/overview/explorer
- `gh` CLI (wraps the API): https://cli.github.com/manual/gh_api

---

Now describe your goal and I'll give you the exact endpoint, a working example, and any gotchas specific to your use case.
