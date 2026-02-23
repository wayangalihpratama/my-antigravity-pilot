---
trigger: always_on
description: Standardized commit message format for the entire repository
---

## Commit Message Standard

To ensure traceability from code changes to their corresponding requirements/issues, a standardized format is enforced across the entire repository.

### Format specification

Every commit MUST follow this format:

```
[#issue_number] <type>(<scope>): <description>
```

### Components

1. **`[#issue_number]`**: (Required) The ID of the issue being addressed, enclosed in brackets and prefixed with #.
2. **`<type>`**: (Required) The type of change (see below).
3. **`<scope>`**: (Optional) The specific area affected (e.g., `backend`, `frontend`, `auth`).
4. **`<description>`**: (Required) A concise, imperative mood summary.

### Types

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
- Repo Structure @repo-structure.md
