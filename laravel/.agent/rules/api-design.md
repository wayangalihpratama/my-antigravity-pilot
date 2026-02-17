---
trigger: model_decision
description: When implementing REST/HTTP APIs (endpoints, handlers, middleware, or response formatting)
---

## API Design

### Route Organization (Laravel Convention)

| File | Purpose | Middleware |
|------|---------|------------|
| `routes/web.php` | Inertia pages (user-facing) | `web` (session, CSRF) |
| `routes/api.php` | External API consumers | `api` (stateless, throttle) |
| `routes/console.php` | Artisan commands | — |

**Strict Separation:**
- Frontend pages → `routes/web.php` → Inertia controllers
- Admin panel → Filament (auto-registered, `/admin`)
- API for external use → `routes/api.php` → API controllers

### RESTful Resource Routes

```php
// Preferred: resource routes
Route::resource('posts', PostController::class);

// Generated routes:
// GET    /posts           → index
// GET    /posts/create    → create
// POST   /posts           → store
// GET    /posts/{post}    → show
// GET    /posts/{post}/edit → edit
// PUT    /posts/{post}    → update
// DELETE /posts/{post}    → destroy
```

### Controller Conventions (Laravel Best Practice)

**Skinny controllers — delegate to services:**
```php
class PostController extends Controller
{
    public function __construct(
        private PostService $postService
    ) {}

    public function store(StorePostRequest $request): RedirectResponse
    {
        $this->postService->create($request->validated());
        return redirect()->route('posts.index');
    }
}
```

**Single-action controllers** for non-CRUD actions:
```php
class PublishPostController extends Controller
{
    public function __invoke(Post $post): RedirectResponse
    {
        // ...
    }
}
```

### API Response Format (for `routes/api.php`)

**Success:**
```json
{
    "data": { ... },
    "message": "Post created successfully"
}
```

**Error:**
```json
{
    "message": "The given data was invalid.",
    "errors": { "title": ["The title field is required."] }
}
```

**Pagination:**
```php
// Use Laravel's built-in pagination (auto-formats JSON)
return PostResource::collection(Post::paginate(15));
```

### HTTP Status Codes

| Code | Usage |
|------|-------|
| 200 | Success (GET, PUT) |
| 201 | Created (POST) |
| 204 | No Content (DELETE) |
| 302 | Redirect (Inertia responses) |
| 400 | Bad Request |
| 401 | Unauthorized |
| 403 | Forbidden |
| 404 | Not Found |
| 422 | Validation Error |
| 500 | Server Error |

### Related Rules
- Error Handling @error-handling.md
- Laravel Backend @laravel-backend.md
- Security Mandate @security-mandate.md
