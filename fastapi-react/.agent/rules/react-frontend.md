---
trigger: model_decision
description: When writing or modifying frontend code (React components, styles, services, tests)
---

## React Frontend Standards

### Technology Stack

- **React 18/19** (Functional Components only)
- **Vite** as the build tool
- **Vanilla CSS** by default (with Tailwind optional)
- **Axios** for API communication
- **Vitest** and **React Testing Library** for tests

### Code Style

- Use **ESLint** and **Prettier**.
- Run linter: `./dc.sh exec frontend npm run lint`
- Run formatter: `./dc.sh exec frontend npm run format`

### Modern React Patterns

- **Hooks**: Use custom hooks to encapsulate logic. Favor `useContext` or `Zustand` for state over Prop Drilling.
- **Functional Components**: Use arrow functions.
- **Co-location**: Keep styles, tests, and component logic together within feature folders.

### Feature-Based Organization [CRITICAL]

Structure the `src/` directory by features:
```text
src/features/
  [feature-name]/
    components/
    hooks/
    services/
    tests/
    index.js (公開用)
```

### Premium Aesthetics ("WOW" Factor)

**Typography & Spacing:**
- **No Browser Defaults**: Import Google Fonts (Inter, Outfit, etc.).
- **Grid System**: Use an 8px base grid for spacing.

**Visual Excellence:**
- **Glassmorphism**: Use `backdrop-filter: blur()`, semi-transparent backgrounds, and subtle borders.
- **Gradients**: Favor subtle, multi-stop linear or radial gradients.
- **Animations**: Use transitions (200ms-300ms) for all interactive states. Use `framer-motion` for complex entry/exit animations.

**States:**
- **Loading**: Use Skeleton loaders that mimic the final layout.
- **Empty**: Design beautiful "empty states" with illustrations or icons.
- **Error**: Use clear, user-friendly error messages with recovery actions.

### Responsive Design (Mandatory)

**Mobile-First Strategy:**
- Write base CSS for mobile viewports.
- Use media queries or Tailwind utility prefixes (`sm:`, `md:`, etc.) to scale up.
- Touch targets must be at least 44x44px.

### Performance

- **Vite HMR**: Ensure HMR is working correctly (configured to `host: true` in `vite.config.js`).
- **Code Splitting**: Use `React.lazy` and `Suspense` for route-level splitting.

### Related Rules
- Docker Commands @docker-commands.md
- Testing Strategy @testing-strategy.md
- Security Mandate @security-mandate.md
- API Design @api-design.md
