---
trigger: model_decision
description: When creating branches, committing code, managing PRs, or working with version control
---

## Git Workflow Principles

### Commit Messages — Conventional Commits

**Format:**
```
[#issue_number] <type>(<scope>): <description>
```

**Types:**
| Type | Purpose |
|------|---------|
| `feat` | New feature |
| `fix` | Bug fix |
| `docs` | Documentation only |
| `style` | Formatting, semicolons, etc. |
| `refactor` | Code change (no new feature/fix) |
| `test` | Adding or updating tests |
| `chore` | Maintenance, dependencies |

### Examples

- `[#1] feat(api): add FastAPI endpoint for user profile`
- `[#12] fix(auth): resolve login timeout`
- `[#45] docs: update README with setup instructions`

### Related Rules
- Root Git Workflow @/Users/galihpratama/Dev/my-antigravity-pilot/.agent/rules/git-workflow.md
- Docker Commands @docker-commands.md
