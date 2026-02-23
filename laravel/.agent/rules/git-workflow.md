---
trigger: model_decision
description: When creating branches, committing code, managing PRs, or working with version control
---

### Commit Messages — Conventional Commits

**Format:**
```
[#issue_number] <type>(<scope>): <description>
```

### Examples

- `[#1] feat(api): add FastAPI endpoint for user profile`
- `[#12] fix(auth): resolve login timeout`
- `[#45] docs: update README with setup instructions`

```
feat(posts): add post creation with image upload
fix(auth): resolve login redirect loop
refactor(models): extract price calculation to service
test(posts): add feature tests for post CRUD
docs(readme): update installation instructions
chore(deps): update laravel to 12.1
style(frontend): fix Tailwind class ordering
```

**Types:** `feat`, `fix`, `refactor`, `test`, `docs`, `chore`, `style`, `perf`, `ci`

### Branch Naming

```
feature/add-post-crud
bugfix/fix-login-redirect
hotfix/patch-security-vulnerability
refactor/extract-price-service
```

### Commit Hygiene

1. **Atomic commits** — one logical change per commit
2. **No WIP commits** on shared branches
3. **Squash** related fixups before merge
4. **Run tests** before committing: `docker compose exec app php artisan test`

### PR Size Guidelines

| Size | Lines Changed | Review Time |
|------|--------------|-------------|
| Small | < 100 | Quick review |
| Medium | 100–300 | Normal review |
| Large | 300–500 | Split if possible |
| Too Large | > 500 | Must split |

### Related Rules
- Root Git Workflow @/Users/galihpratama/Dev/my-antigravity-pilot/.agent/rules/git-workflow.md
- Testing Strategy @testing-strategy.md
- Docker Commands @docker-commands.md
