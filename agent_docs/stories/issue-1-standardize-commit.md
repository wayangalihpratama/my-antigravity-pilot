# Story: ISS-001 - Standardize Commit Message Format (#1)

**Status**: Ready
**Priority**: Must-Have
**Effort**: 2 points

## Description
As a maintainer of the repository, I want all commit messages to be prefixed with an issue number so that I can easily trace changes back to their requirements and maintain a clean audit trail.

## Acceptance Criteria
- [ ] Every stack (`fastapi-nextjs`, `laravel`, `fastapi-ai-stack`, `python-streamlit`) has a documentation rule mandating `[#issue_number]` prefix.
- [ ] Every stack has a checkout/commit workflow showing examples of the new format.
- [ ] Root documentation (README) is updated with the new standard.
- [ ] All 4 stacks are internally consistent.

## Technical Notes
- Update `git-workflow.md` and `5-commit.md` in each stack.
- Create missing files for `fastapi-ai-stack` and `python-streamlit`.
- Cross-reference to the Master Git Rule in root.
