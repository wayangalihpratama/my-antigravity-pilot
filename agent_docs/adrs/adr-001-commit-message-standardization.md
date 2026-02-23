# ADR-001: Standardized Commit Message Format

- **Status**: Accepted
- **Context**: The repository needs a unified way to trace code changes back to specific issues. While Conventional Commits are followed in most stacks, they lack a mandatory issue number prefix.
- **Decision**:
  - Mandate the `[#issue_number]` prefix for all commit messages.
  - New format: `[#issue_number] <type>(<scope>): <description>`
  - Update all 4 tech stacks and the root-level documentation to reflect this standard.
- **Alternatives Considered**:
  - Git Hooks: Rejected for MVP to avoid local environment friction, but may be added later as an optional feature.
  - Suffix format: Rejected as standard tools (like GitHub) often prioritize the beginning of the commit message for visibility.
- **Consequences**:
  - Improved traceability across branches and PRs.
  - Slight increase in friction for first-time contributors.
  - Consistent developer experience across all 4 stacks.
