# Phase 2: Implement (FastAPI AI Stack)

## Purpose
Write production code following a strict **Test-Driven Development (TDD)** approach and high-quality coding standards for AI-driven applications.

## Prerequisites
- **Phase 1 (Research)** completed with a confirmed Specification.
- **Sprint Plan & Stories** (Status: Approved) available in `agent_docs/`.
- **Developer Collaboration**: Invoke **Amelia (Developer)** for core logic and Pydantic validation.

## Steps

**Set Mode:** Use `task_boundary` to set mode to **EXECUTION**.

### 1. TDD Cycle: RED (Failing Test)
Before writing any application code, create the tests:
- **Test File**: Create/Update `tests/test_{feature}.py`.
- **Mocking**: Use `pytest-mock` to mock external AI services or APIs.
- Write a failing test using `./dc.sh tests`.

### 2. TDD Cycle: GREEN (Minimal Code)
Write **only** the code necessary to make the tests pass:
- **Schemas**: Define Pydantic models in `app/schemas/`.
- **Logic**: Implement the minimal logic in `app/` to satisfy the test requirements.
- Verify that `./dc.sh tests` now passes.

### 3. TDD Cycle: REFACTOR (Blue)
Improve the code while keeping the tests green:
- **Optimization**: Refine prompt logic or data processing flows.
- **Code Quality**: Ensure type hinting, logging, and proper dependency injection.
- **Story Alignment**: Verify work against the specific Acceptance Criteria (UAC/TAC).

### 4. Repeat
Continue the Red-Green-Refactor cycle for each story requirement until the task is complete.

## Development Commands

```bash
# Run all tests
./dc.sh tests

# Run specific test
./dc.sh exec backend pytest tests/test_feature.py -v
```

## Completion Criteria
- [ ] Unit tests passing (TDD cycle strictly followed)
- [ ] Implementation aligns with UAC/TAC in `agent_docs/stories/`
- [ ] Error handling and logging added for AI service interactions
- [ ] Document Sync: Update `agent_docs/sprint-plan.md` and stories (Actual Time, Status)

## Next Phase
Ready for integration? Use the `/3-integrate` workflow or invoke **Amelia (Developer)** and **Murat (Tester)**.
