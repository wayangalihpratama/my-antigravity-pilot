---
description: Ship phase - Commit changes using Conventional Commits for Streamlit
---

# Phase 5: Ship (Commit)

## Purpose
Finalize your Streamlit feature with a standardized, traceable commit message.

## Steps

### 1. Verification
Ensure all linting passes.
```bash
./dc.sh exec streamlit flake8 .
```

### 2. Stage Changes
```bash
git add .
```

### 3. Commit with Conventional Format
Use the format: `[#issue_number] <type>(<scope>): <description>`.

Common scopes for this stack include: `ui`, `data`, `layout`, `config`.

```bash
git commit -m "[#issue_number] <type>(<scope>): <description>"
```

### 4. Examples
- `[#1] feat(ui): add sidebar navigation to dashboard`
- `[#5] feat(data): implement caching for CSV loading`
- `[#12] fix(layout): resolve overlap in multi-column view`

## Final Step
Push your branch and open a PR.
