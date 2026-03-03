/**
 * refactored-example.js
 *
 * The "AFTER" version of legacy-example.js, produced by applying the
 * legacy-code-refactor skill's five-step methodology.
 *
 * Every change is annotated with a REFACTORED comment explaining:
 *  - What changed
 *  - Why it is an improvement
 *
 * Anti-patterns fixed:
 *  [1] var → const/let throughout
 *  [2] Callback hell → async/await (linear, readable flow)
 *  [3] Prototype pattern → ES2022 class with private fields (#)
 *  [4] Magic numbers → named constants at the top of the file
 *  [5] String concatenation → template literals
 *  [6] == → === in all comparisons
 *  [7] No error handling → try/catch on every await
 *  [8] Mixed concerns → separate validateOrder, computeTotals, formatSummary functions
 *  [9] Global mutable state → encapsulated in a class / passed as parameters
 */

// =============================================================================
// [4] REFACTORED: Magic numbers → named constants.
// All business rules are visible and centralized here.
// =============================================================================

/** One hour expressed in milliseconds — used for session expiry. */
const MS_PER_HOUR = 60 * 60 * 1000;

/** Minimum order subtotal (in dollars) to qualify for a bulk discount. */
const BULK_DISCOUNT_THRESHOLD = 500;

/** Bulk discount rate applied when subtotal exceeds the threshold. */
const BULK_DISCOUNT_RATE = 0.10; // 10%

/** Sales tax rate — US Pacific region default. Change per deployment target. */
const TAX_RATE = 0.08; // 8%

/** Order count above which a customer is classified as "gold" tier. */
const GOLD_TIER_ORDER_COUNT = 10;

// =============================================================================
// [3] REFACTORED: Prototype "class" → ES2022 class with private fields.
// Private fields (#) prevent external code from accidentally mutating state.
// =============================================================================

class UserSession {
  // [3] REFACTORED: Private fields replace public this.x assignments
  #userId;
  #role;
  #createdAt;
  #lastActivity;

  constructor(userId, role) {
    this.#userId = userId;
    this.#role = role;
    this.#createdAt = Date.now();
    this.#lastActivity = Date.now();
  }

  /** Update the last activity timestamp. Call this on every authenticated request. */
  touch() {
    // [1] REFACTORED: no var; assignment to private field is safe
    this.#lastActivity = Date.now();
  }

  /** Returns true if the session has been inactive for more than one hour. */
  isExpired() {
    // [4] REFACTORED: MS_PER_HOUR replaces the opaque magic number 3600000
    return (Date.now() - this.#lastActivity) > MS_PER_HOUR;
  }

  /**
   * Returns true if this session has the given role.
   * @param {string} requiredRole
   */
  hasPermission(requiredRole) {
    // [6] REFACTORED: === replaces == — no accidental type coercion
    return this.#role === requiredRole;
  }

  /** [5] REFACTORED: Template literal replaces string concatenation. */
  toString() {
    return `UserSession[${this.#userId}, role=${this.#role}]`;
  }

  // Expose read-only getters instead of public properties
  get userId() { return this.#userId; }
  get role() { return this.#role; }
  get createdAt() { return this.#createdAt; }
}

// =============================================================================
// [9] REFACTORED: Global mutable state → encapsulated in a Map passed in,
// or managed by a dedicated cache service.
// =============================================================================

// [9] REFACTORED: userCache is no longer a module-level global.
// Pass a Map instance explicitly so tests can inject a clean state each run.

/**
 * Load all data needed for a user's dashboard.
 *
 * @param {string} userId - The user's unique identifier
 * @param {Map<string, object>} cache - In-memory user cache (injected for testability)
 * @returns {Promise<{user, orders, stats, totalOrders, customerTier}>}
 * @throws {Error} If any database operation fails
 */
async function loadUserDashboard(userId, cache = new Map()) {
  // [2] REFACTORED: Callback hell → three sequential awaits (linear, no nesting).
  // Error handling is now centralized in one try/catch block.
  // [7] REFACTORED: All awaits wrapped in try/catch.

  let user;
  try {
    user = await db.findUser(userId);
  } catch (error) {
    // [5] REFACTORED: Template literal
    throw new Error(`Failed to load user ${userId}: ${error.message}`);
  }

  // [9] REFACTORED: Update the injected cache, not a module-level global
  cache.set(userId, user);

  let orders;
  try {
    orders = await db.findOrders(user.id);
  } catch (error) {
    throw new Error(`Failed to load orders for user ${userId}: ${error.message}`);
  }

  let stats;
  try {
    stats = await db.getOrderStats(orders);
  } catch (error) {
    throw new Error(`Failed to load stats for user ${userId}: ${error.message}`);
  }

  // [4] REFACTORED: GOLD_TIER_ORDER_COUNT replaces magic number 10
  const customerTier = orders.length > GOLD_TIER_ORDER_COUNT ? 'gold' : 'standard';

  // [8] REFACTORED: Response construction is separated from data fetching.
  // Return an immutable result object — never mutate the database entities.
  return {
    user,
    orders,
    stats,
    totalOrders: orders.length,
    customerTier,
  };
}

// =============================================================================
// [7] REFACTORED: No error handling → try/catch on every await.
// =============================================================================

/**
 * Fetch a user's external profile from the third-party API.
 *
 * @param {string} userId
 * @returns {Promise<object>} The user's external profile data
 * @throws {Error} If the network request fails or the API returns a non-2xx status
 */
async function fetchExternalProfile(userId) {
  // [1] REFACTORED: var → const
  // [5] REFACTORED: template literal replaces string concatenation
  let response;
  try {
    response = await fetch(`https://api.example.com/profiles/${userId}`);
  } catch (networkError) {
    throw new Error(`Network error fetching profile for user ${userId}: ${networkError.message}`);
  }

  // [7] REFACTORED: Check HTTP status — response.json() succeeds even on 404
  if (!response.ok) {
    throw new Error(`External profile API returned ${response.status} for user ${userId}`);
  }

  try {
    return await response.json();
  } catch (parseError) {
    throw new Error(`Invalid JSON in profile response for user ${userId}: ${parseError.message}`);
  }
}

// =============================================================================
// [8] REFACTORED: Mixed concerns → three separate functions,
// each with a single responsibility.
// =============================================================================

/**
 * Compute the financial totals for an order.
 * Pure function — no side effects, same inputs always produce same outputs.
 *
 * @param {Array<{price: number, quantity: number}>} items - Line items
 * @returns {{subtotal: number, discount: number, tax: number, total: number}}
 */
function computeOrderTotals(items) {
  // [1] REFACTORED: var i, var subtotal → const/let with for...of
  const subtotal = items.reduce(
    (acc, item) => acc + item.price * item.quantity,
    0,
  );

  // [4] REFACTORED: Named constants replace magic numbers 500 and 0.1
  const discount = subtotal > BULK_DISCOUNT_THRESHOLD
    ? subtotal * BULK_DISCOUNT_RATE
    : 0;

  // [4] REFACTORED: Named constant TAX_RATE replaces 0.08
  const tax = (subtotal - discount) * TAX_RATE;
  const total = subtotal - discount + tax;

  return { subtotal, discount, tax, total };
}

/**
 * Format order totals as a human-readable summary string.
 *
 * @param {{subtotal: number, discount: number, tax: number, total: number}} totals
 * @returns {string}
 */
function formatOrderSummary(totals) {
  // [5] REFACTORED: Template literal + toFixed(2) for proper currency formatting
  return `Order total: $${totals.total.toFixed(2)} (includes $${totals.tax.toFixed(2)} tax)`;
}

/**
 * Process an order: compute totals and attach a formatted summary.
 * Composes computeOrderTotals and formatOrderSummary.
 *
 * @param {{items: Array<{price: number, quantity: number}>}} order
 * @returns {{subtotal, discount, tax, total, summary: string}}
 */
function processOrderTotal(order) {
  // [8] REFACTORED: Delegates to single-responsibility helpers
  const totals = computeOrderTotals(order.items);
  const summary = formatOrderSummary(totals);

  // Immutable return — spread the totals and add summary
  return { ...totals, summary };
}

// =============================================================================
// [1] REFACTORED: CommonJS module.exports → ES module named exports.
// Consistent with modern Node.js (>=12 with "type": "module") and bundlers.
// =============================================================================

export {
  UserSession,
  loadUserDashboard,
  fetchExternalProfile,
  processOrderTotal,
  // Also export helpers so they can be tested in isolation
  computeOrderTotals,
  formatOrderSummary,
};

// =============================================================================
// Jest test stub — verifies behavior was preserved during refactoring.
// Paste into refactored-example.test.js to run.
// =============================================================================

/*
import { describe, it, expect, vi, beforeEach } from 'vitest';
import {
  UserSession,
  computeOrderTotals,
  formatOrderSummary,
  processOrderTotal,
  fetchExternalProfile,
} from './refactored-example.js';

// These tests verify behavior was preserved during refactoring.

describe('UserSession', () => {
  it('reports as not expired when just created', () => {
    const session = new UserSession('user-1', 'admin');
    expect(session.isExpired()).toBe(false);
  });

  it('hasPermission returns true for matching role', () => {
    const session = new UserSession('user-1', 'admin');
    expect(session.hasPermission('admin')).toBe(true);
  });

  it('hasPermission returns false for non-matching role (no type coercion)', () => {
    const session = new UserSession('user-1', 'admin');
    expect(session.hasPermission('user')).toBe(false);
    // This would have been true with == due to coercion in the legacy version
    expect(session.hasPermission(0)).toBe(false);
  });
});

describe('computeOrderTotals', () => {
  it('computes subtotal correctly', () => {
    const items = [{ price: 10, quantity: 2 }, { price: 5, quantity: 4 }];
    const { subtotal } = computeOrderTotals(items);
    expect(subtotal).toBe(40);
  });

  it('applies 10% discount when subtotal exceeds $500', () => {
    const items = [{ price: 300, quantity: 2 }];
    const { subtotal, discount } = computeOrderTotals(items);
    expect(subtotal).toBe(600);
    expect(discount).toBeCloseTo(60);
  });

  it('applies no discount when subtotal is exactly $500', () => {
    const items = [{ price: 500, quantity: 1 }];
    const { discount } = computeOrderTotals(items);
    expect(discount).toBe(0);
  });
});

describe('fetchExternalProfile', () => {
  it('throws an error when fetch fails with a network error', async () => {
    vi.stubGlobal('fetch', vi.fn().mockRejectedValue(new Error('Connection refused')));
    await expect(fetchExternalProfile('user-1')).rejects.toThrow('Network error');
  });

  it('throws an error when the API returns a non-2xx status', async () => {
    vi.stubGlobal('fetch', vi.fn().mockResolvedValue({ ok: false, status: 404 }));
    await expect(fetchExternalProfile('user-1')).rejects.toThrow('404');
  });
});
*/
