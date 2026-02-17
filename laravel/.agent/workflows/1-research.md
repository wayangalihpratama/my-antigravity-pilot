---
description: Research and understand the task, codebase, and Laravel conventions before implementing
---

# Phase 1: Research

## Trigger

Before any implementation, when understanding the task scope and codebase context.

## Steps

### 1. Understand the Request

- Clarify the user's requirements and acceptance criteria
- Identify which layers are affected: backend, frontend, admin, database

### 2. Review Existing Code (Laravel Convention)

```bash
# Check current route definitions
docker compose exec app php artisan route:list

# Check existing models and their relationships
ls app/Models/

# Check migration history
docker compose exec app php artisan migrate:status

# Check existing tests
docker compose exec app php artisan test --list
```

### 3. Check Laravel Documentation

Before implementing, verify the Laravel-recommended approach:

| Task | Documentation |
|------|---------------|
| Routing | https://laravel.com/docs/routing |
| Controllers | https://laravel.com/docs/controllers |
| Eloquent | https://laravel.com/docs/eloquent |
| Validation | https://laravel.com/docs/validation |
| Authorization | https://laravel.com/docs/authorization |
| Testing | https://laravel.com/docs/testing |
| Queues | https://laravel.com/docs/queues |
| Events | https://laravel.com/docs/events |

### 4. Check Existing Agent Assets

- Review `.agent/rules/` for applicable rules
- Review `.agent/skills/` for relevant patterns
- Check for potential conflicts (e.g., Filament vs Inertia routing)

### 5. Pre-Flight Checklist

Run the **guardrails** pre-flight before proceeding:
→ See `.agent/skills/guardrails/SKILL.md`

## Output

- Clear understanding of what to build
- List of files to create/modify
- Chosen architectural pattern (following Laravel convention)
- Ready to proceed to Phase 2: Implement
