# AGENTS.md — BMAD Multi-Agent Guidelines (3-Layer Index)

Thin entry-point index for AI coding agents (Antigravity, Claude Code, OpenAI Codex, Cursor). Detailed rules and skills load conditionally to conserve context tokens.

---

## 🏛️ Layer 1: Persona Roster

* **`bmad-dev` (Amelia)**: TDD Developer (`Red -> Green -> Refactor`, Ponytail Decision Ladder).
* **`bmad-architect` (Winston)**: System Architect (LLDs, ADRs, API contracts).
* **`bmad-tester` (Murat)**: Test Architect (edge cases, **>=80% coverage gate**).
* **`bmad-reviewer` (Rachel)**: Code Reviewer (`[SEC]`, `[DATA]`, `[ARCH]`, `[PERF]`, `[BLOAT]`, `[SCOPE]`).
* **`bmad-ux` (Sally) / `frontend-design`**: Anti-AI-Slop UI & bespoke design tokens.
* **`bmad-writer` (Paige) / `humanizer`**: Docs-as-code & anti-AI-prose filter.

## 📂 Layer 2 & 3: On-Demand Rules, Skills & Workflows

* **Conditional Rules**: `bmad-team/rules/` (mirrored to `.agent/rules/`) — `@coding-standards.md`, `@scope-governance.md`, `@git-workflow.md`, `@token-conservation.md`.
* **Skills & Workflows**: `bmad-team/skills/` & `bmad-team/workflows/` (`/0-planning`, `/1-research`, `/2-implement`, `/4-verify`, `/5-commit`, `/6-pr`, `/handoff`).
* **Context Pruning**: `.agent/config.yaml` blocks unrelated domain skills on every turn.

## 🛡️ Core Inviolables & Tooling

1. **TDD & Minimalism**: Failing test first; step through the Pre-Code Decision Ladder before adding code or dependencies.
2. **Scope Quarantine**: Edit only declared touchpoints; quarantine unrelated refactors to backlog issues.
3. **Git & Secrets**: Never commit/push without user approval; `[#issue] <type>(<scope>): <desc>`; zero hardcoded secrets.
4. **Tooling**: Playwright (`npx playwright test`), Context7 (`query-docs`), Strix (`npx strix scan`), 9Router (`http://127.0.0.1:20128/v1`, `9r status`).
