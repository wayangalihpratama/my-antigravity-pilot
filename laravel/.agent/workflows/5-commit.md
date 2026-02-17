---
description: Stage, commit, and push changes using conventional commits
---

# Phase 5: Commit

## Trigger

After completing Phase 4: Verify with all checks passing.

## Steps

### 1. Status Check

```bash
git status -s
```

### 2. Stage Files

Group related changes into logical commits:

```bash
# Backend (migration + model + service + controller + requests)
git add database/migrations/ app/Models/ app/Services/ app/Http/

# Frontend (pages + components)
git add resources/js/

# Tests
git add tests/

# Config/Routes
git add routes/ config/
```

Or stage all:
```bash
git add -A
```

### 3. Commit with Conventional Format

Format: `type(scope): description`

```bash
# Feature
git commit -m "feat(posts): add post CRUD with service layer and Inertia pages"

# Fix
git commit -m "fix(auth): resolve login redirect loop for verified users"

# Refactor
git commit -m "refactor(posts): extract post logic to PostService"

# Tests
git commit -m "test(posts): add feature tests for post lifecycle"

# Styling
git commit -m "style(posts): implement responsive Tailwind layout for post index"
```

### 4. Push

```bash
git pull --rebase origin $(git branch --show-current)
git push origin $(git branch --show-current)
```

### 5. Post-Push Verification

```bash
# Verify clean state
git status

# Verify commit in log
git log -1 --oneline
```

## Commit Message Convention

| Type | Usage |
|------|-------|
| `feat` | New feature |
| `fix` | Bug fix |
| `refactor` | Code restructuring (no behavior change) |
| `test` | Adding or updating tests |
| `docs` | Documentation only |
| `chore` | Maintenance (deps, config) |
| `style` | Formatting (Pint, Prettier) |
| `perf` | Performance improvement |
| `ci` | CI/CD changes |

## Rule Compliance

- Git Workflow @git-workflow.md
