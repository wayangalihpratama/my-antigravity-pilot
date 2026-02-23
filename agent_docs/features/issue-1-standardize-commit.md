# Feature Document: Issue #1 - Standardized Commit Message Format

## 1. Overview
Standardize the commit message format across all tech stacks in the repository to ensure every commit is prefixed with its associated issue number.

**Issue ID**: #1
**Standard**: `[#issue_number] <type>(<scope>): <description>`

## 2. Requirements
- **FR1**: Update `git-workflow.md` in all stack directories to mandate the `[#issue_number]` prefix.
- **FR2**: Update all `/5-commit.md` workflows to show examples and instructions for the new prefix.
- **FR3**: Ensure compatibility with Conventional Commits (type, scope, etc.).
- **FR4**: Update root README or other meta-docs to socialize the requirement.

## 3. Logic Changes
### Stacks
- `fastapi-nextjs`: `.agent/rules/git-workflow.md`, `.agent/workflows/5-commit.md`
- `laravel`: `.agent/rules/git-workflow.md`, `.agent/workflows/5-commit.md`
- `fastapi-ai-stack`: `.agent/rules/git-workflow.md`, `.agent/workflows/5-commit.md` (if exists)
- `python-streamlit`: `.agent/rules/git-workflow.md`, `.agent/workflows/5-commit.md` (if exists)

## 4. Success Criteria
- Valid commit example: `[#1] fix(auth): resolve login timeout`
- Invalid commit example: `feat: add new button` (Missing prefix)
