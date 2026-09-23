# 🕹️ Retro Educational Minigame Stack

Zero-dependency, high frame-rate 2D canvas arcade game boilerplate designed for instant execution in mobile webviews (TikTok / Instagram bio links) and desktop browsers.

---

## ⚡ Tech Stack
- **Rendering Context**: HTML5 Canvas 2D (`getContext('2d')`) at native 320x240 resolution
- **Scaling**: CSS `image-rendering: pixelated;` for crisp retro pixels
- **Core Logic**: Vanilla JavaScript ES6+ (delta-time loop, FSM: `START`/`PLAYING`/`PAUSED`/`GAMEOVER`)
- **Audio Engine**: Web Audio API oscillator synthesis (8-bit square/sawtooth waves, zero external `.mp3` files)
- **Controls**: Unified mobile virtual touch D-Pad and desktop keyboard fallback
- **Deployment**: 1-push zero-build deploy to **GitHub Pages (`github.io`)** or **Vercel**

---

## 🚀 Quickstart

### Option 1: Direct File Open
Open `index.html` in any web browser. No build steps, bundlers, or package installations needed.

### Option 2: Local Docker Preview
```bash
# Start Nginx preview server at http://localhost:8081
./dc.sh up -d

# Stop preview server
./dc.sh down
```

### Option 3: Run Automated Verification Tests
```bash
npm test
```

---

## 🎮 Game Controls
- **Desktop Keyboard**:
  - `◀` / `▶` or `A` / `D`: Move Bin Left / Right
  - `Space` or `Z`: Switch Bin Type (Organic / Plastic / Paper) or Start Game
- **Mobile Touch**:
  - `◀` `▶` on-screen D-Pad buttons
  - `A` virtual action button

---

## 🌐 Instant 1-Push Deployment

### 1. GitHub Pages (`github.io`)
This template includes `.github/workflows/deploy.yml`:
1. Push code to your GitHub repo on branch `main`.
2. In your repo on GitHub: **Settings > Pages > Build and deployment > Source** -> Select **GitHub Actions**.
3. The game will be live instantly at `https://<username>.github.io/<repo>/`.

### 2. Vercel
Run in your terminal:
```bash
npx vercel --prod
```
Or connect your GitHub repository in the Vercel dashboard. Vercel serves the static files directly using the included `vercel.json`.

---

## 🤖 BMAD AI Agent Workflow
In Antigravity or your AI assistant:
- Use `/0-planning` to define custom game themes, educational quizzes, or sorting mechanics.
- Call skill `create-game-mechanic` to generate drop zones, obstacle spawners, or power-up systems.
- Run `/4-verify` to validate delta-time math, collision physics, and touch responsive scaling.
