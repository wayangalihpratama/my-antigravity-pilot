---
trigger: always_on
description: Documentation Hierarchy Rule — enforces the progression of Brief → PRD → LLD before development begins.
---

## Documentation Hierarchy Rule: Brief → PRD → LLD

All initiatives and features in this team MUST progress through three documentation stages before development begins. No user story or code task may be moved to "In Development" unless the corresponding LLD section or document exists.

---

### Stage 1: Product Brief (Owner: PM / Product Lead)
**Template**: `bmad-team/templates/PRODUCT_BRIEF.md`
**Frequency**: One brief per product or major release cycle. It is the executive-facing north star. **Per-feature product briefs are forbidden.**
**Location**: `docs/briefs/{NNN}_{release_or_product}_brief.md` (shared, git-tracked) or `docs/product_brief.md` directly under the `docs/` folder (if present).
Before any initiative is designed, produce a 1–2 page Product Brief containing:
- **Problem Statement**: The specific user pain point or business gap, with supporting data
- **Target Audience**: The primary persona(s) affected
- **Strategic Alignment**: The company OKR or business goal this supports
- **Success Criteria & KPIs**: Quantified, measurable outcomes with target dates
- **Assumptions & Open Questions**: Key assumptions and unknowns to validate before the PRD

> [!IMPORTANT]
> If a `product_brief.md` file is available directly under the `docs/` folder (`docs/product_brief.md`), it MUST always be respected and followed as the primary product brief/source of truth. Per-feature briefs are not used.

*Exit criterion: Brief reviewed and approved by at least one stakeholder outside the product team.*

---

### Stage 2: Project PRD – Product Requirements Document (Owner: PM + Design)
**Template**: `bmad-team/templates/PRD.md`
**Frequency**: One high-level Project PRD per project or major initiative.
**Location**: `docs/prd/project_prd.md` (shared, git-tracked)
Translate the approved Brief into a Project PRD containing:
- **Goals & Core Metrics**: Structured success outcomes linked to business metrics.
- **Scope**: Explicit Must-Have, Nice-to-Have, and Out-of-Scope boundaries.
- **Assumptions & Open Questions**: Core constraints to resolve before technical design.

*Exit criterion: Project PRD signed off by Leads before Project LLD begins.*

---

### Stage 3: Project LLD – Low-Level Design (Owner: Tech Lead / Architect)
**Template**: `bmad-team/templates/LLD.md`
**Frequency**: One project-wide system design.
**Location**: `docs/lld/project_lld.md` (and components under `docs/lld/components/{module}_lld.md` if complex).
Translate the high-level PRD requirements into technical designs:
- **Core Architecture & Data Flow**: Global schemas, APIs, auth, and external integrations.
- **Modular Layout**: For large systems, store sub-components in `docs/lld/components/` and automatically maintain the index/TOC in the main `project_lld.md` map.

*Exit criterion: Project LLD approved; structural patterns aligned before Feature Specs are drafted.*

---

### Stage 4: Feature Specification / Implementation Plan (Owner: Developer / Tech Lead)
**Template**: `bmad-team/templates/FEATURE_SPEC.md`
**Frequency**: Created per feature request/feature branch.
**Location**: `docs/features/{NNN}_{feature_name}_spec.md` (moved to `docs/features/implemented/` or marked `[STATUS: IMPLEMENTED]` after completion).
The Feature Specification is the **single, complete technical source of truth** for feature design and implementation tasks. It covers:
- **Architecture Overview**: Step-by-step logic sequences and Mermaid diagrams.
- **Backend & Database Model**: Specific schema updates, models, migrations, and API router payloads.
- **Frontend & UI Wireframes**: State management hooks, layout components, and ASCII mockups.
- **Verification & Estimations**: Test commands, manual testing plans, and precise task estimations in developer hours (capped at 16h per task).

---

### Rule of Thumb
- **PRD/LLD vs Feature Spec**: High-level constraints, databases, and global layouts go to the project-level PRD and LLD. Specific implementation steps, feature routes, database model file schemas, and UI components go into the per-feature Implementation Plan (Feature Spec). We do not create separate PRD or LLD files for individual features.

---

### Deterministic Branch-Prefix Routing
To remove agent cognitive load, the active execution workflow is bound directly to the current git branch name:
- **Spike Mode**: Active when branch starts with `spike/` or `experiment/`.
- **Fastpath**: Active when branch starts with `hotfix/` or `bugfix/`.
- **Standard Lifecycle**: Active on all other branches (e.g. `feature/`, `release/`).

---

### Spike Mode (Experimental Phase)
For rapid prototyping, R&D, or experimental "spike" tasks where technical feasibility is being tested:
- **Activation**: Binds deterministically to `spike/*` or `experiment/*` branches.
- **Bypass**: Preceding documentation stages (Brief, PRD, LLD) are bypassed entirely to prioritize velocity.
- **Micro-Retrofit Log**: To prevent documentation debt, the developer MUST maintain a running list of structural, schema, and API changes under a `## Micro-Retrofit Log` section in a root-level gitignored `spike_notes.md` file during implementation. **Updates must be logged incrementally immediately after each subtask or test case is completed.**
- **Hard Gate**: Spikes are **never** merged directly to `main`. A retrospective documentation cycle (retrofitting Product Brief, PRD, and LLD) must parse the Micro-Retrofit Log and codify it into the `docs/` subdirectories before the merge request can be opened.

---

### In-Flight Design Amendment Protocol
If a developer uncovers a technical blocker or requires a design change (e.g. database schema tweak, API contract modification) *during* active story implementation:
- **No Blocking Loopback**: Work does not stop. The developer drafts a quick amendment detailing the change in the chat.
- **Peer/Architect Validation**: Share the amendment in the chat. Once approved by Winston/John, code implementation proceeds.
- **"Dirty LLD" Tagging**: The developer immediately appends a `<!-- DIRTY_AMENDMENT: [amendment details, approved date] -->` tag at the top of the project LLD (`docs/lld/project_lld.md`) or relevant component LLD. This alerts other developers that the spec is dirty and in-flight.
- **Retrospective Sync & Git Diff Safety Net**: The Tech Writer (`bmad-writer`) harvests these tags in Phase 8 (Document), updates the PRD/LLD/System Map, and clears the tags. **As a safety net to catch untagged changes, the writer must run `git diff origin/main --name-only` to identify all modified codebase files and synchronize their structural implications.**

---

### Enforcement
- Agents must detect the active mode deterministically by running a git branch check during Pre-Flight.
- Agents generating tasks or code must reference an approved requirement in `docs/prd/project_prd.md` and the Feature Specification.
- Agents generating code must reference an approved LLD component or schema definition (e.g., in `docs/lld/project_lld.md`)
- If a preceding Brief, PRD, or LLD is missing or unapproved, the agent must STOP and request it before proceeding — unless **Spike Mode** is active.
- At Phase 8, the Tech Writer MUST execute the Git Diff Safety Net check to guarantee that all actual code schema modifications are synchronized with documentation.
