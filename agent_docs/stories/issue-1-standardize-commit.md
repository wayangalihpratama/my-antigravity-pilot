# Story: ISS-001 - Standardize Commit Message Format (#1)

**As a** maintainer of the repository
**I want** all commit messages to be prefixed with an issue number
**So that** I can easily trace changes back to their requirements and maintain a clean audit trail.

### Timeline & Effort
- **Estimated Time**: 4h
- **Actual Time**:
- **Effort Points**: 2 points

### Acceptance Criteria

#### User Acceptance Criteria (UAC)
- [ ] Root documentation (README) is updated with the new standard.
- [ ] Every stack has a checkout/commit workflow showing examples of the new format.

#### Technical Acceptance Criteria (TAC)
- [ ] Every stack (`fastapi-nextjs`, `laravel`, `fastapi-ai-stack`, `python-streamlit`) has a documentation rule mandating `[#issue_number]` prefix.
- [ ] Update `git-workflow.md` and `5-commit.md` in each stack.
- [ ] All 4 stacks are internally consistent via cross-references to the Master Git Rule in root.

### Technical Notes
- Create missing files for `fastapi-ai-stack` and `python-streamlit`.
- Use `./dc.sh exec` for all stack-specific operations.

### Definition of Done
- [ ] Unit tests passing (where applicable for automation)
- [ ] Code reviewed
- [ ] Documentation updated in all stack `.agent/` directories
