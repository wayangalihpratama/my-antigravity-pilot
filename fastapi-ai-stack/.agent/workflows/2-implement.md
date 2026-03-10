---
description: Implement phase - Red-Green-Refactor with Class-Based Python testing
---

1. **Prerequisite**: Proactively scan `.agent/workflows/` and use required workflows.
2. Create/update Pydantic schemas in `app/schemas/`.
3. **Write a failing test in `tests/` (TDD Enforced)**.
4. Implement the minimal logic in `app/`.
5. Run tests: `./dc.sh tests`.
6. Refactor and repeat.
7. **Document Sync**: Update `agent_docs/stories/` (Actual Time, UAC/TAC), `agent_docs/sprint-plan.md` to reflect completed state, and related `agent_docs/features/` docs simultaneously.
