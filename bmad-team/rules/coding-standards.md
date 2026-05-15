---
trigger: always_on
description: BMAD Coding Standards — DRY, KISS, YAGNI, TDD, SOC, BDUF, and SOLID
---

# BMAD Coding Standards

The BMAD Method adheres to industry-leading coding principles to ensure maintainability, scalability, and performance. Every agent, especially **Amelia (Developer)** and **Winston (Architect)**, must strictly follow these standards.

## 1. Core Acronyms

### DRY – Don’t Repeat Yourself
- **Principle**: Every piece of knowledge must have a single, unambiguous, authoritative representation within a system.
- **Action**: Identify duplicated logic and "DRY it up" by extracting functions or modules.

### KISS – Keep It Simple Stupid
- **Principle**: Most systems work best if they are kept simple rather than made complicated.
- **Action**: Avoid over-engineering. If a solution feels like you're "using your CS degree" for a simple problem, simplify it.

### YAGNI – You Aren’t Gonna Need It
- **Principle**: Always implement things when you actually need them, never when you just foresee that you need them.
- **Action**: Do not add modules, frameworks, or dependencies for "future possibilities." Stick to the current requirements.

### TDD – Test Driven Development
- **Principle**: Write tests before functional code.
- **Action**: Follow the Red → Green → Refactor cycle for every story. Ensure near 100% test coverage.

### SOC – Separation of Concerns
- **Principle**: A design principle for separating a computer program into distinct sections such that each section addresses a separate concern.
- **Action**: "Do one thing and do it well." Divide large functions/classes into smaller, independent units.

### BDUF – Big Design Up Front
- **Principle**: Avoid spending excessive time on complex architecture before writing code.
- **Action**: Start small, build a solid foundation, and iterate. Design only what is necessary for the current phase.

---

## 2. SOLID Principles

### S – Single Responsibility Principle
- A function, class, or module should have one, and only one, reason to change.
- **Check**: If a function name has "And" in it (e.g., `loginAndFetchData`), it's likely breaking SRP.

### O – Open-Closed Principle
- Software entities should be open for extension but closed for modification.
- **Check**: Can you add new behavior (e.g., a new flavor, a new plugin) without modifying the existing source code?

### L – Liskov Substitution Principle
- Objects of a superclass should be replaceable with objects of its subclasses without breaking the application.
- **Check**: Ensure subclasses or mock implementations satisfy the same contracts as the base.

### I – Interface Segregation Principle
- No client should be forced to depend on methods it does not use.
- **Check**: Avoid bloated interfaces or required parameters that aren't necessary for the specific use case.

### D – Dependency Inversion Principle
- Depend on abstractions, not concretions.
- **Check**: Inject dependencies (e.g., dispatchers, listeners) rather than hardcoding specific implementations.

---

## 3. Readability & Clarity

### Descriptive Naming
- Use clear, full names for variables and functions. 
- **Rule**: Avoid abbreviations (use `calculateTotal` instead of `calcTot` or `qty`). Avoid generic names like `temp` or `data` unless the scope is extremely narrow (e.g., a 2-line loop).

### Meaningful Comments
- Focus on the **"why"** rather than the "how". 
- **Rule**: Code should be self-explanatory. Use comments only for complex logic, business rules, or "hacks" that aren't immediately obvious.

### Consistent Formatting
- Maintain a uniform coding style (indentation, spacing, line breaks).
- **Rule**: Use project-standard formatters (e.g., Prettier for JS, Black for Python, Pint for Laravel) for automation.

### Avoid Magic Values
- Replace hardcoded numbers or strings with named constants or enumerations.
- **Rule**: Never use naked strings or numbers in logic.

---

## 4. Reliability & Maintenance

### Error Handling
- Manage exceptions gracefully to prevent crashes and provide helpful error messages.
- **Rule**: Always use try-catch blocks in critical operations and log errors appropriately.

### FIRST Testing Principle
- **Fast**: Tests should run quickly.
- **Independent**: Tests should not depend on each other.
- **Repeatable**: Tests should yield the same result every time.
- **Self-Validating**: Tests should have a clear pass/fail result.
- **Timely**: Tests should be written just before the production code (TDD).

### Security
- **Rule**: Always validate and sanitize user inputs to protect against common vulnerabilities (XSS, SQL Injection). Use built-in framework protections.

### Refactor Regularly
- Periodically review and clean up code to improve structure without changing external behavior.

---

## 5. Mandatory Validation

Before finalizing any implementation, Amelia must verify:
- [ ] **Core**: DRY, KISS, YAGNI, SOC, and TDD followed.
- [ ] **SOLID**: SRP, OCP, LSP, ISP, DIP principles respected.
- [ ] **Readability**: Descriptive naming, no magic values, consistent formatting.
- [ ] **Reliability**: Graceful error handling and FIRST-compliant tests.
- [ ] **Security**: Inputs sanitized and validated.
