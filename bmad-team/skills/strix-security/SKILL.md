---
name: strix-security
description: Autonomous AI penetration testing, exploit validation, and vulnerability remediation using Strix CLI and agent skills.
---

# Strix: Autonomous AI Penetration Testing & Security

A specialized guide for running autonomous security assessments, validating vulnerabilities with real Proof-of-Concept (PoC) exploits, and remediating high-risk issues with coding agents.

---

## 🎯 Core Capabilities

1. **Active Exploitation & Verification**: Unlike static linters (SAST) that generate theoretical warnings, Strix tests applications dynamically to verify whether a vulnerability is truly exploitable before reporting it.
2. **OWASP Top 10 Coverage**: Tests for SQLi, XSS, Broken Object-Level Authorization (BOLA/IDOR), SSRF, CSRF, sensitive data exposure, and broken authentication.
3. **AI Fix Generation**: Automatically outputs remediation diffs and tailored AI fix prompts to refactor vulnerable code directly in Claude Code, Codex, or Antigravity.

---

## 🛠️ Usage & Commands

### 1. Installation & Skill Setup
To equip the agent with Strix capabilities:
```bash
# Add Strix skill via skills registry
npx skills add usestrix/strix

# Or install Strix CLI globally / locally
npm install -g strix
# or run on demand:
npx strix --help
```

### 2. Running Security Scans
```bash
# Scan local codebase and web application
npx strix scan

# Scan a running local service (e.g. localhost:3000 or staging API)
npx strix scan --target http://localhost:3000

# Scan specific modules or route handlers
npx strix scan --path ./src/api
```

### 3. Remediation Workflow
1. **Analyze Vulnerability Report**: Review the severity, endpoint, attack payload, and generated PoC.
2. **Check Root Cause**: Identify insecure parameter handling, missing middleware, or lack of authorization checks.
3. **Apply Fix**: Refactor the code adhering to secure defaults:
   - Use parameterized queries / ORM methods.
   - Enforce server-side session and role validation (do not trust client input).
   - Sanitize and encode user-supplied HTML/text.
   - Implement rate-limiting and CSRF tokens on state-changing endpoints.
4. **Re-test with Strix**: Re-run the specific exploit PoC to guarantee the patch works without breaking existing business logic.
