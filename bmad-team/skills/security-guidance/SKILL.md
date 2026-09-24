---
name: security-guidance
description: Proactive security audit checklists and vulnerability prevention rules. Use when writing authentication, authorization, database queries, file uploads, external API integrations, or performing security audits.
---

# Security Guidance & Vulnerability Prevention

## Overview
A comprehensive security gate preventing the most common critical application security flaws across the development lifecycle.

---

## 🛡️ Critical Security Checklists

### 1. Injection & Database Security
- [ ] **Parameterized Queries**: Never concatenate user inputs into SQL/ORM queries. Always use prepared statements or ORM binding.
- [ ] **No Raw Deserialization**: Prohibit unvetted `pickle.load()`, `yaml.load()` without SafeLoader, or `eval()`.
- [ ] **No Command Injection**: Avoid `shell=True` in Python subprocess or raw shell string concatenation.

### 2. Authentication & Authorization (AuthN/AuthZ)
- [ ] **Object-Level Authorization (IDOR)**: Always verify that the currently authenticated user owns or has explicit permission to access requested entity IDs (`WHERE user_id = current_user.id`).
- [ ] **Constant-Time Comparison**: Use `crypto.timingSafeEqual()` or `hmac.compare_digest()` for tokens, password hashes, and secrets to prevent timing attacks.
- [ ] **Secure Session & Cookie Flags**: `HttpOnly`, `Secure`, `SameSite=Lax` or `Strict`.

### 3. Frontend & Cross-Site Scripting (XSS)
- [ ] **No Raw HTML Injection**: Never inject untrusted user input into `innerHTML`, `dangerouslySetInnerHTML`, or `v-html`.
- [ ] **Content Security Policy (CSP)**: Whitelist explicitly needed script and frame sources.
- [ ] **External Link Protection**: Always append `rel="noopener noreferrer"` to external `target="_blank"` links.

### 4. Secrets & Environment Hygiene
- [ ] **Zero Hardcoded Secrets**: No private keys, JWT secrets, database connection strings, or cloud tokens in repository code.
- [ ] **Sensitive Data Scrubbing**: Ensure sensitive fields (passwords, tokens, payment data) are stripped from logs and error messages.

### 5. Network & Server-Side Request Forgery (SSRF)
- [ ] **URL Whitelisting**: If fetching remote URLs on behalf of users, validate the scheme (`https`) and reject loopback/private IPs (`127.0.0.1`, `10.0.0.0/8`, `192.168.0.0/16`, `169.254.169.254`).
