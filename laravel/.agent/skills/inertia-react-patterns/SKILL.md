---
name: inertia-react-patterns
description: Inertia.js + React 19 patterns for Laravel. Use when creating pages, forms, layouts, or working with shared data. Covers Inertia conventions, Tailwind CSS responsive patterns, and performance optimization.
---

# Inertia.js + React Patterns

## Inertia Page Conventions

### Page Component Structure

```jsx
import { Head, Link, usePage } from '@inertiajs/react'
import Layout from '@/Components/layouts/AppLayout'

export default function Show({ post }) {
    return (
        <Layout>
            <Head title={post.title} />
            <article className="max-w-3xl mx-auto px-4 py-8">
                <h1 className="text-3xl font-bold mb-4">{post.title}</h1>
                <p className="text-gray-600 dark:text-gray-400 mb-6">
                    By {post.user.name}
                </p>
                <div className="prose dark:prose-invert">{post.body}</div>
            </article>
        </Layout>
    )
}
```

### Persistent Layouts

```jsx
// Define layout on the page component
Show.layout = page => <Layout children={page} />
```

### Shared Data (from HandleInertiaRequests middleware)

```jsx
const { auth, flash } = usePage().props

// Access authenticated user
const user = auth.user

// Flash messages
{flash.success && (
    <div className="bg-green-100 text-green-800 p-3 rounded mb-4">
        {flash.success}
    </div>
)}
```

## Form Patterns

### Basic Form with `useForm`

```jsx
import { useForm } from '@inertiajs/react'

function CreatePost() {
    const { data, setData, post, processing, errors, reset } = useForm({
        title: '',
        body: '',
    })

    function submit(e) {
        e.preventDefault()
        post('/posts', {
            onSuccess: () => reset(),
        })
    }

    return (
        <form onSubmit={submit} className="space-y-4 max-w-2xl mx-auto px-4">
            <div>
                <label className="block text-sm font-medium mb-1">Title</label>
                <input
                    value={data.title}
                    onChange={e => setData('title', e.target.value)}
                    className="w-full px-3 py-2 border rounded-md min-h-[44px]
                               dark:bg-gray-800 dark:border-gray-700"
                />
                {errors.title && (
                    <p className="text-red-500 text-sm mt-1">{errors.title}</p>
                )}
            </div>
            <button
                type="submit"
                disabled={processing}
                className="bg-blue-600 text-white px-6 py-2 rounded min-h-[44px]
                           hover:bg-blue-700 disabled:opacity-50 w-full md:w-auto"
            >
                {processing ? 'Saving...' : 'Create Post'}
            </button>
        </form>
    )
}
```

### Form with File Upload

```jsx
const { data, setData, post, progress } = useForm({
    title: '',
    avatar: null,
})

function submit(e) {
    e.preventDefault()
    post('/posts', { forceFormData: true })
}

<input type="file" onChange={e => setData('avatar', e.target.files[0])} />
{progress && <progress value={progress.percentage} max="100" />}
```

## Navigation

```jsx
import { Link, router } from '@inertiajs/react'

// Declarative navigation (preferred)
<Link href="/posts" className="text-blue-600 hover:underline">Posts</Link>

// Preserve scroll position
<Link href="/posts" preserveScroll>Posts</Link>

// Programmatic navigation
router.visit('/posts')
router.post('/posts', { title: 'New' })
router.delete(`/posts/${id}`)
```

## Tailwind CSS Responsive Patterns

### Breakpoint Reference

| Prefix | Min Width | Device |
|--------|-----------|--------|
| (none) | 0px | Mobile |
| `sm:` | 640px | Large mobile |
| `md:` | 768px | Tablet |
| `lg:` | 1024px | Laptop |
| `xl:` | 1280px | Desktop |
| `2xl:` | 1536px | Large desktop |

### Layout Utilities

```jsx
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
<div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
```

### Common Responsive Patterns

```jsx
// Stack → side-by-side
<div className="flex flex-col md:flex-row gap-4">

// Responsive grid: 1 col → 2 col → 3 col → 4 col
<div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">

// Auto-fit grid (fluid, no breakpoints needed)
<div className="grid grid-cols-[repeat(auto-fit,minmax(280px,1fr))] gap-4">

// Hide/show at breakpoints
<nav className="hidden md:flex gap-6">{/* Desktop nav */}</nav>
<button className="md:hidden min-h-[44px]">☰</button> {/* Mobile hamburger */}

// Responsive padding
<div className="px-4 sm:px-6 lg:px-8">

// Responsive spacing between sections
<section className="py-8 md:py-12 lg:py-16">

// Responsive typography
<h1 className="text-2xl sm:text-3xl lg:text-4xl xl:text-5xl font-bold">
```

### Containers & Aspect Ratios

```jsx
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

```jsx
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

```jsx
// Full-width inputs on mobile, side-by-side on desktop
<form className="space-y-4">
  <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
    <input className="w-full px-3 py-2 border rounded-md min-h-[44px]
                     dark:bg-gray-800 dark:border-gray-700" />
    <input className="w-full px-3 py-2 border rounded-md min-h-[44px]
                     dark:bg-gray-800 dark:border-gray-700" />
  </div>
  <button className="w-full md:w-auto px-6 py-2 min-h-[44px]
                     bg-blue-600 text-white rounded hover:bg-blue-700">
    Submit
  </button>
</form>
```

### Dark Mode

```jsx
<div className="bg-white dark:bg-gray-900 text-gray-900 dark:text-gray-100">
  <p className="text-gray-600 dark:text-gray-400">Subtitle</p>
</div>
```

**Manual Dark Mode Toggle (Tailwind v4):**
```css
/* In app.css — replaces tailwind.config darkMode setting */
@import "tailwindcss";
@custom-variant dark (&:where(.dark, .dark *));
```
Then toggle the `dark` class on `<html>` via JavaScript/React state + `localStorage`.

### State Variants

```jsx
// Hover, focus, active
<button className="bg-violet-500 hover:bg-violet-600 focus:outline-2
  focus:outline-offset-2 focus:outline-violet-500 active:bg-violet-700" />

// Focus-visible (keyboard-only focus)
<input className="ring-0 focus-visible:ring-2 focus-visible:ring-blue-500" />

// Disabled state
<button disabled className="disabled:opacity-50 disabled:cursor-not-allowed" />

// Group hover — style children when parent is hovered
<a className="group block p-4 hover:bg-sky-50">
  <h3 className="text-gray-900 group-hover:text-sky-600">Project</h3>
  <p className="text-gray-500 group-hover:text-sky-400">Description</p>
</a>

// Named groups for nested hover contexts
<li className="group/item">
  <a className="group/edit invisible group-hover/item:visible">
    <span className="group-hover/edit:text-gray-700">Edit</span>
  </a>
</li>

// List styling
<li className="first:pt-0 last:pb-0">
<tr className="odd:bg-white even:bg-gray-50 dark:odd:bg-gray-900 dark:even:bg-gray-950">
```

### Color Opacity Modifier

```jsx
// Opacity shorthand with /value
<div className="bg-sky-500/20" />      {/* 20% opacity */}
<div className="text-white/75" />      {/* 75% opacity */}
<div className="border-gray-300/25" /> {/* 25% opacity */}
<div className="bg-black/50" />        {/* 50% opacity */}

// Works with all color utilities: bg-*, text-*, border-*, ring-*, shadow-*
```

### Arbitrary Values

```jsx
// One-off values with [] syntax
<div className="bg-[#316ff6]" />            {/* Custom hex color */}
<div className="top-[117px]" />              {/* Exact pixel value */}
<div className="grid-cols-[24rem_2.5rem_minmax(0,1fr)]" />

// CSS variables with () shorthand
<div className="fill-(--my-brand-color)" />  {/* Same as fill-[var(--my-brand-color)] */}

// Combine with variants
<div className="lg:top-[344px] hover:bg-[#1a73e8]" />

// Arbitrary CSS property
<div className="[--gutter-width:1rem] lg:[--gutter-width:2rem]" />
```

### Container Queries

```jsx
// Component-level responsive (based on container width, not viewport)
<div className="@container">
  <div className="flex flex-col @min-md:flex-row @min-md:gap-6">
    <img className="w-full @min-md:w-48" />
    <div className="p-4">Content</div>
  </div>
</div>

// Named containers
<div className="@container/sidebar">
  <div className="@min-sm/sidebar:grid-cols-2" />
</div>
```

### Conditional Classes Pattern

Use `clsx` for conditional Tailwind classes:

```jsx
import { clsx } from 'clsx'

function Button({ variant = 'primary', disabled, children }) {
  return (
    <button
      className={clsx(
        'px-4 py-2 rounded font-medium transition-colors min-h-[44px]',
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

**⚠️ Never construct dynamic class names:**
```jsx
// ❌ WRONG — Tailwind scans files as plain text, can't resolve interpolation
<div className={`bg-${color}-500`} />

// ✅ CORRECT — Map props to complete, static class name strings
const colorVariants = {
  blue: "bg-blue-600 hover:bg-blue-500 text-white",
  red: "bg-red-500 hover:bg-red-400 text-white",
  yellow: "bg-yellow-300 hover:bg-yellow-400 text-black",
}
<div className={colorVariants[color]} />
```

### Tailwind v4 CSS Directives

```css
/* Theme customization — replaces tailwind.config.ts */
@import "tailwindcss";
@theme {
  --font-display: "Satoshi", "sans-serif";
  --color-brand-500: oklch(0.84 0.18 117.33);
  --breakpoint-3xl: 120rem;
}

/* Reusable component classes */
@layer components {
  .card {
    background-color: var(--color-white);
    border-radius: var(--radius-lg);
    padding: --spacing(6);
    box-shadow: var(--shadow-xl);
  }
}

/* Custom utility that works with all variants */
@utility tab-4 {
  tab-size: 4;
}

/* Use @variant in custom CSS */
.my-element {
  background: white;
  @variant dark {
    background: black;
  }
}

/* Register extra source paths for class detection */
@source "../node_modules/@my-company/ui-lib";
```

### Animation Utilities

```jsx
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

## Rule Compliance

- Inertia React Frontend @inertia-react-frontend.md
- Docker Commands @docker-commands.md
- Security Mandate @security-mandate.md
