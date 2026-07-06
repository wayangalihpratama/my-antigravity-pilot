---
description: Planning & Estimation Phase - creates a detailed features specification/PRD with ballpark estimations without implementing it.
---

# Phase 0: Planning & Estimation 📋

## Purpose
Define the high-level product goals, technical architecture (LLD), and feature implementation plans (Feature Spec). This phase focuses entirely on alignment and estimation. It is designed to run prior to any implementation, allowing stakeholders to make informed decisions before allocating development resources.

> [!IMPORTANT]
> **DISTINCTION BETWEEN PLANNING & RESEARCH WORKFLOWS**:
> - **Phase 0: Planning (This Phase)**: Focuses on *what* to build, high-level system architecture, and drafting the Feature Specification (`FEATURE_SPEC.md`). **Read-only research of the codebase is fully allowed and expected** during this phase to determine exact database models, routes, and paths. However, **NO file modifications, code creation, tests, or command-line updates** may be executed.
> - **Phase 1: Research**: Bridges the gap between the approved Feature Specification and implementation. Focuses on *how* to implement the approved spec (locating precise insertion points, mapping imports, identifying package constraints, and constructing the detailed checklist in `task.md`).
>
> **NO IMPLEMENTATION / WRITE CHANGES**: The agent must NOT write any implementation code, write unit tests, or run modifying command line updates during Phase 0. This workflow halts immediately after generating and refining the specification documents, requiring the user to explicitly invoke `/1-research` or `/2-implement` to begin development.
> *(Note: If Spike Mode is active, this planning phase is bypassed entirely for velocity, and documentation is generated retrospectively.)*

---

## Steps

### 1. Requirements Discovery & 5W1H (Read-Only Research)
Before creating any document, analyze the user's request and conduct a 5W1H analysis to build a complete picture:
- **Who**: Who are the primary actors or personas interacting with this feature?
- **What**: What is the feature, and what are its key functional requirements?
- **Where**: Where does it live in the current system (frontend paths, backend modules, database schemas)?
- **When**: When does it trigger, or when in the timeline is it needed?
- **Why**: Why is this feature necessary? What user pain point does it address?
- **How**: How will it behave? Describe the high-level logic flow.
- **Research Boundary**: Limit Phase 0 codebase research strictly to *interfaces, models, routes, and component boundaries*. Do NOT spend time analyzing helper logic, optimization paths, or internal function details to avoid analysis paralysis.

### 2. Project-Level PRD & LLD Alignment & Updates
Establish the foundational design and system constraints, and check for required updates:
- **Check for Updates**: Determine if the new feature request changes high-level system rules, core metrics, or global architecture. If yes, **update the high-level Project PRD and LLD first** before drafting individual feature specs.
- **Project PRD (High-Level)**: Ensure a high-level Project PRD exists at `docs/prd/project_prd.md` (or transform an existing System Design Document / SDD). If missing, generate one using the `generate-prd` workflow and the `bmad-team/templates/PRD.md` template.
- **Project LLD (Derived from PRD)**: Based on the high-level PRD, generate/align the project-level LLD at `docs/lld/project_lld.md` using the `generate-lld` workflow and the `bmad-team/templates/LLD.md` template.
- **Modular LLD References**: If the project-level LLD becomes too large, modularize it by placing component-specific low-level designs in sub-files under `docs/lld/components/{module}_lld.md` and referencing them in the main `docs/lld/project_lld.md` index to prevent git merge conflicts.
- **Do NOT Create Per-Feature PRD/LLD**: Avoid generating separate PRD and LLD documents for each minor feature. Keep them consolidated at the project level to prevent documentation sprawl.

### 3. Feature Specification / Implementation Plan
For each specific feature request, follow the **Akvo Feature Spec standard** to create a detailed, actionable implementation plan. Do not create separate user stories.
- **Auto-Increment Naming Prefix**: Automatically scan existing files in `docs/features/` (including the `implemented/` subdirectory) to find the highest 3-digit prefix (e.g., `001`, `002`), increment it by 1, and name the new file like `docs/features/{NNN}_{feature_name}_spec.md` to maintain the evolution timeline.
Create the specification using the template `bmad-team/templates/FEATURE_SPEC.md`. The document MUST cover:
- **Overview**: High-level explanation of the feature and target outcome.
- **Architecture Overview**: Step-by-step logic flow (e.g. API requests, async processing, background workers, event dispatching) with a Mermaid diagram representing the interaction sequence.
- **Backend Implementation**:
  - Detailed database model updates (fields, types, constraints).
  - Database migration paths.
  - API router modifications and exact HTTP payload/response schemas.
- **Frontend Implementation**:
  - State management changes (hooks, API integration).
  - UI component design, layout hierarchy, and user interaction states (including ASCII wireframes if needed).
- **Verification & Testing**:
  - Commands for automated testing.
  - Manual verification instructions.
- **Epic & Ballpark Estimation (Developer Hours)**:
  - Concrete tasks broken down so no single task exceeds 16 hours (2 days).
  - Est. Hours ranges (Min - Max) and confidence levels.

---

## Completion Criteria
- [ ] Requirements gathered and 5W1H analyzed.
- [ ] High-level Project-level PRD aligned/created.
- [ ] Project-level LLD generated and aligned based on the high-level PRD.
- [ ] Feature Specification (`docs/features/{feature_name}_spec.md`) created using the `FEATURE_SPEC.md` template.
- [ ] Estimates in developer hours and epic tasks finalized in the Feature Spec.
- [ ] User has reviewed and approved the Feature Specification.

## 🛑 HALT: Workflow Stop
**STOP! Do not write code or proceed to implementation.**
Present the finalized `docs/features/{feature_name}_spec.md` to the user.

**Handoff Protocol**:
- To begin the next phase, the user must explicitly initiate the **`/1-research`** workflow or **`/2-implement`** workflow.
- **Fast-Track Option**: If the Feature Spec is complete, fully aligned, and has no open questions, the agent may ask: *"Would you like to fast-track directly into Phase 1 (Research) or Phase 2 (Implementation)?"*. If the user approves, the agent may transition immediately without stopping.
