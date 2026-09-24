---
name: plugin-structure
description: Standards for organizing plugins, skills, subagents, and tools. Use when structuring new plugin bundles, configuring manifests, or setting up modular agent extensions.
---

# Plugin & Agent Package Structure

## Overview
Standards for architecting modular agent plugins, ensuring automatic discovery, clean separation of concerns, and seamless distribution across projects.

---

## 📁 Standard Plugin Layout

```plaintext
my-agent-plugin/
├── .claude-plugin/           # Plugin metadata & manifest
│   └── plugin.json
├── commands/                 # Slash commands (.md)
├── agents/                   # Subagent persona definitions (.md)
├── skills/                   # Modular skills (subdirectories with SKILL.md)
│   ├── skill-a/
│   │   └── SKILL.md
│   └── skill-b/
│       └── SKILL.md
├── hooks/                    # Event-driven hooks & validation scripts
│   └── hooks.json
└── README.md                 # Plugin documentation and usage instructions
```

## Configuration Manifest (`plugin.json`)
```json
{
  "name": "bmad-core-toolkit",
  "version": "1.0.0",
  "description": "Essential agile development personas, skills, and quality gates for AI coding.",
  "author": "BMAD Team",
  "license": "MIT"
}
```

## Discovery & Portability Rules
- Use relative paths within plugins and skills so they remain portable across different host directories.
- Avoid hardcoded environment assumptions; declare dependencies explicitly in the README.
