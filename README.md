# 🚀 My Antigravity Pilot

Pre-configured AI agent skeletons for fullstack development — designed for [Antigravity](https://github.com/anthropics/antigravity) and compatible AI coding assistants.

## What Is This?

A collection of **agent configurations** (rules, skills, and workflows) tailored for different fullstack tech stacks. Each stack directory contains a complete `.agent/` setup that you can drop into your project to supercharge your AI-assisted development.

Think of it as a "starter kit" for your AI pair programmer — pre-loaded with best practices, coding standards, and structured workflows specific to your tech stack.

## Available Stacks

| Stack | Directory | Status |
|-------|-----------|--------|
| **FastAPI + Next.js** | [`fastapi-nextjs/`](./fastapi-nextjs/) | ✅ Ready |
| **Laravel** | `laravel/` | 🔜 Planned |
| *More coming...* | | |

## Stack Contents

Each stack directory follows this structure:

```
<stack-name>/
└── .agent/
    ├── rules/        # Coding standards and constraints
    │   ├── always_on  → enforced constantly (e.g., security, docker)
    │   └── model_decision → activated when relevant (e.g., API design, testing)
    ├── skills/       # On-demand guides for specific tasks
    │   └── <skill-name>/SKILL.md
    └── workflows/    # Step-by-step development phases
        └── <phase>.md
```

### FastAPI + Next.js

**9 Rules** — Two-tier trigger system (`always_on` / `model_decision`):
- `rule-priority.md` — Conflict resolution hierarchy
- `security-mandate.md` — Always-on security principles
- `docker-commands.md` — Always-on Docker execution rules
- `error-handling.md` — Error handling patterns
- `api-design.md` — RESTful API standards
- `testing-strategy.md` — Test pyramid, TDD, AAA pattern
- `git-workflow.md` — Conventional commits, branch naming
- `fastapi-backend.md` — Python/FastAPI/Pydantic standards
- `nextjs-frontend.md` — Next.js 15/React 19/Tailwind CSS + responsive design

**5 Skills:**
- `debugging-protocol` — Hypothesis-driven systematic debugging
- `guardrails` — Pre-flight checklist & post-implementation self-review
- `code-review` — Structured review with severity tags
- `fastapi-crud` — Step-by-step CRUD endpoint creation
- `nextjs-patterns` — Next.js 15 best practices & Tailwind patterns

**6 Workflows:**
- `1-research` → `2-implement` → `3-integrate` → `4-verify` → `5-commit`
- `orchestrator` — Coordinates the full development cycle

## How to Use

### 1. Copy to Your Project

```bash
# Copy the entire .agent directory for your stack
cp -r fastapi-nextjs/.agent /path/to/your/project/
```

### 2. Customize

Edit the rules and skills to match your project's specific needs:
- Update service URLs in `docker-commands.md`
- Adjust auth patterns in `fastapi-backend.md`
- Modify test commands for your test runner

### 3. Develop with AI

Your AI assistant will automatically pick up the `.agent/` configuration and follow the rules, invoke skills when relevant, and use workflows to structure development.

## Sources & Credits

These configurations are adapted from:

| Source | What's Used |
|--------|------------|
| [awesome-agv](https://github.com/wayangalihpratama/awesome-agv) | Rule architecture, security, error handling, debugging, guardrails, code review |
| [Microsoft Skills](https://github.com/microsoft/skills) | FastAPI router & Pydantic model patterns |
| [Vercel Skills](https://github.com/vercel-labs/next-skills) | Next.js 15 & React best practices |
| [obra/superpowers](https://github.com/obra/superpowers) | Systematic debugging methodology |

## Contributing

Want to add a new stack? Create a directory with the stack name and add a `.agent/` directory following the structure above. PRs welcome!

## License

[MIT](./LICENSE) — Use freely, attribution appreciated.
