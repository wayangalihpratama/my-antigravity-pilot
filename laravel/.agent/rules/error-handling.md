---
trigger: model_decision
description: When implementing error handling, working with error types, or designing error recovery strategies
---

## Error Handling

### Principles

1. **Never fail silently** — every error must be logged or reported
2. **Fail fast** — validate inputs at the boundary, not deep in business logic
3. **Provide context** — error messages must help diagnose the issue
4. **No information leakage** — user-facing errors must not expose internals
5. **Resource cleanup** — use try/finally or middleware for cleanup

### Laravel Backend Error Patterns

**Use Laravel's Exception Handler** (`bootstrap/app.php`):
```php
->withExceptions(function (Exceptions $exceptions) {
    $exceptions->render(function (NotFoundHttpException $e) {
        return response()->json(['message' => 'Resource not found'], 404);
    });
})
```

**Form Request Validation** (preferred over manual validation):
```php
class StorePostRequest extends FormRequest
{
    public function rules(): array
    {
        return [
            'title' => ['required', 'string', 'max:255'],
            'body'  => ['required', 'string'],
        ];
    }
}
```

**Service Layer Exceptions**:
```php
// Throw specific exceptions from services
throw new ModelNotFoundException('Post not found');
throw new AuthorizationException('You cannot edit this post');

// Never catch generic Exception unless re-throwing
```

**API Error Response Format** (consistent JSON):
```json
{
    "message": "The given data was invalid.",
    "errors": {
        "title": ["The title field is required."]
    }
}
```

### Inertia/React Frontend Error Patterns

**Use Inertia error handling** (global via `app.jsx`):
```jsx
// Handle server-side validation errors
const { errors } = usePage().props

// Display field-level errors
{errors.title && <p className="text-red-500 text-sm">{errors.title}</p>}
```

**Error boundaries for unexpected crashes**:
```jsx
import { router } from '@inertiajs/react'

router.on('error', (event) => {
    console.error('Inertia error:', event)
})
```

### Related Rules
- Security Mandate @security-mandate.md
- API Design @api-design.md
- Laravel Backend @laravel-backend.md
