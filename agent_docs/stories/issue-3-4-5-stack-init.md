# User Stories: Strapi-NextJS Stack Initialization

## [ISS-003] FEAT: Scaffold Strapi-NextJS Directory Structure
**User Story**: As a developer, I want a standardized directory structure and Docker configuration for the new stack.
**Acceptance Criteria (UAC)**:
- [ ] `strapi-nextjs/` folder created.
- [ ] `backend/` and `frontend/` subdirectories exist.
- [ ] `.agent/` configuration copied from FastAPI stack and adapted.
- [ ] `dc.sh` and `compose.yml` configured for both services.

## [ISS-004] FEAT: Initialize Strapi v5 Backend
**User Story**: As a content manager, I want a working Strapi v5 instance with basic security and config-sync.
**Acceptance Criteria (UAC)**:
- [ ] Strapi v5.6.0 installed via Docker.
- [ ] `strapi-plugin-config-sync` configured.
- [ ] Sample "Homepage" single type created.

## [ISS-005] FEAT: Initialize Next.js 15 Frontend
**User Story**: As a user, I want a high-performance frontend that consumes Strapi content.
**Acceptance Criteria (UAC)**:
- [ ] Next.js 15 (App Router) initialized.
- [ ] Tailwind CSS configured with the UX spec's theme.
- [ ] Basic data fetching from Strapi implemented.
