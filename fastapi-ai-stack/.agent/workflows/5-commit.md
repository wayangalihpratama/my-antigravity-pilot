---
description: Ship phase - Commit changes using Conventional Commits for FastAPI AI Stack
---

# Phase 5: Ship (Commit)

## Purpose
Finalize your AI agent feature with a standardized, traceable commit message.

## Steps

### 1. Verification
Ensure all linting and tests pass.
```bash
./dc.sh exec app flake8 .
```

### 2. Stage Changes
```bash
git add .
```

### 3. Commit with Conventional Format
Use the format: `[#issue_number] <type>(<scope>): <description>`.

Common scopes for this stack include: `api`, `agent`, `graph`, `tools`, `schema`.

```bash
git commit -m "[#issue_number] <type>(<scope>): <description>"
```

### 4. Examples
- `[#1] feat(api): add FastAPI endpoint for user profile`
- `[#3] feat(agent): implement LangGraph agent with tool calling`
- `[#12] fix(graph): resolve state update loop in agent graph`

## Final Step
Push your branch and open a PR.
