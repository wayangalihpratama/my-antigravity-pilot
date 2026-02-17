---
name: nextjs-patterns
description: Next.js 15 best practices and patterns. Use when creating pages, components, data fetching, or optimizing the frontend. Covers App Router conventions, RSC boundaries, async patterns, error handling, Tailwind CSS patterns, and performance optimization.
---

# Next.js 15 Patterns

## File Conventions

### Special Files (App Router)

| File | Purpose |
|------|---------|
| `page.tsx` | Route page component |
| `layout.tsx` | Shared layout (persists across navigations) |
| `loading.tsx` | Loading UI (Suspense fallback) |
| `error.tsx` | Error boundary for route |
| `not-found.tsx` | 404 UI |
| `template.tsx` | Re-rendered layout |

### Route Segments

| Pattern | Syntax | Example |
|---------|--------|---------|
| Dynamic | `[param]` | `/users/[id]` |
| Catch-all | `[...param]` | `/docs/[...slugs]` |
| Optional catch-all | `[[...param]]` | `/shop/[[...categories]]` |
| Route groups | `(group)` | `/(auth)/login` |

## RSC Boundaries

### Server Components (default)

```tsx
// No directive needed — server by default
export default async function Page() {
  const data = await fetchData()  // Direct async fetch
  return <div>{data.title}</div>
}
```

**Can:** async/await, access backend, read files, use secrets
**Cannot:** hooks, event handlers, browser APIs, state

### Client Components

```tsx
'use client'

import { useState } from 'react'

export default function Counter() {
  const [count, setCount] = useState(0)
  return <button onClick={() => setCount(c => c + 1)}>{count}</button>
}
```

**Rule:** Keep `'use client'` as low in the tree as possible.

### Invalid Patterns

```tsx
// ❌ Async client component (INVALID in React 19)
'use client'
export default async function Page() { ... }

// ❌ Non-serializable props to client components
<ClientComp callback={() => {}} />  // Functions can't serialize
```

## Async Patterns (Next.js 15+)

In Next.js 15+, `params`, `searchParams`, `cookies()`, `headers()` are **async**:

```tsx
// ✅ Correct
export default async function Page({
  params,
}: {
  params: Promise<{ id: string }>
}) {
  const { id } = await params
  return <div>{id}</div>
}
```

## Data Fetching

### Server Components (preferred)

```tsx
async function UserPage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params
  const res = await fetch(`http://backend:8000/api/users/${id}`)
  const user = await res.json()
  return <UserProfile user={user} />
}
```

### Avoid Waterfalls

```tsx
// ❌ Sequential (waterfall)
const user = await fetchUser(id)
const posts = await fetchPosts(id)

// ✅ Parallel
const [user, posts] = await Promise.all([
  fetchUser(id),
  fetchPosts(id),
])
```

### Client-Side Data Fetching

Use SWR or Axios for client components:

```tsx
'use client'
import useSWR from 'swr'
import axios from 'axios'

const fetcher = (url: string) => axios.get(url).then(r => r.data)

function UserList() {
  const { data, error, isLoading } = useSWR('/api/users', fetcher)
  if (isLoading) return <Loading />
  if (error) return <Error error={error} />
  return <ul>{data.map(u => <li key={u.id}>{u.name}</li>)}</ul>
}
```

## Error Handling

```
app/
├── global-error.tsx   # Root error boundary (catches layout errors)
├── error.tsx          # App-level error boundary
├── not-found.tsx      # 404 page
└── users/
    ├── error.tsx      # Route-specific error boundary
    └── not-found.tsx  # Route-specific 404
```

```tsx
// error.tsx
'use client'

export default function Error({
  error,
  reset,
}: {
  error: Error & { digest?: string }
  reset: () => void
}) {
  return (
    <div>
      <h2>Something went wrong!</h2>
      <button onClick={() => reset()}>Try again</button>
    </div>
  )
}
```

## Performance Quick Reference

| Priority | Category | Key Rules |
|----------|----------|-----------|
| CRITICAL | Waterfalls | Use `Promise.all()`, Suspense boundaries |
| CRITICAL | Bundle size | Direct imports (no barrel files), `next/dynamic` |
| HIGH | Server perf | Minimize client component props, parallel fetches |
| MEDIUM | Re-renders | `useMemo`/`useCallback` only when profiling shows need |

## Image & Font Optimization

```tsx
import Image from 'next/image'

// ✅ Always use next/image
<Image src="/photo.jpg" alt="Photo" width={800} height={600} />

// ❌ Never use raw img
<img src="/photo.jpg" />
```

## Tailwind CSS Patterns

### Layout Utilities

```tsx
// Flexbox layout
<div className="flex items-center justify-between gap-4">
  <h1 className="text-2xl font-bold">Title</h1>
  <button className="btn">Action</button>
</div>

// Grid layout
<div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
  {items.map(item => <Card key={item.id} {...item} />)}
</div>

// Container with responsive padding
<div className="container mx-auto px-4 sm:px-6 lg:px-8">
```

### Responsive Design (Mobile-First)

**Breakpoint Reference:**
| Prefix | Min Width | Typical Device |
|--------|-----------|----------------|
| (none) | 0px | Small mobile |
| `sm:` | 640px | Large mobile |
| `md:` | 768px | Tablet |
| `lg:` | 1024px | Laptop |
| `xl:` | 1280px | Desktop |
| `2xl:` | 1536px | Large desktop |

```tsx
// Base = mobile, then scale up
<div className="
  text-sm          {/* mobile */}
  md:text-base     {/* tablet */}
  lg:text-lg       {/* desktop */}
">

// Stack → side-by-side
<div className="flex flex-col md:flex-row gap-4">

// Responsive grid
<div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">

// Auto-fit grid (fluid, no breakpoints needed)
<div className="grid grid-cols-[repeat(auto-fit,minmax(280px,1fr))] gap-4">

// Hide/show at breakpoints
<nav className="hidden md:flex">        {/* Desktop nav */}
<button className="md:hidden">☰</button> {/* Mobile hamburger */}

// Responsive padding
<div className="px-4 sm:px-6 lg:px-8">

// Responsive spacing
<section className="py-8 md:py-12 lg:py-16">
```

### Responsive Containers & Aspect Ratios

```tsx
// Container with max-width
<div className="container mx-auto px-4">

// Aspect ratio (video, cards, images)
<div className="aspect-video">      {/* 16:9 */}
<div className="aspect-square">     {/* 1:1 */}
<div className="aspect-[4/3]">      {/* 4:3 */}

// Full viewport sections
<section className="min-h-screen flex items-center justify-center">
```

### Responsive Tables

```tsx
// Horizontal scroll on mobile, full table on desktop
<div className="overflow-x-auto">
  <table className="min-w-full divide-y divide-gray-200 dark:divide-gray-700">
    {/* table content */}
  </table>
</div>

// Alternative: card layout on mobile, table on desktop
<div className="hidden md:block">{/* Table view */}</div>
<div className="md:hidden space-y-4">{/* Card view */}</div>
```

### Responsive Forms

```tsx
// Full-width inputs on mobile, side-by-side on desktop
<form className="space-y-4">
  <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
    <input className="w-full px-3 py-2 border rounded-md min-h-[44px]" />
    <input className="w-full px-3 py-2 border rounded-md min-h-[44px]" />
  </div>
  <button className="w-full md:w-auto px-6 py-2 min-h-[44px]">
    Submit
  </button>
</form>
```

### Dark Mode

```tsx
<div className="bg-white dark:bg-gray-900 text-gray-900 dark:text-gray-100">
  <p className="text-gray-600 dark:text-gray-400">Subtitle</p>
</div>
```

### Conditional Classes Pattern

Use `clsx` or a `cn()` helper for conditional Tailwind classes:

```tsx
import { clsx } from 'clsx'

function Button({ variant = 'primary', disabled, children }) {
  return (
    <button
      className={clsx(
        'px-4 py-2 rounded font-medium transition-colors',
        {
          'bg-blue-600 text-white hover:bg-blue-700': variant === 'primary',
          'bg-gray-200 text-gray-800 hover:bg-gray-300': variant === 'secondary',
          'opacity-50 cursor-not-allowed': disabled,
        }
      )}
    >
      {children}
    </button>
  )
}
```

### Animation Utilities

```tsx
// Transitions
<button className="transition-colors duration-200 hover:bg-blue-700">

// Transform on hover
<div className="transition-transform hover:scale-105">

// Built-in animations
<div className="animate-spin">⟳</div>
<div className="animate-pulse">Loading...</div>
```

## Responsive Testing

**Every page must pass at these widths before merge:**

| Width | What to Check |
|-------|---------------|
| 320px | No overflow, readable text, stacked layout |
| 375px | Standard mobile — touch targets ≥44px |
| 768px | Tablet — grid switches, nav transitions |
| 1024px | Desktop layout fully kicks in |
| 1440px+ | No awkward stretching, max-width containers |

**Common Responsive Bugs to Avoid:**
- Horizontal scrollbar at any breakpoint
- Fixed-width elements that break on mobile
- Text too small to read without zooming
- Buttons/links too close together for touch
- Images overflowing their containers
- Modals/dialogs not fitting mobile viewport

## Metadata

```tsx
// Static metadata
export const metadata = {
  title: 'My Page',
  description: 'Page description',
}

// Dynamic metadata
export async function generateMetadata({ params }) {
  const { id } = await params
  return { title: `User ${id}` }
}
```

## Rule Compliance

- NextJS Frontend @nextjs-frontend.md
- Docker Commands @docker-commands.md
- Testing Strategy @testing-strategy.md
