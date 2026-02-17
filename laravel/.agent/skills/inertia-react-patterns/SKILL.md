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
