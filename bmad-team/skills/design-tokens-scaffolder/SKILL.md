---
name: design-tokens-scaffolder
description: Bridge between design tools (Figma) and code. Use when extracting, scaffolding, or maintaining design tokens, CSS custom properties, and Tailwind theme configurations.
---

# Design Tokens Scaffolder

## Overview
Design tokens encapsulate the visual atoms of a design system (colors, spacing, typography, radii, elevations) into platform-agnostic variables that bridge design files and production code.

---

## 🎨 Token Architecture

### 1. CSS Custom Properties (`:root`)
Define semantic color and typography scales in CSS variables:
```css
:root {
  /* Primitive Tokens */
  --color-brand-primary-base: #2563eb;
  --color-brand-primary-hover: #1d4ed8;
  --color-neutral-surface: #ffffff;
  --color-neutral-text: #0f172a;

  /* Semantic Tokens */
  --radius-button: 0.75rem;
  --spacing-section-y: clamp(3rem, 6vw, 6rem);
  --font-family-display: 'Inter', -apple-system, sans-serif;
}
```

### 2. Tailwind Theme Integration
Map tokens cleanly into `tailwind.config.js`:
```javascript
module.exports = {
  theme: {
    extend: {
      colors: {
        brand: {
          DEFAULT: 'var(--color-brand-primary-base)',
          hover: 'var(--color-brand-primary-hover)'
        }
      },
      borderRadius: {
        button: 'var(--radius-button)'
      }
    }
  }
};
```

### 3. Figma Dev Mode MCP Translation
When extracting tokens via Figma MCP:
- Map Figma Color Styles directly to named semantic tokens rather than arbitrary hex strings.
- Convert Figma Auto Layout padding/gap values directly to standard spacing increments (`4px`, `8px`, `12px`, `16px`, `24px`, `32px`).
- Export typography as unified styles including `font-size`, `line-height`, `letter-spacing`, and `font-weight`.
