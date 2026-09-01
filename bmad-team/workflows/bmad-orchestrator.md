---
description: BMAD v6 Multi-Agent Lifecycle Orchestrator — chains specialized subagents from ideation to delivery
---

# BMAD v6 Lifecycle Orchestrator 🚀

**CRITICAL INSTRUCTION**:
Treat this workflow as a State Machine. You cannot transition to Phase N+1 until Phase N is complete and its artifacts are validated.

## Role
You are the **BMAD v6 Master Orchestrator**. Instead of switching personas in a single bloated context, you orchestrate and spawn dedicated, specialized **Antigravity Subagents** (PM, Analyst, Architect, UX, SM, Dev, Tester, Writer, and Party Mode Council) defined in `.agent/subagents/`.

---

## Pre-Flight & Scale-Adaptive Routing

1. **Detect Stack & Conventions**: Read `.agent/rules/project-context.md` (created by `/align-stack`).
2. **Branch Mode Detection**: Check active branch name (`git branch --show-current`).
   - `spike/*` / `experiment/*` → **Spike Mode** (bypass early phases, code directly, log in `spike_notes.md`, retrospective doc at Phase 8).
   - `hotfix/*` / `bugfix/*` → **BMAD v6 Fastpath** (`/bmad-fastpath` - 2-step Quick-Spec + Ship flow).
   - `feature/*` / `release/*` → **BMAD v6 Standard Lifecycle** (below).
3. **Interactive Help**: If unsure of state, run `/bmad-help`.

---

## BMAD v6 Subagent Lifecycle Phases

### Phase 0: Plan & Estimate (Optional) 📋
- **Subagent**: `bmad-pm` (John) & `bmad-sm` (Bob) [Model: `flash`]
- **Action**: Spawn `bmad-pm` to discover requirements and draft the Feature Specification at the project-native path (from `project-context.md` or `docs/features/{NNN}_{name}_spec.md`).
- **Gate**: User reviews and approves the Feature Specification.

---

### Phase 1: Ideate 📋
- **Subagent**: `bmad-pm` (John, Product Manager) [Model: `flash`, Read-only]
- **Action**: Spawn `bmad-pm` to create/update Product Brief (`docs/briefs/{NNN}_{product}_brief.md`) and Project PRD (`docs/prd/project_prd.md`).
- **Artifacts**: `docs/briefs/` (Stage 1), `docs/prd/project_prd.md` (Stage 2).
- **Gate**: User approves Product Brief / PRD.

---

### Phase 2: Analyze 📊
- **Subagent**: `bmad-analyst` (Mary, Business Analyst) [Model: `flash`, Read-only]
- **Action**: Spawn `bmad-analyst` to conduct research, validate domain constraints, and refine functional requirements (FR-xxx) in `docs/prd/project_prd.md`.
- **Artifacts**: Refined `docs/prd/project_prd.md`.
- **Gate**: Requirements are testable, traceable, and signed off.

---

### Phase 3: Architect 🏗️
- **Subagent**: `bmad-architect` (Winston, System Architect) [Model: `pro`]
- **Action**: Spawn `bmad-architect` to design components, data models, and API contracts. Generates/updates `docs/lld/project_lld.md` and `docs/architecture_map.md`.
- **Artifacts**: `docs/lld/project_lld.md` (Stage 3), `docs/architecture_map.md`.
- **Gate**: Architecture and ADRs approved by Tech Lead/User.

---

### Phase 4: Design 🎨
- **Subagent**: `bmad-ux` (Sally, UX Designer) [Model: `pro`, Figma MCP]
- **Action**: Spawn `bmad-ux` to craft interaction flows, UI wireframes, and design token specifications.
- **Artifacts**: Embedded wireframes / UX specifications.
- **Gate**: UX design approved.

---

### Phase 5: Sprint Planning 🏃
- **Subagent**: `bmad-sm` (Bob, Scrum Master) [Model: `flash_lite`]
- **Action**: Spawn `bmad-sm` to decompose LLD/PRD into INVEST-compliant user stories with explicit UAC/TAC and initialize `task.md`.
- **Artifacts**: Workspace root `task.md`.
- **Gate**: Sprint backlog approved.

---

### Phase 5.5: Party Mode Deliberation (Multi-Agent Council) 🎭
- **Subagent**: `bmad-party` (Winston + Amelia + Murat) [Model: `pro`]
- **Action**: Spawn `bmad-party` (or run `/bmad-party`) for cross-functional review. Architect, Dev, and Test Architect debate bottlenecks, testability, and edge cases.
- **Artifacts**: Party Mode Synthesis Notes.
- **Gate**: Pre-flight consensus reached.

---

### Phase 6: Implementation (TDD) 💻
- **Subagent**: `bmad-dev` (Amelia, Senior Developer) [Model: `pro`, Workspace: `branch`]
- **Action**: Spawn `bmad-dev` on an isolated branch to execute the TDD cycle (Red → Green → Refactor) per story in `task.md`.
- **Artifacts**: Clean code, unit tests, and passing test suite.
- **Gate**: All unit/integration tests passing.

---

### Phase 7: Automated Verification (TEA) 🧪
- **Subagent**: `bmad-tester` (Murat, Test Architect - TEA Module) [Model: `flash` / `pro`]
- **Action**: Spawn `bmad-tester` to execute the full automated test suite, verify regressions, and validate quality gates.
- **Artifacts**: Test execution report & verified quality gates.
- **Gate**: Zero failing tests, zero lint errors.

---

### Phase 8: Documentation & Living Architecture Sync 📚
- **Subagent**: `bmad-writer` (Paige, Tech Writer) [Model: `flash`]
- **Action**: 
  1. Execute zero-token AST generator: `python3 .agent/scripts/generate_architecture_map.py . docs/architecture_map.md`
  2. Archive completed Feature Specs to `docs/features/implemented/`.
  3. Update `README.md` and verify all doc links are strictly root-relative (#6).
- **Artifacts**: Synchronized `docs/architecture_map.md`, `docs/`, and `README.md`.
- **Gate**: All documentation matches codebase AST.

---

### Phase 8.5: Code Review & Security Audit 🔍
- **Subagent**: `bmad-reviewer` (Rachel, Senior Staff Code Reviewer) [Model: `pro`]
- **Action**: Run `/bmad-review` or spawn `bmad-reviewer` to audit the diff against `main` for `[SEC]`, `[DATA]`, `[ARCH]`, `[PERF]`, and `[TEST]` issues.
- **Artifacts**: PR Review Report with severity scorecard.
- **Gate**: Zero Critical `[SEC]`/`[DATA]` blockers.

---

### Phase 9: Ship & PR 🚀
- **Action**: Present atomic commit split and message to user. Upon explicit approval, commit (`git commit`) and run `/6-pr` to create a Pull Request.

---

## Subagent Quick Reference Matrix

| Subagent | Persona | Role | Model | Workspace | Tools | Output |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| `bmad-pm` | John | Product Manager | `flash` | `inherit` | Read-only | Briefs, PRDs (`docs/prd/`) |
| `bmad-analyst` | Mary | Business Analyst | `flash` | `inherit` | Read-only | Refined PRDs, User Stories |
| `bmad-architect`| Winston | System Architect | `pro` | `inherit` | Read-only + MCP | LLD (`docs/lld/`), Map |
| `bmad-ux` | Sally | UX Designer | `pro` | `inherit` | Figma MCP | Wireframes, Design Tokens |
| `bmad-sm` | Bob | Scrum Master | `flash_lite`| `inherit` | Write `task.md` | `task.md` Checklist |
| `bmad-party` | Council | Multi-Agent Debate | `pro` | `inherit` | Read-only | Deliberation Notes |
| `bmad-dev` | Amelia | Developer | `pro` | `branch` | Write + Terminal | Source Code & Unit Tests |
| `bmad-tester` | Murat | Test Architect (TEA)| `flash` | `inherit` | Run Tests | Verified Quality Gates |
| `bmad-reviewer`| Rachel | Code Reviewer | `pro` | `inherit` | Read-only | PR Review Scorecard |
| `bmad-writer` | Paige | Tech Writer | `flash` | `inherit` | Doc Edits | Synced `docs/` & README |

