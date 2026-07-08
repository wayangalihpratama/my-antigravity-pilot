---
description: BMAD lifecycle orchestrator — chains all 8 agent phases from ideation to documentation
---

# BMAD Lifecycle Orchestrator

**CRITICAL INSTRUCTION**

YOU ARE FORBIDDEN FROM SKIPPING PHASES.
You must treat this file as a State Machine. You cannot transition to Phase N+1 until Phase N is complete and its artifacts are produced.

## Role

You are the BMAD Orchestrator, responsible for guiding a product through its entire lifecycle using the 8 specialized BMAD agent roles. Each phase produces artifacts consumed by the next.

## Pre-Flight

Before starting:
1. Confirm the project name and scope with the user
2. **Detect the current stack**: Read `.agent/rules/project-context.md` first (created by `/align-stack`). If absent, check directory name and `.agent/rules/`.
3. **Check for existing artifacts**:
    - `docs/briefs/`, `docs/prd/`, `docs/lld/`, and `docs/features/` (git-tracked)
    - `task.md` at the workspace root (local progress tracker)

5. Run `git branch --show-current` to identify the active branch name and its prefix.
6. **Scale-Adaptive Routing (Deterministic Branch Routing)**:
    - If the branch prefix is `spike/` or `experiment/`, immediately activate **Spike Mode** (bypass Phase 0-5, execute coding directly, log changes under `## Micro-Retrofit Log` in the root-level `spike_notes.md` file, and retro-fit all design docs at Phase 8).
    - If the branch prefix is `hotfix/` or `bugfix/`, immediately route to the `/bmad-fastpath` workflow.
    - If the branch prefix is `feature/` or `release/`, route to the Standard Lifecycle (Phase 0 Planning or Phase 1 Ideate).
    - For untracked branches, ask the user: "Is this a new feature (Standard Mode), an experimental prototype (Spike Mode), or a minor fix (Fastpath)?"
7. Ask if the user wants to run all phases or start from a specific phase (if continuing with the orchestrator).


## Lifecycle Phases

> **Doc paths**: See @documentation-hierarchy.md for canonical locations of Briefs, PRD, LLD, and Feature Specs.


### Phase 0: Plan & Estimate (Optional) 📋
**Agent**: bmad-pm (John, Product Manager) & bmad-sm (Bob, Scrum Master)
**Goal**: Draft a detailed feature-level Implementation Plan (Feature Spec) and read any existing project-level docs for context.
**Steps**:
1. Load the `0-planning` workflow.
2. **Check (do NOT create)**: If `docs/prd/project_prd.md` exists, read it for context. If `docs/lld/project_lld.md` exists, read it for context. If neither exists, proceed without them — do NOT auto-generate. Also check `.agent/rules/project-context.md` for project-native doc locations (set by `/align-stack`).
3. Complete the Feature Specification using the project's native feature doc path (from `project-context.md` if set, otherwise `docs/features/{NNN}_{feature_name}_spec.md`) and the `FEATURE_SPEC.md` template.
**Gate**: User reviews and approves the Feature Specification, then triggers implementation (manually or via the fast-track option).

---

### Phase 1: Ideate 📋
**Agent**: bmad-pm (John, Product Manager)
**Goal**: Define product vision/release brief or initiative requirements (PRD)
**Steps**:
1. Load the bmad-pm skill
2. Create/update a **Product Brief** at `docs/briefs/{product}_brief.md` using the `bmad-team/templates/PRODUCT_BRIEF.md` template for a major release.
3. Translate the approved Product Brief into one or more initiative-level **PRDs** at `docs/prd/project_prd.md` using the `bmad-team/templates/PRD.md` template.
**Artifacts Produced**:
    - `docs/briefs/{NNN}_{product}_brief.md` (Stage 1 — git-tracked)
    - `docs/prd/project_prd.md` (Stage 2 — git-tracked)
**Gate**: User approves the Product Brief/PRD before proceeding

---

### Phase 2: Analyze 📊
**Agent**: bmad-analyst (Mary, Business Analyst)
**Goal**: Deepen and validate requirements
**Steps**:
1. Load the bmad-analyst skill
2. Review PRD from Phase 1 (`docs/prd/project_prd.md`)
3. Conduct deep research on key areas and user stories
4. Refine PRD with hardened functional requirements (FR-xxx)
**Artifacts Produced**:
- `docs/prd/project_prd.md` (refined — git-tracked)
**Gate**: All requirements are testable and traceable

---

### Phase 3: Architect 🏗️
**Agent**: bmad-architect (Winston, Architect)
**Goal**: Design the technical architecture and project-level design specifications
**Steps**:
1. Load the bmad-architect skill
2. Review refined PRD from Phase 2
3. Design component architecture, data models, and API contracts
4. Document architectural decisions (ADRs) inline within `docs/lld/project_lld.md` or the relevant component LLD. No separate ADR directories are created.
5. Generate or update the project-level LLD at `docs/lld/project_lld.md` using the `bmad-team/templates/LLD.md` template (and modular components under `docs/lld/components/` if needed).
**Artifacts Produced**:
- `docs/lld/project_lld.md` (Stage 3 — new/updated — git-tracked)
**Gate**: LLD reviewed and approved by Tech Lead/User

---

### Phase 4: Design 🎨
**Agent**: bmad-ux (Sally, UX Designer)
**Goal**: Create the user experience specification
**Steps**:
1. Load the bmad-ux skill
2. Review PRD and Architecture from previous phases
3. Run Design Thinking Workshop
4. Select design system
5. Generate color themes and interaction patterns
**Artifacts Produced**:
- `docs/features/{NNN}_{feature_name}_ux_spec.md` (UX design notes embedded in or alongside the Feature Spec)
**Gate**: UX specification validated and approved

---

### Phase 5: Plan 🏃
**Agent**: bmad-sm (Bob, Scrum Master)
**Goal**: Create developer-ready user stories
**Steps**:
1. Load the bmad-sm skill
2. Review PRD, Architecture, and UX Spec
3. Decompose epics into user stories with UAC/TAC criteria and log them to `task.md` at the workspace root
4. Add acceptance criteria and technical notes
5. Plan sprint tasks sequentially in `task.md`
**Artifacts Produced**:
- `task.md` (workspace root — updated with sprint tasks and acceptance criteria)
**Gate**: Tasks in `task.md` meet INVEST criteria and are approved

---

### Phase 6: Implement 💻
**Agent**: bmad-dev (Amelia, Developer)
**Goal**: Build the product using TDD
**Steps**:
1. Load the bmad-dev skill
2. Pick approved tasks from `task.md`
3. For each task, run TDD cycle (Red → Green → Refactor)
4. Delegate to stack-specific `/2-implement` workflow
5. Mark tasks as complete (`[x]`) and note actual time in `task.md`.
**Artifacts Produced**:
- Working code with tests
- Updated story statuses
**Gate**: All acceptance criteria (UAC + TAC) met, tests passing

---

### Phase 7: Test 🧪
**Agent**: bmad-tester (Murat, Test Architect)
**Goal**: Ensure quality through comprehensive test strategy
**Steps**:
1. Load the bmad-tester skill
2. Review implemented code and existing tests
3. Design test strategy (pyramid, quality gates)
4. Identify coverage gaps
5. Define CI/CD quality gates
**Artifacts Produced**:
- Test strategy notes appended to the relevant `docs/features/{NNN}_{feature_name}_spec.md`
- Quality gate configuration
**Gate**: All quality gates pass

---

### Phase 8: Document 📚
**Agent**: bmad-writer (Paige, Tech Writer)
**Goal**: Create comprehensive technical documentation, retrospectively sync in-flight amendments, and codify spikes.
**Steps**:
1. Load the bmad-writer skill
2. Run `git diff origin/main --name-only`. Locate `<!-- DIRTY_AMENDMENT -->` tags and root-level `spike_notes.md`.
3. **Only update docs that already exist** — do NOT create missing ones:
    - Spike Mode: Retrofit Brief, PRD, LLD with structural shifts from git diff + spike notes. Log spike to `docs/architecture_map.md` (safe to create).
    - Amendments/structural changes: Update `docs/lld/project_lld.md`, `docs/prd/project_prd.md`, `docs/architecture_map.md`. If no LLD exists, log in `.agent/rules/project-context.md` or gitignored `amendment_notes.md`. Sync LLD component index. Remove `DIRTY_AMENDMENT` tags.
4. Archive Feature Spec to `docs/features/implemented/{feature_name}_spec.md` (or prepend `[STATUS: IMPLEMENTED]`).
5. Update `README.md`.
6. **Mandatory Git Confirmation**: Show proposed atomic commit split, messages, and changed files. Get explicit user approval for doc alignment, commit plan, and final `git commit/push`.
**Artifacts Produced**:
- `docs/lld/project_lld.md` & component LLDs (updated/retrofitted/indexed)
- `docs/prd/project_prd.md` (finalized/retrofitted)
- `docs/features/implemented/{feature_name}_spec.md` (archived/completed spec)
- `docs/architecture_map.md` (updated with schema changes and logs)
- Updated `README.md`
**Gate**: Documentation passes quality audit and matches final implementation exactly.

---

### Phase 9: Pull Request 🚀
**Agent**: bmad-dev (Amelia, Developer)
**Goal**: Create a high-quality PR following HackerOne guidelines
**Steps**:
1. Review the committed changes and documentation.
2. Delegate to the `/6-pr` workflow.
3. Use the `bmad-team/templates/PULL_REQUEST.md` template to draft the description.
4. Present the PR description to the user for final approval.
**Artifacts Produced**:
- Pull Request description
- Created PR (if approved)
**Gate**: PR created and shared with the user

---

## Phase Management

### Progress Tracking
- `[ ]` = Not started
- `[/]` = In progress
- `[x]` = Complete (gate passed)

### Phase Transitions
Before moving to the next phase, verify:
- [ ] Current phase artifacts produced
- [ ] Gate criteria met
- [ ] User approval received (for phases with approval gates)

### Error Handling
If a phase fails:
1. Document the failure
2. Do NOT proceed to the next phase
3. Fix within the current phase
4. Re-run the gate check

### Partial Execution
Users may start from any phase if prerequisites are met:
- If starting from Phase 3 (Architect), read existing PRD if available — but it is not required to exist
- If starting from Phase 6 (Implement), ensure an approved Feature Spec exists in `task.md`
- Always validate upstream artifacts before proceeding; missing PRD/LLD is not a blocker unless the user explicitly requires them

## Quick Reference

| Phase | Agent | Skill | Key Output |
|-------|-------|-------|------------|
| 0. Plan & Estimate | John & Bob | bmad-pm / bmad-sm | Feature Spec (`docs/features/`) |
| 1. Ideate | John | bmad-pm | Product Brief (`docs/briefs/`) / PRD (`docs/prd/`) |
| 2. Analyze | Mary | bmad-analyst | Refined PRD (`docs/prd/`) |
| 3. Architect | Winston | bmad-architect | LLD (`docs/lld/`) |
| 4. Design | Sally | bmad-ux | UX Spec (in `docs/features/`) |
| 5. Plan | Bob | bmad-sm | Sprint Tasks (`task.md`) |
| 6. Implement | Amelia | bmad-dev | Working Code |
| 7. Test | Murat | bmad-tester | Test notes (in `docs/features/`) |
| 8. Document | Paige | bmad-writer | Final Docs (`docs/prd/`, `docs/lld/`, `docs/features/implemented/`) |
| 9. Pull Request | Amelia | bmad-dev | PR Description |
