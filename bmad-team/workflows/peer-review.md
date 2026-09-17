---
description: Interactive Peer PR Review Assistant — audits a colleague's Pull Request, calibrates review findings interactively with you, and submits line-level reviews or Changes Requested directly to GitHub.
---

# Interactive Peer PR Review Assistant (`/bmad-peer-review`) 🔍🤝

## Purpose
When you are assigned as a reviewer on a teammate's Pull Request, this workflow uses **Rachel (`bmad-reviewer`)** to perform a rigorous automated audit of the PR, collaborate with you to calibrate and refine the review comments, and submit the final review (with `APPROVE`, `COMMENT`, or `REQUEST_CHANGES`) directly to GitHub.

---

## Workflow Steps

### 1. Ingest Remote PR & Context
Provide the PR number or URL (e.g., `/bmad-peer-review 42` or `https://github.com/org/repo/pull/42`):
```bash
# Fetch PR metadata, linked issue, and changed files
gh pr view <PR_NUMBER> --json number,title,body,author,baseRefName,headRefName,files,reviews

# Extract full diff for audit
gh pr diff <PR_NUMBER>
```

---

### 2. Multi-Vector Deep Audit (Rachel & Council)
Rachel (`bmad-reviewer`) audits the remote diff across all standard severity dimensions:
1. **🛡️ `[SEC]` Security**: Auth decorators, SQL/NoSQL injection, secret leaks, CSRF/XSS.
2. **💾 `[DATA]` Data Integrity**: Unhandled transactions, race conditions, migration reversibility.
3. **🏗️ `[ARCH]` Architecture**: SOLID compliance, layer leakage, missing adapters.
4. **📦 `[SCOPE]` Scope Containment**: Touched files vs. linked issue requirements (flagging unsolicited refactoring).
5. **♻️ `[DRY]` Code Duplication**: Cloned functions/AST similarity $>70\%$, missing shared strategies.
6. **⚡ `[PERF]` Performance**: Unbatched I/O / DB queries inside loops, blocking async calls.
7. **🧪 `[CONTRACT]` & `[TEST]`**: Mock-reality parity, missing tests, edge cases, $\ge 80\%$ coverage check.
8. **💡 `[NIT]` / Suggestions**: Constructive readability or framework suggestions.

---

### 3. Present Draft Review to You (Interactive Calibration)
The agent generates a draft review scorecard in the chat:

```markdown
# 📋 Draft Peer Review for PR #{PR_NUMBER}: {PR_TITLE}
**Author**: @{author} | **Target**: {base_branch} | **Auditor**: Rachel + You

## 📊 Summary Assessment
- **Critical / Blockers [SEC/DATA]**: N
- **Major [ARCH/PERF/SCOPE/DRY/TEST]**: N
- **Minor / Suggestions [PAT/NIT]**: N
- **Proposed Verdict**: [APPROVE / REQUEST_CHANGES / COMMENT]

## 📝 Proposed Line-Level Comments
1. `path/to/file.py:L45` — **[SEC]** Missing authorization check on admin endpoint.
   - *Suggested Comment*: "Please add the `@require_admin` dependency here to prevent unauthorized access."
2. `path/to/service.py:L112` — **[PERF]** Database lookup inside loop ($O(N)$ query).
   - *Suggested Comment*: "Consider querying all IDs upfront using `filter(id__in=ids)` to avoid $N$ round-trips."

---
### 💬 User Calibration Options:
- You can tell me:
  - *"Remove item #2, it's a minor internal script."*
  - *"Add a question asking why they chose Library X instead of Library Y."*
  - *"Change verdict from REQUEST_CHANGES to COMMENT."*
  - *"Looks great, submit to GitHub."*
```

---

### 4. Review Refinement & Calibration
The agent adjusts the comments and verdict based on your guidance until you are completely satisfied with the review.

---

### 5. Submit Review to GitHub
Once confirmed by you, the agent submits the review directly using the GitHub CLI:

```bash
# Option A: Request Changes with inline summary
gh pr review <PR_NUMBER> --request-changes --body "<calibrated_review_markdown>"

# Option B: General Review Comments
gh pr review <PR_NUMBER> --comment --body "<calibrated_review_markdown>"

# Option C: Approve PR
gh pr review <PR_NUMBER> --approve --body "<calibrated_approval_markdown>"
```

---

## 🎯 Reviewer Principles
- **Constructive & Empathetic**: Praise good design decisions and explain the *why* behind every suggested change.
- **Actionable Suggestions**: Always provide a concrete code snippet or solution when requesting a change.
- **Fast Turnaround**: Keep reviews concise, structured, and easy for the author to address in 1 atomic pass.
