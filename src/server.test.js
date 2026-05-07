import test from "node:test";
import assert from "node:assert/strict";

import { createTip, updateTip, validateTipData } from "./server.js";
import seedData from "./data/copilot_tips.json" with { type: "json" };

const categories = seedData.categories;

test("createTip creates a valid tip", () => {
  const tips = [];
  const result = createTip(
    tips,
    {
      id: "custom-001",
      title: "Custom Tip",
      description: "Custom description",
      category: categories[0],
      difficulty: "beginner",
      impact: "medium",
    },
    categories,
  );

  assert.equal(result.success, true);
  assert.equal(result.tip.id, "custom-001");
  assert.equal(result.total_count, 1);
});

test("createTip rejects duplicate IDs", () => {
  const tips = [
    {
      id: "custom-001",
      title: "Existing Tip",
      description: "Existing description",
      category: categories[0],
      difficulty: "beginner",
      impact: "medium",
    },
  ];

  const result = createTip(
    tips,
    {
      id: "CUSTOM-001",
      title: "Duplicate Tip",
      description: "Duplicate description",
      category: categories[0],
      difficulty: "beginner",
      impact: "medium",
    },
    categories,
  );

  assert.equal(result.success, false);
  assert.match(result.error, /already exists/i);
  assert.equal(tips.length, 1);
});

test("validateTipData rejects missing required fields for create", () => {
  const result = validateTipData(
    {
      id: "custom-001",
      title: "Missing fields",
    },
    categories,
  );

  assert.equal(result.valid, false);
  assert.match(result.error, /Missing required field/i);
});

test("validateTipData allows partial object for update mode", () => {
  const result = validateTipData(
    {
      impact: "high",
    },
    categories,
    { isUpdate: true },
  );

  assert.equal(result.valid, true);
});

test("updateTip applies partial updates with before/after", () => {
  const tips = [
    {
      id: "prompt-001",
      title: "Original title",
      description: "Original description",
      category: categories[0],
      difficulty: "beginner",
      impact: "medium",
    },
  ];

  const result = updateTip(tips, categories, "prompt-001", {
    difficulty: "advanced",
    impact: "high",
  });

  assert.equal(result.success, true);
  assert.equal(result.before.difficulty, "beginner");
  assert.equal(result.after.difficulty, "advanced");
  assert.deepEqual(result.changes, ["difficulty", "impact"]);
});

test("updateTip rejects empty update payload", () => {
  const tips = [
    {
      id: "prompt-001",
      title: "Original title",
      description: "Original description",
      category: categories[0],
      difficulty: "beginner",
      impact: "medium",
    },
  ];

  const result = updateTip(tips, categories, "prompt-001", {});
  assert.equal(result.success, false);
  assert.match(result.error, /No updates provided/i);
});

test("updateTip rejects invalid field values", () => {
  const tips = [
    {
      id: "prompt-001",
      title: "Original title",
      description: "Original description",
      category: categories[0],
      difficulty: "beginner",
      impact: "medium",
    },
  ];

  const result = updateTip(tips, categories, "prompt-001", {
    difficulty: "expert",
  });

  assert.equal(result.success, false);
  assert.match(result.error, /Invalid difficulty/i);
});

test("updateTip rejects unknown tip id", () => {
  const tips = [];
  const result = updateTip(tips, categories, "missing-tip", { impact: "high" });
  assert.equal(result.success, false);
  assert.match(result.error, /not found/i);
});
