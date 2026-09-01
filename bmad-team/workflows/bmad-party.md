---
description: BMAD v6 Party Mode — multi-agent deliberation council (Architect + Dev + Tester) for cross-functional pre-flight validation.
---

# BMAD v6 Party Mode Deliberation 🎭

## Purpose
Before writing production code on complex features, **Party Mode** brings together the **System Architect (Winston)**, **Senior Developer (Amelia)**, and **Test Architect (Murat)** into a structured multi-perspective council to challenge assumptions, resolve edge cases, and eliminate blind spots.

---

## Deliberation Steps

### 1. Pre-Flight Review
Load the active Feature Specification (`docs/features/{NNN}_{name}_spec.md` or native path from `project-context.md`) and Project LLD (`docs/lld/project_lld.md`).

### 2. Council Discussion (Three-Way Synthesis)

Spawn or simulate the subagent council:

1. **🏗️ Winston (Architect)** presents:
   - Data flow and component boundaries
   - Security considerations and error models
   - Database schema modifications & migrations
2. **💻 Amelia (Developer)** challenges:
   - Implementation complexity and dependency hurdles
   - Performance hot paths & potential race conditions
   - File edit strategy and refactoring needs
3. **🧪 Murat (Test Architect / TEA)** critiques:
   - Unhandled edge cases and boundary conditions
   - Mocking requirements for external APIs
   - Integration & regression test strategy

### 3. Output Party Mode Synthesis
Summarize the agreed decisions and risk mitigations:
- **Consensus Reached**: Key architectural trade-offs resolved.
- **Edge Cases Identified**: Additional scenarios to add to the test strategy.
- **Spec Updates**: Minor adjustments applied to the Feature Spec.

### 4. Handoff
Once approved by the user, immediately transition to `/2-implement` with `bmad-dev` (Amelia) to begin TDD.
