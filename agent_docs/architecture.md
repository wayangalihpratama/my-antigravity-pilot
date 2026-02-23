# Architecture: My Antigravity Pilot (Skeleton)

## 1. System Overview
The repository acts as a source for AI agent configurations. It is structured as a collection of self-contained stacks that share a common methodology (BMAD).

## 2. Component Design
- **Root Layer (`.agent/`)**: Contains global policies (Repo structure, BMAD team merger).
- **Stack Layer (`<stack>/`)**: Contains specialized configurations for specific frameworks (FastAPI, Laravel, etc.).
- **Integration Layer (`setup.sh`)**: Merges Root and Stack layers into a destination project.

## 3. Communication Patterns
- **User to Agent**: Via slash commands (`/bmad-orchestrator`, `/2-implement`).
- **Agent to Code**: Via rules (security, API design) and workflows.

## 4. Documentation Architecture
- **Living Documents**: Project skeletons in `agent_docs/`.
- **Feature Documents**: Task-specific requirements.
- **Traceability**: Enforced via standardized commit messages linking to issues.

## 5. Security Model
- **Deny by Default**: Standardized security rules applied to all stacks.
- **Docker-First**: Isolation of development environments.
