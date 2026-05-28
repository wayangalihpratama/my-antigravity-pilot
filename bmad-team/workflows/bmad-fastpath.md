---
description: Scale-Adaptive BMAD workflow for small bugs, minor refactors, and fast-track tickets
---

# BMAD Fastpath Workflow ⚡

**CRITICAL INSTRUCTION**
This workflow is ONLY for minor tasks and is activated on `hotfix/` or `bugfix/` branches. Do NOT use this for large features or architectural overhauls.
If the branch prefix is `spike/` or `experiment/`, switch to Spike Mode. If the branch prefix is `feature/` or `release/`, switch to `/bmad-orchestrator.md` for the Standard Lifecycle.

## Role

You are the BMAD Orchestrator executing the Fastpath. This streamlined pipeline bypasses the heavy PM and Analyst phases.

## Pipeline Steps

### Step 1: Architect (Technical Design)
**Agent**: bmad-architect
**Goal**: Rapid technical footprint
1. Load `bmad-architect`
2. Analyze the bug or requested change.
3. Identify precisely which files to change (using Document Sharding).
4. Check if the change affects behavior documented in `docs/` — if so, note which docs need updating.
5. Outline the exact implementation steps.
**Gate**: User approves the technical footprint.

### Step 2: Plan (Story Creation)
**Agent**: bmad-sm
**Goal**: Dev-ready requirements
1. Load `bmad-sm`
2. Create or update a targeted user story in `agent_docs/stories/`.
3. List explicit UAC and TAC.
**Gate**: Story meets INVEST criteria for the small scope.

### Step 3: Implement (TDD Build)
**Agent**: bmad-dev
**Goal**: Write the fix securely
1. Load `bmad-dev`
2. Follow Red-Green-Refactor to implement the story.
**Gate**: All tests pass.

### Step 4: Verify (Tester)
**Agent**: bmad-tester
**Goal**: Quality assurance
1. Load `bmad-tester`
2. Run relevant tests locally or review the dev tests to ensure no regressions.
**Gate**: Quality gates clear.

### Step 5: Document (Writer)
**Agent**: bmad-writer
**Goal**: Changelog, commit (with confirmation), and docs update
1. Load `bmad-writer`
2. Run the **Git Diff Safety Net** check (`git diff origin/main --name-only`) to discover all modified files, routes, or schemas.
3. Update the README or changelog if applicable.
4. If the changes affect documented behavior, database schemas, or routing, retrospectively sync any inline In-Flight Amendments or detected diff changes to the PRD at `docs/prd/{initiative}_prd.md`, the System Architecture Map (`docs/architecture_map.md`), and the granular LLD at `docs/lld/{feature}_lld.md`. Clear any `<!-- DIRTY_AMENDMENT -->` tags.
5. **Mandatory Git Confirmation**: Verify that all documentation is perfectly aligned with the implementation and determine if the changes should be split into **atomic commits**. Show the proposed commit split plan, message(s), and list of changed files to the user. Ask for explicit permission for the **doc alignment**, the **commit split plan**, and the final **git commit/push**.

## Completion
Once completed, hand back control to the user.
