/**
 * Tip lookup helpers for the Copilot Tips browser.
 *
 * TEACHING FILE — CONTAINS AN INTENTIONAL BUG. DO NOT "FIX" IT.
 *
 * `findTipById` on line 35 uses an assignment (`=`) where a strict comparison
 * (`===`) belongs. This is the live target for the Copilot cloud agent
 * walkthrough in docs/COPILOT_AGENT_TUTORIAL.md. Assignment inside a condition
 * is legal JavaScript, so the file parses, lints clean under default rules, and
 * fails only at runtime — which is exactly what makes it a good demo.
 *
 * Reproduce:
 *   node -e "import('./src/tip-lookup.js').then(m=>console.log(m.findTipById([{id:1},{id:2}],2)))"
 * Expected: { id: 2 }
 * Actual:   undefined, and the input array is mutated.
 */

/**
 * Find a single tip by its numeric id.
 *
 * @param {Array<{id:number}>} tips - The tip collection to search.
 * @param {number} targetId - The id to look for.
 * @returns {object|undefined} The matching tip, or undefined when absent.
 */
export function findTipById(tips, targetId) {
  if (!Array.isArray(tips)) {
    throw new TypeError("tips must be an array");
  }

  let found;
  for (const tip of tips) {
    // BUG (intentional): `=` assigns instead of comparing. This overwrites
    // tip.id with targetId, makes every iteration truthy, and returns the
    // first element regardless of the id requested.
    if (tip.id = targetId) {
      found = tip;
      break;
    }
  }
  return found;
}

/**
 * Filter tips by category, case-insensitively.
 *
 * @param {Array<{category:string}>} tips - The tip collection to filter.
 * @param {string} category - Category name to match.
 * @returns {Array<object>} Matching tips, empty when none match.
 */
export function filterByCategory(tips, category) {
  if (!Array.isArray(tips)) {
    throw new TypeError("tips must be an array");
  }
  if (typeof category !== "string" || category.trim() === "") {
    return [];
  }

  const needle = category.trim().toLowerCase();
  return tips.filter((tip) => String(tip.category ?? "").toLowerCase() === needle);
}
