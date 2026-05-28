---
description: Research phase - deep context discovery and workspace knowledge gathering
---

# Phase 1: Research (Workspace Optimized)

## Purpose
Understand the request context by analyzing the existing codebase and gathering project-specific technical knowledge before implementation.

## Steps

### 0. Specification Verification
Before starting research, you MUST verify the requirements:
- **Check for Spec**: Look in `docs/prd/` and `docs/lld/` for the corresponding initiative PRD and feature LLD (unless Spike Mode is active).
- **User Confirmation**: Ask the user: "Are these the correct PRD and LLD documents for this task?" or "Should I create new PRD/LLD specifications using the templates?"
- **PM Collaboration**: If requirements are ambiguous, invoke **John (Product Manager)** to clarify.

### 1. Analyze Request & Workspace Context
Parse the user's request and cross-reference with the project state:
- **Scope:** Define what is being asked.
- **Context:** Check `docs/` and `agent_docs/` to align with the project's current phase.
- **Analyst Collaboration**: For complex domain logic, invoke **Mary (Business Analyst)** for deep research.

### 2. Repository Reconnaissance (Internal KB)
Search the current workspace to understand:
- **Architecture:** Identify relevant modules. Invoke **Winston (Architect)** for structural guidance.
- **Patterns:** Locate similar implementations to ensure consistency.
- **Dependencies:** Review dependency files (e.g., `package.json`, `requirements.txt`, `composer.json`) for specific versions.

### 3. Build Mental Model
Inventory the "Knowns":
- **Business Logic:** Derived from existing requirements and specs.
- **Technical Constraints:** Limitations of the current stack.
- **Integration Points:** Where exactly the new code touches the old.

### 4. Define Scope & Task Boundary
Create a plan with bite-sized atomic tasks in `task.md`:
- Map tasks to specific files identified in Step 2.
- **Sprint Planning**: If this is a new feature, invoke **Bob (Scrum Master)** to create stories and a sprint plan in `agent_docs/`.

### 5. Identify Research Topics
List specific technologies and internal patterns that need verification.

### 6. Technical & Documentation Research
Perform targeted queries for the project's specific versions:
- Use **Web Search** for exact versions.
- Search for "Migration Guides" or "Breaking Changes" if touching older dependencies.

### 7. Document Findings (Research Logs)
Create `agent_docs/research_logs/{feature_name}.md`. Must Include:
- **Internal References:** "Follows pattern found in `path/to/existing/file`."
- **API Signatures:** Verified from current documentation.
- **Workspace Gotchas:** Specific issues found in this repo's history/code.

### 8. Architectural Decision Records (ADRs)
If structural changes are needed, invoke **Winston (Architect)** to create an ADR at `agent_docs/decisions/NNNN-title.md`.

## Completion Criteria
- [ ] PRD and LLD verified and confirmed with the user (unless in Spike Mode)
- [ ] Workspace analyzed (Patterns & Versions identified)
- [ ] `task.md` created with file-specific atomic tasks
- [ ] Research log created at `agent_docs/research_logs/{feature_name}.md`
- [ ] ADR created if architectural patterns are deviated from

## Next Phase
Ready for implementation? Use the `/2-implement` workflow or invoke **Amelia (Developer)**.
