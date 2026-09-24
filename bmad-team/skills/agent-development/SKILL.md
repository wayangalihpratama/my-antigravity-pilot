---
name: agent-development
description: Architectural guidance for designing, configuring, and orchestrating specialized AI subagents. Use when defining new subagents, scoping tool permissions, setting model tiers, or structuring context boundaries.
---

# Agent & Subagent Development Guide

## Overview
Subagents are specialized, autonomous AI personas running in dedicated context windows with scoped tool permissions, tailored system prompts, and tiered models. Subagents eliminate prompt pollution, conserve tokens, and maintain domain focus.

## Subagent Architecture Matrix

When architecting a subagent persona, configure 5 core dimensions:

| Dimension | Options / Guidelines | Rationale |
|---|---|---|
| **Role & Persona** | Clear job title (e.g. `bmad-pm`, `bmad-architect`, `bmad-dev`, `bmad-tester`) | Sets domain perspective and tone. |
| **Context Scope** | Dedicated context window with specific input/output boundary | Prevents cross-turn clutter. |
| **Model Tier** | `pro` (complex reasoning/architecture), `flash` (fast research/testing), `flash_lite` (task tracking) | Cost & token optimization. |
| **Tool Permissions** | Read-only vs. Write + Terminal vs. MCP-specific | Enforces principle of least privilege. |
| **Workspace Mode** | `inherit` (shared working dir) or `branch` (isolated workspace) | Protects main codebase from unverified edits. |

## Subagent Definition Schema

```yaml
---
name: bmad-dev
role: Senior Software Engineer
model: pro
tools:
  - read_file
  - write_file
  - replace_file_content
  - run_command
workspace: branch
---
```

## System Prompt Guidelines

1. **Role & Identity**: State 1-2 sentences defining identity, experience level, and perspective.
2. **Operational Rules**:
   - Explicit workflow phases (e.g., Isolate → Failing Test → Minimal Fix → Verify).
   - Strict boundaries (e.g., "Do not modify files outside `src/` without explicit user permission").
3. **Output Expectations**: State exact deliverable formats (e.g., LLD document, test suite report, PR review diff analysis).
4. **Handoff Protocols**: Define which agent to call next upon task completion.

## Quality Checklist
- [ ] Role description reads like a distinct job title.
- [ ] Tool permissions are restricted to the minimum set needed.
- [ ] Model selection matches task complexity (`flash` for lookups, `pro` for code/architecture).
- [ ] System prompt enforces TDD and verification before claiming completion.
