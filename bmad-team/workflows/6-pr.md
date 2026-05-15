---
description: Create a high-quality Pull Request following HackerOne best practices
---

# Phase 6: Pull Request

## Purpose
Create a clear, informative, and professional Pull Request (PR) description that helps reviewers understand the "What", "Why", and "How" of your changes.

## Prerequisites
- **Phase 5 (Commit)** completed and changes pushed to the branch.
- Verified test results and documentation alignment.

## Steps

### 1. Gather Context
Collect the following information:
- **What**: Functional changes (brief summary).
- **Why**: Motivation and ticket links (GitHub Issue, Jira, etc.).
- **How**: Implementation strategy (architecture, patterns, libraries).
- **Testing**: How you verified it (tests run, manual steps).
- **Screenshots**: Visual evidence (if applicable).

### 2. Generate PR Description
Draft the description using the `bmad-team/templates/PULL_REQUEST.md` template.

#### Self-Review Checklist:
- [ ] Written for humans (prose, not just acronyms).
- [ ] Provides "antennae" for reviewers (security, performance, etc.).
- [ ] Concise yet informative.
- [ ] Includes ticket/issue links.

### 3. Create PR
Execute the git command or provide the content for the PR.

```bash
# Example using GH CLI (if available)
gh pr create --title "[#issue] <type>(<scope>): <description>" --body-file PULL_REQUEST.md
```

## Completion Criteria
- [ ] PR description follows the What/Why/How/Testing structure.
- [ ] Ticket links are included.
- [ ] Self-review performed.
- [ ] PR created or content provided to the user for manual creation.
