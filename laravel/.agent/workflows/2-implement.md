---
description: Implement the feature following Laravel conventions (Migration → Model → Service → Controller → Frontend → Tests)
---

# Phase 2: Implement

## Trigger

After completing Phase 1: Research and having a clear plan.

## Steps

### 1. Database Layer (Migrations + Seeders)

Follow the [Laravel Migration Guide](https://laravel.com/docs/migrations):

```bash
# Create migration
docker compose exec app php artisan make:migration create_posts_table

# Run migration
docker compose exec app php artisan migrate

# Verify
docker compose exec app php artisan migrate:status
```

**Laravel Best Practices:**
- Always implement `down()` method for rollback
- Add indexes on frequently queried columns
- Use `foreignId()->constrained()->cascadeOnDelete()` for foreign keys
- Use timestamps, soft deletes where appropriate

### 2. Model Layer

Follow the [Eloquent Documentation](https://laravel.com/docs/eloquent):

```bash
docker compose exec app php artisan make:model Post -f  # with factory
```

**Laravel Best Practices:**
- Define `$fillable` (never `$guarded = []`)
- Define `casts()` for type safety
- Define relationships using typed return types
- Use Query Scopes for reusable filters
- Use Accessors/Mutators for data transformation

### 3. Service Layer (Business Logic)

```bash
docker compose exec app php artisan make:class Services/PostService
```

**Laravel Best Practices:**
- Keep controllers skinny — delegate to services
- One service per model/domain concept
- Inject via constructor dependency injection
- Use Eloquent eager loading (`with()`) to prevent N+1

### 4. Validation Layer (Form Requests)

Follow the [Validation Documentation](https://laravel.com/docs/validation):

```bash
docker compose exec app php artisan make:request StorePostRequest
docker compose exec app php artisan make:request UpdatePostRequest
```

**Laravel Best Practices:**
- Always use Form Request classes — never inline `$request->validate()`
- Separate Store/Update requests
- Use `authorize()` for request-level authorization
- Use conditional rules with `sometimes`

### 5. Controller Layer

Follow the [Controller Documentation](https://laravel.com/docs/controllers):

```bash
docker compose exec app php artisan make:controller PostController --resource
```

**Laravel Best Practices:**
- Use resource controllers for CRUD operations
- Use single-action controllers (`__invoke()`) for non-CRUD
- Use route model binding for resource lookup
- Type-hint Form Requests for automatic validation
- Return `Inertia::render()` for web routes
- Return `JsonResource` for API routes

### 6. Authorization (Policies)

Follow the [Authorization Documentation](https://laravel.com/docs/authorization):

```bash
docker compose exec app php artisan make:policy PostPolicy --model=Post
```

**Laravel Best Practices:**
- Create policies for all models with user-scoped operations
- Register policies in `AuthServiceProvider` (auto-discovery in Laravel 12)
- Use `$this->authorize()` in controllers or `Gate::allows()` in services

### 7. Frontend Layer (Inertia + React + Tailwind)

→ See `.agent/skills/inertia-react-patterns/SKILL.md`

**Laravel Best Practices:**
- Pages correspond to controller methods (Index, Show, Create, Edit)
- Use `useForm` hook for form handling with CSRF
- Use `Link` from `@inertiajs/react` for navigation
- Share common data via `HandleInertiaRequests` middleware

**Tailwind CSS & Responsive Design (Mandatory):**
- Use utility-first Tailwind classes — avoid custom CSS
- Mobile-first: base styles for mobile, add `sm:`, `md:`, `lg:`, `xl:` breakpoints
- Every page MUST be responsive: test at 320px, 768px, 1024px, 1440px
- Touch targets ≥44px on mobile (`min-h-[44px]`)
- Use `dark:` variant for dark mode support
- Extract repeated patterns into React components, not `@apply`

### 8. Routes

Follow the [Routing Documentation](https://laravel.com/docs/routing):

```php
// routes/web.php — resource routes (preferred)
Route::resource('posts', PostController::class)->middleware('auth');

// Single action
Route::post('/posts/{post}/publish', PublishPostController::class)->middleware('auth');
```

**Laravel Best Practices:**
- Use `Route::resource()` for standard CRUD
- Use middleware for auth protection
- Keep `routes/web.php` for Inertia, `routes/api.php` for external APIs
- Never define admin routes manually — Filament handles this

### 9. Tests (TDD Encouraged)

Follow the [Testing Documentation](https://laravel.com/docs/testing):

→ See `.agent/skills/laravel-crud/SKILL.md` for test examples.

```bash
# Run tests
docker compose exec app php artisan test

# Run specific test
docker compose exec app php artisan test --filter=PostTest
```

### 10. Code Formatting

```bash
docker compose exec app ./vendor/bin/pint
```

## Output

- All files created following Laravel conventions
- Tests passing
- Code formatted with Pint
- Ready for Phase 3: Integrate
