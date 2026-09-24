---
name: pr-review-toolkit
description: Multi-vector code review toolkit for comprehensive pull request audits. Use when conducting deep code reviews, analyzing regression risks, auditing type safety, detecting silent errors, or reviewing documentation.
---

# PR Review Toolkit (Multi-Vector Audit)

## Overview
The PR Review Toolkit provides 6 specialized review perspectives to thoroughly analyze code diffs before merging.

---

## 🔍 The 6 Review Vectors

### 1. Silent Failure & Error Handling Auditor
- Scan for empty `catch {}` blocks or swallowed promises (`.catch(() => {})`).
- Verify that errors provide actionable debugging context, stack traces, and proper HTTP status codes.
- Ensure fallback values do not silently mask critical upstream failures.

### 2. Type Design & Invariant Auditor
- Verify that types represent valid domain states (make illegal states unrepresentable).
- Prohibit unsafe `any` or broad `as unknown as Type` casts without validation guards.
- Check strict null and undefined checks on external API response parsers.

### 3. Test Gap & Quality Analyzer
- Check if newly introduced branch conditions, edge cases, and error paths have corresponding test assertions.
- Verify test independence (tests do not rely on execution order or dirty persistent database state).
- Ensure assertions test business outcomes rather than implementation details.

### 4. Code Quality & Architectural Integrity
- Check for DRY violations and copy-paste duplications across files.
- Verify single responsibility principle on newly added classes/functions.
- Ensure changes stay strictly within the declared scope of the issue.

### 5. Code Simplification & Dead Code Eliminator
- Identify overly complex abstractions, unnecessary wrapper layers, or premature optimizations.
- Flag dead code, unused imports, or lingering debug logs.

### 6. Documentation & Comment Accuracy
- Verify that updated function signatures have matching docstrings.
- Ensure inline comments explain *why* non-obvious code exists rather than restating *what* it does.
- Flag misleading or outdated comments contradicted by the new diff.
