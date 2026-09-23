# Issue: Add "Business Landing" Tech Stack (HTML5 + Tailwind CDN + Alpine.js)

## 📌 Summary
Add a zero-build, conversion-focused **Business & Brand Landing Page Stack** (`business-landing/`) to `my-antigravity-pilot`. This stack is designed for lightning-fast delivery of landing pages for local businesses and personal brands with instant deployment to **GitHub Pages (`github.io`)**, **Vercel**, or **Netlify** at zero hosting cost.

---

## 🎯 Objectives & Motivation
- **Zero Build Complexity**: No Node modules, PostCSS, Webpack, or Vite required for production runtime.
- **Conversion-Optimized**: Pre-configured with direct WhatsApp Click-to-Chat integration, Google Maps responsive embed, Alpine.js reactive components (quote modals, mobile nav menu, FAQ accordion), and Lucide icons.
- **1-Click / 1-Push Deployment**: Ready-to-go GitHub Pages Action (`.github/workflows/deploy.yml`) and `vercel.json`.
- **BMAD v6 Integration**: Full `.agent/` architecture equipped with subagents, workflows, and skills for prompt-to-landing-page generation.

---

## 🛠️ Technical Specification

### 1. Core Architecture
- **Markup**: Semantic HTML5 (`<header>`, `<main>`, `<section>`, `<article>`, `<footer>`).
- **Styling**: Tailwind CSS via official CDN (`<script src="https://cdn.tailwindcss.com"></script>`).
- **State & Interactivity**: Alpine.js via CDN (`<script defer src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js"></script>`).
- **Icons**: Lucide Icons CDN / inline SVGs.
- **Business Integrations**:
  - Direct WhatsApp Click-to-Chat CTA: `https://wa.me/<number>?text=<urlencoded_message>`
  - Google Maps Embed iframe with responsive container.

### 2. Local Development & Testing
- **Local Dev Server**: Optional lightweight Docker setup via `compose.yml` (`nginx:alpine` at port `8080`) and `./dc.sh` wrapper.
- **Automated Testing**: Headless Playwright tests (`tests/landing.spec.js`) verifying semantic landmarks, WhatsApp button attributes, modal open/close transitions, and mobile viewport layout.

### 3. Directory Layout
```plaintext
business-landing/
├── .agent/
│   ├── config.yaml
│   ├── rules/
│   │   ├── landing-page-standards.md
│   │   ├── deployment-guidelines.md
│   │   └── ...
│   ├── skills/
│   │   └── create-landing-section/
│   └── workflows/
├── .github/
│   └── workflows/
│       └── deploy.yml
├── assets/
│   └── .gitkeep
├── index.html
├── vercel.json
├── compose.yml
├── dc.sh
├── package.json
├── tests/
│   └── landing.spec.js
└── README.md
```

---

## 📋 Acceptance Criteria
- [x] Functional `index.html` with working mobile menu, quote modal, WhatsApp CTA, and Google Maps embed.
- [x] Zero build toolchain required to view or deploy.
- [x] GitHub Pages automated deploy workflow included.
- [x] Vercel static routing configured.
- [x] `compose.yml` & `dc.sh` working for local preview.
- [x] `.agent/` rules, skills, and workflows integrated with BMAD v6.
- [x] Root `setup.sh` correctly detects and scaffolds `business-landing`.
- [x] Root `README.md` updated in Available Stacks table.
