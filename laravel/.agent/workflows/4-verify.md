---
description: Verify all changes pass tests, formatting, and quality checks before committing
---

# Phase 4: Verify

## Trigger

After completing Phase 3: Integrate with all components wired together.

## Steps

### 1. Run Full Test Suite

```bash
# Run all tests
docker compose exec app php artisan test

# Run with verbose output
docker compose exec app php artisan test -v

# Run with coverage (if configured)
docker compose exec app php artisan test --coverage
```

### 2. Code Formatting (Laravel Pint — PSR-2 compliance)

```bash
# Auto-fix formatting
docker compose exec app ./vendor/bin/pint

# Check only (no changes)
docker compose exec app ./vendor/bin/pint --test
```

### 3. Frontend Build Check

```bash
# Verify Vite production build works
docker compose exec node npm run build
```

### 4. Laravel-Specific Checks

```bash
# Verify routes are registered correctly
docker compose exec app php artisan route:list

# Verify migration can rollback cleanly
docker compose exec app php artisan migrate:rollback
docker compose exec app php artisan migrate

# Clear all caches and verify app works
docker compose exec app php artisan config:clear
docker compose exec app php artisan cache:clear
docker compose exec app php artisan view:clear
docker compose exec app php artisan route:clear
```

### 5. Post-Implementation Self-Review

Run the **guardrails** post-implementation checklist:
→ See `.agent/skills/guardrails/SKILL.md`

### 6. Responsive Design Check (Frontend)

| Width | What to Check |
|-------|---------------|
| 320px | Stacked layout, no horizontal overflow |
| 375px | Touch targets ≥44px |
| 768px | Grid/layout transitions |
| 1024px | Full desktop layout |
| 1440px | Max-width containers |

### 7. Security Checklist

- [ ] No `dd()`, `dump()`, or `var_dump()` in code
- [ ] No hardcoded secrets
- [ ] `$fillable` defined on all new models
- [ ] Form Requests used for all input validation
- [ ] Policies used for authorization
- [ ] CSRF protection active (Inertia handles this)

## Output

- All tests passing
- Code formatted with Pint
- Frontend builds cleanly
- Migrations reversible
- Responsive design verified
- Security checklist complete
- Ready for Phase 5: Commit
