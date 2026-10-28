# 🛠️ Global AI Engineering Tools & Upstream Maintenance Guide

This document defines the architecture, operational workflow, and maintenance lifecycle for the global AI developer tools utilized across all projects in the **BMAD v6 / My Antigravity Pilot** ecosystem.

---

## 🏛️ Architecture & Core Philosophy

Instead of forcing every child project or tech stack (e.g. Laravel PHP, Python FastAPI, Streamlit, Go) to maintain separate Node.js or Python security and testing dependencies in their local `package.json` / `requirements.txt`:

1. **Host-Level Global Installation**: All AI utility CLIs, MCP servers, and browser binaries are maintained globally on the host operating system.
2. **Repository Ownership & Upstream Governance**: **`my-antigravity-pilot`** serves as the central control plane responsible for auditing, version-checking, and upgrading these tools.
3. **Zero Project Bloat**: Child repositories remain clean, pure to their native tech stack, and free of redundant testing/security runner packages.
4. **Instant Agent Interoperability**: Any AI agent (Claude Code, Antigravity, OpenAI Codex, Cursor) operating in any stack can immediately invoke these capabilities without running installation steps.

---

## 📦 The 4 Global AI Tooling Suites

| Tool | Global Binary / Package | Managed Via | Primary Role & Capabilities |
|---|---|---|---|
| 🎭 **Playwright** | `playwright` (`v1.64+`)<br>Browsers: `~/Library/Caches/ms-playwright/` | `npm install -g playwright`<br>`npx playwright install chromium` | E2E browser automation, UI snapshots, responsive layout audits, interactive user journeys, and accessibility testing via CLI & MCP. |
| 🔍 **Context7** | `ctx7` (`v0.5+`)<br>MCP: `@upstash/context7-mcp` | `npm install -g ctx7`<br>`.claude/mcp.json` | Real-time, version-specific official documentation retrieval (`resolve-library-id`, `query-docs`) to eliminate API hallucinations. |
| 🛡️ **Strix Security** | `strix` (`v1.7+`) | `uv tool install strix-agent`<br>*(Isolated Python runtime)* | Autonomous AI penetration testing (OWASP Top 10), active vulnerability validation with Proof-of-Concept (PoC) exploits, and automated fix generation. |
| ⚡ **9Router** | `9r` (`v0.5+`)<br>Port `20128` | `npm install -g 9router`<br>macOS LaunchAgent | Local smart AI gateway with RTK context compression (saving 20–40% token usage), automatic fallback, and model routing. |

---

## 🚀 Repository Maintenance Commands

As the master controller, this repository provides centralized commands via `setup.sh` to check readiness and upgrade all tools in one step:

### 1. Check Tool Status & Versions (`--check-tools`)
Inspects whether all tools, browser binaries, and the 9Router gateway are online and healthy:
```bash
./setup.sh --check-tools
```
*Sample Output:*
```text
Checking Global Engineering & Security Tools...

  ✅ Playwright CLI: Version 1.64.1 (Global)
  ✅ Playwright Browsers: Global cache found (chromium-1181 chromium-1208)
  ✅ Context7 CLI: v0.5.13 (Global)
  ✅ Strix Security: strix 1.7.0 (Global: strix)
  ✅ 9Router Gateway: Active on port 20128 (RTK Token Saver Enabled)

All global tools are ready for AI agent execution!
```

### 2. Upgrade All Global Tools (`--update-tools`)
Fetches and installs the latest upstream releases for all tools and updates Playwright browser engines:
```bash
./setup.sh --update-tools
```
*Actions Performed:*
- Upgrades `playwright` npm package and downloads updated Chromium binaries.
- Upgrades `ctx7` CLI to the latest version.
- Upgrades `strix-agent` via `uv tool upgrade`.
- Upgrades `9router` to the latest release.

---

## 🤖 In-Project Agent & Workflow Protocol

When an AI agent (Amelia `bmad-dev`, Murat `bmad-tester`, or Rachel `bmad-reviewer`) executes inside a child project:

### Rule 1: Never Install per Project
Agents must **never** execute `npm install playwright` or `pip install strix-agent` inside application source trees unless explicitly instructed for CI/CD pipeline authoring.

### Rule 2: Pre-Flight Version Check
Before executing test automation or security scans, agents run a lightweight pre-flight check:
```bash
# Verify Playwright
playwright --version || npx playwright --version

# Verify Context7
ctx7 --version || npx -y ctx7 --version

# Verify Strix
strix -v || uv tool run strix-agent -v
```

### Rule 3: Execution Commands
Agents invoke the tools using native global commands:
```bash
# Playwright UI Test
playwright test tests/e2e/auth.spec.ts
playwright codegen http://localhost:3000

# Context7 Documentation Query
ctx7 query "how to configure CORS in FastAPI"

# Strix Security Pentest
strix --target http://localhost:3000 -m quick
```

---

## 🔄 Project Synchronization

When child projects are bootstrapped or synchronized using:
```bash
./setup.sh --sync-all
```
The verification script is automatically updated at `.agent/scripts/check-global-tools.sh` in all 8 template stacks, ensuring every project inherits identical verification capabilities.
