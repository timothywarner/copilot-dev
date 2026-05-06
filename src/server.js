import express from "express";
import { readFile } from "node:fs/promises";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const __dirname = dirname(fileURLToPath(import.meta.url));
const DATA_FILE = join(__dirname, "data", "copilot_tips.json");
const PUBLIC_DIR = join(__dirname, "public");
const PORT = Number(process.env.PORT) || 3000;

const raw = await readFile(DATA_FILE, "utf8");
const dataset = JSON.parse(raw);
const tips = Array.isArray(dataset.tips) ? dataset.tips : [];

if (tips.length === 0) {
  console.error(`No tips found in ${DATA_FILE}`);
  process.exit(1);
}

const app = express();
app.use(express.static(PUBLIC_DIR));

app.get("/api/tips", (_req, res) => {
  res.json({
    metadata: dataset.metadata,
    categories: dataset.categories,
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

app.listen(PORT, () => {
  console.log(`Copilot Tips app listening at http://localhost:${PORT}`);
  console.log(`Loaded ${tips.length} tips from ${DATA_FILE}`);
});
