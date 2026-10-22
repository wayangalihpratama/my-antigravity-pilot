# 🛠️ AI Extensions, MCP Tools & 9Router Integration Guide

Dokumentasi ini merangkum seluruh konfigurasi plugin, tools **MCP (Model Context Protocol)**, **Agent Skills**, serta integrasi **9Router** yang telah diimplementasikan di repositori **My Antigravity Pilot**.

Dokumen ini ditujukan sebagai referensi tim, standar operasional, dan panduan replikasi untuk project baru.

---

## 📑 Daftar Isi
1. [Arsitektur & Komponen Utama](#1-arsitektur--komponen-utama)
2. [Ekstensi & Agent Skills](#2-ekstensi--agent-skills)
   - [Playwright Testing (CLI & MCP)](#a-playwright-testing-cli--mcp)
   - [Strix Security (Autonomous Pentesting)](#b-strix-security-autonomous-pentesting)
   - [Frontend Design Skill (Anti-Slop UI)](#c-frontend-design-skill-anti-slop-ui)
   - [Context7 (Live Docs & Zero Hallucination)](#d-context7-live-docs--zero-hallucination)
3. [Model Context Protocol (MCP) Configuration](#3-model-context-protocol-mcp-configuration)
4. [9Router: Gateway, Token Saver & Multi-Provider](#4-9router-gateway-token-saver--multi-provider)
   - [Fitur Unggulan](#fitur-unggulan)
   - [Manajemen Layanan (`9router-service.sh`)](#manajemen-layanan-9router-servicesh)
   - [Dashboard & Port](#dashboard--port)
   - [Menghubungkan Akun Antigravity & Provider Lain](#menghubungkan-akun-antigravity--provider-lain)
   - [Konfigurasi di CLI & Coding Tools](#konfigurasi-di-cli--coding-tools)
5. [Orkestrasi Project & Replikasi (`setup.sh`)](#5-orkestrasi-project--replikasi-setupsh)

---

## 1. Arsitektur & Komponen Utama

Ekosistem agent pada workspace ini menggabungkan tiga pilar:

```
┌────────────────────────────────────────────────────────────────────────┐
│                   Coding Agent (Antigravity / Claude Code)             │
└───────────────────┬────────────────────────────────┬───────────────────┘
                    │                                │
                    ▼                                ▼
       ┌────────────────────────┐       ┌─────────────────────────┐
       │   Agent Skills (BMAD)  │       │  MCP Servers & Tools    │
       │  • frontend-design     │       │  • Playwright (Browser) │
       │  • strix-security      │       │  • Context7 (Live Docs) │
       │  • playwright-testing  │       └─────────────────────────┘
       │  • context7            │
       │  • 9router             │
       └────────────────────────┘
                    │
                    ▼
       ┌─────────────────────────────────────────────────────────┐
       │             9Router Local Gateway (:20128)              │
       │  • RTK Token Saver (Hemat 20-40% context)               │
       │  • Smart 3-Tier Fallback (Subscription → Cheap → Free)   │
       │  • Multi-Account OAuth Load Balancing                   │
       └────────────────────────────┬────────────────────────────┘
                                    ▼
       ┌─────────────────────────────────────────────────────────┐
       │  AI Providers: Antigravity / Claude / Kiro / Vertex     │
       └─────────────────────────────────────────────────────────┘
```

---

## 2. Ekstensi & Agent Skills

Semua panduan operasional agent disimpan dalam format standar `SKILL.md` di folder `bmad-team/skills/` dan didistribusikan ke setiap stack.

### A. Playwright Testing (CLI & MCP)
* **Lokasi Skill:** [`bmad-team/skills/playwright-testing/SKILL.md`](../bmad-team/skills/playwright-testing/SKILL.md)
* **Paket MCP:** `@modelcontextprotocol/server-playwright`
* **Fungsi:**
  * Memberikan kemampuan visual browser automation untuk agent (membuka halaman, mengklik tombol, mengisi input).
  * Mengambil screenshot full-page atau spesifik komponen untuk memverifikasi layout UI.
  * Membaca JavaScript console logs dan network requests untuk mendeteksi error runtime di browser.
* **Penggunaan CLI:**
  ```bash
  npx playwright test
  npx playwright codegen http://localhost:3000
  ```

### B. Strix Security (Autonomous Pentesting)
* **Lokasi Skill:** [`bmad-team/skills/strix-security/SKILL.md`](../bmad-team/skills/strix-security/SKILL.md)
* **Fungsi:**
  * Melakukan scanning kerentanan OWASP Top 10 (SQLi, XSS, Broken Auth, IDOR/BOLA, SSRF) secara aktif pada endpoint aplikasi.
  * Berbeda dari SAST statis, Strix menghasilkan **Proof-of-Concept (PoC)** nyata untuk memvalidasi apakah bug benar-benar bisa dieksploitasi (mengeliminasi *false positives*).
  * Memformat laporan menjadi *AI fix prompt* yang siap diproses agent untuk me-refactor kode yang rentan.
* **Penggunaan CLI:**
  ```bash
  npx strix scan --target http://localhost:3000
  ```

### C. Frontend Design Skill (Anti-Slop UI)
* **Lokasi Skill:** [`bmad-team/skills/frontend-design/SKILL.md`](../bmad-team/skills/frontend-design/SKILL.md)
* **Fungsi:**
  * Membimbing agent agar tidak menghasilkan tampilan generik (*AI slop* seperti gradien ungu default, card grid seragam, atau font Inter tanpa karakter).
  * Menerapkan proses **Two-Pass Design**: Pass 1 (penentuan 4–6 token warna hex autentik & ASCII wireframe) dan Pass 2 (self-critique & build).
  * Memastikan penulisan microcopy yang fungsional, active-voice CTA, dan state handling yang konsisten.

### D. Context7 (Live Docs & Zero Hallucination)
* **Lokasi Skill:** [`bmad-team/skills/context7/SKILL.md`](../bmad-team/skills/context7/SKILL.md)
* **Paket MCP:** `@upstash/context7-mcp@latest`
* **Fungsi:**
  * Mengambil dokumentasi resmi dan contoh kode terkini secara *real-time* sesuai versi library yang digunakan project (Next.js 15, Tailwind v4, Drizzle, Zod, dll.).
  * Menggunakan tool `resolve-library-id` dan `query-docs` untuk mencegah halusinasi sintaks yang sudah usang (*deprecated*).

---

## 3. Model Context Protocol (MCP) Configuration

Konfigurasi MCP telah disiapkan di level root dan template project:
* Root workspace: `.claude/mcp.json` dan `.mcp.json`
* Template BMAD: `bmad-team/templates/mcp.json`

**Isi Konfigurasi:**
```json
{
  "mcpServers": {
    "playwright": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-playwright"]
    },
    "context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp@latest"]
    }
  }
}
```

---

## 4. 9Router: Gateway, Token Saver & Multi-Provider

[9Router](https://github.com/decolua/9router) berfungsi sebagai proxy pintar lokal yang menjembatani coding assistant dengan puluhan provider AI.

### Fitur Unggulan:
1. **RTK Token Saver (Built-in):** Memangkas output perintah terminal (`git diff`, `grep`, `ls`, log errors) sebesar **20–40%** sebelum dikirim ke LLM tanpa kehilangan konteks.
2. **Smart 3-Tier Fallback:**
   * **Tier 1 (Subscription):** Antigravity, Claude Code Pro/Max, Codex.
   * **Tier 2 (Cheap Backup):** GLM-5.1 ($0.6/1M), MiniMax ($0.2/1M).
   * **Tier 3 (Free Forever):** Kiro AI (Claude 4.5 free), OpenCode Free, Vertex AI ($300 credits).
3. **Multi-Account Balancing:** Menghubungkan beberapa akun Google/Antigravity sekaligus untuk menghindari batas rate limit.

### Manajemen Layanan (`9router-service.sh`):
Gunakan skrip pengelola di root repositori:

```bash
# Menjalankan 9Router di background
./9router-service.sh start

# Memeriksa status layanan
./9router-service.sh status

# Membuka Web Dashboard di browser
./9router-service.sh dashboard

# Menghentikan layanan
./9router-service.sh stop

# Melihat log real-time
./9router-service.sh logs
```

### Dashboard & Port:
* **Web UI:** `http://127.0.0.1:20128/dashboard`
* **API Base:** `http://127.0.0.1:20128/v1`
* **Default Password:** `123456`

### Menghubungkan Akun Antigravity & Provider Lain:
1. Buka dashboard di `http://127.0.0.1:20128/dashboard`.
2. Buka tab **Providers**:
   * Klik **Antigravity** → Lakukan login OAuth Google.
   * Klik **Kiro AI** atau **OpenCode Free** untuk mengaktifkan fallback gratis.
3. Buka tab **Combos** untuk membuat alur fallback otomatis (misal: *Antigravity → Kiro Claude → OpenCode*).

### Konfigurasi di CLI & Coding Tools:
Arahkan endpoint AI ke 9Router melalui environment variables:

```bash
export OPENAI_BASE_URL="http://127.0.0.1:20128/v1"
export OPENAI_API_KEY="[api-key-dari-dashboard-9router]"
```

Untuk Claude Code (`~/.claude/config.json`):
```json
{
  "anthropic_api_base": "http://127.0.0.1:20128/v1",
  "anthropic_api_key": "your-9router-api-key"
}
```

---

## 5. Orkestrasi Project & Replikasi (`setup.sh`)

Seluruh tools, MCP, dan skills di atas terintegrasi penuh ke dalam skrip orkestrasi sentral: [`setup.sh`](../setup.sh).

### Perintah Utama:

#### 1. Sinkronisasi Global ke Semua Stack:
Memperbarui seluruh stack bawaan repositori agar memiliki skills dan config MCP terbaru:
```bash
./setup.sh --sync-all
```

#### 2. Replikasi ke Project Baru / Eksternal:
Untuk menyalin seluruh konfigurasi agent, skills, dan MCP ke direktori project lain di komputer Anda:
```bash
# Mode Interaktif
./setup.sh

# Mode Langsung (Agent config only ke folder di luar repositori)
./setup.sh business-landing /path/to/project-baru agent

# Mode BMAD Only (Hanya rules, skills, subagents, dan MCP tanpa skeleton kode)
./setup.sh none /path/to/project-baru bmad
```

---
*Dokumentasi ini dibuat otomatis dan dikelola dalam repositori `my-antigravity-pilot`.*
