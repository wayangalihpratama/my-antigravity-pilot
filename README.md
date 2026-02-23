# 🚀 My Antigravity Pilot

Pre-configured AI agent skeletons for fullstack development — designed for [Antigravity](https://github.com/anthropics/antigravity) and compatible AI coding assistants.

## What Is This?

A collection of **agent configurations** (rules, skills, and workflows) tailored for different fullstack tech stacks. Each stack directory contains a complete `.agent/` setup that you can drop into your project to supercharge your AI-assisted development.

Think of it as a "starter kit" for your AI pair programmer — pre-loaded with best practices, coding standards, and structured workflows specific to your tech stack.

## Available Stacks

| Stack | Directory | Status |
|-------|-----------|--------|
| **FastAPI + Next.js** | [`fastapi-nextjs/`](./fastapi-nextjs/) | ✅ Ready |
| **Laravel** | [`laravel/`](./laravel/) | ✅ Ready |
| **FastAPI AI Stack** | [`fastapi-ai-stack/`](./fastapi-ai-stack/) | ✅ Ready |
| **Python + Streamlit** | [`python-streamlit/`](./python-streamlit/) | ✅ Ready |
| *More coming...* | | |

## BMAD Agent Team

The **BMAD (Business-Model-Architecture-Development) Method** provides 8 specialized AI agent roles that guide your project through a structured product development lifecycle. These are included automatically with every stack via `setup.sh`.

| Agent | Name | Role | Skill | Input | Output |
|-------|------|------|-------|-------|--------|
| 📋 PM | John | Product Manager | `bmad-pm` | Ideas | Product Brief, PRD |
| 📊 Analyst | Mary | Business Analyst | `bmad-analyst` | PRD | Research, Refined PRD |
| 🏗️ Architect | Winston | Architect | `bmad-architect` | PRD | Architecture, ADRs |
| 🎨 UX | Sally | UX Designer | `bmad-ux` | Requirements | Design Spec |
| 🏃 SM | Bob | Scrum Master | `bmad-sm` | Specs | User Stories |
| 💻 Dev | Amelia | Developer | `bmad-dev` | User Story | Code + Tests |
| 🧪 Tester | Murat | Test Architect | `bmad-tester` | Code | Test Strategy |
| 📚 Writer | Paige | Tech Writer | `bmad-writer` | Artifacts | Documentation |

**Lifecycle:** Ideate (PM) → Analyze (Analyst) → Architect → Design (UX) → Plan (SM) → Implement (Dev) → Test (Tester) → Document (Writer)

---

## Workflow Guide: When to Use What

This repository offers two ways to work: **BMAD Lifecycle** (Process-Driven) and **Stack Workflows** (Task-Driven).

### 1. When to use the BMAD Lifecycle?
Use BMAD when **building a feature from scratch** or when you need **strategic guidance**.

- **Scenario**: "I have an idea for a new dashboard."
  - **Action**: Run `/bmad-orchestrator` (starts at Ideation).
- **Scenario**: "I need to design the database schema for the user profile."
  - **Action**: Call `@Winston` (Architecture phase).
- **Scenario**: "I need user stories for the login system."
  - **Action**: Call `@Bob` (Planning phase).

**Why?** BMAD ensures you don't skip critical steps like requirements gathering, architecture design, or testing strategy. It produces artifacts in `agent_docs/` that keep the team aligned.

### 2. When to use Stack Workflows?
Use Stack Workflows when you **know exactly what to do** and just need to execute efficiently.

- **Scenario**: "Implement the LoginController based on the auth specs."
  - **Action**: Run `/2-implement` (Red-Green-Refactor cycle).
- **Scenario**: "Run the test suite and fix linting errors."
  - **Action**: Run `/4-verify`.
- **Scenario**: "Commit these changes."
  - **Action**: Run `/5-commit`. (Example: `git commit -m "[#1] feat(auth): add login spec"`)

**Why?** These are optimized for speed and adherence to coding standards. They don't ask "why" – they just do "how".

### 3. How they work together
BMAD Agents **delegate** to Stack Workflows.

- **Amelia (Dev Agent)** picks a User Story → understands *WHAT* to build → triggers `/2-implement` to build it *HOW* the stack requires.
- **Murat (Test Agent)** designs the strategy → triggers `/4-verify` to execute it.

> **Rule of Thumb**: Use **BMAD** to figure out *what* to build. Use **Stack Workflows** to *build* it.

## Development Approach: TDD First

This repository enforces **Test-Driven Development (TDD)** as the standard way of working.

### The Core Cycle (Red-Green-Refactor)
1.  🔴 **Red**: Write a failing test for the functionality you want.
2.  🟢 **Green**: Write the *minimal* code required to pass the test.
3.  🔵 **Refactor**: Improve code quality without changing behavior (clean up).

### How to use TDD with BMAD

We have built-in tooling to make this easier:

| Component | Role | Description |
|-----------|------|-------------|
| **`/2-implement`** | Workflow | Automates the TDD cycle. Hardcodes the steps so you don't forget them. |
| **`bmad-dev`** | Agent | Amelia is prompted to *refuse* code requests without a test plan. |
| **`testing-strategy.md`** | Rule | Defines valid test patterns (Pytest classes, Jest specs). |

### Example Workflow
1.  **Ask Amelia**: "I want to add a `calculate_total` function to the Cart model."
2.  **She Responds**: "I'll create a test case for `calculate_total` first."
3.  **She Executes**: Creates `tests/unit/test_cart.py` with a failing assertion.
4.  **She Implements**: Writes the logic in `app/models/cart.py`.
5.  **She Verifies**: Runs the test to confirm it passes.
6.  **She Commits**: `[#727] feat(cart): implement calculate_total logic`

### Benefits
- **AI Safety**: Agents can hallucinate. Tests catch bugs immediately.
- **Documentation**: Tests show exactly how your code is *supposed* to be used.
- **Confidence**: Refactor fearlessly knowing your suite has your back.

> **Pro Tip**: Always ask for the test *before* the implementation. "Create a test for X feature" is a better prompt than "Create X feature".


## Quick Start

### Using `setup.sh` (Recommended)

The setup script copies your chosen stack's `.agent/` directory **plus** the BMAD agent team into a new project:

```bash
# Interactive mode — pick a stack from a menu
./setup.sh

# Non-interactive mode — specify stack and target
./setup.sh laravel ./my-new-app
./setup.sh fastapi-nextjs /path/to/project
```

The result is a project with **stack rules + BMAD skills + BMAD workflows** — everything merged into a single `.agent/` directory.

### Manual Setup

```bash
# 1. Copy the stack's .agent directory
cp -r fastapi-nextjs/.agent /path/to/your/project/

# 2. Merge the BMAD team assets
cp -r bmad-team/rules/* /path/to/your/project/.agent/rules/
cp -r bmad-team/skills/* /path/to/your/project/.agent/skills/
cp -r bmad-team/workflows/* /path/to/your/project/.agent/workflows/
```

### Customize

Edit the rules and skills to match your project's specific needs:
- Update service URLs in `docker-commands.md`
- Adjust auth patterns in stack-specific backend rules
- Modify test commands for your test runner

## Repository Structure

```
my-antigravity-pilot/
├── .agent/                    # Root repo meta-rules
├── bmad-team/                 # Portable BMAD agent team
│   ├── rules/                 # Team structure rule
│   ├── skills/                # 8 agent skills (bmad-*)
│   └── workflows/             # BMAD lifecycle orchestrator
├── fastapi-nextjs/.agent/     # FastAPI + Next.js stack
├── laravel/.agent/            # Laravel stack
└── setup.sh                   # Stack selector + merger
```

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

### Laravel

**9 Rules** — Two-tier trigger system (`always_on` / `model_decision`):
- `rule-priority.md` — Conflict resolution hierarchy
- `security-mandate.md` — Always-on security (Laravel + Inertia + Filament)
- `docker-commands.md` — Always-on Docker Compose execution rules
- `error-handling.md` — Laravel exception handling + Inertia error patterns
- `api-design.md` — RESTful routes, resource controllers, response formats
- `testing-strategy.md` — Pest PHP, TDD cycle, test pyramid
- `git-workflow.md` — Conventional commits, branch naming
- `laravel-backend.md` — PSR-2/PSR-4, service pattern, Eloquent, Form Requests
- `inertia-react-frontend.md` — Inertia.js + React 19 + Tailwind CSS 4 + responsive

**5 Skills:**
- `debugging-protocol` — Systematic debugging with Laravel Artisan introspection
- `guardrails` — Pre-flight & post-implementation checklists for Laravel stack
- `laravel-crud` — Full vertical feature generation (Migration → Model → Service → Controller → React → Tests)
- `filament-admin` — Filament 3 admin panel: resources, widgets, access control
- `inertia-react-patterns` — Inertia.js forms, navigation, Tailwind responsive patterns

**6 Workflows:**
- `1-research` → `2-implement` → `3-integrate` → `4-verify` → `5-commit`
- `orchestrator` — Coordinates the full development cycle (Laravel docs-aligned)

## Sources & Credits

These configurations are adapted from:

| Source | What's Used |
|--------|------------|
| [awesome-agv](https://github.com/wayangalihpratama/awesome-agv) | Rule architecture, security, error handling, debugging, guardrails, code review |
| [BMAD Method](https://github.com/bmadcode/BMAD-METHOD) | Agent team roles and lifecycle methodology |
| [Microsoft Skills](https://github.com/microsoft/skills) | FastAPI router & Pydantic model patterns |
| [Vercel Skills](https://github.com/vercel-labs/next-skills) | Next.js 15 & React best practices |
| [obra/superpowers](https://github.com/obra/superpowers) | Systematic debugging methodology |
| [laravelapp-skeleton](https://github.com/wayangalihpratama/laravelapp-skeleton) | Laravel architecture, Docker setup, Filament, Inertia patterns |

## Contributing

Want to add a new stack? Use the `add-stack` skill or create a directory with the stack name and add a `.agent/` directory following the structure above. The `setup.sh` script will automatically discover new stacks. PRs welcome!

## License

[MIT](./LICENSE) — Use freely, attribution appreciated.
