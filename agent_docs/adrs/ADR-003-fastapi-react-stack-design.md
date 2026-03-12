# ADR-003: FastAPI-React Stack Technical Design

- **Status**: Accepted
- **Context**: The repository needs a new stack for FastAPI and React. This stack must be modern, fast, and optimized for AI-assisted development (multi-stack skeleton).
- **Decision**: 
    1. **Build Tool**: Use [Vite](https://vitejs.dev/) instead of Create React App or Webpack. Vite's native ESM support and fast HMR are critical for a "WOW" developer experience.
    2. **Language**: Standard JavaScript/JSX by default, keeping it simple as a "skeleton", but structured to easily support TypeScript migration.
    3. **Testing**: Use [Vitest](https://vitest.dev/) + [React Testing Library](https://testing-library.com/). Vitest shares the same config as Vite and is significantly faster than Jest.
    4. **Directory Structure**: Adopt a **Feature-based** organization within `frontend/src/features/`. Each feature folder will contain components, hooks, services, and tests.
- **Alternatives Considered**: 
    - **Next.js**: Already exists in the repo as `fastapi-nextjs`. This new stack is specifically for users who want a pure SPA (Single Page Application) experience without the Next.js routing/SSR complexity.
    - **Jest**: Rejected in favor of Vitest for better speed and alignment with Vite.
- **Consequences**: 
    - Developers need to be familiar with Vite-specific config (`vite.config.js`).
    - The `/2-implement` workflow must be adapted to use `vitest` commands.
    - Consistency across the repo is maintained through Docker-based command wrappers.
