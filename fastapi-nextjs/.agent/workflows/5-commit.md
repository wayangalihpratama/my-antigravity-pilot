---
description: Ship phase - Commit changes using Conventional Commits
---

# Phase 5: Ship (Commit)

## Purpose
Finalize the feature by committing verified code using the **Conventional Commits** standard and ensuring alignment with documentation.

## Prerequisites
- **Phase 4 (Verify)** completed with all tests and linters passing.
- **Sprint Collaboration**: Invoke **Bob (Scrum Master)** to verify all stories are marked as complete in `agent_docs/`.
- **Writer Collaboration**: Invoke **Paige (Documentation Writer)** to ensure implementation is synced with `docs/LLD.md`.

## Steps

### 1. Mandatory Git Confirmation
Before committing, you MUST verify:

1. **Doc Alignment**: Verify `docs/LLD.md` and feature specs are updated.
2. **Sprint Status**: Update `agent_docs/sprint-plan.md` with actual times and status.
3. **User Confirmation**: Present the alignment and sprint status to the user.
4. **Atomic Commit Strategy**: Propose a plan to split changes into multiple atomic commits if necessary.
5. **Commit Preparation**: Prepare conventional commit messages.
6. **Final Approval**: Ask: "Should I proceed with the proposed commit(s) and push?"

### 2. Execution
Only after receiving explicit approval, execute the commands:

```bash
git add .
git commit -m "[#issue_number] <type>(<scope>): <description>"
git push origin {branch_name}
```

## Completion Criteria
- [ ] User provided explicit confirmation for alignment and commit plan.
- [ ] Sprint plan and stories are 100% updated in `agent_docs/`.
- [ ] Commits follow Conventional Commits format.

## Next Phase
Task complete! Ready for more work? Ask the user or use the new `/6-pr` workflow to create a Pull Request.
