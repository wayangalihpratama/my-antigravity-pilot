---
trigger: model_decision
description: When writing or modifying PHP backend code (Laravel controllers, models, services, migrations, tests)
---

## Laravel Backend Standards

### Technology Stack

- **Laravel 12** (PHP 8.2+ strict typing)
- **Eloquent ORM** with MySQL 8.0
- **Filament 3** for admin panel
- **Redis** for cache and queues
- **Pest PHP** for testing

### Coding Standards (PSR-2 / PSR-4)

- Follow **PSR-2** coding style (Laravel convention)
- Follow **PSR-4** autoloading
- Use **Laravel Pint** for code formatting: `docker compose exec app ./vendor/bin/pint`
- Use **strict typing**: `declare(strict_types=1);` in all new files
- Use PHP 8.2+ features: typed properties, enums, match expressions, named arguments

### Architecture (Standard Laravel — No DDD)

```
app/
├── Http/
│   ├── Controllers/      # Skinny controllers
│   ├── Requests/         # Form Request validation
│   ├── Resources/        # API Resources (JSON transforms)
│   └── Middleware/
├── Models/               # Eloquent models (all in one place)
├── Services/             # Business logic (fat services)
├── Policies/             # Authorization policies
├── Providers/
│   └── Filament/         # Filament panel providers
└── Filament/
    ├── Resources/        # Admin CRUD resources
    ├── Pages/            # Custom admin pages
    └── Widgets/          # Dashboard widgets
```

**Key principle: Fat Models + Service Layer, Skinny Controllers**

### Controller Conventions

- Use **resource controllers** for CRUD: `Route::resource('posts', PostController::class)`
- Use **single-action controllers** for non-CRUD: `__invoke()`
- **Always type-hint** Form Requests for validation
- **Always use route model binding** for resource lookup
- **Delegate business logic** to Service classes

### Eloquent Model Conventions

```php
class Post extends Model
{
    protected $fillable = ['title', 'body', 'user_id'];  // Mass assignment

    protected function casts(): array     // Attribute casting
    {
        return ['published_at' => 'datetime'];
    }

    // Relationships
    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    // Query Scopes
    public function scopePublished(Builder $query): Builder
    {
        return $query->whereNotNull('published_at');
    }
}
```

**Eloquent Best Practices:**
- **Eager load** relationships to prevent N+1: `Post::with('user')->get()`
- **Use scopes** for reusable query logic
- **Define `$fillable`** on every model — never use `$guarded = []`
- **Use Factories** for test data
- **Use casts** for type safety

### Service Layer Pattern

```php
class PostService
{
    public function create(array $data): Post
    {
        return Post::create($data);
    }

    public function publish(Post $post): Post
    {
        $post->update(['published_at' => now()]);
        return $post->fresh();
    }
}
```

- Create via: `docker compose exec app php artisan make:class Services/PostService`
- Inject into controllers via **constructor dependency injection**
- Keep services focused — one service per model/domain concept

### Form Request Validation

```php
class StorePostRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true; // Or use policies
    }

    public function rules(): array
    {
        return [
            'title' => ['required', 'string', 'max:255'],
            'body'  => ['required', 'string'],
        ];
    }
}
```

- Create via: `docker compose exec app php artisan make:request StorePostRequest`
- **Always use Form Requests** — never `$request->validate()` inline
- Separate `Store*Request` and `Update*Request` for create/update

### Migrations

- Create via: `docker compose exec app php artisan make:migration create_posts_table`
- **Always implement `down()` method** for rollback
- Run: `docker compose exec app php artisan migrate`
- Rollback: `docker compose exec app php artisan migrate:rollback`

### Related Rules
- Docker Commands @docker-commands.md
- Security Mandate @security-mandate.md
- Testing Strategy @testing-strategy.md
- Error Handling @error-handling.md
- API Design @api-design.md
