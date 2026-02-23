# PRD: My Antigravity Pilot (Skeleton)

## 1. Vision & Goals
Standardize AI-assisted development by providing high-quality, pre-configured tech stack skeletons that leverage the BMAD methodology.

## 2. Target Personas
- **The Solo Developer**: Wants to build fast without worrying about boilerplate or config.
- **The AI Agent (e.g., Antigravity)**: Needs clear rules and structure to perform reliably.

## 3. Core Standards (Must-Have)
- **Containerization**: Every stack must use Docker/Docker Compose.
- **Code Quality**: Linting (flake8, black, prettier, etc.) must be pre-configured.
- **Testing**: Every stack must have a primary test runner and a `/2-implement` TDD workflow.
- **BMAD Integration**: Every stack must include the 8-agent team roles in its `.agent` directory.
- **Traceability**: All changes must be traceable via standardized commit messages.

## 4. Stack Architecture
Each stack must maintain:
- `.agent/rules/`: Enforced principles (Security, API design).
- `.agent/skills/`: On-demand task guides.
- `.agent/workflows/`: Sequential development phases.

## 5. Success Metrics
- Reduction in "setup time" for AI agents on new projects.
- Consistency of output across different developers and AI assistants.

## 6. Out of Scope
- Building the actual application logic (this repo provides only the skeleton).
- Cloud hosting/infra-specific code (kept as generic Docker configurations).
