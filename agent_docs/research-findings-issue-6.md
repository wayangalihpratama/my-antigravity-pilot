# Research Findings: FastAPI-React Stack Configuration

**Author**: Mary (Business Analyst)
**Date**: 2026-03-12

## 1. Executive Summary
The `fastapi-react` stack will utilize **Vite** as the build tool for the frontend, providing superior performace and developer experience compared to legacy tools. The project structure will follow a feature-based organization to ensure scalability within the multi-stack repository.

## 2. Technical Stack Recommendation

### Frontend: React + Vite
- **Build Tool**: [Vite](https://vitejs.dev/) - Modern, fast, and ES module native.
- **Language**: JavaScript/React (per user request for a "standard" stack, but extensible to TS).
- **Styling**: Vanilla CSS (default) with optional Tailwind support.
- **Component Library**: None by default (Skeleton approach).

### Testing: Vitest + React Testing Library (RTL)
- **Test Runner**: [Vitest](https://vitest.dev/) - Native Vite integration, Jest-compatible.
- **Library**: [React Testing Library](https://testing-library.com/docs/react-testing-library/intro/) - User-centric testing approach.
- **Advantage**: Faster execution and better alignment with the Vite build pipeline.

### Containerization: Docker Multi-Stage
- **Development**: Node.js alpine image with HMR support (`vite --host`).
- **Production**: 
    - Stage 1: Build static assets using Node.js.
    - Stage 2: Serve static assets using Nginx alpine for minimal footprint.

## 3. Recommended Directory Structure
Aligning with existing repo patterns and feature-based architecture:

```text
fastapi-react/
├── .agent/             # BMAD configuration
├── backend/            # FastAPI source
└── frontend/
    ├── src/
    │   ├── assets/     # Global assets
    │   ├── components/ # Shared UI components
    │   ├── features/   # Feature-grouped components/logic [CRITICAL for scalability]
    │   ├── hooks/      # Custom reusable hooks
    │   ├── layouts/    # Page layouts
    │   ├── pages/      # Route level components
    │   ├── services/   # API logic
    │   └── App.jsx
    ├── tests/          # Global/Integration tests
    ├── Dockerfile
    ├── vite.config.js
    └── package.json
```

## 4. Key Rule & Skill Considerations
- **Rules**: Must enforce component co-location (styles/tests near components).
- **Skills**: Should include a `react-crud` skill that uses modern hooks and feature-based structure.
- **Workflows**: Must adapt the `/2-implement` workflow to use `vitest` instead of `jest` or `playwright`.

## 5. Next Steps
- [ ] Winston (Architect) to define the specific API contracts and Docker Compose configuration.
- [ ] Sally (UX) to define basic component patterns.
