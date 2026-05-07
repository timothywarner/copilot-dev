import express from "express";
import { readFile } from "node:fs/promises";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const __dirname = dirname(fileURLToPath(import.meta.url));
const DATA_FILE = join(__dirname, "data", "copilot_tips.json");
const PUBLIC_DIR = join(__dirname, "public");
const PORT = Number(process.env.PORT) || 3000;
const REQUIRED_FIELDS = [
  "id",
  "title",
  "description",
  "category",
  "difficulty",
  "impact",
];
const VALID_DIFFICULTIES = ["beginner", "intermediate", "advanced"];
const VALID_IMPACTS = ["low", "medium", "high", "critical"];

const raw = await readFile(DATA_FILE, "utf8");
const dataset = JSON.parse(raw);
const tips = Array.isArray(dataset.tips) ? dataset.tips : [];
const validCategories = Array.isArray(dataset.categories) ? dataset.categories : [];

if (tips.length === 0) {
  console.error(`No tips found in ${DATA_FILE}`);
  process.exit(1);
}

function normalizeId(value) {
  return String(value).toLowerCase();
}

function findTipIndexById(tipsStore, tipId) {
  return tipsStore.findIndex((tip) => normalizeId(tip.id) === normalizeId(tipId));
}

export function validateTipData(tipData, categories, { isUpdate = false } = {}) {
  if (!tipData || typeof tipData !== "object" || Array.isArray(tipData)) {
    return { valid: false, error: "Tip data must be an object" };
  }

  const fields = Object.keys(tipData);
  if (isUpdate && fields.length === 0) {
    return { valid: false, error: "No updates provided" };
  }

  if (!isUpdate) {
    for (const field of REQUIRED_FIELDS) {
      if (!(field in tipData)) {
        return { valid: false, error: `Missing required field: ${field}` };
      }
    }
  }

  if ("id" in tipData && (tipData.id === "" || tipData.id === null || tipData.id === undefined)) {
    return { valid: false, error: "Tip id must be non-empty" };
  }

  if ("title" in tipData && typeof tipData.title !== "string") {
    return { valid: false, error: "Title must be a string" };
  }

  if ("description" in tipData && typeof tipData.description !== "string") {
    return { valid: false, error: "Description must be a string" };
  }

  if ("category" in tipData && !categories.includes(tipData.category)) {
    return {
      valid: false,
      error: `Invalid category. Must be one of: ${categories.join(", ")}`,
    };
  }

  if ("difficulty" in tipData && !VALID_DIFFICULTIES.includes(tipData.difficulty)) {
    return {
      valid: false,
      error: `Invalid difficulty. Must be one of: ${VALID_DIFFICULTIES.join(", ")}`,
    };
  }

  if ("impact" in tipData && !VALID_IMPACTS.includes(tipData.impact)) {
    return {
      valid: false,
      error: `Invalid impact. Must be one of: ${VALID_IMPACTS.join(", ")}`,
    };
  }

  return { valid: true, error: "" };
}

export function createTip(tipsStore, tipData, categories) {
  const validation = validateTipData(tipData, categories);
  if (!validation.valid) {
    return { success: false, error: validation.error };
  }

  if (findTipIndexById(tipsStore, tipData.id) !== -1) {
    return {
      success: false,
      error: `Tip with ID '${tipData.id}' already exists`,
    };
  }

  const newTip = { ...tipData };
  tipsStore.push(newTip);
  return {
    success: true,
    message: `Tip '${tipData.id}' created successfully`,
    tip: newTip,
    total_count: tipsStore.length,
  };
}

export function updateTip(tipsStore, categories, tipId, updates) {
  const tipIndex = findTipIndexById(tipsStore, tipId);
  if (tipIndex === -1) {
    return { success: false, error: `Tip '${tipId}' not found` };
  }

  if (updates && "id" in updates && normalizeId(updates.id) !== normalizeId(tipId)) {
    return { success: false, error: "Updating tip ID is not supported" };
  }

  const validation = validateTipData(updates, categories, { isUpdate: true });
  if (!validation.valid) {
    return { success: false, error: validation.error };
  }

  const before = { ...tipsStore[tipIndex] };
  tipsStore[tipIndex] = {
    ...tipsStore[tipIndex],
    ...updates,
  };

  return {
    success: true,
    message: `Tip '${tipId}' updated successfully`,
    before,
    after: tipsStore[tipIndex],
    changes: Object.keys(updates),
  };
}

const app = express();
app.use(express.static(PUBLIC_DIR));
app.use(express.json());

app.get("/api/tips", (_req, res) => {
  res.json({
    metadata: dataset.metadata,
    categories: validCategories,
    total: tips.length,
    tips,
  });
});

app.get("/api/random-tip", (req, res) => {
  const raw = req.query.exclude;
  const exclude = raw !== undefined ? Number(raw) : NaN;
  const pool = Number.isFinite(exclude)
    ? tips.filter((t) => t.id !== exclude)
    : tips;
  if (pool.length === 0) {
    return res.status(404).json({ error: "no tips available" });
  }
  const tip = pool[Math.floor(Math.random() * pool.length)];
  res.json(tip);
});

app.post("/api/tips", (req, res) => {
  const result = createTip(tips, req.body, validCategories);
  if (!result.success) {
    return res.status(400).json(result);
  }
  return res.status(201).json(result);
});

app.patch("/api/tips/:tipId", (req, res) => {
  const result = updateTip(tips, validCategories, req.params.tipId, req.body);
  if (!result.success) {
    return res.status(400).json(result);
  }
  return res.json(result);
});

const isMain = process.argv[1] === fileURLToPath(import.meta.url);
if (isMain) {
  app.listen(PORT, () => {
    console.log(`Copilot Tips app listening at http://localhost:${PORT}`);
    console.log(`Loaded ${tips.length} tips from ${DATA_FILE}`);
  });
}

export { app };
