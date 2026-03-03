/**
 * legacy-example.js
 *
 * A realistic legacy JavaScript file that intentionally contains classic
 * anti-patterns from pre-ES2015 / early Node.js codebases.
 *
 * This file is the "BEFORE" snapshot — use it to demonstrate the
 * legacy-code-refactor skill in a live training session.
 *
 * Anti-patterns present:
 *  - var declarations throughout
 *  - Callback hell (nested callbacks 3 levels deep)
 *  - Prototype-based "class" pattern
 *  - Magic numbers with no names
 *  - String concatenation instead of template literals
 *  - == instead of === in comparisons
 *  - Zero error handling on async operations
 *  - Mixed concerns (validation + DB + formatting in one function)
 *  - Global state mutation
 */

// Global mutable state — shared across all calls
var userCache = {};
var requestCount = 0;

// -------------------------------------------------------------------------
// "Class" defined with prototype pattern
// -------------------------------------------------------------------------

function UserSession(userId, role) {
  this.userId = userId;
  this.role = role;
  this.createdAt = Date.now();
  this.lastActivity = Date.now();
}

UserSession.prototype.isExpired = function() {
  // Magic number: 3600000 milliseconds = 1 hour
  return (Date.now() - this.lastActivity) > 3600000;
};

UserSession.prototype.hasPermission = function(requiredRole) {
  // == instead of === — will accidentally coerce types
  return this.role == requiredRole;
};

UserSession.prototype.toString = function() {
  // String concatenation
  return 'UserSession[' + this.userId + ', role=' + this.role + ']';
};

// -------------------------------------------------------------------------
// Callback hell — three levels deep
// -------------------------------------------------------------------------

function loadUserDashboard(userId, callback) {
  requestCount = requestCount + 1;

  // Level 1: fetch the user
  db.findUser(userId, function(err, user) {
    if (err) {
      callback('Failed to load user: ' + err);
      return;
    }

    // Cache the user — mutates global state
    userCache[userId] = user;

    // Level 2: fetch the user's orders
    db.findOrders(user.id, function(err, orders) {
      if (err) {
        callback('Failed to load orders: ' + err);
        return;
      }

      // Level 3: fetch summary stats for each order
      db.getOrderStats(orders, function(err, stats) {
        if (err) {
          callback('Failed to load stats: ' + err);
          return;
        }

        // Mix of validation, formatting, and response — all in one place
        var result = {};
        result.user = user;
        result.orders = orders;
        result.stats = stats;
        result.totalOrders = orders.length;

        // Magic number: 10 = "high value customer" threshold
        if (orders.length > 10) {
          result.customerTier = 'gold';
        } else {
          result.customerTier = 'standard';
        }

        callback(null, result);
      });
    });
  });
}

// -------------------------------------------------------------------------
// No error handling on async operations
// -------------------------------------------------------------------------

async function fetchExternalProfile(userId) {
  // If this throws a network error, it will be an unhandled rejection
  var response = await fetch('https://api.example.com/profiles/' + userId);
  var data = await response.json();
  return data;
}

// -------------------------------------------------------------------------
// Mixed concerns + magic numbers + var
// -------------------------------------------------------------------------

function processOrderTotal(order) {
  var subtotal = 0;
  var i;

  for (var i = 0; i < order.items.length; i++) {
    subtotal = subtotal + (order.items[i].price * order.items[i].quantity);
  }

  var discount = 0;

  // Magic numbers: 500 (minimum for discount), 0.1 (10% discount rate)
  if (subtotal > 500) {
    discount = subtotal * 0.1;
  }

  // Magic number: 0.08 (tax rate — which jurisdiction? who knows?)
  var tax = (subtotal - discount) * 0.08;
  var total = subtotal - discount + tax;

  // String concatenation + no formatting
  return {
    subtotal: subtotal,
    discount: discount,
    tax: tax,
    total: total,
    summary: 'Order total: $' + total + ' (includes $' + tax + ' tax)'
  };
}

// -------------------------------------------------------------------------
// Export (CommonJS style)
// -------------------------------------------------------------------------

module.exports = {
  UserSession: UserSession,
  loadUserDashboard: loadUserDashboard,
  fetchExternalProfile: fetchExternalProfile,
  processOrderTotal: processOrderTotal
};
