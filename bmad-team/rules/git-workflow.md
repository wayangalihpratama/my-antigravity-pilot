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

> [!IMPORTANT]
> If you are about to commit and do not have an issue number, you MUST ask the user to confirm the issue number before proceeding. Never invent an issue number.

### Pull Request Strategy

When creating a PR:
1. **Title Format**: `[#issue_number] <Clear group/feature name> - <Short Description>`
2. **Safety Audit**: If applicable, attach or link the `safety-audit-issue-[issue_number].md` file.
3. **QA Guide**: If applicable, reference the `qa-guide-issue-[issue_number].md`.

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

### Mandatory User Confirmation

> [!CAUTION]
> **NEVER** perform `git commit` or `git push` automatically. You MUST ask for and receive explicit confirmation from the user before executing these commands.
>
> **Protocol**:
1. **Doc Alignment Check**: Verify that `docs/LLD.md`, feature specs (`docs/{FEATURE_NAME}.md`), and the implementation are perfectly aligned. If there are discrepancies, update the docs or implementation as needed.
2. **User Alignment Confirmation**: Present the alignment status to the user and ask: "Is the documentation perfectly aligned with the implementation?"
3. **Atomic Commit Strategy**: Analyze the changed files and logical updates. Determine if the changes should be split into multiple atomic commits (e.g., separating doc updates from logic changes, or backend from frontend). Propose a commit split plan to the user.
4. **Commit Preparation**: Prepare the commit message(s) and show them to the user along with the list of files for each commit.
5. **Final Approval**: Ask: "Should I proceed with the proposed commit(s) and push?"
6. Only execute the commands if the user says "Yes", "Proceed", or equivalent for the alignment, the split plan, and the final commit(s).
>
> This rule is absolute and overrides any stack-specific documentation that might suggest pushing as a final step.

### Related Rules
- Repo Structure @repo-structure.md
