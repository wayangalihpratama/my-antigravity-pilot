---
description: Scale-Adaptive BMAD workflow for small bugs, minor refactors, and fast-track tickets
---

# BMAD Fastpath Workflow ⚡

**CRITICAL**: Only for minor tasks on `hotfix/` or `bugfix/` branches. For `spike/*` → Spike Mode. For `feature/*` or `release/*` → `/bmad-orchestrator`.

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
2. Add targeted task entries to `task.md` at the workspace root with explicit UAC and TAC.
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
3. Update README or changelog if applicable.
4. If changes affect documented behavior, sync amendments to existing docs (paths per @documentation-hierarchy.md). Clear any `<!-- DIRTY_AMENDMENT -->` tags.
5. **Mandatory Git Confirmation**: Follow @git-workflow.md mandatory confirmation protocol.

## Completion
Once completed, hand back control to the user.
