---
trigger: always_on
description: Documentation Hierarchy Rule — enforces the progression of Brief → PRD → LLD before development begins.
---

## Documentation Hierarchy Rule: Brief → PRD → LLD

All initiatives and features in this team MUST progress through three documentation stages before development begins. No user story or code task may be moved to "In Development" unless the corresponding LLD section or document exists.

---

### Stage 1: Product Brief (Owner: PM / Product Lead)
**Template**: `bmad-team/templates/PRODUCT_BRIEF.md`
**Frequency**: One brief per product or major release cycle. It is the executive-facing north star.
**Location**: `docs/briefs/{release_or_product}_brief.md` (shared, git-tracked) or `docs/product_brief.md` directly under the `docs/` folder (if present).
Before any initiative is designed, produce a 1–2 page Product Brief containing:
- **Problem Statement**: The specific user pain point or business gap, with supporting data
- **Target Audience**: The primary persona(s) affected
- **Strategic Alignment**: The company OKR or business goal this supports
- **Success Criteria & KPIs**: Quantified, measurable outcomes with target dates
- **Assumptions & Open Questions**: Key assumptions and unknowns to validate before the PRD

> [!IMPORTANT]
> If a `product_brief.md` file is available directly under the `docs/` folder (`docs/product_brief.md`), it MUST always be respected and followed as the primary product brief/source of truth.

*Exit criterion: Brief reviewed and approved by at least one stakeholder outside the product team.*

---

### Stage 2: PRD – Product Requirements Document (Owner: PM + Design)
**Template**: `bmad-team/templates/PRD.md`
**Frequency**: One PRD per initiative or epic (representing 3–8 features).
**Location**: `docs/prd/{initiative}_prd.md` (shared, git-tracked)
Translate the approved Brief into a full PRD containing:
- **User Stories & Personas**: Structured user stories with clear priority (MoSCoW)
- **Functional Requirements**: Numbered, unambiguous, testable feature specs (FR-001, FR-002...)
- **Non-Functional Requirements**: Performance targets, availability SLAs, accessibility, security compliance
- **User Flows & Wireframes**: Visual flowcharts (Mermaid) and wireframe links
- **Scope & Dependencies**: Clearly defined v1 boundaries (what is in/out of scope) and external blockages

*Exit criterion: PRD signed off by Engineering Lead and Design Lead before LLD begins.*

---

### Stage 3: LLD – Low-Level Design (Owner: Tech Lead / Senior Engineer)
**Template**: `bmad-team/templates/LLD.md`
**Frequency**: One LLD per individual feature, component, or service.
**Location**: `docs/lld/{feature}_lld.md` (shared, git-tracked)
Translate the PRD requirements into a developer-ready technical design containing:
- **Class & Component Diagrams**: UML diagrams detailing new/modified components
- **Data Flow & Database Schema**: Entity relationship diagrams, schema definitions, indexing strategies, API contracts
- **Logic & Algorithms**: Pseudocode or step-by-step logic for non-trivial requirements
- **Error Handling & Edge Cases**: Failure modes, timeouts, empty states, and fallback behaviors
- **Design Patterns**: Named patterns applied with rationale (e.g. Repository, Strategy)

*Exit criterion: LLD reviewed in a tech design review session; zero open questions remain before task tickets are created.*

---

### Rule of Thumb
- **PRD vs LLD Scope**: If two things share the same "why" and success metrics, they belong in the same PRD (initiative/epic level). If they have different technical implementations or different developers owning them, they each get their own LLD (feature/component/service level).

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
- **Micro-Retrofit Log**: To prevent documentation debt, the developer MUST maintain a running list of structural, schema, and API changes under a `## Micro-Retrofit Log` section in `agent_docs/spike_notes.md` (local only, git-ignored) during implementation. **Updates must be logged incrementally immediately after each subtask or test case is completed.**
- **Hard Gate**: Spikes are **never** merged directly to `main`. A retrospective documentation cycle (retrofitting Product Brief, PRD, and LLD) must parse the Micro-Retrofit Log and codify it into the `docs/` subdirectories before the merge request can be opened.

---

### In-Flight Design Amendment Protocol
If a developer uncovers a technical blocker or requires a design change (e.g. database schema tweak, API contract modification) *during* active story implementation:
- **No Blocking Loopback**: Work does not stop. The developer drafts a quick amendment detailing the change in the chat.
- **Peer/Architect Validation**: Share the amendment in the chat. Once approved by Winston/John, code implementation proceeds.
- **"Dirty LLD" Tagging**: The developer immediately appends a `<!-- DIRTY_AMENDMENT: [amendment details, approved date] -->` tag at the top of the feature LLD (`docs/lld/{feature}_lld.md`). This alerts other developers that the spec is dirty and in-flight.
- **Retrospective Sync & Git Diff Safety Net**: The Tech Writer (`bmad-writer`) harvests these tags in Phase 8 (Document), updates the PRD/LLD/System Map, and clears the tags. **As a safety net to catch untagged changes, the writer must run `git diff origin/main --name-only` to identify all modified codebase files and synchronize their structural implications.**

---

### Enforcement
- Agents must detect the active mode deterministically by running a git branch check during Pre-Flight.
- Agents generating user stories must reference an approved PRD section and issue numbers (e.g., FR-007)
- Agents generating code must reference an approved LLD component or schema definition (e.g., in `docs/lld/{feature}_lld.md`)
- If a preceding Brief, PRD, or LLD is missing or unapproved, the agent must STOP and request it before proceeding — unless **Spike Mode** is active.
- At Phase 8, the Tech Writer MUST execute the Git Diff Safety Net check to guarantee that all actual code schema modifications are synchronized with documentation.
