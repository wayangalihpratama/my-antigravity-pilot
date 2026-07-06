---
description: Planning & Estimation Phase - creates a detailed features specification/PRD with ballpark estimations without implementing it.
---

# Phase 0: Planning & Estimation 📋

## Purpose
Define the detailed scope, user experience, requirements, edge cases, rollout strategy, and ballpark estimation for a new feature. This phase focus entirely on alignment and estimation. It is designed to run prior to any implementation, allowing stakeholders to make informed decisions before allocating development resources.

> [!IMPORTANT]
> **NO IMPLEMENTATION / CODE CHANGES**: The agent must NOT write any implementation code, write unit tests, or run command line updates during this phase. This workflow halts immediately after generating and refining the specification document, requiring the user to explicitly invoke `/1-research` or `/2-implement` to begin development.
> *(Note: If Spike Mode is active, this planning phase is bypassed entirely for velocity, and documentation is generated retrospectively.)*

---

## Steps

### 1. Requirements Discovery & 5W1H
Before creating the document, analyze the user's request and conduct a 5W1H analysis to build a complete picture:
- **Who**: Who are the primary actors or personas interacting with this feature?
- **What**: What is the feature, and what are its key functional requirements?
- **Where**: Where does it live in the current system (frontend paths, backend modules, database schemas)?
- **When**: When does it trigger, or when in the timeline is it needed?
- **Why**: Why is this feature necessary? What user pain point does it address?
- **How**: How will it behave? Describe the high-level logic flow.

### 2. PRD Creation
Create or update an initiative/epic-level PRD (Product Requirements Document) under `docs/prd/{initiative}_prd.md` using the template `bmad-team/templates/PRD.md`. The document MUST be concise, scannable, and include the following sections:

#### I. Overview & Goal
- **Problem Statement**: What specific user or technical problem is being solved?
- **Core Metric**: What is the primary metric we want to move/improve (e.g., reduce checkout drop-off by 5%, reduce API response time by 100ms)?

#### II. User Stories & Flows
- **User Personas**: Who is the feature for and what do they need?
- **User Journey / Flow**: Step-by-step wireframe descriptions or text-based user flows showing the interaction from trigger to completion.
- **Wireframes / UI Mockups (If Needed)**: For user-facing features, include low-fidelity ASCII wireframes or layout maps directly in the markdown to clarify component hierarchy, placement, and interactions before design sign-off.

#### III. Requirements (Scope Guardrails)
To prevent feature creep, categorize requirements into bulleted lists:
- **Must-Have**: Core requirements that must be present in the initial release.
- **Nice-to-Have**: Optional features that can be deferred to future iterations.
- **Out of Scope**: Explicitly documented boundaries of what will *not* be built.

#### IV. Architecture Design (If Needed)
- **Data Flow / Logic Flow**: Visualized using Mermaid flowcharts or sequence diagrams.
- **Data Model changes**: Brief description of new database columns, collections, or API payload interfaces.

#### V. Acceptance Criteria
- **User Acceptance Criteria (UAC)**: Requirements from the user's perspective (e.g., "Given X, when Y, then Z").
- **Technical Acceptance Criteria (TAC)**: Non-functional requirements (e.g., performance thresholds, security constraints, logging).

#### VI. Edge Cases & Errors
- **Failures**: How does the system respond when an API call fails or a timeout occurs?
- **Empty States**: What does the user see when there is no data to display?
- **Boundary Conditions**: How are inputs validated (e.g., character limits, negative values, null states)?

#### VII. Analytics & Telemetry
- **Tracking Events**: Exactly which events and properties will be sent to the analytics backend.
- **Success Metrics**: How the product team will measure the success of this feature post-rollout.

#### VIII. Rollout & Rollback Plan
- **Rollout Strategy**: Phased release plan (e.g., 10% beta users first, feature flag control).
- **Rollback Plan**: Emergency plan detailing how to disable or revert the feature if critical errors occur in production.

#### IX. Epic & Ballpark Estimation
Break down the epic into concrete phases, technical tasks, or component deliveries:
- **Epic Details & Breakdowns**: Divide the initiative into logical epic components or implementation phases (e.g., Phase 1: Core Database & Backend APIs, Phase 2: Frontend Implementation & Integration, Phase 3: Verification & Hardening).
- **Task-Level Breakdown**: For each epic component/phase, list concrete tasks (e.g., "Create database migration for schema update", "Implement auth middleware", "Build responsive layout component").
- **Ballpark Estimation (Developer Hours)**: Provide estimations explicitly in developer hours rather than story points.
  - Break tasks down so no single task exceeds 16 hours (2 days) to ensure accuracy.
  - Include best-case and worst-case ranges or explicitly add an uncertainty buffer (e.g., +20% for integration).
  - Define the confidence level (Low, Medium, High) for each estimate block.
- **Assumptions & Dependencies**: Key assumptions, critical path tasks, or external dependencies affecting the timeline.

---

## Completion Criteria
- [ ] Requirements gathered and 5W1H analyzed
- [ ] Scannable initiative PRD created at `docs/prd/{initiative}_prd.md` using the PRD template
- [ ] Out of Scope boundaries explicitly agreed upon
- [ ] Ballpark estimations and epic breakdown completed
- [ ] User has reviewed and approved the PRD

## 🛑 HALT: Workflow Stop
**STOP! Do not write code or proceed to implementation.**
Present the finalized `docs/prd/{initiative}_prd.md` to the user.

**Handoff Protocol**:
- To begin the next phase, the user must explicitly initiate the **`/1-research`** workflow or **`/2-implement`** workflow.
