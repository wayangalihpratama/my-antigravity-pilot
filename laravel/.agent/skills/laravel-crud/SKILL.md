---
name: laravel-crud
description: Step-by-step guide for creating full vertical features in Laravel. Use when adding new CRUD resources with migration, model, service, controller, Form Request, Inertia pages, and tests.
---

# Laravel CRUD Feature Generation

## Overview

This skill guides the creation of a complete vertical feature following Laravel best practices:
Migration → Model → Service → Form Request → Controller → React Pages → Routes → Tests

## Step 1: Migration

```bash
docker compose exec app php artisan make:migration create_posts_table
```

```php
// database/migrations/xxxx_create_posts_table.php
public function up(): void
{
    Schema::create('posts', function (Blueprint $table) {
        $table->id();
        $table->foreignId('user_id')->constrained()->cascadeOnDelete();
        $table->string('title');
        $table->text('body');
        $table->timestamp('published_at')->nullable();
        $table->timestamps();

        $table->index('user_id');
    });
}

public function down(): void
{
    Schema::dropIfExists('posts');
}
```

Run: `docker compose exec app php artisan migrate`

## Step 2: Model + Factory

```bash
docker compose exec app php artisan make:model Post -f
```

```php
// app/Models/Post.php
class Post extends Model
{
    protected $fillable = ['title', 'body', 'user_id', 'published_at'];

    protected function casts(): array
    {
        return ['published_at' => 'datetime'];
    }

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function scopePublished(Builder $query): Builder
    {
        return $query->whereNotNull('published_at');
    }
}
```

```php
// database/factories/PostFactory.php
class PostFactory extends Factory
{
    public function definition(): array
    {
        return [
            'user_id' => User::factory(),
            'title'   => fake()->sentence(),
            'body'    => fake()->paragraphs(3, true),
            'published_at' => fake()->optional()->dateTime(),
        ];
    }

    public function published(): static
    {
        return $this->state(['published_at' => now()]);
    }
}
```

## Step 3: Service

```bash
docker compose exec app php artisan make:class Services/PostService
```

```php
// app/Services/PostService.php
class PostService
{
    public function list(int $perPage = 15): LengthAwarePaginator
    {
        return Post::with('user')
            ->latest()
            ->paginate($perPage);
    }

    public function create(array $data, User $user): Post
    {
        return $user->posts()->create($data);
    }

    public function update(Post $post, array $data): Post
    {
        $post->update($data);
        return $post->fresh();
    }

    public function delete(Post $post): void
    {
        $post->delete();
    }
}
```

## Step 4: Form Requests

```bash
docker compose exec app php artisan make:request StorePostRequest
docker compose exec app php artisan make:request UpdatePostRequest
```

```php
// app/Http/Requests/StorePostRequest.php
class StorePostRequest extends FormRequest
{
    public function authorize(): bool { return true; }

    public function rules(): array
    {
        return [
            'title' => ['required', 'string', 'max:255'],
            'body'  => ['required', 'string'],
        ];
    }
}
```

## Step 5: Controller

```bash
docker compose exec app php artisan make:controller PostController --resource
```

```php
// app/Http/Controllers/PostController.php
class PostController extends Controller
{
    public function __construct(private PostService $postService) {}

    public function index(): Response
    {
        return Inertia::render('Posts/Index', [
            'posts' => $this->postService->list(),
        ]);
    }

    public function create(): Response
    {
        return Inertia::render('Posts/Create');
    }

    public function store(StorePostRequest $request): RedirectResponse
    {
        $this->postService->create($request->validated(), $request->user());
        return redirect()->route('posts.index');
    }

    public function show(Post $post): Response
    {
        return Inertia::render('Posts/Show', [
            'post' => $post->load('user'),
        ]);
    }

    public function edit(Post $post): Response
    {
        return Inertia::render('Posts/Edit', ['post' => $post]);
    }

    public function update(UpdatePostRequest $request, Post $post): RedirectResponse
    {
        $this->postService->update($post, $request->validated());
        return redirect()->route('posts.show', $post);
    }

    public function destroy(Post $post): RedirectResponse
    {
        $this->postService->delete($post);
        return redirect()->route('posts.index');
    }
}
```

## Step 6: React Pages

```jsx
// resources/js/Pages/Posts/Index.jsx
import { Head, Link } from '@inertiajs/react'

export default function Index({ posts }) {
    return (
        <>
            <Head title="Posts" />
            <div className="max-w-4xl mx-auto px-4 py-8">
                <div className="flex justify-between items-center mb-6">
                    <h1 className="text-2xl font-bold">Posts</h1>
                    <Link href="/posts/create"
                        className="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700">
                        New Post
                    </Link>
                </div>
                <div className="space-y-4">
                    {posts.data.map(post => (
                        <Link key={post.id} href={`/posts/${post.id}`}
                            className="block p-4 border rounded hover:bg-gray-50 dark:hover:bg-gray-800">
                            <h2 className="text-lg font-semibold">{post.title}</h2>
                        </Link>
                    ))}
                </div>
            </div>
        </>
    )
}
```

## Step 7: Routes

```php
// routes/web.php
use App\Http\Controllers\PostController;

Route::resource('posts', PostController::class)
    ->middleware('auth');
```

## Step 8: Tests

```php
// tests/Feature/PostTest.php
use App\Models\User;
use App\Models\Post;

test('user can view posts list', function () {
    $user = User::factory()->create();
    Post::factory()->count(3)->create();

    $this->actingAs($user)
        ->get('/posts')
        ->assertOk()
        ->assertInertia(fn ($page) =>
            $page->component('Posts/Index')
                 ->has('posts.data', 3)
        );
});

test('user can create a post', function () {
    $user = User::factory()->create();

    $this->actingAs($user)
        ->post('/posts', ['title' => 'My Post', 'body' => 'Content'])
        ->assertRedirect('/posts');

    $this->assertDatabaseHas('posts', ['title' => 'My Post']);
});

test('guest cannot access posts', function () {
    $this->get('/posts')->assertRedirect('/login');
});
```

Run: `docker compose exec app php artisan test --filter=PostTest`

## Optional: Step 9 — Filament Admin Resource

```bash
docker compose exec app php artisan make:filament-resource Post --generate
```

This auto-generates `app/Filament/Resources/PostResource.php` with list, create, and edit pages.

## Validation Checklist

- [ ] Migration rolls back cleanly: `php artisan migrate:rollback`
- [ ] Model has `$fillable` guarding attributes
- [ ] Service handles business logic (controller is skinny)
- [ ] Form Requests handle all validation
- [ ] Routes are auth-protected
- [ ] React pages use `Head` for SEO and `Link` for navigation
- [ ] Tests cover happy path and auth guard
- [ ] Code formatted: `./vendor/bin/pint`

## Rule Compliance

- Laravel Backend @laravel-backend.md
- API Design @api-design.md
- Testing Strategy @testing-strategy.md
- Security Mandate @security-mandate.md
- Inertia React Frontend @inertia-react-frontend.md
