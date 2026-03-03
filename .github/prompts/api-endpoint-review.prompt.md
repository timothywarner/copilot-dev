---
agent: ask
model: Claude Sonnet 4
description: 'Review a REST API endpoint for correctness, security, error handling, and best practices'
argument-hint: 'Select your endpoint handler code, then run this prompt'
---

Perform a thorough review of the REST API endpoint in `${selection}`.

If no code is selected, ask the user to paste the endpoint handler they want reviewed.

---

## Review checklist

Work through each section systematically. For each item, state: **PASS**, **FAIL**, or **N/A**, followed by a brief explanation and (for FAILs) a concrete fix.

---

### 1. Input validation

- [ ] Are all path parameters, query parameters, and request body fields validated before use?
- [ ] Is validation done with a schema library (Zod, Pydantic, Joi, marshmallow) — not ad-hoc `if` checks?
- [ ] Are unknown fields rejected or stripped (no mass-assignment vulnerability)?
- [ ] Are field types, lengths, and formats enforced (e.g., email regex, ID must be UUID)?

**What to look for:**

```typescript
// FAIL — no validation, trusting raw input
app.post('/users', (req, res) => {
  db.insert(req.body)  // dangerous: any fields accepted
})

// PASS — validate with Zod before touching the database
const CreateUserSchema = z.object({
  email: z.string().email(),
  name: z.string().min(1).max(100),
  role: z.enum(['admin', 'viewer'])
})

app.post('/users', (req, res) => {
  const parsed = CreateUserSchema.safeParse(req.body)
  if (!parsed.success) return res.status(400).json({ error: parsed.error.flatten() })
  db.insert(parsed.data)
})
```

---

### 2. Authentication and authorization

- [ ] Is the endpoint protected by an authentication middleware (JWT verification, session check, API key)?
- [ ] Is authorization checked — not just "is the user logged in" but "does THIS user own THIS resource"?
- [ ] Are admin-only endpoints guarded with a role check?
- [ ] Are anonymous requests rejected with 401 (not 403)?

**What to look for:**

```typescript
// FAIL — endpoint readable by any authenticated user, even ones who don't own the resource
app.get('/users/:id/private-data', authMiddleware, async (req, res) => {
  const data = await db.getPrivateData(req.params.id)  // no ownership check!
  return res.json(data)
})

// PASS — verify the requesting user owns the resource
app.get('/users/:id/private-data', authMiddleware, async (req, res) => {
  if (req.user.id !== req.params.id && req.user.role !== 'admin') {
    return res.status(403).json({ error: 'Forbidden' })
  }
  const data = await db.getPrivateData(req.params.id)
  return res.json(data)
})
```

---

### 3. HTTP status codes

- [ ] `200 OK` — GET, PUT/PATCH success with body
- [ ] `201 Created` — POST success, resource created (include `Location` header)
- [ ] `204 No Content` — DELETE success, no body
- [ ] `400 Bad Request` — client sent invalid data (include validation error details)
- [ ] `401 Unauthorized` — not authenticated
- [ ] `403 Forbidden` — authenticated but not authorized
- [ ] `404 Not Found` — resource does not exist
- [ ] `409 Conflict` — duplicate resource (unique constraint violation)
- [ ] `422 Unprocessable Entity` — semantically invalid input (business rule violation)
- [ ] `500 Internal Server Error` — never expose stack traces or internal details

---

### 4. Error handling

- [ ] Is the handler wrapped in try/catch (or using an error-handling middleware)?
- [ ] Do error responses return a consistent shape (`{ error: string, details?: ... }`)?
- [ ] Are stack traces and internal error messages hidden from clients?
- [ ] Are database errors caught and translated (not leaked as "relation X does not exist")?

**What to look for:**

```typescript
// FAIL — unhandled rejection, stack trace leaks to client
app.get('/tips/:id', async (req, res) => {
  const tip = await db.getTip(req.params.id)  // throws if not found — unhandled!
  res.json(tip)
})

// PASS — explicit error handling with safe messages
app.get('/tips/:id', async (req, res) => {
  try {
    const tip = await db.getTip(req.params.id)
    if (!tip) return res.status(404).json({ error: 'Tip not found' })
    return res.json(tip)
  } catch (err) {
    console.error('getTip failed:', err)  // log internally
    return res.status(500).json({ error: 'An unexpected error occurred' })
  }
})
```

---

### 5. SQL injection and database safety

(Mark N/A if no database queries are present.)

- [ ] Are all queries parameterized (no string concatenation with user input)?
- [ ] Is an ORM or query builder used that handles escaping automatically?
- [ ] Are bulk operations limited in size to prevent denial of service?

**What to look for:**

```python
# FAIL — SQL injection vulnerability
query = f"SELECT * FROM tips WHERE category = '{category}'"
cursor.execute(query)

# PASS — parameterized query
cursor.execute("SELECT * FROM tips WHERE category = %s", (category,))
```

---

### 6. Response shape consistency

- [ ] Does the endpoint always return the same shape on success?
- [ ] Are null/undefined fields handled (not left as `undefined` which serializes oddly)?
- [ ] Is pagination information included for list endpoints (`total`, `page`, `limit`, `nextCursor`)?
- [ ] Are dates returned as ISO 8601 strings, not timestamps?

---

### 7. Rate limiting and abuse prevention

- [ ] Is there a rate limiter applied to this endpoint (especially auth, search, and write endpoints)?
- [ ] Is the rate limiter applied per-user/IP, not globally?
- [ ] Are `429 Too Many Requests` responses returned with a `Retry-After` header?

---

### 8. Idempotency and safety

- [ ] Is the GET endpoint truly read-only (no state mutations)?
- [ ] Would calling this POST/PUT/DELETE twice cause harm? Should it be idempotent?
- [ ] Are DELETE operations soft-deleted (preferred) or hard-deleted?

---

## Output format

Provide findings as a prioritized list:

**CRITICAL** (security vulnerabilities — fix immediately)
**HIGH** (functional bugs, data loss risk)
**MEDIUM** (best practice violations, maintainability issues)
**LOW** (style, minor improvements)

For each finding:

```text
[SEVERITY] Category: What's wrong
  Current: (show the problematic line or pattern)
  Fix: (show the corrected code or approach)
```

Then provide a summary: overall assessment (PASS / NEEDS WORK / FAIL) with a one-paragraph explanation.
