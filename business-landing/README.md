# 🏢 Business & Brand Landing Page Stack

Zero-build, conversion-optimized static landing page boilerplate tailored for local businesses and personal brands.

---

## ⚡ Tech Stack
- **Structure**: Semantic HTML5
- **Styling**: Tailwind CSS via CDN (`https://cdn.tailwindcss.com`)
- **Interactivity**: Alpine.js via CDN (`https://cdn.jsdelivr.net/npm/alpinejs`)
- **Icons**: Lucide Icons CDN / inline SVGs
- **Integrations**: Direct WhatsApp Click-to-Chat CTA & responsive Google Maps embed
- **Deployment**: Zero-build direct deploy to **GitHub Pages (`github.io`)**, **Vercel**, or **Netlify**

---

## 🚀 Quickstart

### Option 1: Direct File Open
Open `index.html` directly in any web browser. No build steps, no node_modules required.

### Option 2: Local Docker Preview
```bash
# Start Nginx preview server at http://localhost:8080
./dc.sh up -d

# Stop server
./dc.sh down
```

### Option 3: Run Automated Verification Tests
```bash
npm test
```

---

## 🌐 Instant 1-Push Deployment

### 1. GitHub Pages (`github.io`)
This template includes `.github/workflows/deploy.yml`:
1. Push code to your GitHub repo on branch `main`.
2. In your repo on GitHub: **Settings > Pages > Build and deployment > Source** -> Select **GitHub Actions**.
3. Live instantly at `https://<username>.github.io/<repo>/`.

### 2. Vercel
Run in your terminal:
```bash
npx vercel --prod
```
Or import the GitHub repository in the Vercel dashboard. Vercel auto-serves `index.html` using the included `vercel.json`.

---

## 🤖 BMAD AI Agent Workflow
In Antigravity or your AI assistant:
- Use `/0-planning` to define copy, color palette, and business packages.
- Call skill `create-landing-section` to generate new conversion sections (Pricing tables, Testimonials, FAQ accordions).
- Run `/4-verify` to validate HTML semantics, WhatsApp phone numbers, and responsiveness.
