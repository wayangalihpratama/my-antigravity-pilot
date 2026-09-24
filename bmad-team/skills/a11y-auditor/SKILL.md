---
name: a11y-auditor
description: Web accessibility audit and WCAG compliance checker. Use when testing HTML/CSS components for keyboard navigation, ARIA semantics, color contrast, focus traps, or screen reader compatibility.
---

# Accessibility (a11y) Auditor & WCAG Compliance

## Overview
Standards and verification checklists for building fully accessible web interfaces complying with **WCAG 2.1 Level AA**.

---

## ♿ Core Verification Areas

### 1. Keyboard Navigation & Focus Management
- [ ] **Tab Order**: All interactive elements (`<a>`, `<button>`, `<input>`, `<select>`) must be focusable in a logical tab sequence.
- [ ] **Visible Focus Rings**: Never remove `outline: none` without providing a distinct custom focus style (e.g. `focus-visible:ring-2 focus-visible:ring-brand-500`).
- [ ] **Modal Focus Traps**: Dialogs/modals must trap keyboard focus inside while open and return focus to the trigger button upon closing.
- [ ] **Escape Key**: Pressing `Escape` must close open modals, drawers, and dropdown menus.

### 2. Semantic Structure & ARIA Roles
- [ ] **Semantic HTML5 First**: Prefer `<button>` over `<div @click="...">` and `<a>` over `<span onclick="...">`.
- [ ] **Landmarks**: Ensure `<header>`, `<nav>`, `<main>`, and `<footer>` are properly nested.
- [ ] **ARIA Labels**: For icon-only buttons, provide `aria-label="Close dialog"` or visually hidden text (`sr-only`).
- [ ] **Form Labels**: Every input must have an explicitly linked `<label for="inputId">` or `aria-labelledby`.

### 3. Color Contrast & Visual Design
- [ ] **Text Contrast**: Minimum contrast ratio of **4.5:1** for normal text and **3:1** for large text (>= 18pt or 14pt bold).
- [ ] **Non-Text Contrast**: Minimum contrast ratio of **3:1** for UI components and form input borders.
- [ ] **No Color-Only Information**: Never communicate state (error, success, active) through color alone—always pair with an icon or text label.

### 4. Touch & Viewport Accessibility
- [ ] **Touch Target Size**: Interactive targets must measure at least **44x44px** (or `48x48px` on mobile devices).
- [ ] **No Scalability Locking**: Never use `user-scalable=no` or `maximum-scale=1.0` unless explicitly required for full-screen fixed canvas games.
