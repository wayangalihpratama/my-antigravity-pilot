# UX Design Specification: FastAPI-React Configuration

**Author**: Sally (UX Designer)
**Date**: 2026-03-12

## 1. Vision & Emotional Goal
The `fastapi-react` stack should feel **modern, fluid, and premium**. Users (and AI agents) building with this stack should be greeted with code patterns that prioritize visual excellence and smooth interactions from the start.

## 2. Design Principles for `react-frontend.md`

### Aesthetics First
- **Typography**: Default to Google Fonts (e.g., Inter, Outfit) via CSS imports. No browser defaults.
- **Grids & Spacing**: Enforce a strict 4px/8px grid system.
- **Glassmorphism**: Rules should encourage subtle backdrop-filters and semi-transparent borders for a modern feel.
- **Color Palettes**: Curated HSL-based palettes (e.g., sleek dark modes with electric blue accents). Avoid hex-only hardcoding.

### Interaction & Motion
- **Micro-animations**: Components must include hover/active states with 200ms-300ms transitions.
- **Loading States**: Rules must require skeleton screens or animated custom loaders.
- **Feedback**: Immediate visual feedback for all interactive elements (buttons, inputs).

### Accessibility & Responsiveness
- **Mobile First**: All CSS rules generated or guided by the agent must prioritize mobile viewports.
- **Semantic HTML**: Mandatory use of `<nav>`, `<main>`, `<header>`, etc., for accessibility.

## 3. Recommended Design System Patterns
Since this is a skeleton, we don't enforce a library, but the rules will favor patterns from:
- **Tailwind CSS** (if opted-in): Using semantic color names (e.g., `primary`, `surface-100`).
- **Vanilla CSS**: Global CSS variables for tokens (`--color-primary`, `--spacing-md`).

## 4. Interaction Protocol for Agents
When an agent is building a React component:
1. **Research** the "wow" factor for that specific component (e.g., a "premium login form").
2. **Apply** micro-transitions and subtle shadows.
3. **Verify** responsiveness on mobile first.
