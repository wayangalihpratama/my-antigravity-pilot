# Research Findings: Strapi v5 & Guidance Project Analysis

This document summarizes the high-level overview of Strapi v5 and the architectural patterns used in the `climate-think-and-do-tank` guidance project.

## Strapi v5 High-Level Overview

Strapi v5 is a modern Headless CMS built for scalability and developer experience. Key features include:

- **TypeScript-First**: The core and plugins are now fully written in TypeScript, providing better type safety and DX.
- **Improved Content Workflow**:
  - **Draft & Publish**: A reworked system that allows better management of content states.
  - **Content History**: Built-in versioning and rollback capabilities.
- **Document Service API**: A new API layer that replaces the Entity Service, using `documentId` for more consistent content referencing across environments.
- **Simplified API Responses**: The JSON format is now flattened (no more `.data.attributes`), making it easier to consume on the frontend.
- **Vite Bundler**: The Admin UI uses Vite for significantly faster build and reload times.

## Most Used Cases in `climate-think-and-do-tank`

The guidance project demonstrates several production-ready patterns:

### 1. Modular Page Builder (Single Types + Components)
- **Pattern**: Uses "Single Types" (e.g., `homepage`, `about`) for unique pages.
- **Implementation**: These pages use **Components** (like `slider`, `seo`, `rich-text`) to create flexible, modular layouts. This allows editors to move blocks around without developer intervention.

### 2. Structured Content Hubs (Collection Types)
- **Pattern**: Uses "Collection Types" for repeating content (e.g., `news-item`, `event`, `partner`).
- **Implementation**: Relations are used extensively (e.g., `news-item` links to `topic`) to create a connected content graph.

### 3. Custom API Logic (Controllers & Routes)
- **Pattern**: Custom functional endpoints beyond standard CRUD.
- **Example**: `api/email-check` provides a specific endpoint to validate if an email is already registered, bypassing the standard public user list for security.

### 4. Advanced User Management
- **Pattern**: Extending the `users-permissions` plugin.
- **Implementation**: Adding custom fields like `organisation`, `stakeholder_role`, and `profile_image` to the core `user` model via `allowedFields` configuration.

### 5. Schema Portability (`config-sync`)
- **Pattern**: Version-controlling the CMS schema and permissions.
- **Implementation**: The `strapi-plugin-config-sync` plugin exports database configurations (Content Types, User Roles, Permissions) to JSON files in `backend/config/sync`, ensuring all environments (dev, staging, prod) stay in sync.

## Frontend Integration Pattern (Next.js)

- **Data Fetching**: The project uses Next.js **Pages Router** with `getStaticProps` or `getServerSideProps`.
- **API Consumption**: Fetches data from the Strapi `/api` endpoints using the standard `fetch` API, often wrapped in helper functions to handle authentication and base URLs.
- **Environment Management**: Uses `docker-entrypoint.sh` to inject runtime environment variables into the Next.js frontend, allowing for "build once, run anywhere" Docker images.
