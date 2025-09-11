# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

This is a teaching and learning repository for GitHub Copilot for Developers O'Reilly Live Training sessions. It contains course materials, example code, and resources for learning GitHub Copilot features and best practices.

## Key Commands

### Node.js Application (src directory)
```bash
# Install dependencies
cd src && npm install

# Run the Copilot Tips console application
cd src && npm start

# Run tests
cd src && npm test

# Run tests with watch mode
cd src && npm run test:watch

# Run tests with coverage
cd src && npm run test:coverage
```

## Repository Architecture

### Course Structure
The repository is organized around teaching GitHub Copilot with the following key areas:

- **`/modules`** - Core course content divided into progressive learning modules
- **`/exercises`** - Hands-on practice exercises for skill development
- **`/examples`** - Code samples demonstrating Copilot features across languages
- **`/docs`** - Course documentation and setup guides
- **`/exam-metadata`** - GitHub Copilot certification exam objectives and preparation materials

### Application Code
- **`/src`** - Sample Node.js console application demonstrating Copilot tips
  - Uses Jest for testing framework
  - Interactive CLI built with Inquirer.js
  - Visual output using Chalk and Boxen

### GitHub Configuration
- **`.github/copilot-instructions.md`** - Custom Copilot instructions emphasizing:
  - Azure cloud architecture patterns
  - Security-first development (OWASP, zero-trust)
  - Test-driven development practices
  - GitHub Enterprise features
  - Infrastructure as Code (Bicep, ARM, Terraform)

## Development Context

When assisting with this repository:

1. **Teaching Focus** - Code examples should be clear and educational, demonstrating best practices for using GitHub Copilot
2. **Security Emphasis** - Follow the security-first mindset outlined in the copilot instructions
3. **Test Coverage** - Ensure any new code includes appropriate Jest tests when working in the `/src` directory
4. **Azure Integration** - Consider Azure cloud patterns when relevant to examples
5. **Documentation** - Maintain clear documentation for learning purposes

## Important Notes

- This is primarily a teaching repository, not a production application
- The `/src` directory contains a demonstration Node.js app for teaching debugging and testing with Copilot
- Multiple subdirectories contain various practice projects and examples from different training sessions
- Focus on educational clarity when modifying or adding code examples