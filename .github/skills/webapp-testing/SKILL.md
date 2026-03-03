---
name: webapp-testing
description: Write Playwright and Jest E2E tests for web application user flows. Use when asked to test a login page, form, navigation, authentication flow, or any browser-based user interaction. Automatically identifies testable flows, generates selectors, and produces complete test files following best practices for async handling, accessibility-first selectors, and assertion coverage.
license: MIT
compatibility: Requires Node.js 18+, @playwright/test or jest with @testing-library
metadata:
  author: copilot-dev-course
  version: "1.0"
allowed-tools: read_file write_file run_terminal_command
---

# Webapp Testing Skill

You are an expert in writing E2E and component tests for web applications using **Playwright** (for browser-based tests) and **Jest + Testing Library** (for component/unit tests). When this skill is active, follow every step below precisely.

## Step 1: Identify the Target File and Testable Flows

Before writing a single line of test code:

1. Read the target HTML, component, or route file completely.
2. Enumerate every **user flow** visible in the UI:
   - Form submissions (login, register, search, checkout)
   - Navigation (links, breadcrumbs, tabs, modals)
   - State changes (error messages, success banners, loading spinners)
   - Authentication gates (redirect to login, session expiry)
3. Prioritize flows by **risk**: authentication > data mutation > read-only display.
4. Ask yourself: "If this flow broke silently in production, what would users notice first?" — test that first.

## Step 2: Choose the Right Test Type

| Scenario | Test Type | Tool |
|---|---|---|
| Full browser flow (login → dashboard) | E2E | Playwright |
| Single component rendering | Component | Jest + Testing Library |
| API response handling in UI | Integration | Playwright with mock routes |
| Accessibility | A11y | Playwright + axe-core |

## Step 3: Selector Strategy (Accessibility-First)

Always prefer selectors in this order:

```typescript
// 1. BEST: Role + accessible name (resilient to CSS/layout changes)
await page.getByRole('button', { name: 'Sign in' }).click();
await page.getByRole('textbox', { name: 'Email address' }).fill('user@example.com');

// 2. GOOD: Label text (tied to semantic HTML)
await page.getByLabel('Password').fill('secret');

// 3. OK: Placeholder text (only if no label exists)
await page.getByPlaceholder('Enter your email').fill('user@example.com');

// 4. LAST RESORT: data-testid (when no semantic option exists)
await page.getByTestId('submit-btn').click();

// NEVER USE: CSS class names, XPath, positional selectors
// BAD:
await page.locator('.btn-primary').click();       // breaks on CSS refactor
await page.locator('//button[1]').click();        // brittle, breaks on DOM changes
```

**Why accessibility-first?** These selectors also verify your app is accessible to screen reader users — two tests for the price of one.

## Step 4: Test Structure Pattern

Every test file must follow this structure:

```typescript
import { test, expect } from '@playwright/test';

// Group related tests in a describe block
test.describe('Login Page', () => {

  // Run before each test: navigate to a clean state
  test.beforeEach(async ({ page }) => {
    await page.goto('/login');
    // Wait for the page to be fully interactive before each test
    await page.waitForLoadState('networkidle');
  });

  // Happy path first
  test('should log in with valid credentials', async ({ page }) => {
    // ARRANGE: Set up the preconditions
    await page.getByLabel('Email').fill('user@example.com');
    await page.getByLabel('Password').fill('correctpassword');

    // ACT: Perform the user action
    await page.getByRole('button', { name: 'Sign in' }).click();

    // ASSERT: Verify the expected outcome
    await expect(page).toHaveURL('/dashboard');
    await expect(page.getByRole('heading', { name: 'Welcome' })).toBeVisible();
  });

  // Error path second
  test('should show error message with invalid credentials', async ({ page }) => {
    await page.getByLabel('Email').fill('wrong@example.com');
    await page.getByLabel('Password').fill('wrongpassword');
    await page.getByRole('button', { name: 'Sign in' }).click();

    // Wait for error state — never use arbitrary sleep()
    await expect(page.getByRole('alert')).toBeVisible();
    await expect(page.getByRole('alert')).toContainText('Invalid email or password');
  });

  // Edge cases and validation
  test('should require both email and password fields', async ({ page }) => {
    await page.getByRole('button', { name: 'Sign in' }).click();
    await expect(page.getByText('Email is required')).toBeVisible();
    await expect(page.getByText('Password is required')).toBeVisible();
  });
});
```

## Step 5: Async Handling Rules

**Golden rule: NEVER use `page.waitForTimeout()` (sleep) in tests.**

```typescript
// BAD — flaky, fails on slow CI machines
await page.waitForTimeout(2000);
await expect(page.getByText('Success')).toBeVisible();

// GOOD — wait for the specific condition you care about
await expect(page.getByText('Success')).toBeVisible({ timeout: 10_000 });

// GOOD — wait for network to settle after an action
await page.click('button[type="submit"]');
await page.waitForResponse(resp => resp.url().includes('/api/login'));

// GOOD — wait for navigation to complete
await Promise.all([
  page.waitForURL('/dashboard'),
  page.click('button[type="submit"]'),
]);
```

## Step 6: What to Assert

Cover all three assertion types for every significant flow:

```typescript
// 1. URL/navigation assertions
await expect(page).toHaveURL('/dashboard');
await expect(page).toHaveURL(/\/user\/\d+/);

// 2. Visibility assertions
await expect(page.getByRole('heading', { name: 'Dashboard' })).toBeVisible();
await expect(page.getByRole('alert')).not.toBeVisible();

// 3. Content assertions
await expect(page.getByRole('status')).toContainText('Logged in as');
await expect(page.locator('title')).toHaveText('Dashboard | MyApp');

// 4. Form state assertions
await expect(page.getByLabel('Email')).toHaveValue('user@example.com');
await expect(page.getByRole('button', { name: 'Sign in' })).toBeDisabled();

// 5. Network assertions (use sparingly — test behavior not implementation)
const response = await page.waitForResponse('/api/auth/login');
expect(response.status()).toBe(200);
```

## Step 7: Playwright Configuration

When generating tests, also check for or create `playwright.config.ts`:

```typescript
import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './tests/e2e',
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  reporter: 'html',
  use: {
    baseURL: 'http://localhost:3000',
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
  },
  projects: [
    { name: 'chromium', use: { ...devices['Desktop Chrome'] } },
    { name: 'firefox', use: { ...devices['Desktop Firefox'] } },
  ],
  webServer: {
    command: 'npm run dev',
    url: 'http://localhost:3000',
    reuseExistingServer: !process.env.CI,
  },
});
```

## Step 8: Output Checklist

Before delivering the test file, verify:

- [ ] Every identified user flow has at least one test
- [ ] Happy path AND at least one error/edge path covered
- [ ] No `page.waitForTimeout()` calls
- [ ] All selectors use accessibility-first approach
- [ ] Test file includes `beforeEach` navigation setup
- [ ] Each test has a clear ARRANGE / ACT / ASSERT structure
- [ ] File is saved as `*.spec.ts` in the `tests/e2e/` directory

## Reference Files

- `example-test.spec.ts` — Complete annotated Playwright test for a login page
- `sample-login-page.html` — Sample HTML login page to run tests against
