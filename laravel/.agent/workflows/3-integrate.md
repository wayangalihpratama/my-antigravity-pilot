---
description: Integrate backend and frontend layers, wire up Inertia pages, and configure Filament admin
---

# Phase 3: Integrate

## Trigger

After completing Phase 2: Implement with all individual components ready.

## Steps

### 1. Wire Backend to Frontend (Inertia)

Verify the controller returns data that the React page expects:

```php
// Controller returns props
return Inertia::render('Posts/Index', [
    'posts' => $this->postService->list(),
    'filters' => $request->only('search', 'status'),
]);
```

```jsx
// React page receives props
export default function Index({ posts, filters }) { ... }
```

### 2. Configure Shared Data

```php
// app/Http/Middleware/HandleInertiaRequests.php
public function share(Request $request): array
{
    return [
        ...parent::share($request),
        'auth' => [
            'user' => $request->user(),
        ],
        'flash' => [
            'success' => fn () => $request->session()->get('success'),
            'error'   => fn () => $request->session()->get('error'),
        ],
    ];
}
```

### 3. Integrate Filament Admin (if applicable)

```bash
# Create admin resource for the new model
docker compose exec app php artisan make:filament-resource Post --generate

# Verify admin panel
docker compose exec app php artisan filament:upgrade
```

→ See `.agent/skills/filament-admin/SKILL.md`

### 4. Verify Route Registration

```bash
# List all routes and verify new routes are registered
docker compose exec app php artisan route:list --path=posts
```

### 5. Cross-Concern Validation

| Check | Command |
|-------|---------|
| Routes don't conflict | `php artisan route:list` |
| Migrations applied | `php artisan migrate:status` |
| Filament assets current | `php artisan filament:upgrade` |
| Vite builds cleanly | `npm run build` |
| No missing dependencies | `composer install && npm install` |

### 6. Integration Test

Write a test that exercises the full request cycle:

```php
test('full post lifecycle', function () {
    $user = User::factory()->create();

    // Create
    $this->actingAs($user)
        ->post('/posts', ['title' => 'Test', 'body' => 'Content'])
        ->assertRedirect('/posts');

    $post = Post::first();

    // Read
    $this->get("/posts/{$post->id}")
        ->assertOk()
        ->assertInertia(fn ($page) =>
            $page->component('Posts/Show')
                 ->has('post')
        );

    // Update
    $this->put("/posts/{$post->id}", ['title' => 'Updated', 'body' => 'New'])
        ->assertRedirect();

    // Delete
    $this->delete("/posts/{$post->id}")
        ->assertRedirect('/posts');
});
```

## Output

- Backend and frontend properly wired via Inertia
- Filament admin configured (if applicable)
- No route conflicts
- Integration test passing
- Ready for Phase 4: Verify
