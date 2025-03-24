# GitHub Copilot Prompt Examples

These prompt examples can help you get better results from GitHub Copilot by structuring your requests effectively.

## Coding Prompts

### Function Generation

```
/**
 * Create a function that validates a password with the following requirements:
 * - At least 8 characters
 * - At least one uppercase letter
 * - At least one lowercase letter
 * - At least one number
 * - At least one special character
 * - No spaces
 * @param {string} password - The password to validate
 * @returns {boolean} - Whether the password is valid
 */
```

### Code Explanation Request

```
// Explain what this code does:
const memoize = (fn) => {
  const cache = {};
  return (...args) => {
    const key = JSON.stringify(args);
    if (key in cache) {
      return cache[key];
    }
    const result = fn(...args);
    cache[key] = result;
    return result;
  };
};
```

### Test Generation

```
// Generate unit tests for this function:
function calculateTotalPrice(items, taxRate) {
  const subtotal = items.reduce((sum, item) => sum + item.price * item.quantity, 0);
  const tax = subtotal * taxRate;
  return subtotal + tax;
}
```

### Bug Fix Request

```
// This function has a bug. It should return the nth Fibonacci number:
function fibonacci(n) {
  if (n <= 0) return 0;
  if (n == 1) return 1;
  return fibonacci(n) + fibonacci(n - 1);
}
// Fix the bug and explain what was wrong.
```

## Language-Specific Templates

### Node.js Example

```
/**
 * Create an Express.js REST API endpoint that:
 * - Accepts POST requests to /api/users
 * - Validates that the request body has email and password fields
 * - Returns a 400 error if validation fails
 * - Creates a new user in the database if validation passes
 * - Returns the created user with a 201 status code
 */
```

### Python Example

```
# Create a Python function that:
# 1. Reads a CSV file
# 2. Filters rows based on a specified column value
# 3. Groups the data by another column
# 4. Calculates the sum and average for a numeric column within each group
# 5. Returns the results as a dictionary
```

### SQL Example

```
-- Create an SQL query that:
-- 1. Shows total sales per product category 
-- 2. For the last 30 days
-- 3. Only for customers with more than 5 purchases
-- 4. Sorted by total sales descending
```

## Additional Tips

1. Use detailed comments to describe exactly what you want
2. Include specific requirements or constraints
3. Provide context by describing the problem you're solving
4. Include examples of expected input/output when appropriate
5. Break complex requests into smaller, focused prompts 