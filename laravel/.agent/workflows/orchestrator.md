---
description: Master workflow that orchestrates all development phases (Research → Implement → Integrate → Verify → Commit)
---

# Orchestrator

## Purpose

This workflow coordinates the 5 development phases. Use it when starting a new feature, bugfix, or refactor.

## The Flow

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│ 1. Research │ ──▶ │ 2. Implement│ ──▶ │ 3. Integrate│ ──▶ │ 4. Verify   │ ──▶ │ 5. Commit   │
└─────────────┘     └─────────────┘     └─────────────┘     └─────────────┘     └─────────────┘
      ▲                                       │                    │
      └───────────── (if issues found) ───────┴────────────────────┘
```

## Phase Summaries

### Phase 1: Research → `.agent/workflows/1-research.md`
- Understand requirements and scope
- Review existing code with Artisan commands
- Check Laravel documentation for recommended approach
- Run pre-flight checklist (guardrails)

### Phase 2: Implement → `.agent/workflows/2-implement.md`
- Follow Laravel convention order: Migration → Model → Service → Form Request → Controller → Policy → Frontend → Routes → Tests
- Use Artisan generators where possible
- Follow service layer pattern (skinny controllers)

### Phase 3: Integrate → `.agent/workflows/3-integrate.md`
- Wire Inertia backend ↔ frontend
- Configure shared data in `HandleInertiaRequests`
- Set up Filament admin resource (if needed)
- Verify no route conflicts

### Phase 4: Verify → `.agent/workflows/4-verify.md`
- Run full test suite
- Format with Laravel Pint
- Verify Vite build
- Rollback/re-run migrations
- Run guardrails post-implementation review
- Check responsive design

### Phase 5: Commit → `.agent/workflows/5-commit.md`
- Stage logically grouped changes
- Commit with conventional format
- Push to remote

## Key Tools Reference

| Task | Command |
|------|---------|
| Run tests | `docker compose exec app php artisan test` |
| Format code | `docker compose exec app ./vendor/bin/pint` |
| Check routes | `docker compose exec app php artisan route:list` |
| Run migrations | `docker compose exec app php artisan migrate` |
| Generate model | `docker compose exec app php artisan make:model Name -mf` |
| Generate controller | `docker compose exec app php artisan make:controller NameController --resource` |
| Generate service | `docker compose exec app php artisan make:class Services/NameService` |
| Generate request | `docker compose exec app php artisan make:request StoreNameRequest` |
| Generate policy | `docker compose exec app php artisan make:policy NamePolicy --model=Name` |
| Generate Filament resource | `docker compose exec app php artisan make:filament-resource Name --generate` |
| Build frontend | `docker compose exec node npm run build` |
| Dev server | `docker compose exec node npm run dev -- --host` |

## Skills Reference

| Skill | When to Use |
|-------|-------------|
| `debugging-protocol` | When facing bugs, test failures, unexpected behavior |
| `guardrails` | Before any code (pre-flight) and after code (self-review) |
| `laravel-crud` | When creating new CRUD resources end-to-end |
| `filament-admin` | When configuring admin panel resources |
| `inertia-react-patterns` | When building frontend pages and components |
