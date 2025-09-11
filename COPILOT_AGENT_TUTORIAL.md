# GitHub Copilot Coding Agent Tutorial

A step-by-step guide to enabling and delegating work to GitHub Copilot's autonomous coding agent, including the complete workflow from bug assignment to PR creation.

## 🚀 What is the Coding Agent?

GitHub Copilot's coding agent is an autonomous AI that can:
- Take on GitHub issues independently
- Create feature branches
- Write and modify code
- Run tests and fix failures
- Create pull requests
- Respond to review feedback

The agent works in a secure, cloud-based GitHub Actions environment and can handle low-to-medium complexity tasks in well-tested codebases.

## 📋 Prerequisites

### Required Access
- **GitHub Copilot Enterprise** or **Business** subscription
- **Administrator must enable** the "Copilot coding agent" policy for your organization
- **VS Code 1.99+** or VS Code Insiders

### Required Extensions
- GitHub Copilot extension
- GitHub Pull Requests extension (signed into correct GitHub account)

## ⚙️ Step 1: Enable Agent Mode

### In VS Code Settings

1. **Open Settings**: `Ctrl+,` (Windows/Linux) or `Cmd+,` (Mac)
2. **Search for**: `chat.agent.enabled`
3. **Enable the setting**: Check the box or set to `true`
4. **Enable delegation UI**: Set `githubPullRequests.codingAgent.uiIntegration` to `true`

### Alternative: Settings.json

```json
{
  "chat.agent.enabled": true,
  "githubPullRequests.codingAgent.uiIntegration": true,
  "github.copilot.chat.agent.runTasks": true
}
```

## 🎯 Step 2: Create a GitHub Issue (Example Bug)

We've intentionally added a bug to `src/test-app.js` on line 42. Let's create an issue for it:

### Create the Issue

1. **Go to your GitHub repository**
2. **Click Issues → New Issue**
3. **Title**: `Fix assignment instead of comparison bug in test-app.js`
4. **Description**:
```markdown
## Bug Description
There's a JavaScript assignment bug in `src/test-app.js` line 42 where we're using `=` instead of `===` for comparison.

## Current Behavior
```javascript
if (code = 0) {  // BUG: Assignment instead of comparison
```

## Expected Behavior
Should use strict comparison:
```javascript
if (code === 0) {
```

## Impact
This causes the condition to always evaluate to truthy (except when code is 0), making the success/failure logic incorrect.

## Acceptance Criteria
- [ ] Fix the assignment operator to use strict comparison (`===`)
- [ ] Ensure all tests pass
- [ ] Add a test case to prevent regression
```

5. **Create Issue** and note the issue number (#X)

## 🤖 Step 3: Assign the Issue to Copilot

### Method 1: GitHub Web Interface

1. **Open the issue** you just created
2. **Click "Assignees"** in the right sidebar
3. **Type**: `@copilot` or `github-copilot[bot]`
4. **Select the Copilot bot** from the dropdown
5. **Watch for the 👀 emoji reaction** - this means Copilot accepted the task

### Method 2: GitHub CLI

```bash
gh issue edit [ISSUE_NUMBER] --add-assignee github-copilot[bot]
```

### Method 3: VS Code Chat Delegation

1. **Open Copilot Chat**: `Ctrl+Alt+I` (Windows/Linux) or `Cmd+Option+I` (Mac)
2. **Start a conversation**:
```
I need to fix a JavaScript bug in src/test-app.js line 42. There's an assignment operator (=) being used instead of a comparison operator (===). Can you create a branch, fix this bug, add a test, and open a PR?
```
3. **Click "Delegate to coding agent"** button (if UI integration enabled)

### Method 4: New Agents Panel (GitHub.com)

1. **Visit any page on GitHub.com**
2. **Click the Agents panel** (new feature)
3. **Describe your task**:
```
Fix the JavaScript assignment bug in src/test-app.js line 42 where = should be ===. Create a branch, fix the bug, add a test to prevent regression, and open a PR linked to issue #[NUMBER]
```
4. **Select your repository** and submit

## 📊 Step 4: Monitor Agent Progress

### Track in VS Code

1. **Open Pull Requests view** in VS Code
2. **Look for "Copilot on My Behalf"** query
3. **Click "View Session"** to see play-by-play progress

### Track on GitHub

1. **Check the issue** - Copilot will add comments about its progress
2. **Watch for branch creation** - Usually named like `copilot-fix-[description]`
3. **Monitor for PR creation** - Copilot will link it to the original issue

### What the Agent Does

The agent will:
1. **React with 👀** to acknowledge the assignment
2. **Create a feature branch** from the default branch
3. **Analyze the codebase** and understand the bug
4. **Make the necessary fix** (change `=` to `===`)
5. **Run existing tests** to ensure nothing breaks
6. **Add new test cases** if appropriate
7. **Create a pull request** with detailed description
8. **Link the PR to the original issue**

## 🔧 Step 5: Review and Guide the Agent

### Provide Feedback

If the agent's solution needs adjustments, comment on the PR:

```markdown
@copilot This looks good! Can you also add a JSDoc comment explaining what the code parameter represents?
```

### Common Feedback Patterns

```markdown
@copilot Can you also update the error handling to be more specific?

@copilot Please add unit tests for both success and failure cases.

@copilot The fix looks correct, but can you also check for similar issues in other files?
```

### Agent Will Respond By:
- Making requested changes
- Pushing new commits to the PR branch
- Running tests again
- Commenting with status updates

## ✅ Step 6: Expected Workflow Completion

### What You Should See:

1. **New Branch**: `copilot-fix-assignment-comparison-bug` (or similar)
2. **Fixed Code**:
```javascript
if (code === 0) {  // Fixed: Strict comparison
```

3. **Pull Request** with:
   - Clear title: "Fix assignment operator in test-app.js condition"
   - Detailed description of the change
   - Link to original issue: "Fixes #X"
   - Test results showing green CI

4. **Additional Improvements** might include:
   - Enhanced error handling
   - Added test cases
   - Code comments for clarity

## 🛠️ Troubleshooting

### Agent Doesn't Respond
- Check if Copilot coding agent policy is enabled in your org
- Ensure you have the right subscription (Business/Enterprise)
- Try reassigning the issue

### Agent Gets Stuck
- Add clarifying comments to the issue
- Provide more specific requirements
- Tag `@copilot` in issue comments with additional guidance

### Tests Fail
- The agent will automatically try to fix test failures
- It reads error messages and attempts corrections
- If stuck, provide hints in PR comments

## 💡 Best Practices

### Writing Good Issues for Copilot

```markdown
## Clear Title
Fix [specific problem] in [specific file/location]

## Problem Description
- What's currently happening
- What should happen instead
- Code examples showing the issue

## Acceptance Criteria
- [ ] Specific fix requirements
- [ ] Testing requirements  
- [ ] Documentation needs

## Context
- Any relevant background
- Related files or dependencies
- Performance or compatibility considerations
```

### Effective Agent Communication

✅ **Good**: "Fix the strict comparison bug and add defensive checks"
❌ **Bad**: "Make the code better"

✅ **Good**: "Add unit tests for both success (code=0) and failure (code≠0) paths"
❌ **Bad**: "Add some tests"

### Repository Preparation

- **Maintain good test coverage** - Agent relies on tests for validation
- **Keep clear coding standards** - Use `.github/copilot-instructions.md`
- **Document complex logic** - Helps agent understand context
- **Use conventional commit messages** - Agent follows existing patterns

## 📈 Advanced Usage

### Multi-Issue Workflows

```markdown
@copilot This issue is related to #123 and #124. Please ensure compatibility with the changes made in those PRs.
```

### Custom Agent Instructions

Create `.github/instructions/bugfix.instructions.md`:

```markdown
---
applyTo: "**/*.js"
description: "Bug fix guidelines"
---

When fixing bugs:
1. Always add regression tests
2. Update JSDoc comments if logic changes
3. Check for similar patterns elsewhere in codebase
4. Ensure backward compatibility
5. Add detailed commit messages explaining the fix
```

### Integration with CI/CD

Ensure your repository has:
- Automated testing on PRs
- Linting and formatting checks
- Security scanning
- Code coverage reporting

The agent will wait for CI checks and attempt to fix failures automatically.

## 📊 Monitoring and Analytics

### Usage Tracking

- **Cost**: Each agent session uses one premium request
- **GitHub Actions minutes** are consumed during execution
- **Track usage** via GitHub's Copilot Metrics API

### Success Metrics

Monitor:
- Issue resolution time
- PR quality (review comments, iterations)
- Test coverage improvements
- Code quality improvements

## 🎓 Learning Exercise

Try this workflow with the bug we've added:

1. Create the issue using the template above
2. Assign to `@copilot`
3. Watch the agent work through VS Code or GitHub
4. Provide feedback to refine the solution
5. Merge the PR once satisfied

This hands-on experience will help you understand the agent's capabilities and how to effectively delegate development tasks.

## 🚨 Limitations and Considerations

### What the Agent Handles Well
- Bug fixes in well-understood codebases
- Feature additions with clear requirements
- Test generation and improvement
- Code refactoring with existing test coverage
- Documentation updates

### What to Avoid
- Complex architectural changes
- Security-critical modifications without review
- Large-scale migrations
- Business logic without clear specifications
- Critical production hotfixes (review first!)

### Security Considerations
- Agent runs in secure GitHub Actions environment
- No direct access to production systems
- All changes go through normal PR review process
- Audit logs available for enterprise customers

---

## 🎯 Next Steps

1. **Practice** with simple bugs and features
2. **Create templates** for common issue types
3. **Train your team** on effective agent communication
4. **Monitor results** and refine your process
5. **Scale up** to more complex tasks as you build confidence

The GitHub Copilot coding agent represents a significant step toward autonomous development assistance. By following this tutorial, you'll be able to effectively delegate routine development tasks and focus on higher-level architecture and product decisions.