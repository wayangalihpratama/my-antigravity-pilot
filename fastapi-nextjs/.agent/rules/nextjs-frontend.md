---
trigger: model_decision
description: When writing or modifying frontend code (Next.js pages, React components, TypeScript, styles)
---

## Next.js Frontend Standards

### Technology Stack

- **Next.js 15** with App Router
- **React 19** with TypeScript (strict mode)
- **Tailwind CSS** for styling (utility-first)
- **Axios** for API communication
- **Jest** and **React Testing Library** for tests

### Code Style

- Use **ESLint** with Next.js configuration
- Use **Prettier** for code formatting
- Run linter: `./dc.sh exec frontend yarn lint`
- Format: `./dc.sh exec frontend prettier --write .`

### Tailwind CSS Best Practices

**Utility-First Approach:**
- Use Tailwind utility classes directly in JSX — avoid custom CSS unless necessary
- Extract repeated utility patterns into components, not `@apply` directives
- Use `@apply` only in `globals.css` for base styles (e.g., typography)

**Responsive Design:**
- Mobile-first: start with base styles, add breakpoints (`sm:`, `md:`, `lg:`, `xl:`, `2xl:`)
- Use Tailwind responsive prefixes, not CSS media queries
- Use container queries (`@container`, `@min-md:`) for component-level responsive

**State Variants (hover, focus, and other states):**
- Use `hover:`, `focus:`, `active:` for interactive states
- Use `focus-visible:` for keyboard focus (accessibility)
- Use `disabled:` for disabled form elements
- Use `group` parent + `group-hover:` to style children based on parent state
- Use `first:`, `last:`, `odd:`, `even:` for list/table styling
```tsx
// Interactive button with state variants
<button className="bg-violet-500 hover:bg-violet-600 focus:outline-2
  focus:outline-offset-2 focus:outline-violet-500 active:bg-violet-700
  disabled:opacity-50 disabled:cursor-not-allowed">

// Group hover — style children when parent is hovered
<a className="group">
  <h3 className="text-gray-900 group-hover:text-white">Title</h3>
  <p className="text-gray-500 group-hover:text-white">Description</p>
</a>

// List styling with first/last/odd/even
<tr className="odd:bg-white even:bg-gray-50 dark:odd:bg-gray-900 dark:even:bg-gray-950">
```

**Color Opacity Modifier:**
- Use `bg-black/50` syntax for opacity: `bg-sky-500/20`, `text-white/75`, `border-gray-300/25`
- Works with all color utilities: `bg-*`, `text-*`, `border-*`, `ring-*`, `shadow-*`

**Arbitrary Values:**
- Use `[]` for one-off values: `bg-[#316ff6]`, `top-[117px]`, `grid-cols-[repeat(auto-fit,minmax(280px,1fr))]`
- Use `()` for CSS variables: `fill-(--my-brand-color)`
- Combine with variants: `lg:top-[344px]`, `hover:bg-[#1a73e8]`

**Dark Mode (Tailwind v4):**
- Default: uses `prefers-color-scheme` media query
- Use `dark:` variant: `bg-white dark:bg-gray-900 text-gray-900 dark:text-gray-100`
- For manual toggle, use `@custom-variant` in CSS (not `tailwind.config.ts`):
```css
@import "tailwindcss";
@custom-variant dark (&:where(.dark, .dark *));
```

**Container Queries:**
- Use `@container` for component-level responsive design
- Use `@min-sm:`, `@min-md:`, `@min-lg:` prefixes inside containers
```tsx
<div className="@container">
  <div className="@min-md:flex @min-md:flex-row flex-col">
    {/* Layout changes based on container width, not viewport */}
  </div>
</div>
```

**Component Extraction Pattern:**
```tsx
// ❌ Don't repeat utilities everywhere
<button className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded">

// ✅ Extract into a component
function Button({ children, ...props }) {
  return (
    <button
      className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
      {...props}
    >
      {children}
    </button>
  )
}
```

**Avoid:**
- Inline `style` attributes when Tailwind has the equivalent utility
- Mixing Tailwind with CSS modules in the same component
- `!important` overrides — restructure class order instead

**⚠️ Never Construct Dynamic Class Names:**
```tsx
// ❌ WRONG — Tailwind cannot detect dynamically constructed classes
<div className={`bg-${color}-500 text-${size}`}>

// ✅ CORRECT — Map props to complete, static class name strings
const colorVariants = {
  blue: "bg-blue-600 hover:bg-blue-500 text-white",
  red: "bg-red-500 hover:bg-red-400 text-white",
}
<div className={colorVariants[color]}>
```

### Tailwind v4 CSS Directives

**Theme Customization (`@theme`):**
- Define design tokens in CSS, not `tailwind.config.ts`
```css
@import "tailwindcss";
@theme {
  --font-display: "Satoshi", "sans-serif";
  --color-brand-500: oklch(0.84 0.18 117.33);
  --breakpoint-3xl: 120rem;
}
```

**Custom CSS Layers:**
- `@layer base` — default element styles (headings, body)
- `@layer components` — reusable component classes (`btn`, `card`)
- Custom classes in `@layer components` can be overridden by utilities
```css
@layer components {
  .btn-primary {
    border-radius: calc(infinity * 1px);
    background-color: var(--color-violet-500);
    padding-inline: --spacing(5);
    padding-block: --spacing(2);
    font-weight: var(--font-weight-semibold);
    color: var(--color-white);
  }
}
```

**Custom Utilities & Variants:**
```css
/* Custom utility that works with all variants */
@utility tab-4 {
  tab-size: 4;
}

/* Use @variant in custom CSS for dark mode etc. */
.my-element {
  background: white;
  @variant dark {
    background: black;
  }
}

/* Register additional source paths for class detection */
@source "../node_modules/@my-company/ui-lib";
```

### Responsive Design (Mandatory)

**Every page and component MUST be responsive.** Test at all breakpoints before considering work complete.

**Mobile-First Architecture:**
- Write base styles for mobile (320px+), then add breakpoints
- Tailwind breakpoints: `sm` (640px), `md` (768px), `lg` (1024px), `xl` (1280px), `2xl` (1536px)
- Always start with the smallest screen and scale up

**Responsive Layout Strategy:**
```tsx
// Stack on mobile, side-by-side on desktop
<div className="flex flex-col md:flex-row gap-4">

// Responsive grid: 1 col → 2 col → 3 col
<div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">

// Auto-fit grid (adapts to available space)
<div className="grid grid-cols-[repeat(auto-fit,minmax(280px,1fr))] gap-4">

// Full-width on mobile, constrained on desktop
<div className="w-full max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
```

**Responsive Typography:**
```tsx
// Scale text size across breakpoints
<h1 className="text-2xl sm:text-3xl lg:text-4xl xl:text-5xl font-bold">

// Responsive line length for readability
<p className="max-w-prose">
```

**Touch Targets:**
- Minimum touch target: 44×44px for buttons and interactive elements
- Use `min-h-[44px] min-w-[44px]` for small interactive elements
- Add adequate spacing between clickable items on mobile

**Responsive Images:**
```tsx
import Image from 'next/image'

<Image
  src="/hero.jpg"
  alt="Hero"
  width={1200}
  height={600}
  sizes="(max-width: 768px) 100vw, (max-width: 1200px) 50vw, 33vw"
  className="w-full h-auto object-cover"
/>
```

**Navigation Pattern:**
```tsx
// Desktop nav visible, mobile hamburger
<nav className="hidden md:flex items-center gap-6">{/* links */}</nav>
<button className="md:hidden p-2" aria-label="Menu">☰</button>
```

**Responsive Checklist (Must pass before merge):**
- [ ] Works on 320px (small mobile)
- [ ] Works on 375px (standard mobile)
- [ ] Works on 768px (tablet)
- [ ] Works on 1024px (desktop)
- [ ] Works on 1440px+ (large desktop)
- [ ] No horizontal scroll at any breakpoint
- [ ] Touch targets ≥44px on mobile
- [ ] Text is readable without zooming
- [ ] Images scale properly
- [ ] Navigation is accessible on all sizes

### React Server Component (RSC) Boundaries

**Server Components (default):**
- Can be `async` and fetch data directly
- Cannot use hooks, event handlers, or browser APIs
- Ideal for data fetching, metadata, layout

**Client Components (`'use client'`):**
- Required for: hooks, event handlers, browser APIs, state
- Keep as small as possible — push state to leaf components

```tsx
// ❌ Wrong: Entire page is client
'use client'
export default function Page() { ... }

// ✅ Right: Only interactive parts are client
export default async function Page() {
  const data = await fetchData()
  return <ClientWidget initialData={data} />
}
```

### Data Fetching Patterns

**Server Components:** Fetch directly (preferred)
```tsx
async function Page() {
  const data = await fetch('http://backend:8000/api/users')
  return <UserList users={data} />
}
```

**Client Components:** Use SWR or Axios
```tsx
'use client'
import useSWR from 'swr'

function UserList() {
  const { data, error } = useSWR('/api/users', fetcher)
  // ...
}
```

### Performance Rules (Priority Order)

1. **Eliminate waterfalls** — Use `Promise.all()` for independent operations
2. **Optimize bundle** — Import directly (avoid barrel files), use `next/dynamic` for heavy components
3. **Server-side perf** — Minimize data in client component props
4. **Re-render optimization** — Use `useMemo`, `useCallback` only when profiling shows need

### Error Handling

- Use `error.tsx` for route-level boundaries
- Use `not-found.tsx` for 404 pages
- Use `loading.tsx` for Suspense fallbacks

### Image & Font Optimization

- Always use `next/image` over `<img>`
- Use `next/font` for font loading
- Set `sizes` attribute for responsive images

### Testing

- Use **Jest** + **React Testing Library**
- Run tests: `./dc.sh exec frontend yarn test`
- Test component behavior, not implementation
- Name tests: `should [behavior] when [condition]`

### Related Rules
- Docker Commands @docker-commands.md
- Testing Strategy @testing-strategy.md
- Security Mandate @security-mandate.md
