---
description: Migrate a project from the old agent_docs-only approach to the new docs/ + agent_docs/ split structure.
---

# 📦 Migrate to New Documentation Structure

Use this workflow when a project was set up with the **previous BMAD approach** where all artifacts (architecture, features, ADRs, etc.) lived in `agent_docs/`. This workflow migrates shared documentation into the git-tracked `docs/` directory.

## Pre-Flight

1. Confirm the project path with the user.
2. Check that `agent_docs/` exists and contains artifacts.
3. Check if `docs/` already exists — if so, ask the user before overwriting.

## Steps

### Step 1: Bootstrap `docs/` Directory
// turbo
1. Create `docs/` if it doesn't exist.

### Step 2: Migrate Shared Documents

Scan `agent_docs/` and move **shared documentation** into `docs/`. Follow this mapping:

| Old Location | New Location | Action |
|-------------|-------------|--------|
| `agent_docs/product-brief.md` | `docs/briefs/{product}_brief.md` | Move and rename. Reformat using the `PRODUCT_BRIEF.md` template. |
| `agent_docs/prd.md` / `docs/*_spec.md` | `docs/prd/{initiative}_prd.md` | Move and rename. Reformat using the `PRD.md` template. |
| `agent_docs/architecture.md` / `docs/LLD.md` | `docs/lld/{feature}_lld.md` | Break up into granular low-level design files per feature/component using the `LLD.md` template. |
| Global schema/ADR indexes | `docs/architecture_map.md` | Bootstrap the System Architecture Map with global configurations and core entity ERDs. |

> [!CAUTION]
> Do NOT move sprint plans, stories, research notes, or internal PRDs. These stay in `agent_docs/`.

### Step 3: Keep Local-Only Files in `agent_docs/`

These files must **remain** in `agent_docs/` (NOT moved):
- `sprint-plan.md`
- `stories/`
- `research_logs/`
- `decisions/` (local drafts)
- `ux-design-specification*.md`
- `strapi-learning-guide.md` or similar learning notes

### Step 4: Update `.gitignore`
// turbo
1. Ensure `.agent/` and `agent_docs/` are in `.gitignore`.
2. Add entries if missing.

### Step 5: Clean Up Git Tracking

If `agent_docs/` was previously tracked by git:
```bash
git rm -r --cached agent_docs/
git rm -r --cached .agent/
```
This removes them from git tracking without deleting local files.

### Step 6: Safety Audit
// turbo
1. Scan all files in `docs/` for credentials, API keys, or PII.
2. Replace any found secrets with placeholders (e.g., `YOUR_API_KEY`).
3. Verify compliance with `docs-standard.md`.

### Step 7: Present to User

Show the user:
- List of files moved to `docs/`
- List of files kept in `agent_docs/`
- Any credentials found and sanitized
- Suggested commit message

## Completion Criteria
- [ ] `docs/` contains `briefs/`, `prd/`, and `lld/` subdirectories
- [ ] `agent_docs/` contains only sprint/story execution artifacts
- [ ] `.gitignore` excludes `.agent/` and `agent_docs/`
- [ ] No credentials in `docs/`
- [ ] User has reviewed and approved the migration
