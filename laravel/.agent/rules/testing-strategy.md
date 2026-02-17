---
trigger: model_decision
description: When writing tests, designing test strategy, or implementing TDD cycle
---

## Testing Strategy

### Test Pyramid

```
       ╱ Browser (Dusk) ╲        ← 10% (optional, E2E)
      ╱  Feature Tests    ╲      ← 60% (HTTP, controllers, integration)
     ╱   Unit Tests         ╲    ← 30% (services, models, helpers)
```

### Testing Framework

- **Pest PHP** — preferred for conciseness and readability
- **PHPUnit** — also supported (Pest is built on top of it)
- Run tests: `docker compose exec app php artisan test`
- Run with coverage: `docker compose exec app php artisan test --coverage`

### Test Organization

```
tests/
├── Feature/          # HTTP tests — full request/response cycle
│   ├── PostTest.php
│   └── AuthTest.php
├── Unit/             # Isolated logic — services, models, helpers
│   ├── PostServiceTest.php
│   └── PriceCalculatorTest.php
└── TestCase.php      # Base test class
```

### TDD Cycle

1. **Red** — Write a failing test that describes the desired behavior
2. **Green** — Write the minimum code to make the test pass
3. **Refactor** — Clean up the code while keeping the test green

### Feature Test Pattern (Pest)

```php
use App\Models\User;
use App\Models\Post;

test('user can create a post', function () {
    $user = User::factory()->create();

    $response = $this->actingAs($user)
        ->post('/posts', [
            'title' => 'My Post',
            'body'  => 'Content here',
        ]);

    $response->assertRedirect('/posts');
    $this->assertDatabaseHas('posts', ['title' => 'My Post']);
});

test('guest cannot create a post', function () {
    $this->post('/posts', ['title' => 'My Post'])
        ->assertRedirect('/login');
});
```

### Unit Test Pattern (Pest)

```php
use App\Services\PriceCalculator;

test('calculates total with tax', function () {
    $calculator = new PriceCalculator();
    expect($calculator->withTax(100, 0.1))->toBe(110.0);
});
```

### Quality Standards

- **Use `RefreshDatabase` trait** for database tests
- **Use Factories** for test data — never insert raw SQL
- **Test business logic, not framework** (don't test "Eloquent works")
- **Name tests descriptively**: `test('user can create a post')`
- **One assertion per concept** — test one behavior per test
- **Mock external services** — don't hit real APIs in tests

### Coverage Goals

| Category | Target |
|----------|--------|
| Services | ≥ 80% |
| Controllers | ≥ 70% (via Feature tests) |
| Models | ≥ 60% (relationships, scopes) |
| Overall | ≥ 70% |

### Related Rules
- Docker Commands @docker-commands.md
- Laravel Backend @laravel-backend.md
