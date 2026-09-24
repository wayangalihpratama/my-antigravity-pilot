---
name: command-development
description: Guide for creating, structuring, and testing slash commands and task workflows. Use when defining custom slash commands, setting up dynamic arguments, or structuring interactive prompts.
---

# Slash Command & Workflow Development

## Overview
Slash commands and workflow files (`.agent/workflows/*.md`) are pre-configured, reusable instructions that standardize multi-step development processes for developers and AI agents.

---

## 🛠️ Anatomy of a Command

```markdown
---
description: Run the automated implementation phase of a user story following TDD.
---

# 2. Implementation Workflow

## Objective
Implement the feature specified in the active user story using strict Test-Driven Development (TDD).

## Steps
1. **Verify Story**: Read `agent_docs/stories/active_story.md`.
2. **Red Phase**: Write failing unit/integration tests covering the acceptance criteria.
3. **Green Phase**: Write minimal implementation code to satisfy the tests.
4. **Refactor**: Clean up and optimize while keeping all tests passing.
5. **Quality Check**: Run `./dc.sh exec web npm test` (or stack test runner).
```

## Best Practices
- **Imperative & Actionable**: Write instructions using direct, unambiguous commands.
- **Fail Fast**: Include pre-flight checks in Step 1 that halt execution if prerequisite files or dependencies are missing.
- **Tool Grounding**: Reference project wrapper scripts (e.g. `./dc.sh`) rather than bare host tools.
