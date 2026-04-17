# Phase 2: Implement (Laravel)

## Purpose
Write production code following a strict **Mobile-First Design** approach and **Test-Driven Development (TDD)** principles, adhering to the highest Laravel standards.

## Prerequisites
- **Phase 1 (Research)** completed with a confirmed Specification.
- **Sprint Plan & Stories** (Status: Approved) available in `agent_docs/`.
- **Developer Collaboration**: Invoke **Amelia (Developer)** for backend logic and **Sally (UX)** for frontend styling and mobile-first verification.

## Steps

**Set Mode:** Use `task_boundary` to set mode to **EXECUTION**.

### 1. TDD Cycle: RED (Failing Test)
Before writing any application code, create the feature tests:
- **Backend (PHP):** Create `tests/Feature/{Feature}Test.php`.
- **Sally Collaboration**: Ensure the test includes assertions for responsive design requirements if applicable.
- Write a failing test using `php artisan test`.

### 2. TDD Cycle: GREEN (Minimal Code)
Write **only** the code necessary to make the tests pass, following the Laravel layer sequence:
- **Database**: Migrations and Seeders.
- **Model**: Eloquent models with relations and casts.
- **Logic**: Service layer and Form Requests.
- **Controller**: Resource controllers with Policy authorization.
- **Mobile-First UI**: Implement the frontend (Inertia/React) for **mobile viewports first**. Use Sally's guidance for layout constraints.
- Verify that `php artisan test` now passes.

### 3. TDD Cycle: REFACTOR (Blue)
Improve the core while keeping the tests green:
- **Styling**: Add desktop-optimized styles after the mobile view is perfect.
- **Cleanup**: Run `vendor/bin/pint` for formatting.
- **Story Alignment**: Verify work against the specific Acceptance Criteria (UAC/TAC).

### 4. Repeat
Continue the Red-Green-Refactor cycle for each story requirement until the task is complete.

## Development Commands

```bash
# Run tests
docker compose exec app php artisan test --filter={Feature}

# Code Formatting
docker compose exec app ./vendor/bin/pint
```

## Completion Criteria
- [ ] Mobile-First Design verified and confirmed
- [ ] Unit/Feature tests passing (TDD cycle strictly followed)
- [ ] Implementation aligns with UAC/TAC in `agent_docs/stories/`
- [ ] Code follows Laravel best practices (Migrations, Models, Policies)
- [ ] Document Sync: Update `agent_docs/sprint-plan.md` and stories (Actual Time, Status)

## Next Phase
Ready for integration? Use the `/3-integrate` workflow or invoke **Amelia (Developer)** and **Murat (Tester)**.
