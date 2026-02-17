---
trigger: model_decision
description: When writing or modifying frontend code (Inertia.js pages, React components, Tailwind CSS, Vite config)
---

## Inertia + React Frontend Standards

### Technology Stack

- **React 19** with JSX (via Inertia.js)
- **Inertia.js** for server-driven SPA
- **Tailwind CSS 4** for styling (utility-first)
- **Vite** for asset bundling and HMR

### File Structure

```
resources/
├── js/
│   ├── app.jsx              # Inertia app bootstrap
│   ├── bootstrap.js         # Axios config
│   ├── Pages/               # Inertia pages (correspond to controllers)
│   │   ├── Welcome.jsx
│   │   ├── Posts/
│   │   │   ├── Index.jsx
│   │   │   ├── Show.jsx
│   │   │   └── Edit.jsx
│   ├── Components/          # Reusable React components
│   │   ├── ui/              # Base UI components
│   │   └── layouts/         # Layout components
│   └── Hooks/               # Custom React hooks
├── css/
│   └── app.css              # Tailwind imports + custom styles
└── views/
    └── app.blade.php        # Root Blade template for Inertia
```

### Inertia Conventions

**Page components** must export default and correspond to controller methods:
```jsx
// resources/js/Pages/Posts/Index.jsx
import { Head, Link } from '@inertiajs/react'

export default function Index({ posts }) {
    return (
        <>
            <Head title="Posts" />
            {posts.map(post => (
                <Link key={post.id} href={`/posts/${post.id}`}>
                    {post.title}
                </Link>
            ))}
        </>
    )
}
```

**Use Inertia form helpers** for mutations:
```jsx
import { useForm } from '@inertiajs/react'

function CreatePost() {
    const { data, setData, post, processing, errors } = useForm({
        title: '', body: '',
    })

    function submit(e) {
        e.preventDefault()
        post('/posts')
    }

    return (
        <form onSubmit={submit}>
            <input value={data.title} onChange={e => setData('title', e.target.value)} />
            {errors.title && <p className="text-red-500 text-sm">{errors.title}</p>}
            <button disabled={processing}>Create</button>
        </form>
    )
}
```

### Tailwind CSS Best Practices

**Utility-First Approach:**
- Use Tailwind utility classes directly in JSX — avoid custom CSS unless necessary
- Extract repeated utility patterns into components, not `@apply` directives
- Use `@apply` only in `app.css` for base styles (e.g., typography)

**State Variants (hover, focus, and other states):**
- Use `hover:`, `focus:`, `active:` for interactive states
- Use `focus-visible:` for keyboard focus (accessibility)
- Use `disabled:` for disabled form elements
- Use `group` parent + `group-hover:` to style children based on parent state
- Use `first:`, `last:`, `odd:`, `even:` for list/table styling
```jsx
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

**Container Queries:**
- Use `@container` for component-level responsive design
- Use `@min-sm:`, `@min-md:`, `@min-lg:` prefixes inside containers
```jsx
<div className="@container">
  <div className="@min-md:flex @min-md:flex-row flex-col">
    {/* Layout changes based on container width, not viewport */}
  </div>
</div>
```

**Component Extraction Pattern:**
```jsx
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

**Dark Mode (Tailwind v4):**
- Default: uses `prefers-color-scheme` media query
- Use `dark:` variant: `bg-white dark:bg-gray-900 text-gray-900 dark:text-gray-100`
- For manual toggle, use `@custom-variant` in CSS (not `tailwind.config.ts`):
```css
@import "tailwindcss";
@custom-variant dark (&:where(.dark, .dark *));
```

**Avoid:**
- Inline `style` attributes when Tailwind has the equivalent utility
- Mixing Tailwind with CSS modules in the same component
- `!important` overrides — restructure class order instead

**⚠️ Never Construct Dynamic Class Names:**
```jsx
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

**Every page and component MUST be responsive.** Test at all breakpoints before merge.

**Mobile-First Architecture:**
- Write base styles for mobile (320px+), then add breakpoints
- Tailwind breakpoints: `sm` (640px), `md` (768px), `lg` (1024px), `xl` (1280px), `2xl` (1536px)
- Always start with the smallest screen and scale up

**Responsive Layout Strategy:**
```jsx
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
```jsx
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
```jsx
<img
  src="/hero.jpg"
  alt="Hero"
  className="w-full h-auto object-cover rounded-lg"
  loading="lazy"
/>
```

**Navigation Pattern:**
```jsx
// Desktop nav visible, mobile hamburger
<nav className="hidden md:flex items-center gap-6">{/* links */}</nav>
<button className="md:hidden p-2 min-h-[44px]" aria-label="Menu">☰</button>
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

### Performance Rules

1. **No jQuery** — use React hooks and Inertia helpers
2. **No direct DOM manipulation** — use React state/refs
3. **Use `Link` from `@inertiajs/react`** for navigation (preserves SPA state)
4. **Lazy load heavy components** with `React.lazy()` and `Suspense`
5. **Use `useMemo`/`useCallback`** only when profiling shows need

### Related Rules
- Docker Commands @docker-commands.md
- Security Mandate @security-mandate.md
- Testing Strategy @testing-strategy.md
