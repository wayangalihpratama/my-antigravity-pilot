---
name: skill-development
description: Guidance for creating, structuring, and optimizing agent skills. Use when authoring new SKILL.md files, defining trigger conditions, progressive disclosure, or organizing reusable workflows.
---

# Skill Development Guide

Skills are modular, self-contained instruction packages that extend AI agent capabilities with specialized procedural knowledge, checklists, and domain best practices.

## Anatomy of a Skill

Every skill resides in its own directory with a required `SKILL.md` file:

```plaintext
skill-name/
├── SKILL.md              # Required: Main instructions and frontmatter
├── scripts/              # Optional: Helper utilities and automated scripts
├── references/           # Optional: Deep reference documentation
└── examples/             # Optional: Concrete code and implementation examples
```

## Frontmatter Standard

The YAML frontmatter defines how and when the AI discovers and activates the skill:

```yaml
---
name: skill-name
description: A concise, highly specific 1-2 sentence description explaining WHAT the skill does and EXACTLY WHEN to use it. Include relevant trigger keywords and scenarios.
---
```

## Core Authoring Principles

### 1. Progressive Disclosure & Token Efficiency
- Keep the main `SKILL.md` focused on essential workflows, checklists, and common rules.
- Place extensive reference tables, schemas, or large examples in separate `references/` or `examples/` files and link to them using markdown links.
- Avoid repeating general programming advice; focus strictly on domain-specific idioms and constraints.

### 2. Actionable & Procedural Structure
Organize skills around sequential phases or clear operational steps:
1. **Context & Prerequisites**: What information or files must be verified first.
2. **Step-by-Step Procedure**: Clear, imperative guidance with copy-pasteable patterns.
3. **Quality Gates & Checklists**: Specific criteria that must be verified before completing the task.
4. **Common Pitfalls & Anti-Patterns**: What NOT to do.

### 3. Clear Code Patterns
Provide minimal, idiomatic code snippets that demonstrate:
- Recommended imports and module structures.
- Error handling and edge-case management.
- Integration with project wrappers (e.g. `./dc.sh` or project CLI).

## Quality Checklist for New Skills

- [ ] Directory name is kebab-case (`my-new-skill/`).
- [ ] `SKILL.md` has valid YAML frontmatter with `name` and `description`.
- [ ] Description clearly states triggering conditions without generic filler.
- [ ] All code examples are tested, syntactic, and follow project standards.
- [ ] References to other rules or skills use standard relative paths.
