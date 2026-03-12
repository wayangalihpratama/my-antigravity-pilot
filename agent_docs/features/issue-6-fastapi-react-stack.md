# Feature: issue-6-fastapi-react-stack

## Overview
This feature involves creating a new tech stack skeleton for `fastapi-react`. Following the "Clean Slate" architecture principles (v4/v5) and BMAD methodology, this stack will provide a pre-configured environment for developing applications with a FastAPI backend and a React (Vanilla/Vite) frontend. The focus is on the `.agent/` directory, providing rules, skills, and workflows to enable seamless AI-assisted development.

## User Stories Mapping
- [ISS-006-001: Backend Core Config](file:///Users/galihpratama/Dev/my-antigravity-pilot/agent_docs/stories/ISS-006-001-backend-core.md)
- [ISS-006-002: Frontend React Config](file:///Users/galihpratama/Dev/my-antigravity-pilot/agent_docs/stories/ISS-006-002-frontend-react.md)
- [ISS-006-003: BMAD Workflow Adaptation](file:///Users/galihpratama/Dev/my-antigravity-pilot/agent_docs/stories/ISS-006-003-workflow-adaptation.md)

## Requirements
- **Functional**:
    - Provide `.agent/rules/` for both backend and frontend.
    - Provide `.agent/skills/` for common tasks (CRUD, debugging, patterns).
    - Provide `.agent/workflows/` for the standard BMAD implementation lifecycle.
    - **Frontend Stack**: React 18+ with Vite as the build tool.
    - **Test Stack**: Vitest + React Testing Library for frontend; Pytest for backend.
    - **Architecture**: Feature-based directory structure in `frontend/src/features/`.
- **Non-Functional**:
    - **Performance**: Use HMR for local development in Docker.
    - **Containerization**: Multi-stage Docker builds (Build -> Nginx).

## Constraints
- Must use Vite for React (modern standards).
- Must follow component co-location (styles and tests near components).
- Must use standard BMAD roles in `.agent/sm`, `.agent/dev`, etc.
