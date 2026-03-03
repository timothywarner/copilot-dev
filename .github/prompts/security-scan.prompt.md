---
agent: agent
model: Claude Sonnet 4
description: 'Scan code for OWASP Top 10 vulnerabilities, hardcoded secrets, injection risks, and insecure patterns'
argument-hint: 'Select the code to scan, or specify a file path to analyze'
tools: ['read', 'search/codebase']
---

Perform a thorough security scan of the following code:

**Code to scan:** `${selection}`

If no code is selected, scan the file at: `${file}`

If neither is provided, ask for the code or file path to analyze.

---

## Scan methodology

Work through each category below systematically. For every finding, report:

```text
[SEVERITY] Category: Vulnerability name
  File: path/to/file  Line(s): N-M
  Finding: What the vulnerable code does
  Risk: What an attacker could do with this
  Code (current):
    [the vulnerable snippet]
  Remediation:
    [the fixed version with explanation]
```

Severity levels:

- **CRITICAL** — exploitable remotely, immediate data breach or system compromise risk
- **HIGH** — serious vulnerability requiring prompt attention
- **MEDIUM** — defense-in-depth issue or vulnerability requiring specific conditions
- **LOW** — best practice violation, minor hardening opportunity
- **INFO** — observation worth noting but not a vulnerability

---

## Category 1: Hardcoded secrets

Scan for any secrets, credentials, or sensitive values embedded directly in source code:

Look for patterns like:

- API keys, tokens, passwords assigned to variables
- Connection strings with embedded credentials
- JWT secrets, encryption keys, salts
- AWS/Azure/GCP credentials (`AKIA...`, ARM tokens, service account keys)
- OAuth client secrets
- Private keys (`-----BEGIN RSA PRIVATE KEY-----`)

```python
# CRITICAL — hardcoded secret
API_KEY = "sk-proj-AbCdEf1234567890"         # OpenAI key exposed
DB_PASSWORD = "MyS3cr3tP@ssw0rd!"            # Database credential

# PASS — environment variable
API_KEY = os.environ.get("OPENAI_API_KEY")
if not API_KEY:
    raise ValueError("OPENAI_API_KEY environment variable not set")
```

**Common secret patterns to flag:**

- `password = "..."` or `pwd = "..."`
- `secret = "..."` or `api_key = "..."`
- `token = "..."` (unless clearly a placeholder)
- Long alphanumeric strings in assignments (possible keys)
- Base64-encoded strings in config values

---

## Category 2: Injection vulnerabilities

### SQL Injection

```python
# CRITICAL — SQL injection
query = f"SELECT * FROM users WHERE name = '{user_input}'"

# PASS — parameterized
cursor.execute("SELECT * FROM users WHERE name = %s", (user_input,))
```

### Command Injection

```python
# CRITICAL — shell injection
import subprocess
subprocess.run(f"ls {user_path}", shell=True)

# PASS — no shell interpolation
subprocess.run(["ls", user_path], shell=False)
```

### Path Traversal

```python
# HIGH — path traversal
with open(f"/data/{user_filename}") as f:  # user could pass "../../etc/passwd"

# PASS — validate and sanitize
safe_path = Path("/data") / Path(user_filename).name
if not safe_path.resolve().is_relative_to(Path("/data")):
    raise ValueError("Invalid file path")
```

### Template Injection (Server-Side)

```python
# HIGH — SSTI
from jinja2 import Template
tmpl = Template(user_input)  # user controls template — arbitrary code execution

# PASS — use sandboxed environment or escape user input before rendering
```

---

## Category 3: Broken authentication and session management

- [ ] Passwords stored as plaintext or with weak hashing (MD5, SHA1)?
- [ ] Session tokens generated with weak randomness (`random` module instead of `secrets`)?
- [ ] JWT tokens not validated (signature skipped, `alg: none` accepted)?
- [ ] Session IDs not rotated after login?
- [ ] Authentication tokens logged to console or files?

```python
# CRITICAL — weak password hashing
import hashlib
hashed = hashlib.md5(password.encode()).hexdigest()

# PASS — use bcrypt or argon2
from argon2 import PasswordHasher
ph = PasswordHasher()
hashed = ph.hash(password)
```

---

## Category 4: Sensitive data exposure

- [ ] Sensitive data returned in API responses that isn't needed?
- [ ] PII (email, phone, SSN) logged to console or log files?
- [ ] Error messages that include stack traces, DB schema, or internal paths?
- [ ] Data transmitted over HTTP instead of HTTPS?
- [ ] Credentials or tokens visible in URLs (query parameters)?

```python
# HIGH — password hash returned in API response
return {"id": user.id, "email": user.email, "password_hash": user.password_hash}

# PASS — exclude sensitive fields
return {"id": user.id, "email": user.email}
```

---

## Category 5: Broken access control

- [ ] Is authorization checked for every endpoint that accesses user-owned resources?
- [ ] Can a user access another user's data by changing an ID in the URL (IDOR)?
- [ ] Are admin endpoints protected by role checks, not just authentication?
- [ ] Does the API surface internal IDs (sequential integers) that enable enumeration?

```python
# HIGH — IDOR: any authenticated user can read any invoice
@app.get("/invoices/{invoice_id}")
def get_invoice(invoice_id: int, current_user: User = Depends(get_current_user)):
    return db.get_invoice(invoice_id)  # no ownership check!

# PASS — verify ownership before returning
@app.get("/invoices/{invoice_id}")
def get_invoice(invoice_id: int, current_user: User = Depends(get_current_user)):
    invoice = db.get_invoice(invoice_id)
    if invoice.owner_id != current_user.id:
        raise HTTPException(status_code=403, detail="Forbidden")
    return invoice
```

---

## Category 6: Security misconfiguration

- [ ] Debug mode enabled in production (`DEBUG=True`, `app.run(debug=True)`)?
- [ ] Default credentials in use?
- [ ] CORS configured to allow any origin (`Access-Control-Allow-Origin: *`) for credentialed endpoints?
- [ ] Unnecessary HTTP methods enabled (e.g., DELETE on read-only endpoints)?
- [ ] Verbose error pages that reveal framework/version details?

---

## Category 7: Insecure deserialization

- [ ] Is `pickle.loads()` called on user-supplied data? (arbitrary code execution)
- [ ] Is `yaml.load()` used instead of `yaml.safe_load()`?
- [ ] Is `eval()` or `exec()` called with user input?
- [ ] Is JSON parsed and then immediately `eval`'d?

```python
# CRITICAL — pickle deserialization of untrusted data
data = pickle.loads(request.data)  # remote code execution

# CRITICAL — unsafe YAML load
config = yaml.load(user_config)  # use yaml.safe_load()

# CRITICAL — eval of user input
result = eval(user_expression)  # arbitrary code execution
```

---

## Category 8: Using components with known vulnerabilities

- [ ] Check Python packages against `pip-audit` or `safety` database
- [ ] Check Node packages against `npm audit`
- [ ] Are dependency versions pinned (to prevent supply chain attacks)?
- [ ] Are any packages imported but unused (unnecessary attack surface)?

---

## Category 9: Insufficient logging and monitoring

- [ ] Are authentication failures logged (with IP, timestamp, user)?
- [ ] Are authorization failures logged?
- [ ] Are high-value operations logged (data export, admin actions, privilege escalation)?
- [ ] Are logs stored where they can be reviewed, not just printed to stdout?
- [ ] Are sensitive values (passwords, tokens) absent from log entries?

---

## Category 10: Cross-Site Request Forgery (CSRF)

(Mark N/A for pure API backends with no browser session cookies)

- [ ] Are state-changing endpoints (POST, PUT, DELETE) protected by CSRF tokens?
- [ ] Is `SameSite=Strict` or `SameSite=Lax` set on session cookies?

---

## Output format

After scanning all categories, provide:

### Summary table

| Severity | Count |
|----------|-------|
| CRITICAL | N |
| HIGH | N |
| MEDIUM | N |
| LOW | N |
| INFO | N |

### Prioritized findings

List all findings from CRITICAL down to LOW, each with the full format shown above.

### Overall verdict

```text
VERDICT: [PASS / NEEDS WORK / FAIL]

[2-3 sentences: overall security posture, most important finding,
recommended first action]
```

### Quick wins

List up to 5 changes that can be made in under 30 minutes each that would have the highest security impact.

---

Begin the scan now on the selected code or file.
