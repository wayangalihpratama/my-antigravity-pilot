# Phase 2: Implement (FastAPI & Next.js)

## Purpose
Write production code following a strict **Mobile-First Design** approach and **Test-Driven Development (TDD)** principles to ensure high-quality, maintainable features.

## Prerequisites
- **Phase 1 (Research)** completed with a confirmed Specification.
- **Sprint Plan & Stories** (Status: Approved) available in `agent_docs/`.
- **Developer Collaboration**: Invoke **Amelia (Developer)** for core logic and **Sally (UX)** for frontend styling and mobile-first verification.

## Steps

**Set Mode:** Use `task_boundary` to set mode to **EXECUTION**.

### 1. Mobile-First Workspace Setup
Before coding, define the mobile viewport constraints:
- **Sally Collaboration**: Review the UI requirements for mobile-first breakpoints and layout.
- Use Tailwind CSS responsive utilities (`sm:`, `md:`, `lg:`) starting from the base (mobile) style.

### 2. TDD Cycle: RED (Failing Test)
Create the test files first:
- **Backend (Python):** Create `backend/tests/test_{feature_name}.py`. Use class-based `pytest`.
- **Frontend (Next.js):** Co-locate `*.test.tsx` within the component folder.
- Write a test that fails because the feature does not exist yet.

### 3. TDD Cycle: GREEN (Minimal Code)
Write **only** the code necessary to make the tests pass:
- **Mobile-First Implementation**: Build the UI for mobile viewports *first*.
- **Amelia Collaboration**: Ensure backend routers and schemas follow Pydantic v2 validation.
- Verify that the tests now pass.

### 4. TDD Cycle: REFACTOR (Blue)
Improve the code while keeping the tests green:
- **Styling**: Add desktop-specific styles (`lg:`, etc.) only after the mobile view is perfect.
- **Code Quality**: Ensure type hinting, logging, and proper dependency injection.
- **Story Alignment**: Verify work against the specific Acceptance Criteria (UAC/TAC).

### 5. Repeat
Continue the Red-Green-Refactor cycle for each story requirement until the task is complete.

## Development Commands

```bash
# Python: Run specific class
./dc.sh exec backend python -m pytest backend/tests/test_feature.py -v

# Frontend: Run Jest tests
./dc.sh exec frontend yarn test
```

## Completion Criteria
- [ ] Mobile-First Design verified and confirmed
- [ ] Unit tests passing (TDD cycle strictly followed)
- [ ] Implementation aligns with UAC/TAC in `agent_docs/stories/`
- [ ] Error handling and logging added
- [ ] Document Sync: Update `agent_docs/sprint-plan.md` and stories (Actual Time, Status)

## Next Phase
Ready for integration? Use the `/3-integrate` workflow or invoke **Amelia (Developer)** and **Murat (Tester)**.