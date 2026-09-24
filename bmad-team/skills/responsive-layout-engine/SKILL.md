---
name: responsive-layout-engine
description: Advanced CSS layout, container queries, modern flexbox/grid, fluid typography, and view transitions. Use when building complex responsive layouts, handling multiple viewports, or creating smooth state transitions.
---

# Responsive Layout & Modern CSS Engine

## Overview
Standards and modern CSS techniques for creating resilient, fluid layouts across mobile, tablet, desktop, and ultra-wide screens without fragile pixel breakpoints.

---

## 📐 Layout Principles

### 1. Modern Grid & Subgrid
- Use CSS Grid for overall page macro-layouts and 2D alignments:
  ```css
  .auto-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(min(100%, 280px), 1fr));
    gap: 1.5rem;
  }
  ```
- Use `subgrid` to align nested child elements (e.g. card titles, action buttons) across different cards in the same row.

### 2. Container Queries (`@container`)
- Style components based on the size of their parent container rather than the global browser viewport:
  ```css
  .card-container {
    container-type: inline-size;
  }

  @container (min-width: 400px) {
    .card {
      display: flex;
      flex-direction: row;
    }
  }
  ```

### 3. Fluid Typography & Spacing (`clamp()`)
- Replace rigid breakpoint font sizes with smooth fluid clamping:
  ```css
  h1 {
    font-size: clamp(2rem, 5vw + 1rem, 4.5rem);
    line-height: 1.15;
  }
  ```

### 4. Reduced Motion & View Transitions
- Always respect user accessibility preferences:
  ```css
  @media (prefers-reduced-motion: reduce) {
    *, ::before, ::after {
      animation-duration: 0.01ms !important;
      transition-duration: 0.01ms !important;
    }
  }
  ```
- Use the **View Transitions API** for seamless page and component state morphing.
