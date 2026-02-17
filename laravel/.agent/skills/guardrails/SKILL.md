---
name: guardrails
description: Pre-flight checklist and post-implementation self-review protocol. Use before generating any code (pre-flight) and after writing code but before verification (self-review) to catch issues early.
---

# Guardrails

## Pre-Flight Checklist

Run this BEFORE writing any code:

### 1. Understand the Request
- [ ] I understand what the user is asking for
- [ ] I've identified all affected files and components
- [ ] I know which layer(s) are involved (backend, frontend, admin, database)

### 2. Check Rules
- [ ] Security: Input validation via Form Request? Authorization via Policy? @security-mandate.md
- [ ] Docker: All commands use `docker compose exec`? @docker-commands.md
- [ ] Architecture: Service layer for business logic? Skinny controller? @laravel-backend.md
- [ ] Frontend: Using Inertia conventions? Tailwind utility classes? @inertia-react-frontend.md

### 3. Check Dependencies
- [ ] Does this change require a new migration?
- [ ] Does this change require a new npm/composer package?
- [ ] Will this conflict with Filament admin routes or styling?
- [ ] Does this break existing tests?

### 4. Plan the Test
- [ ] I know which test(s) to write/update
- [ ] I know whether this needs Feature or Unit tests
- [ ] I'll write the test first (TDD) if creating new functionality

---

## Post-Implementation Self-Review

Run this AFTER writing code, BEFORE marking complete:

### 1. Security Review
- [ ] No hardcoded secrets or API keys
- [ ] All user input validated via Form Request
- [ ] Authorization checks via Policy/Gate
- [ ] Mass assignment protected (`$fillable` defined)
- [ ] No raw SQL queries — using Eloquent ORM

### 2. Code Quality
- [ ] Ran `docker compose exec app ./vendor/bin/pint` (formatting)
- [ ] No `dd()`, `dump()`, or `var_dump()` left in code
- [ ] No commented-out code blocks
- [ ] Strict typing used in new PHP classes
- [ ] Migration has `down()` method

### 3. Frontend Quality
- [ ] Responsive at 320px, 768px, 1024px, 1440px
- [ ] Using `Link` from `@inertiajs/react` for navigation
- [ ] Touch targets ≥44px on mobile
- [ ] No inline styles when Tailwind utility exists
- [ ] Dark mode classes applied where appropriate

### 4. Tests
- [ ] Tests pass: `docker compose exec app php artisan test`
- [ ] New code has corresponding tests
- [ ] Tests use factories, not raw data insertion

### 5. Docker
- [ ] All commands use `docker compose exec` prefix
- [ ] No references to bare `php`, `composer`, `node`, or `npm`

## Rule Compliance

- Security Mandate @security-mandate.md
- Docker Commands @docker-commands.md
- Laravel Backend @laravel-backend.md
- Inertia React Frontend @inertia-react-frontend.md
- Testing Strategy @testing-strategy.md
