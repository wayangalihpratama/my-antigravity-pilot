---
name: debugging-protocol
description: Systematic protocol for debugging complex issues. Use when facing bugs, test failures, unexpected behavior, or performance problems. Provides a structured hypothesis-driven approach to find root causes.
---

# Debugging Protocol

## Overview

A systematic, hypothesis-driven approach to debugging Laravel applications. Follow these phases in order.

## Phase 1: Root Cause Investigation

**Goal:** Understand what went wrong before changing any code.

### Information Gathering

```bash
# Check Laravel logs
docker compose exec app tail -f storage/logs/laravel.log

# Check container logs
docker compose logs app --tail=50
docker compose logs web --tail=50

# Check MySQL status
docker compose exec db mysqladmin -u root -p$DB_PASSWORD status

# Check Redis
docker compose exec redis redis-cli ping

# Run tests to see current state
docker compose exec app php artisan test --filter=FailingTest
```

### Questions to Answer

1. **When did it break?** What was the last change before the issue?
2. **Is it reproducible?** Always, sometimes, or only in specific conditions?
3. **What's the scope?** One endpoint, one model, or system-wide?
4. **Are there error messages?** Check logs, browser console, network tab.

## Phase 2: Pattern Analysis

**Goal:** Identify patterns in the failure.

- **Backend errors:** Check `storage/logs/laravel.log` and exception handler
- **Frontend errors:** Check browser console and Vite dev server output
- **Database errors:** Check migration status and query logs
- **Docker errors:** Check container health and network connectivity

```bash
# Check migration status
docker compose exec app php artisan migrate:status

# Check routes
docker compose exec app php artisan route:list --path=posts

# Clear all caches
docker compose exec app php artisan config:clear
docker compose exec app php artisan cache:clear
docker compose exec app php artisan view:clear
docker compose exec app php artisan route:clear
```

## Phase 3: Hypothesis and Testing

**Goal:** Form and test hypotheses systematically.

1. **State your hypothesis** clearly before making changes
2. **Design a minimal test** that proves or disproves it
3. **Change only one thing** at a time
4. **Record results** — what worked, what didn't

### Common Hypotheses

| Symptom | Likely Cause | Quick Check |
|---------|-------------|-------------|
| 500 error | Missing migration/config | `php artisan migrate:status` |
| Blank page | Vite not running | `docker compose logs node` |
| CSRF mismatch | Session issue | Check `.env` session config |
| Class not found | Autoload stale | `composer dump-autoload` |
| N+1 queries | Missing eager load | Check `with()` on query |
| Admin unstyled | Filament assets | `php artisan filament:upgrade` |

## Phase 4: Implementation

**Goal:** Fix the root cause, not the symptom.

1. **Write a test** that captures the bug
2. **Fix the code** — minimal, targeted change
3. **Verify the fix** — run the test
4. **Check for regressions** — run full test suite

```bash
# Run specific test
docker compose exec app php artisan test --filter=PostTest

# Run full suite
docker compose exec app php artisan test

# Format code after fix
docker compose exec app ./vendor/bin/pint
```

## Rule Compliance

- Docker Commands @docker-commands.md
- Error Handling @error-handling.md
- Testing Strategy @testing-strategy.md
