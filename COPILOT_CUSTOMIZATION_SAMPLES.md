# GitHub Copilot Customization Samples

This file contains teaching examples of various GitHub Copilot customization files including instructions, prompts, and agent configurations. These are JavaScript/Node.js-oriented examples designed for the GitHub Copilot training repository.

## 📁 Repository-wide Instructions
**File:** `.github/copilot-instructions.md`

```markdown
# GitHub Copilot Instructions

You are assisting with a JavaScript/Node.js teaching repository for GitHub Copilot training.

## Code Style
- Use ES6+ syntax (arrow functions, async/await, destructuring)
- Prefer const over let, avoid var
- Use descriptive variable names (e.g., `userProfile` not `up`)
- Add JSDoc comments for all functions
- Follow Airbnb JavaScript style guide

## Testing
- Write Jest tests for all new functions
- Include both positive and negative test cases
- Aim for 80% code coverage minimum
- Use descriptive test names: `should return formatted date when valid input provided`

## Error Handling
- Always use try-catch with async/await
- Provide meaningful error messages
- Log errors with appropriate context
- Never expose sensitive data in error messages

## Node.js Specifics
- Use native ES modules when possible
- Prefer built-in Node.js modules over external dependencies
- Handle async operations properly
- Always validate user input
```

## 📁 Path-scoped Instructions
**File:** `.github/instructions/frontend.instructions.md`

```markdown
---
applyTo: "src/frontend/**/*.{js,jsx,ts,tsx}"
description: "React and frontend-specific instructions"
---

# Frontend Development Instructions

## React Components
- Use functional components with hooks
- Implement proper prop validation with PropTypes or TypeScript
- Keep components small and focused (single responsibility)
- Use custom hooks for shared logic

## State Management
- Use React Context for global state
- Implement useReducer for complex state logic
- Avoid prop drilling - use composition instead

## Styling
- Use CSS modules or styled-components
- Follow BEM naming convention for classes
- Ensure responsive design with mobile-first approach

## Example Component Structure:
```javascript
import React, { useState, useEffect } from 'react';
import PropTypes from 'prop-types';
import styles from './Component.module.css';

const Component = ({ title, onAction }) => {
  const [data, setData] = useState(null);
  
  useEffect(() => {
    // Effect logic here
  }, []);
  
  return (
    <div className={styles.container}>
      <h2>{title}</h2>
      {/* Component content */}
    </div>
  );
};

Component.propTypes = {
  title: PropTypes.string.isRequired,
  onAction: PropTypes.func
};

export default Component;
```

**File:** `.github/instructions/api.instructions.md`

```markdown
---
applyTo: "src/api/**/*.{js,ts}, src/routes/**/*.{js,ts}"
description: "API and backend route instructions"
---

# API Development Instructions

## Express Routes
- Use async middleware with proper error handling
- Implement input validation using Joi or express-validator
- Return consistent response format
- Use appropriate HTTP status codes

## Security
- Implement rate limiting
- Sanitize all user inputs
- Use helmet.js for security headers
- Never expose internal error details

## Response Format:
```javascript
// Success response
{
  "success": true,
  "data": {},
  "message": "Operation successful"
}

// Error response
{
  "success": false,
  "error": {
    "code": "ERROR_CODE",
    "message": "User-friendly error message"
  }
}
```

## Example Route:
```javascript
router.post('/users', 
  validateInput(userSchema),
  rateLimiter,
  async (req, res, next) => {
    try {
      const user = await userService.create(req.body);
      res.status(201).json({
        success: true,
        data: user,
        message: 'User created successfully'
      });
    } catch (error) {
      next(error);
    }
  }
);
```

**File:** `.github/instructions/tests.instructions.md`

```markdown
---
applyTo: "**/*.test.{js,ts}, **/*.spec.{js,ts}, tests/**/*.{js,ts}"
description: "Testing guidelines and patterns"
---

# Testing Instructions

## Jest Test Structure
- Use describe blocks for grouping related tests
- Implement beforeEach/afterEach for setup and cleanup
- Mock external dependencies
- Test edge cases and error conditions

## Test Naming Convention:
```javascript
describe('ComponentName', () => {
  describe('methodName', () => {
    it('should return expected value when valid input provided', () => {
      // Test implementation
    });
    
    it('should throw error when invalid input provided', () => {
      // Test implementation
    });
  });
});
```

## Coverage Requirements:
- Functions: 80% minimum
- Branches: 75% minimum
- Lines: 80% minimum
- Statements: 80% minimum

## Mocking Example:
```javascript
jest.mock('../services/userService');

const mockUserService = require('../services/userService');
mockUserService.findById.mockResolvedValue({ id: 1, name: 'Test User' });
```

## 📁 Prompt Files
**File:** `.github/prompts/component-generator.prompt.md`

```markdown
---
mode: 'agent'
model: 'GPT-4o'
tools: ['githubRepo', 'codebase']
description: 'Generate a new React component with tests'
---

# Generate React Component

Create a new React functional component with the following requirements:

## Component Details:
- Name: ${componentName}
- Location: src/components/${componentName}
- Props: ${props}
- Purpose: ${purpose}

## Requirements:
1. Create the component file (${componentName}.jsx)
2. Add PropTypes validation
3. Create a CSS module (${componentName}.module.css)
4. Generate unit tests (${componentName}.test.js)
5. Add JSDoc documentation
6. Include accessibility attributes (ARIA labels)
7. Make it responsive and mobile-friendly

## Component Should Include:
- Error boundary handling
- Loading states if async data
- Proper event handler naming (handleClick, handleSubmit)
- Memoization where appropriate (React.memo, useMemo)

## Test Coverage:
- Test all props variations
- Test user interactions
- Test error states
- Test accessibility

Please follow the coding standards in our copilot-instructions.md file.
```

**File:** `.github/prompts/api-endpoint.prompt.md`

```markdown
---
mode: 'agent'
model: 'Claude-3.5-Sonnet'
tools: ['codebase', 'terminal']
description: 'Create a new REST API endpoint'
---

# Create REST API Endpoint

Generate a new REST API endpoint with complete implementation:

## Endpoint Details:
- Method: ${method}
- Path: ${path}
- Purpose: ${purpose}
- Authentication: ${authRequired}

## Implementation Requirements:
1. Create route handler in src/routes/${resource}.js
2. Implement service layer in src/services/${resource}Service.js
3. Add data model in src/models/${resource}.js
4. Create validation schema using Joi
5. Add integration tests
6. Update API documentation

## Include These Features:
- Input validation middleware
- Error handling middleware
- Rate limiting
- Request logging
- Response caching (if applicable)
- Database transaction handling

## Security Considerations:
- SQL injection prevention
- XSS protection
- CSRF token validation (for state-changing operations)
- Proper authentication/authorization checks

## Generate:
```javascript
// Route definition
router.${method.toLowerCase()}('${path}',
  authenticate,
  validateInput(${resource}Schema),
  rateLimiter,
  async (req, res, next) => {
    // Implementation
  }
);
```

Run tests after creation to ensure everything works.
```

**File:** `.github/prompts/code-review.prompt.md`

```markdown
---
mode: 'edit'
model: 'GPT-4o'
description: 'Perform comprehensive code review'
---

# Code Review Checklist

Review the selected code for the following aspects:

## Code Quality
- [ ] Clean, readable, and maintainable code
- [ ] DRY principle followed (no unnecessary duplication)
- [ ] SOLID principles applied where appropriate
- [ ] Appropriate naming conventions used
- [ ] Code complexity is manageable (cyclomatic complexity < 10)

## JavaScript/Node.js Specific
- [ ] Proper async/await usage without blocking
- [ ] Memory leaks prevented (event listeners cleaned up)
- [ ] Promises handled correctly (no unhandled rejections)
- [ ] ES6+ features used appropriately
- [ ] Dependencies up to date and necessary

## Security
- [ ] No hardcoded secrets or credentials
- [ ] Input validation implemented
- [ ] SQL injection prevention
- [ ] XSS protection in place
- [ ] Authentication/authorization checks

## Performance
- [ ] Database queries optimized (indexes, pagination)
- [ ] Caching implemented where beneficial
- [ ] Unnecessary re-renders prevented (React)
- [ ] Bundle size optimized
- [ ] Lazy loading implemented

## Testing
- [ ] Unit tests present and passing
- [ ] Edge cases covered
- [ ] Mocks used appropriately
- [ ] Test coverage adequate (>80%)

## Documentation
- [ ] Functions have JSDoc comments
- [ ] Complex logic explained
- [ ] README updated if needed
- [ ] API documentation current

Provide specific suggestions for improvements with code examples.
```

**File:** `.github/prompts/debug-assistant.prompt.md`

```markdown
---
mode: 'agent'
model: 'Claude-3.5-Sonnet'
tools: ['terminal', 'codebase', 'diagnostics']
description: 'Debug and fix issues in JavaScript/Node.js code'
---

# Debug Assistant

Help me debug and fix the following issue:

## Error Information:
- Error message: ${errorMessage}
- File: ${fileName}
- Line number: ${lineNumber}
- Stack trace: ${stackTrace}

## Investigation Steps:
1. Analyze the error message and stack trace
2. Check the code at the specified location
3. Look for common JavaScript pitfalls:
   - Undefined/null references
   - Async/await issues
   - Type coercion problems
   - Scope issues
   - Event loop blocking

## Debugging Actions:
1. Add console.log statements for variable inspection
2. Check function parameters and return values
3. Verify async operation handling
4. Review recent changes (git diff)
5. Run relevant tests in isolation

## Common Node.js Issues to Check:
- Unhandled promise rejections
- Memory leaks from event listeners
- Circular dependencies
- Module resolution issues
- Environment variable problems

## Fix Strategy:
1. Identify root cause
2. Implement fix with minimal changes
3. Add error handling if missing
4. Write test to prevent regression
5. Update documentation if needed

After fixing, run the test suite to ensure no regressions.
```

## 📁 Agent Configuration
**File:** `AGENTS.md`

```markdown
# GitHub Copilot Agent Configuration

This file configures the GitHub Copilot coding agent for this repository.

## Development Workflow

When working on new features:
1. Create a feature branch
2. Write tests first (TDD approach)
3. Implement the feature
4. Ensure all tests pass
5. Update documentation
6. Create pull request with detailed description

## Automated Tasks

### Before Each Task:
- Check for uncommitted changes
- Pull latest from main branch
- Install/update dependencies if package.json changed

### After Code Generation:
- Run linter (ESLint)
- Run formatter (Prettier)
- Run tests (Jest)
- Check test coverage

### On Test Failure:
- Read error output carefully
- Fix the specific failing test
- Re-run entire test suite
- Do not proceed until all tests pass

## Code Generation Preferences

### For New Files:
- Add file header with purpose and author
- Include appropriate license header
- Create corresponding test file
- Update index exports if applicable

### For Modifications:
- Preserve existing code style
- Maintain backward compatibility
- Update related tests
- Add migration notes if breaking changes

## Testing Strategy

### Unit Tests:
- Test individual functions in isolation
- Mock all external dependencies
- Cover edge cases and error conditions
- Aim for 80% coverage minimum

### Integration Tests:
- Test API endpoints end-to-end
- Use test database
- Clean up test data after each test
- Test both success and failure scenarios

## Common Commands

```bash
# Development
npm run dev          # Start development server
npm run build        # Build for production
npm run lint         # Run ESLint
npm run format       # Run Prettier

# Testing
npm test            # Run all tests
npm run test:watch  # Run tests in watch mode
npm run test:coverage # Generate coverage report

# Git Workflow
git status          # Check current status
git add .           # Stage changes
git commit -m ""    # Commit with message
git push            # Push to remote
```

## Error Recovery

If the agent encounters an error:
1. Save the error message
2. Rollback any partial changes
3. Analyze the root cause
4. Attempt alternative approach
5. Ask for user guidance if stuck

## Performance Considerations

- Prefer native Node.js modules over external packages
- Implement pagination for large datasets
- Use caching for frequently accessed data
- Optimize database queries with proper indexing
- Implement rate limiting for public APIs
```

## 📁 VS Code MCP Configuration
**File:** `.vscode/mcp.json`

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "${env:GITHUB_TOKEN}"
      }
    },
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "path/to/allowed/directory"]
    },
    "postgres": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-postgres",
        "postgresql://localhost/copilot_demo"
      ]
    }
  }
}
```

## 📁 Knowledge Base Reference
**File:** `.github/KB_REFERENCE.md`

```markdown
# Knowledge Base Usage Guide

## Available Knowledge Bases

### @knowledge-base:javascript-patterns
Contains best practices and design patterns for JavaScript development

### @knowledge-base:copilot-training
Training materials and exercises for GitHub Copilot

### @knowledge-base:api-documentation
API documentation and integration guides

## How to Reference in Chat

```
@knowledge-base:javascript-patterns How do I implement the Observer pattern?
```

```
Using @knowledge-base:api-documentation, explain the user authentication flow
```

## Creating New Knowledge Bases

1. Go to GitHub.com → Settings → Copilot → Knowledge bases
2. Click "New knowledge base"
3. Add repositories (max 20)
4. Add documentation sources
5. Name it descriptively
6. Use in VS Code with @knowledge-base:name
```

## Usage Tips

- These files work together to provide comprehensive AI assistance
- Customize based on your team's specific needs
- Version control all configuration files
- Review and update regularly as patterns evolve
- Share with team for consistency