/**
 * example-test.spec.ts
 *
 * Complete annotated Playwright E2E test for sample-login-page.html
 * This file demonstrates every pattern taught by the webapp-testing skill.
 *
 * Run with:
 *   npx playwright test example-test.spec.ts --headed
 *
 * Prerequisites:
 *   npm install -D @playwright/test
 *   npx playwright install chromium
 */

import { test, expect, Page } from '@playwright/test';
import path from 'node:path';

// ---------------------------------------------------------------------------
// Helpers — extracted so tests stay focused on WHAT, not HOW
// ---------------------------------------------------------------------------

/**
 * Navigate to the local login page HTML file.
 * In a real project, replace the file:// URL with your baseURL (e.g. http://localhost:3000/login).
 */
async function goToLoginPage(page: Page): Promise<void> {
  const filePath = path.resolve(__dirname, 'sample-login-page.html');
  await page.goto(`file://${filePath}`);
  // Wait until the DOM is interactive, not just DOMContentLoaded
  await page.waitForLoadState('domcontentloaded');
}

/**
 * Fill the login form with the given credentials.
 * Using getByLabel() — most resilient selector type.
 */
async function fillLoginForm(
  page: Page,
  email: string,
  password: string,
): Promise<void> {
  await page.getByLabel('Email address').fill(email);
  await page.getByLabel('Password').fill(password);
}

// ---------------------------------------------------------------------------
// Test suite
// ---------------------------------------------------------------------------

test.describe('Login Page', () => {
  // Navigate to a clean page state before every test.
  // This guarantees test isolation — no test depends on another.
  test.beforeEach(async ({ page }) => {
    await goToLoginPage(page);
  });

  // -------------------------------------------------------------------------
  // Happy path
  // -------------------------------------------------------------------------

  test('should display the login form on load', async ({ page }) => {
    // Verify page identity
    await expect(page).toHaveTitle('Sign In | MyApp');

    // Check heading is visible and correct
    await expect(page.getByRole('heading', { name: 'MyApp' })).toBeVisible();

    // Check all form elements are present
    await expect(page.getByLabel('Email address')).toBeVisible();
    await expect(page.getByLabel('Password')).toBeVisible();
    await expect(page.getByRole('button', { name: 'Sign in' })).toBeVisible();

    // Error banner should be hidden on initial load
    await expect(page.getByRole('alert')).not.toBeVisible();
  });

  test('should log in successfully with valid credentials', async ({ page }) => {
    // ARRANGE
    await fillLoginForm(page, 'user@example.com', 'correct-horse-battery-staple');

    // ACT — click the submit button
    await page.getByRole('button', { name: 'Sign in' }).click();

    // ASSERT — wait for the success state without any arbitrary sleep()
    // The status role maps to the success-banner element
    await expect(page.getByRole('status')).toBeVisible({ timeout: 5_000 });
    await expect(page.getByRole('status')).toContainText('Login successful');

    // The form should be hidden after success
    await expect(page.locator('#login-form')).not.toBeVisible();
  });

  // -------------------------------------------------------------------------
  // Error paths — test every observable failure mode
  // -------------------------------------------------------------------------

  test('should show error alert with invalid credentials', async ({ page }) => {
    // ARRANGE
    await fillLoginForm(page, 'wrong@example.com', 'badpassword');

    // ACT
    await page.getByRole('button', { name: 'Sign in' }).click();

    // ASSERT — the role="alert" with aria-live="assertive" is our error banner
    await expect(page.getByRole('alert')).toBeVisible({ timeout: 5_000 });
    await expect(page.getByRole('alert')).toContainText('Invalid email or password');

    // The button should be re-enabled so the user can try again
    await expect(page.getByRole('button', { name: 'Sign in' })).toBeEnabled();
  });

  test('should require the email field', async ({ page }) => {
    // Leave email blank, fill password only
    await page.getByLabel('Password').fill('somepassword');

    // ACT — try to submit with empty email
    await page.getByRole('button', { name: 'Sign in' }).click();

    // ASSERT — field-level error message appears
    // Note: there are two role="alert" elements on this page (field errors + banner)
    // We target by text content to be specific
    await expect(page.getByText('Email is required')).toBeVisible();
  });

  test('should require the password field', async ({ page }) => {
    await page.getByLabel('Email address').fill('user@example.com');

    await page.getByRole('button', { name: 'Sign in' }).click();

    await expect(page.getByText('Password is required')).toBeVisible();
  });

  test('should show validation error for malformed email address', async ({ page }) => {
    await page.getByLabel('Email address').fill('not-an-email');
    await page.getByLabel('Password').fill('somepassword');

    await page.getByRole('button', { name: 'Sign in' }).click();

    await expect(page.getByText('Please enter a valid email address')).toBeVisible();
  });

  // -------------------------------------------------------------------------
  // Button state during submission
  // -------------------------------------------------------------------------

  test('should disable the submit button while login is in progress', async ({ page }) => {
    await fillLoginForm(page, 'user@example.com', 'correct-horse-battery-staple');

    // Click and immediately check the disabled state — the form has an 800ms delay
    await page.getByRole('button', { name: 'Sign in' }).click();

    // The button text changes to "Signing in…" during the pending state
    await expect(page.getByRole('button', { name: 'Signing in…' })).toBeDisabled();
  });

  // -------------------------------------------------------------------------
  // Navigation links — verify they point to the correct destinations
  // -------------------------------------------------------------------------

  test('should have a working "Forgot password" link', async ({ page }) => {
    const forgotLink = page.getByRole('link', { name: 'Forgot password?' });

    await expect(forgotLink).toBeVisible();
    // Check the href attribute — no navigation needed
    await expect(forgotLink).toHaveAttribute('href', '/forgot-password');
  });

  test('should have a working "Create one" signup link', async ({ page }) => {
    const signupLink = page.getByRole('link', { name: 'Create one' });

    await expect(signupLink).toBeVisible();
    await expect(signupLink).toHaveAttribute('href', '/register');
  });

  // -------------------------------------------------------------------------
  // Keyboard accessibility
  // -------------------------------------------------------------------------

  test('should be fully operable with keyboard navigation', async ({ page }) => {
    // Tab through the form fields in expected DOM order
    await page.keyboard.press('Tab'); // focus: email
    await expect(page.getByLabel('Email address')).toBeFocused();

    await page.keyboard.press('Tab'); // focus: password
    await expect(page.getByLabel('Password')).toBeFocused();

    await page.keyboard.press('Tab'); // focus: forgot password link
    await expect(page.getByRole('link', { name: 'Forgot password?' })).toBeFocused();

    await page.keyboard.press('Tab'); // focus: submit button
    await expect(page.getByRole('button', { name: 'Sign in' })).toBeFocused();

    // Submit using Enter key — identical to clicking
    await page.getByLabel('Email address').fill('user@example.com');
    await page.getByLabel('Password').fill('correct-horse-battery-staple');
    await page.getByRole('button', { name: 'Sign in' }).press('Enter');

    await expect(page.getByRole('status')).toBeVisible({ timeout: 5_000 });
  });
});
