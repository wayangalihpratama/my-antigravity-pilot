---
description: Research phase - deep context discovery and workspace knowledge gathering
---

# Phase 1: Research (Workspace Optimized)

## Purpose
Understand the implementation context within the existing codebase. This phase focuses on mapping technical plans (Feature Specs) to specific files, validating library APIs, identifying patterns, and organizing the implementation checklist in `task.md` before writing code.

> [!IMPORTANT]
> **DISTINCTION BETWEEN PLANNING & RESEARCH WORKFLOWS**:
> - **Phase 0: Planning**: Focuses on *what* to build, high-level project specs (PRD, LLD), and drafting the Feature Specification (`FEATURE_SPEC.md`). **Read-only research of the codebase is fully allowed and expected** during Phase 0 to verify database models, routes, and paths for spec accuracy. However, **no implementation modifications, testing, or code creation** may occur.
> - **Phase 1: Research (This Phase)**: Focuses on bridging the approved Feature Specification into code implementation. It is workspace-driven (locating exact code insertion points, mapping library dependencies, and organizing the step-by-step checklist in `task.md`). **NO code changes or implementation edits** occur in this phase.

## Steps

### 0. Specification & High-Level Doc Verification
Before starting research, you MUST verify the requirements and check for high-level changes:
- **Check for Specs**: Ensure the project-level PRD (`docs/prd/project_prd.md`), LLD (`docs/lld/project_lld.md`), and the specific feature's spec (`docs/features/{feature_name}_spec.md`) exist and are approved.
- **Check for High-Level Updates**: Assess if the workspace structure or library analysis reveals that the high-level PRD or LLD needs to be updated to support the feature's implementation. If so, update the project-level documentation first.
- **User Confirmation**: Ask the user: "Are these the correct PRD, LLD, and Feature Spec documents for this task?" or "Should I create/transform/update them first?"
- **PM Collaboration**: If feature requirements or scopes in the spec are ambiguous, invoke **John (Product Manager)** to clarify.

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
Create `agent_docs/research_logs/{feature_name}_md`. Must Include:
- **Internal References:** "Follows pattern found in `path/to/existing/file`."
- **API Signatures:** Verified from current documentation.
- **Workspace Gotchas:** Specific issues found in this repo's history/code.

### 8. Architectural Decision Records (ADRs)
If structural changes are needed, invoke **Winston (Architect)** to create an ADR at `agent_docs/decisions/NNNN-title.md`.

## Completion Criteria
- [ ] PRD, LLD, and Feature Spec verified and confirmed with the user (unless in Spike Mode)
- [ ] Workspace analyzed (Patterns & Versions identified)
- [ ] `task.md` created with file-specific atomic tasks
- [ ] Research log created at `agent_docs/research_logs/{feature_name}.md`
- [ ] ADR created if architectural patterns are deviated from

## Next Phase
Ready for implementation? Use the `/2-implement` workflow or invoke **Amelia (Developer)**.
