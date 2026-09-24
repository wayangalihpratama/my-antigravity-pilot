---
name: feature-dev
description: Structured 7-phase feature development workflow. Use when building non-trivial features from scratch to ensure thorough exploration, requirement clarification, architectural planning, TDD implementation, and verification.
---

# Feature Development Lifecycle (7-Phase Protocol)

## Overview
The `feature-dev` protocol structures software development into 7 deliberate phases to prevent architectural drift, unvetted assumptions, and untested implementations.

```
Phase 1: Explore ──> Phase 2: Clarify ──> Phase 3: Plan ──> Phase 4: Test-First (TDD)
                                                                    │
Phase 7: Review <── Phase 6: Verify <── Phase 5: Implement <────────┘
```

---

## The 7 Phases

### Phase 1: Explore & Context Discovery
- Inspect existing codebase patterns, data models, routes, and shared utilities.
- Identify touchpoint files and potential integration conflicts.
- **Rule**: Do NOT write code yet.

### Phase 2: Clarify Requirements & Ambiguity
- Review the feature request for underspecified edge cases, error states, and permissions.
- If ambiguities exist, interview the user using structured choices.
- Agree on concrete success criteria and scope boundaries.

### Phase 3: Architectural Design & Plan
- Create an implementation plan (`LLD` or `implementation_plan.md`).
- Define exact file paths to create/modify, data structures, and API contracts.
- Obtain explicit user validation on the plan before touching application code.

### Phase 4: Test-First (Red Phase)
- Write unit/integration tests covering the expected behavior and edge cases before writing implementation logic.
- Run tests to confirm they fail for the expected reason (`Red`).

### Phase 5: Minimal Implementation (Green Phase)
- Implement the minimal, clean code required to satisfy the failing tests.
- Adhere strictly to project coding standards (DRY, SOLID, explicit error handling).

### Phase 6: Verification & Refactor
- Run the full test suite, linters, and type checkers.
- Perform visual or DOM checks if UI changes are involved.
- Refactor code for clarity, performance, and token conservation without breaking passing tests.

### Phase 7: Quality Review & Commit
- Perform a self-review against security vulnerabilities, accidental dead code, and out-of-scope modifications.
- Stage declared touchpoint files explicitly.
- Commit following the repository standard: `[#issue_number] <type>(<scope>): <description>`.
