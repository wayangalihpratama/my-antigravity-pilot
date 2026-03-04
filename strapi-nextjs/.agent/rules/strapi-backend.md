## Strapi Backend

### Core Philosophy
- **TypeScript-First**: All custom code (controllers, services, middlewares) should be written in TypeScript.
- **Document Service**: Use the Strapi v5 Document Service API (`strapi.documents`) instead of the legacy Entity Service.
- **Headless-First**: Design APIs to be consumed by multiple frontends.

### Content Modeling
- **Single Types**: Use for unique pages (e.g., Homepage, Global Settings).
- **Collection Types**: Use for repeatable content (e.g., News, Projects, Users).
- **Components**: Group fields into reusable parts (e.g., `shared.slider`, `shared.seo`).
- **Dynamic Zones**: Use to create flexible page builders.

### Coding Standards
- **Controllers**: Keep logic thin; delegate complexity to services.
- **Services**: Contain the core business logic and database queries.
- **Validation**: Use Pydantic-like validation or standard Strapi validation hooks.
- **Testing**: Use **TDD**. Write Vitest/Jest tests for custom logic.

### Environment & Config
- Use `strapi-plugin-config-sync` to version control schemas.
- All secrets MUST be in `.env`.
