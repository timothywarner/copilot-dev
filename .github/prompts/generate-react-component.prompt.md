---
agent: agent
model: GPT-4o
description: 'Scaffold a production-ready TypeScript React functional component with props, hooks, accessibility, and a test stub'
argument-hint: 'Component name and purpose (e.g., "UserProfileCard — displays user avatar, name, and role")'
tools: ['read', 'edit', 'search/codebase']
---

Your goal is to scaffold a complete, production-ready React functional component based on the information provided.

## What I need from you

If the component name and purpose are not already specified, ask for:

1. **Component name** — PascalCase, descriptive (e.g., `UserProfileCard`, `SearchResultsList`)
2. **Component purpose** — one sentence describing what it renders and what it does
3. **Key props** — what data does it accept? What callbacks does it expose?
4. **State needed?** — does it manage any local state (loading, open/closed, selected item)?

Component name: `${input:componentName:MyComponent}`
Component purpose: `${input:componentPurpose:Describe what this component does}`

---

## What I'll generate

### 1. The component file: `${input:componentName:MyComponent}.tsx`

```tsx
import { useState, useEffect, useCallback } from 'react'

// --- Types ---

/**
 * Props for the ${input:componentName:MyComponent} component.
 */
export interface ${input:componentName:MyComponent}Props {
  /** Primary data to display */
  data: SomeDataType
  /** Called when the user performs the primary action */
  onAction?: (item: SomeDataType) => void
  /** Optional CSS class for the root element */
  className?: string
  /** When true, renders in a loading/skeleton state */
  isLoading?: boolean
}

// --- Component ---

/**
 * ${input:componentName:MyComponent} — ${input:componentPurpose:describe what this renders}
 *
 * @example
 * ```tsx
 * <${input:componentName:MyComponent}
 *   data={myData}
 *   onAction={(item) => console.log('Action on', item)}
 * />
 * ```
 */
export function ${input:componentName:MyComponent}({
  data,
  onAction,
  className = '',
  isLoading = false,
}: ${input:componentName:MyComponent}Props) {
  // Local state
  const [isExpanded, setIsExpanded] = useState(false)

  // Side effects
  useEffect(() => {
    // Example: reset expanded state when data changes
    setIsExpanded(false)
  }, [data])

  // Stable callbacks
  const handleAction = useCallback(() => {
    onAction?.(data)
  }, [data, onAction])

  // Loading state guard
  if (isLoading) {
    return (
      <div
        className={`animate-pulse rounded-lg bg-gray-100 h-24 ${className}`}
        aria-busy="true"
        aria-label="Loading..."
      />
    )
  }

  return (
    <article
      className={`rounded-lg border p-4 ${className}`}
      aria-label={`${input:componentName:MyComponent} for ${data.name ?? 'item'}`}
    >
      {/* Header */}
      <header className="flex items-center justify-between">
        <h2 className="text-lg font-semibold">{data.name}</h2>
        <button
          type="button"
          onClick={() => setIsExpanded((prev) => !prev)}
          aria-expanded={isExpanded}
          aria-controls="component-details"
          className="text-sm text-blue-600 hover:underline focus-visible:outline-2"
        >
          {isExpanded ? 'Collapse' : 'Expand'}
        </button>
      </header>

      {/* Expandable details */}
      {isExpanded && (
        <section id="component-details" className="mt-2 text-sm text-gray-600">
          {data.description}
        </section>
      )}

      {/* Primary action */}
      {onAction && (
        <footer className="mt-4">
          <button
            type="button"
            onClick={handleAction}
            className="rounded bg-blue-600 px-4 py-2 text-white hover:bg-blue-700 focus-visible:outline-2"
          >
            Take Action
          </button>
        </footer>
      )}
    </article>
  )
}

export default ${input:componentName:MyComponent}
```

### 2. The test stub: `${input:componentName:MyComponent}.test.tsx`

```tsx
import { render, screen, fireEvent } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { ${input:componentName:MyComponent} } from './${input:componentName:MyComponent}'

// --- Test data factory (immutable) ---
const makeMockData = (overrides = {}) => ({
  name: 'Test Item',
  description: 'A description for testing purposes.',
  id: 'item-001',
  ...overrides,
})

describe('${input:componentName:MyComponent}', () => {
  describe('rendering', () => {
    it('renders with required props', () => {
      render(<${input:componentName:MyComponent} data={makeMockData()} />)
      expect(screen.getByRole('article')).toBeInTheDocument()
    })

    it('renders item name as heading', () => {
      render(<${input:componentName:MyComponent} data={makeMockData({ name: 'My Item' })} />)
      expect(screen.getByRole('heading', { name: 'My Item' })).toBeInTheDocument()
    })

    it('renders loading skeleton when isLoading is true', () => {
      render(<${input:componentName:MyComponent} data={makeMockData()} isLoading />)
      expect(screen.getByLabelText('Loading...')).toBeInTheDocument()
      expect(screen.queryByRole('heading')).not.toBeInTheDocument()
    })
  })

  describe('expand/collapse', () => {
    it('shows description when expanded', async () => {
      const user = userEvent.setup()
      render(<${input:componentName:MyComponent} data={makeMockData()} />)

      await user.click(screen.getByRole('button', { name: /expand/i }))
      expect(screen.getByText('A description for testing purposes.')).toBeVisible()
    })

    it('hides description when collapsed again', async () => {
      const user = userEvent.setup()
      render(<${input:componentName:MyComponent} data={makeMockData()} />)

      await user.click(screen.getByRole('button', { name: /expand/i }))
      await user.click(screen.getByRole('button', { name: /collapse/i }))
      expect(screen.queryByText('A description for testing purposes.')).not.toBeInTheDocument()
    })
  })

  describe('action callback', () => {
    it('calls onAction with the data item when action button clicked', async () => {
      const user = userEvent.setup()
      const mockData = makeMockData()
      const onAction = jest.fn()

      render(<${input:componentName:MyComponent} data={mockData} onAction={onAction} />)
      await user.click(screen.getByRole('button', { name: /take action/i }))

      expect(onAction).toHaveBeenCalledTimes(1)
      expect(onAction).toHaveBeenCalledWith(mockData)
    })

    it('does not render action button when onAction is not provided', () => {
      render(<${input:componentName:MyComponent} data={makeMockData()} />)
      expect(screen.queryByRole('button', { name: /take action/i })).not.toBeInTheDocument()
    })
  })

  describe('accessibility', () => {
    it('expand button has correct aria-expanded state', async () => {
      const user = userEvent.setup()
      render(<${input:componentName:MyComponent} data={makeMockData()} />)

      const btn = screen.getByRole('button', { name: /expand/i })
      expect(btn).toHaveAttribute('aria-expanded', 'false')

      await user.click(btn)
      expect(screen.getByRole('button', { name: /collapse/i })).toHaveAttribute('aria-expanded', 'true')
    })
  })
})
```

---

## Checklist before I generate

Confirm (or let me infer from your description):

- [ ] Props shape — what data does the component receive?
- [ ] Does it need `useState`? What state?
- [ ] Does it need `useEffect`? For what side effect?
- [ ] Does it fire any callbacks (`onClick`, `onChange`, etc.)?
- [ ] Any conditional rendering (loading, empty, error states)?

Provide your component name and purpose above, and I'll generate both files tailored to your actual use case.
