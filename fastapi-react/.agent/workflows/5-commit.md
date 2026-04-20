---
description: Documentation alignment and commit preparation
---

# Phase 5: Ship (Commit)

## Purpose
Finalize the feature by committing verified code using the **Conventional Commits** standard and ensuring perfect alignment with the project's documentation and sprint planning.

## Prerequisites
- **Phase 4 (Verify)** completed with all tests and linters passing.
- **Sprint Collaboration**: Invoke **Bob (Scrum Master)** to verify that all Acceptance Criteria (UAC/TAC) are marked as complete in `agent_docs/stories/`.
- **Writer Collaboration**: Invoke **Paige (Documentation Writer)** to ensure that the implementation is perfectly synced with the project's technical documentation and feature specs.

## Steps

### 1. Mandatory Git Confirmation
Before any commit or push, you MUST verify the following gates:

1. **Doc Alignment Check**: Verify that the actual implementation is perfectly aligned with the feature specifications and internal documentation.
2. **Sprint Status Check**: Verify that the `agent_docs/sprint-plan.md` and relevant stories are updated with statuses, actual times, and AC checklists.
3. **User Confirmation**: Present the alignment and sprint status to the user and ask: "Is the documentation aligned and the sprint plan updated?"
4. **Atomic Commit Strategy**: Analyze the changed files. Determine if the changes should be split into multiple atomic commits (e.g., separating backend from frontend, or logic from docs). Propose a split plan to the user.
5. **Commit Preparation**: Prepare the conventional commit message(s) and show them to the user.
6. **Final Approval**: Ask: "Should I proceed with the proposed commit(s) and push?"

### 2. Execution
Only after receiving explicit approval for all the above, execute the commands:

```bash
# Example Stage
git add .

# Example Commit
git commit -m "[#issue_number] <type>(<scope>): <description>"

# Example Push
git push origin {branch_name}
```

## Completion Criteria
- [ ] User provided explicit confirmation for alignment, split plan, and final commit.
- [ ] Sprint plan and stories are 100% updated in `agent_docs/`.
- [ ] Commits follow the `[#issue_number] <type>(<scope>): <description>` format.

## Final Step
Task complete! Ready for more work? Ask the user for a new requirement or check the backlog with **Bob (Scrum Master)**.
