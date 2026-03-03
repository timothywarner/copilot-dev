---
name: legacy-code-refactor
description: Systematically modernize legacy JavaScript or TypeScript code. Use when asked to refactor, modernize, clean up, or update old code. Identifies anti-patterns (var declarations, callback hell, prototype chains, magic numbers, missing error handling), explains each change, applies safe transformations, and adds tests. Step-by-step methodology ensures the code behaves identically before and after refactoring.
license: MIT
compatibility: JavaScript ES5+ to ES2022+. Node.js 18+. Optionally TypeScript 5+ for type-annotated output.
metadata:
  author: copilot-dev-course
  version: "1.0"
allowed-tools: read_file write_file run_terminal_command
---

# Legacy Code Refactor Skill

You are an expert in safely modernizing legacy JavaScript/TypeScript codebases. When this skill activates, follow the **five-step methodology** below precisely. Never change observable behavior — only improve the structure, readability, and maintainability.

## The Core Principle

> "Refactoring is changing the internal structure of software without changing its observable behavior."
> — Martin Fowler

Every transformation must be **provably safe**: the code must do the same thing before and after.

## Step 1: Audit — Identify All Anti-Patterns

Read the target file completely, then produce an audit table listing every issue found:

| # | Line | Anti-Pattern | Why It's a Problem | Safe Fix |
|---|---|---|---|---|
| 1 | 3 | `var` in function scope | `var` is function-scoped and hoisted; causes subtle bugs | Replace with `const` or `let` |
| 2 | 12 | Nested callback (callback hell) | Impossible to reason about error flow; unreadable | Rewrite with `async/await` |
| 3 | 25 | `prototype` method | No encapsulation; harder to subclass; verbose | Convert to `class` with methods |
| 4 | 31 | Magic number `86400000` | Intent is invisible; breaking change if the value changes | Extract to named constant `MS_PER_DAY` |
| 5 | 44 | No error handling | Unhandled rejections crash Node.js silently | Wrap in try/catch |
| 6 | 55 | Mixed concerns | Validation + persistence + response in one function | Separate into distinct functions |

Present this table to the user before making any changes.

## Step 2: Catalog of Anti-Patterns and Safe Fixes

### 2.1 `var` → `const` / `let`

```javascript
// BEFORE — var is function-scoped and hoisted; assignment in loops leaks
var maxRetries = 3;
var i;
for (var i = 0; i < maxRetries; i++) { ... }

// AFTER — const for values that don't change, let for loop variables
const MAX_RETRIES = 3;
for (let i = 0; i < MAX_RETRIES; i++) { ... }
```

**Safe when:** The variable is not re-declared in the same scope (var allows re-declaration; let/const do not).

### 2.2 Callback Hell → async/await

```javascript
// BEFORE — nested callbacks; error handling at every level; hard to read
function getUserOrders(userId, callback) {
  db.findUser(userId, function(err, user) {
    if (err) return callback(err);
    db.findOrders(user.id, function(err, orders) {
      if (err) return callback(err);
      callback(null, orders);
    });
  });
}

// AFTER — linear, readable, error bubbles up naturally
async function getUserOrders(userId) {
  const user = await db.findUser(userId);
  const orders = await db.findOrders(user.id);
  return orders;
}
```

**Safe when:** All callers can be updated to use `await` or `.then()`. If the function is part of a public API using the Node.js callback convention, expose both forms during a transition period.

### 2.3 Prototype Chains → ES2022 Classes

```javascript
// BEFORE — prototype-based "class" pattern
function Animal(name) {
  this.name = name;
}
Animal.prototype.speak = function() {
  return this.name + ' makes a sound.';
};

// AFTER — ES2022 class with private fields
class Animal {
  #name; // private field — not accessible outside the class

  constructor(name) {
    this.#name = name;
  }

  speak() {
    return `${this.#name} makes a sound.`;
  }
}
```

**Safe when:** No code directly accesses `.prototype` on the constructor function. Check for `Animal.prototype.newMethod = ...` patterns outside the class definition before converting.

### 2.4 Magic Numbers → Named Constants

```javascript
// BEFORE — 86400000 and 7 have no context
if (Date.now() - lastLogin > 86400000 * 7) {
  lockAccount(user);
}

// AFTER — intent is crystal clear; one place to change the policy
const MS_PER_DAY = 24 * 60 * 60 * 1000;
const INACTIVITY_LOCK_DAYS = 7;
const INACTIVITY_LOCK_THRESHOLD_MS = MS_PER_DAY * INACTIVITY_LOCK_DAYS;

if (Date.now() - lastLogin > INACTIVITY_LOCK_THRESHOLD_MS) {
  lockAccount(user);
}
```

### 2.5 No Error Handling → try/catch + Typed Errors

```javascript
// BEFORE — unhandled rejection crashes the process silently in older Node
async function fetchUserData(id) {
  const response = await fetch(`/api/users/${id}`);
  const data = await response.json();
  return data;
}

// AFTER — every failure path is handled explicitly
async function fetchUserData(id) {
  let response;
  try {
    response = await fetch(`/api/users/${id}`);
  } catch (networkError) {
    throw new Error(`Network request failed for user ${id}: ${networkError.message}`);
  }

  if (!response.ok) {
    throw new Error(`API returned ${response.status} for user ${id}`);
  }

  try {
    return await response.json();
  } catch (parseError) {
    throw new Error(`Failed to parse API response for user ${id}: ${parseError.message}`);
  }
}
```

### 2.6 String Concatenation → Template Literals

```javascript
// BEFORE
var message = 'Hello, ' + user.name + '! You have ' + count + ' messages.';

// AFTER
const message = `Hello, ${user.name}! You have ${count} messages.`;
```

### 2.7 Equality (`==`) → Strict Equality (`===`)

```javascript
// BEFORE — == coerces types; '5' == 5 is true
if (userId == null) { ... }   // catches null AND undefined — use this intentionally
if (status == 'active') { ... } // BAD: type coercion is a bug waiting to happen

// AFTER — === never coerces
if (userId === null || userId === undefined) { ... }  // explicit
if (status === 'active') { ... }  // clear intent
```

**Exception:** `value == null` (checking for both `null` and `undefined`) is an accepted pattern when intentional — comment it.

### 2.8 Mixed Concerns → Single Responsibility

```javascript
// BEFORE — one function does validation, persistence, AND response formatting
async function saveUser(req, res) {
  if (!req.body.email) { res.status(400).send('Email required'); return; }
  const user = await db.save(req.body);
  res.json({ id: user.id, email: user.email });
}

// AFTER — each function has one job
function validateUserInput(body) {
  if (!body.email) throw new ValidationError('Email is required');
}

async function persistUser(data) {
  return db.save(data);
}

async function createUserHandler(req, res) {
  validateUserInput(req.body);
  const user = await persistUser(req.body);
  res.json({ id: user.id, email: user.email });
}
```

## Step 3: Apply Transformations Safely

Apply changes in this sequence to minimize risk:

1. **Constants first** — rename magic numbers and magic strings (zero behavioral change)
2. **`var` → `const`/`let`** — mechanical substitution; fix any re-declarations
3. **Template literals** — string concatenation to template literals (zero behavioral change)
4. **`==` → `===`** — go one-by-one; verify each comparison's intent before changing
5. **Prototype → class** — rewrite the shape, then verify instance checks (`instanceof`) still work
6. **Callbacks → async/await** — rewrite the function, then update every call site
7. **Error handling** — add try/catch around every `await` that can throw
8. **Concern separation** — extract functions last, after the code is clean

After each step: run the tests (or note if no tests exist).

## Step 4: Document Every Change

For every changed line or block, add a comment explaining:

```javascript
// REFACTORED: var → const (never reassigned)
const MAX_RETRIES = 3;

// REFACTORED: magic number → named constant (86400000 ms = 1 day)
const MS_PER_DAY = 24 * 60 * 60 * 1000;

// REFACTORED: callback → async/await (same behavior, linear flow)
async function getUserOrders(userId) { ... }
```

## Step 5: Write Tests for the Refactored Code

After refactoring, generate a Jest test file that:

1. Tests the public API of each function (same inputs → same outputs as before)
2. Tests error paths that now have explicit handling
3. Uses `describe` blocks matching function names
4. Includes a comment: `// These tests verify behavior was preserved during refactoring`

```javascript
// Example test structure for a refactored module
describe('getUserOrders', () => {
  it('returns orders for a valid user ID', async () => {
    // ... test the happy path
  });

  it('throws when the user is not found', async () => {
    // ... test that errors bubble up correctly
  });
});
```

## Output Checklist

Before delivering refactored code:

- [ ] Audit table presented before any changes
- [ ] Every anti-pattern from the catalog addressed
- [ ] No `var` declarations remain (unless intentionally preserved with comment)
- [ ] No callback-style async code (all converted to async/await)
- [ ] No magic numbers (all extracted to named constants)
- [ ] Every `await` wrapped in try/catch or delegated via throw
- [ ] `===` used everywhere (no bare `==` without explanation)
- [ ] Refactor comments added to every changed section
- [ ] Test file generated covering happy path + error paths

## Reference Files

- `legacy-example.js` — Legacy JavaScript file with intentional anti-patterns (the "before")
- `refactored-example.js` — Same code after applying this skill (the "after")
