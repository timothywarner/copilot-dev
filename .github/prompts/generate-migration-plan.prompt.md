---
agent: agent
model: Claude Sonnet 4
description: 'Scan the codebase and produce a phased migration plan with effort estimates and breaking change inventory'
argument-hint: 'Describe the migration (e.g., "JavaScript to TypeScript", "React 17 to 19", "Python 2 to 3", "REST to GraphQL")'
tools: ['read', 'search/codebase', 'list', 'fetch']
---

Your goal is to analyze this codebase and produce a structured, actionable migration plan for the following migration:

**Migration target:** `${input:migrationTarget:Describe your migration — e.g., JavaScript to TypeScript}`

---

## Phase 1: Codebase discovery

First, scan the codebase to understand the current state. Use `#codebase` search to explore:

1. **Count and categorize source files** — how many files exist per type, per directory?
2. **Identify the technology stack** — framework, language version, build tools, test runner
3. **Find dependency versions** — check `package.json`, `pyproject.toml`, `requirements.txt`, `Cargo.toml`, or equivalent
4. **Locate configuration files** — `tsconfig.json`, `.babelrc`, `jest.config.*`, `webpack.config.*`, etc.
5. **Identify external integrations** — APIs called, databases used, third-party SDKs

Report findings in this format:

```text
## Codebase Summary
- Language: [current version]
- Framework: [name + version]
- Total source files: [N]
- Test files: [N] ([coverage]%)
- Key dependencies: [list top 10]
- Build tooling: [bundler, transpiler, linter]
```

---

## Phase 2: Breaking change inventory

Scan for every pattern that will break or require change during the migration. Categorize each:

| Severity | Meaning |
|----------|---------|
| BLOCKING | Migration cannot proceed until this is resolved |
| HIGH | Will break at runtime; must fix in early phases |
| MEDIUM | Will break at compile/lint time; fix per phase |
| LOW | Deprecation warnings; fix opportunistically |

For each issue found, output:

```text
[SEVERITY] File: path/to/file.js  Line: N
  Pattern: what the current code does
  Change needed: what it must become after migration
  Effort: S / M / L (Small <1h, Medium 1-4h, Large >4h)
```

### Migration-specific patterns to look for

**JavaScript → TypeScript:**

- Implicit `any` from untyped function parameters
- `module.exports` / `require()` (CommonJS → ESM)
- Missing return types on public functions
- `undefined` checks vs. optional chaining
- Third-party packages with no `@types/` definitions
- Dynamic property access (`obj[key]`) requiring index signatures

**React 17 → React 19:**

- `ReactDOM.render()` → `createRoot()`
- Class components with `componentDidMount` etc. → hooks
- Legacy Context API (`contextTypes`, `getChildContext`) → `createContext`
- `string` refs → `useRef()`
- `findDOMNode()` usage (removed in React 19)
- `defaultProps` on function components (deprecated)
- `act()` import changes in tests

**Python 2 → Python 3:**

- `print` statements → `print()` function
- `unicode` / `str` / `bytes` confusion
- `dict.iteritems()`, `.itervalues()`, `.iterkeys()` → `.items()` etc.
- `xrange()` → `range()`
- Integer division: `5/2` → `5//2`
- `__future__` imports to remove
- `raw_input()` → `input()`

**REST → GraphQL:**

- Each REST endpoint becomes a Query or Mutation
- Pagination patterns (offset-based → cursor-based)
- Authentication header changes
- N+1 query patterns that GraphQL DataLoader must solve
- File upload handling differences
- Error shape differences (HTTP status codes → GraphQL `errors` array)

---

## Phase 3: Dependency audit

For each dependency, check:

1. Is it compatible with the migration target?
2. Is there a migration guide or codemod available?
3. Is it still actively maintained?
4. Should it be replaced entirely?

Output a table:

```text
| Package | Current | Target-compatible | Action |
|---------|---------|------------------|--------|
| react   | 17.0.2  | Yes (upgrade to 19.0) | npm install react@19 |
| enzyme  | 3.11    | No (unmaintained) | Replace with @testing-library/react |
```

---

## Phase 4: Migration plan (phased)

Break the migration into phases where each phase results in a working, deployable codebase. Never plan a "big bang" migration that leaves the app broken for more than one sprint.

### Phase template

```text
## Phase N: [Name]
Duration: [N days/weeks]
Effort: [N person-days]
Prerequisites: Phase N-1 complete

### Objectives
- [What this phase accomplishes]

### Tasks (in order)
1. [Specific task — which files, what change, what tool/codemod]
2. ...

### Success criteria
- [ ] All existing tests pass
- [ ] No new type errors / lint errors
- [ ] App builds and runs locally
- [ ] CI/CD pipeline passes

### Rollback plan
[How to undo this phase if something goes wrong]
```

### Recommended phase structure

**Phase 0: Prerequisites & tooling** (1-3 days)

- Add migration toolchain (TypeScript compiler, codemods, etc.)
- Configure new tooling alongside existing (not replacing yet)
- Add CI check for new format
- Brief: no production code changes

**Phase 1: Low-hanging fruit** (3-7 days)

- Migrate leaf files (utilities, helpers) that have no dependents
- Run available codemods (e.g., `ts-migrate`, `react-codemod`, `2to3`)
- Establish the pattern for the rest of the team

**Phase 2: Core domain** (1-2 weeks)

- Migrate business logic and data layer
- Highest value: types/contracts that touch everything

**Phase 3: UI / presentation layer** (1-2 weeks)

- Migrate components and views
- Update tests alongside each component

**Phase 4: Infrastructure & integration** (3-5 days)

- Build config, CI/CD, deployment scripts
- Update Docker images, environment variables

**Phase 5: Cleanup & polish** (2-3 days)

- Remove compatibility shims
- Enable strict mode / additional lint rules
- Final audit for remaining legacy patterns

---

## Phase 5: Tooling recommendations

List specific tools that automate or assist this migration:

```text
## Recommended tooling

### Codemods / automation
- [tool name]: [what it automates] — [how to run it]

### Type stubs / adapters
- [package]: [what it provides]

### Linting during transition
- [ESLint rule or Mypy config]: [how to enable incrementally]

### Testing approach
- Run old and new implementations in parallel for [N] weeks
- Use feature flags to switch between implementations
```

---

## Phase 6: Risk assessment

```text
## Risks

| Risk | Probability | Impact | Mitigation |
|------|------------|--------|------------|
| Third-party library incompatible | Medium | High | Pin version, fork, or replace |
| Test coverage too low to detect regressions | High | High | Add tests in Phase 0 before migrating |
| Team unfamiliar with target tech | Medium | Medium | 1-day workshop before Phase 1 |
```

---

Now scan the codebase and produce the complete migration plan for: **`${input:migrationTarget:your migration}`**

Start with Phase 1 discovery, then work through each section above. Be specific — include actual file names, line numbers, and commands wherever possible.
