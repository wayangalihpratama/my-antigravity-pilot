---
trigger: model_decision
description: BMAD Coding Standards — DRY, KISS, YAGNI, TDD, SOC, BDUF, SOLID. Load when implementing or reviewing technical designs.
---

# BMAD Coding Standards

## 1. Core Principles

| Acronym | Rule | Action |
|---------|------|--------|
| **DRY** | Don't Repeat Yourself | Extract duplicated logic into functions/modules |
| **KISS** | Keep It Simple | Avoid over-engineering; simplify if unsure |
| **YAGNI** | You Aren't Gonna Need It | Only implement what's needed now, not "future" features |
| **TDD** | Test-Driven Development | Write failing test first → make it pass → refactor |
| **SOC** | Separation of Concerns | One function/class = one responsibility |
| **BDUF** | Avoid Big Design Up Front | Start small, iterate; design only for the current phase |

---

## 2. SOLID Principles

| Letter | Principle | Check |
|--------|-----------|-------|
| **S** | Single Responsibility | If function name has "And", it's likely breaking SRP |
| **O** | Open-Closed | Add behavior via extension, not by modifying existing code |
| **L** | Liskov Substitution | Subclasses must satisfy same contracts as base |
| **I** | Interface Segregation | No client forced to depend on methods it doesn't use |
| **D** | Dependency Inversion | Inject dependencies; don't hardcode implementations |

---

## 3. Readability & Reliability

- **Naming**: Use full, descriptive names (`calculateTotal` not `calcTot`). No `temp` or `data` unless scope is ≤2 lines.
- **Comments**: Explain the *why*, not the *how*. Code should be self-explanatory.
- **Formatting**: Use project-standard formatters (Prettier, Black, Pint, etc.).
- **Magic Values**: Replace hardcoded strings/numbers with named constants or enums.
- **Error Handling**: Use try-catch in critical operations; log errors appropriately.
- **Security**: Validate and sanitize all user inputs (XSS, SQL injection). Use framework protections.
- **FIRST Tests**: Tests must be Fast, Independent, Repeatable, Self-validating, Timely (written before prod code).

---

## 4. Mandatory Validation Checklist

Before finalizing any implementation:
- [ ] DRY, KISS, YAGNI, SOC, TDD followed
- [ ] SOLID: SRP, OCP, LSP, ISP, DIP respected
- [ ] Descriptive naming, no magic values, consistent formatting
- [ ] Graceful error handling, FIRST-compliant tests, inputs sanitized
