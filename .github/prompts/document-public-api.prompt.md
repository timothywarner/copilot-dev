---
agent: agent
model: GPT-4o
description: 'Add complete JSDoc or Google-style docstrings to all public functions, classes, and methods in the selected file'
argument-hint: 'Select the code to document, or specify a file — works with TypeScript, JavaScript, and Python'
tools: ['read', 'edit']
---

Add complete, accurate documentation to all public functions, classes, and methods in the following code:

**Code to document:** `${selection}`

If no code is selected, document the file: `${file}`

---

## Documentation standards by language

Detect the language automatically from the file extension or syntax, then apply the correct standard.

---

### TypeScript / JavaScript — JSDoc

Add JSDoc comments above every:

- Exported function
- Exported class (and its public methods)
- Exported type / interface (if complex)
- Exported constant (if non-obvious)

**Do not document:**

- Internal/private helpers (prefixed `_` or not exported)
- Simple pass-through functions where the name is self-documenting
- Test files

#### JSDoc template

```typescript
/**
 * [One-sentence summary of what this function does — active voice, starts with a verb]
 *
 * [Optional: 1-2 additional sentences for complex behavior, edge cases, or important caveats.
 *  Omit this paragraph if the one-liner is sufficient.]
 *
 * @param paramName - [Description of what this parameter represents. Include type constraints
 *   if not obvious from the TypeScript type. E.g., "Must be a positive integer", "Cannot be empty."]
 * @param optionalParam - [Description.] Defaults to `defaultValue`.
 * @returns [What the function returns. If it returns an object, describe the shape.
 *   If it returns a Promise, describe what the resolved value contains.]
 * @throws {ErrorType} [When/why this error is thrown.]
 *
 * @example
 * ```typescript
 * // [Brief description of what this example demonstrates]
 * const result = myFunction('input', { option: true })
 * // result: { id: 'abc', status: 'ok' }
 * ```
 */
export function myFunction(paramName: string, optionalParam = 'default'): SomeType {
```

#### Class documentation

```typescript
/**
 * [What this class represents — its role in the system, what it encapsulates]
 *
 * [Optional: design pattern used (e.g., "Implements the Repository pattern for..."),
 *  or key invariant the class maintains]
 *
 * @example
 * ```typescript
 * const service = new TipService({ dataPath: './data/tips.json' })
 * const tips = await service.search('keyboard')
 * ```
 */
export class TipService {
  /**
   * Creates a new TipService instance.
   *
   * @param config - Configuration options for the service.
   * @param config.dataPath - Absolute or relative path to the tips JSON data file.
   * @param config.cacheEnabled - When true, caches search results for 60 seconds.
   *   Defaults to `false`.
   */
  constructor(config: TipServiceConfig) {}

  /**
   * Searches tips by keyword across title, description, and tags fields.
   *
   * Search is case-insensitive. Returns all tips when query is an empty string.
   *
   * @param query - The search term. Pass an empty string to return all tips.
   * @returns Array of tips matching the query, sorted by relevance score descending.
   *   Returns an empty array (not null) when no results match.
   * @throws {TypeError} When query is null or undefined.
   *
   * @example
   * ```typescript
   * const results = await service.search('keyboard shortcut')
   * console.log(results.length)  // e.g., 3
   * console.log(results[0].title)  // e.g., "Accept suggestion with Tab"
   * ```
   */
  async search(query: string): Promise<Tip[]> {}
}
```

---

### Python — Google-style docstrings

Add Google-style docstrings to every:

- Public function or method (no leading underscore)
- Public class
- Module-level docstring (if missing)

**Do not document:**

- Private methods (`_method_name`)
- Dunder methods (`__init__`, `__repr__`) unless they have non-obvious behavior
- Simple properties that just return a stored value

#### Function docstring template

```python
def search_tips(query: str, category: str | None = None) -> list[dict]:
    """Search tips by keyword, optionally filtered to a specific category.

    Search is case-insensitive and matches against tip title, description,
    and tags. Returns all tips when query is an empty string.

    Args:
        query: The search term. Pass an empty string to return all tips.
            Must not be None; raises TypeError if None is passed.
        category: When provided, only tips in this category are searched.
            Must match exactly one of the values in VALID_CATEGORIES.
            Defaults to None (search all categories).

    Returns:
        A list of tip dictionaries, each containing 'id', 'title',
        'category', 'description', and 'tags' keys. Returns an empty
        list (not None) when no tips match.

    Raises:
        TypeError: When query is None.
        ValueError: When category is provided but not in VALID_CATEGORIES.

    Example:
        >>> results = search_tips("keyboard", category="Shortcuts")
        >>> len(results)
        3
        >>> results[0]["title"]
        'Accept inline suggestion with Tab'
    """
```

#### Class docstring template

```python
class TipService:
    """Service layer for accessing and searching GitHub Copilot tips.

    Provides search, filter, and random-selection capabilities over the
    tips data file. Implements a simple in-memory cache to avoid repeated
    disk reads within the same request lifecycle.

    Attributes:
        data_path: Path to the JSON file containing tip data.
        cache_enabled: Whether in-memory caching is active.

    Example:
        >>> service = TipService(data_path="data/copilot_tips.json")
        >>> tips = service.search("keyboard")
        >>> print(tips[0]["title"])
        'Accept inline suggestion with Tab'
    """
```

---

## Rules for writing good documentation

### What to describe — not what the code does, but WHY and WHAT IT MEANS

```typescript
// POOR — just re-states the code
/**
 * Gets the tips and filters them by category.
 */
async function filterByCategory(category: string): Promise<Tip[]>

// GOOD — explains meaning, edge cases, return contract
/**
 * Returns all tips in the given category, sorted alphabetically by title.
 *
 * Category matching is exact and case-sensitive. Use one of the values
 * from `VALID_CATEGORIES` to avoid empty results.
 *
 * @returns An empty array (not null) when no tips match the given category.
 */
async function filterByCategory(category: string): Promise<Tip[]>
```

### @example must be realistic and runnable

```typescript
// POOR — trivial, doesn't show real usage
/**
 * @example myFunction('hello')
 */

// GOOD — shows real inputs and what the output looks like
/**
 * @example
 * ```typescript
 * const tips = await filterByCategory('Shortcuts')
 * // tips: [
 * //   { id: 'tip-001', title: 'Accept with Tab', category: 'Shortcuts', ... },
 * //   { id: 'tip-002', title: 'Dismiss with Escape', category: 'Shortcuts', ... }
 * // ]
 * ```
 */
```

### @throws must specify the error class and exact condition

```typescript
// POOR
/** @throws Error if something goes wrong */

// GOOD
/**
 * @throws {TypeError} When `query` is null or undefined.
 * @throws {RangeError} When `limit` is less than 1 or greater than 100.
 * @throws {NetworkError} When the remote data source is unreachable after 3 retries.
 */
```

---

## What NOT to document

Skip documentation for:

```typescript
// Self-evident — the name says it all
export function isEmpty(arr: unknown[]): boolean

// Internal implementation detail
function _buildQueryString(params: Record<string, string>): string

// Simple re-export
export { TipService } from './TipService'
```

---

## Final pass checklist

After generating all documentation, verify:

- [ ] Every exported function has a docstring
- [ ] Every public class and its public methods have docstrings
- [ ] All `@param` tags match the actual parameter names
- [ ] All `@returns` describe the actual return type and shape
- [ ] Each `@example` compiles/runs correctly (no typos, correct API)
- [ ] No documentation just restates the function name in prose
- [ ] Module-level docstring exists (for Python files)

Now generate complete documentation for all public APIs in the selected code.
