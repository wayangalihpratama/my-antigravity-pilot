---
description: Research phase - deep context discovery and workspace knowledge gathering for Laravel
---

# Phase 1: Research (Workspace Optimized)

## Purpose
Understand the request context by analyzing the existing codebase and gathering project-specific technical knowledge before implementation, following Laravel best practices.

## Steps

### 0. Specification Verification
Before starting research, you MUST verify the requirements:
- **Check for Spec**: Look in `docs/` for an existing feature specification (e.g., `docs/{FEATURE_NAME}.md`).
- **User Confirmation**: Ask the user: "Is {spec_name}.md the correct specification for this task?" or "Should I create a new feature specification using the template?"
- **PM Collaboration**: If requirements are ambiguous, invoke **John (Product Manager)** to clarify.

### 1. Identify Affected Layers
Parse the user's request and cross-reference with the project state:
- **Scope:** Define what is being asked.
- **Context:** Check `docs/` and `agent_docs/` to align with the project's current phase.
- **Analyst Collaboration**: For complex domain logic, invoke **Mary (Business Analyst)** for deep research.

### 2. Repository Reconnaissance (Laravel Context)
Search the current workspace to understand:
- **Architecture:** Identify relevant models, controllers, and services. Invoke **Winston (Architect)** for structural guidance.
- **Artisan Insight**: 
  ```bash
  php artisan route:list
  php artisan migrate:status
  ```
- **Patterns:** Locate similar implementations (e.g., existing models, relationships, or Inertia/Filament patterns).
- **Dependencies**: Check `composer.json` and `package.json`.

### 3. Build Mental Model
Inventory the "Knowns":
- **Business Logic:** Derived from existing requirements and specs.
- **Technical Constraints:** Limitations of the current stack (Laravel, Inertia/Filament, MySQL/PostgreSQL).
- **Integration Points:** Where exactly the new code touches the old (Routes, Models, Policies).

### 4. Define Scope & Task Boundary
Create a plan with bite-sized atomic tasks in `task.md`:
- Map tasks to specific files identified in Step 2.
- **Sprint Planning**: If this is a new feature, invoke **Bob (Scrum Master)** to create stories and a sprint plan in `agent_docs/`.

### 5. Identify Research Topics
List specific Laravel technologies (e.g., Queues, Events, Policies) that need verification.

### 6. Technical & Documentation Research
Perform targeted queries for the project's specific versions:
- Use **Web Search** for exact versions (e.g., "Laravel 11 routing patterns", "Filament 3 custom fields").
- **Official Docs**: Consult [laravel.com/docs](https://laravel.com/docs).

### 7. Document Findings (Research Logs)
Create `agent_docs/research-findings-{slug}.md`. Must Include:
- **Internal References:** "Follows pattern found in `app/Services/AuthService.php`."
- **API/Method Signatures:** Verified from current documentation.
- **Workspace Gotchas:** Specific issues found in this repo's history (e.g., custom middleware order).

### 8. Architectural Decision Records (ADRs)
If structural changes are needed, invoke **Winston (Architect)** to create an ADR at `agent_docs/adrs/ADR-NNN-title.md`.

## Completion Criteria
- [ ] Specification verified and confirmed with the user
- [ ] Workspace analyzed (Routes & Models identified)
- [ ] `task.md` created with file-specific atomic tasks
- [ ] Research log created referencing internal and external sources
- [ ] ADR created if architectural patterns are deviated from

## Next Phase
Ready for implementation? Use the `/2-implement` workflow or invoke **Amelia (Developer)**.
