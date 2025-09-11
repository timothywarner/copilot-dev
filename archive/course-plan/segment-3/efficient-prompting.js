/**
 * This file demonstrates efficient prompting techniques for GitHub Copilot
 * 
 * TECHNIQUE 1: Descriptive function naming
 * Simply naming your function descriptively can guide Copilot's suggestions
 */
function sortArrayOfObjectsByProperty(array, property) {
  // Copilot will likely suggest an implementation like:
  return array.sort((a, b) => {
    if (a[property] < b[property]) return -1;
    if (a[property] > b[property]) return 1;
    return.0;
  });
}

/**
 * TECHNIQUE 2: Detailed comments and specification
 * Adding detailed specifications helps Copilot generate better code
 */
// Create a function that validates an email address with the following requirements:
// - Must contain a single @ symbol
// - Must have a valid domain with at least one period
// - Cannot contain spaces
// - Must be between 5 and 255 characters
function validateEmail(email) {
  // Copilot will suggest implementation here
}

/**
 * TECHNIQUE 3: Starting implementation and letting Copilot complete
 * Start writing code and let Copilot finish the pattern
 */
function fetchUserData(userId) {
  return fetch(`/api/users/${userId}`)
    .then(response => {
      // Copilot will continue with error handling and response parsing
    })
    // Copilot will add appropriate catch and error handling
}

/**
 * TECHNIQUE 4: Tests first approach
 * Write tests first and let Copilot implement the function
 */
// Function to implement: calculateDiscountedPrice
// Should apply the given discount percentage to the price

// Test cases:
test('calculateDiscountedPrice applies 10% discount correctly', () => {
  expect(calculateDiscountedPrice(100, 10)).toBe(90);
});

test('calculateDiscountedPrice handles 0% discount', () => {
  expect(calculateDiscountedPrice(50, 0)).toBe(50);
});

test('calculateDiscountedPrice applies maximum 100% discount', () => {
  expect(calculateDiscountedPrice(75, 110)).toBe(0);
});

// Copilot will likely suggest implementation of calculateDiscountedPrice here

/**
 * TECHNIQUE 5: Using JSDoc comments for typed suggestions
 * Providing type information helps Copilot generate better code
 */
/**
 * @typedef {Object} Product
 * @property {string} id - Unique product identifier
 * @property {string} name - Product name
 * @property {number} price - Product price
 * @property {string[]} categories - Product categories
 */

/**
 * Filters products by a specific category
 * @param {Product[]} products - Array of product objects
 * @param {string} category - Category to filter by
 * @returns {Product[]} Filtered product array
 */
function filterProductsByCategory(products, category) {
  // Copilot will suggest implementation with proper typing
} 