# Exercise: Basic Coding with GitHub Copilot

## Objective
Learn how to interact with GitHub Copilot through basic prompts and understand its suggestion system.

## Prerequisites
- GitHub Copilot configured in your IDE
- Basic Python knowledge

## Time Estimate
15-20 minutes

## Instructions

### Step 1: Basic Function Creation
1. Create a new file called `calculator.py`
2. Type a comment describing a function to add two numbers
3. Let Copilot suggest the implementation and press Tab to accept
4. Repeat for a function to multiply two numbers
5. Add input validation by commenting about validating inputs

### Step 2: Documentation Generation
1. Position your cursor above one of your functions
2. Type `"""` and let Copilot suggest documentation
3. Accept or modify the suggestions to ensure:
   - Parameters and return types are documented
   - Usage examples are included in the docstring

### Step 3: Test Case Creation
1. At the bottom of your file, add a comment: `# Test cases for the calculator functions`
2. Let Copilot suggest test code
3. Add comments describing edge cases you want to test
4. Allow Copilot to generate tests for these cases

### Step 4: Error Handling
1. Add comments about improving error handling in your functions
2. Let Copilot suggest error handling code
3. Implement appropriate error messages and handling

## Expected Outcome
You should have a calculator.py file with:
- Well-documented functions with proper docstrings
- Comprehensive error handling
- A complete test suite
- Code that follows Python best practices

## Tips
- Start with clear comments describing what you want
- Use natural language in your comments
- Try different variations of prompts if the first suggestion isn't ideal
- Use Tab to accept suggestions, Esc to dismiss them

## Challenge (Optional)
Add more calculator functions:
- Division with zero handling
- Power function with validation
- Square root with domain validation 