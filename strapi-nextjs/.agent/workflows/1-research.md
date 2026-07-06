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
- **Check for Specs**: Ensure the project-level PRD (`docs/prd/project_prd.md`), LLD (`docs/lld/project_lld.md`), and the specific feature's spec (`docs/features/{NNN}_{feature_name}_spec.md`) exist and are approved.
- **Check for High-Level Updates**: Assess if the workspace structure or library analysis reveals that the high-level PRD or LLD needs to be updated to support the feature's implementation. If so, update the project-level documentation first.
- **User Confirmation**: Ask the user: "Are these the correct PRD, LLD, and Feature Spec documents for this task?" or "Should I create/transform/update them first?"
- **PM Collaboration**: If feature requirements or scopes in the spec are ambiguous, invoke **John (Product Manager)** to clarify.

### 1. Analyze Request & Workspace Context
Parse the user's request and cross-reference with the project state:
- **Scope:** Define what is being asked.
- **Context:** Check `docs/` to align with the project's current phase.
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
- **Checklist Breakdown**: Translate the approved Feature Spec's tasks directly into the local `task.md` checklist. No separate sprint plans or stories are required.

### 5. Identify Research Topics
List specific technologies and internal patterns that need verification.

### 6. Technical & Documentation Research
Perform targeted queries for the project's specific versions:
- Use **Web Search** for exact versions.
- Search for "Migration Guides" or "Breaking Changes" if touching older dependencies.

### 7. Document Findings
Document key research findings and verified API signatures directly in the Feature Spec (`docs/features/{NNN}_{feature_name}_spec.md`) under a new "Technical Audit" section, or inline inside the local `task.md` file.

### 8. Architectural Decisions
If structural changes or architectural deviations are needed, invoke **Winston (Architect)** to document them inline in `docs/lld/project_lld.md` or as a new component file under `docs/lld/components/`.

## Completion Criteria
- [ ] PRD, LLD, and Feature Spec verified and confirmed with the user (unless in Spike Mode)
- [ ] Workspace analyzed (Patterns & Versions identified)
- [ ] `task.md` created in the root with file-specific atomic tasks
- [ ] Research findings documented inside the Feature Spec or `task.md`
- [ ] Architectural decisions documented in Project LLD / components if needed

## Next Phase
Ready for implementation? Use the `/2-implement` workflow or invoke **Amelia (Developer)**.
