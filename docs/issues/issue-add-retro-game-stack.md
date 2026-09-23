# Issue: Add "Retro Edu Minigame" Tech Stack (HTML5 Canvas 2D + Vanilla JS + Web Audio)

## 📌 Summary
Add a zero-dependency, high-frame-rate **Retro Educational Minigame Stack** (`retro-game/`) to `my-antigravity-pilot`. This stack allows AI agents to instantly build arcade 2D minigames (e.g., waste-sorting quizzes, reflex games, retro collectors) that run smoothly in mobile webviews (such as TikTok, Instagram bio links) and deploy in 1 push to **GitHub Pages (`github.io`)** or **Vercel**.

---

## 🎯 Objectives & Motivation
- **Zero Dependencies & Single-File Ready**: Pure Vanilla JavaScript (ES6+), HTML5 `<canvas>` 2D, and synthetic Web Audio (no external `.mp3` or asset downloads required).
- **Pixelated Retro Aesthetic**: Low internal rendering resolution (e.g., `320x240` or `256x224`) scaled crisp to any screen size using CSS `image-rendering: pixelated;`.
- **High Frame-Rate & Mobile First**: Delta-time `requestAnimationFrame` game loop with unified virtual touch D-Pad / action buttons and desktop keyboard controls.
- **BMAD v6 Integration**: Full `.agent/` architecture with skills to scaffold custom game mechanics, drop zones, and educational quiz states.

---

## 🛠️ Technical Specification

### 1. Core Architecture
- **Rendering Context**: HTML5 Canvas 2D (`getContext('2d')`) rendered internally at `320x240` and scaled to viewport.
- **Core Engine**: Vanilla JS ES6 modules with:
  - Delta-time accumulator game loop (consistent speeds across 60Hz and 120Hz displays).
  - Finite State Machine: `START`, `PLAYING`, `PAUSED`, `GAMEOVER`.
  - Collision detection & score tracking.
- **Audio Synthesizer**: Web Audio API oscillator synthesis (square & sawtooth waves for retro 8-bit sound effects: jump, score, hit, game over) with user-gesture audio context unlocking.
- **Controls**: Unified Touch Events (`touchstart`/`touchend` for virtual D-Pad buttons) + Keyboard fallback (`ArrowKeys`, `WASD`, `Space`).

### 2. Local Development & Testing
- **Local Dev Server**: Optional lightweight Docker setup via `compose.yml` (`nginx:alpine` at port `8081`) and `./dc.sh` wrapper.
- **Automated Testing**: Headless Vitest/Node test suite (`tests/engine.spec.js`) verifying math helpers, collision logic, state machine transitions, and delta-time steps.

### 3. Directory Layout
```plaintext
retro-game/
├── .agent/
│   ├── config.yaml
│   ├── rules/
│   │   ├── retro-game-standards.md
│   │   ├── deployment-guidelines.md
│   │   └── ...
│   ├── skills/
│   │   └── create-game-mechanic/
│   └── workflows/
├── .github/
│   └── workflows/
│       └── deploy.yml
├── index.html
├── style.css
├── main.js
├── vercel.json
├── compose.yml
├── dc.sh
├── package.json
├── tests/
│   └── engine.spec.js
└── README.md
```

---

## 📋 Acceptance Criteria
- [x] Complete playable retro canvas game template with score, sprite drawing, audio synth, and virtual controls.
- [x] Zero build toolchain required for production run or deployment.
- [x] GitHub Pages automated deploy workflow included.
- [x] Vercel static routing configured.
- [x] `compose.yml` & `dc.sh` working for local preview.
- [x] `.agent/` rules, skills, and workflows integrated with BMAD v6.
- [x] Root `setup.sh` correctly detects and scaffolds `retro-game`.
- [x] Root `README.md` updated in Available Stacks table.
