---
trigger: always_on
---

## Security Mandate

**Security is a foundational requirement, not a feature.**

### Universal Security Principles

1. **Never trust user input:** All data from users, APIs, or external sources must be validated server-side
2. **Deny by default:** Require explicit permission grants, never assume access
3. **Fail securely:** When errors occur, fail closed (deny access) rather than open
4. **Defense in depth:** Multiple layers of security, never rely on a single control

### FastAPI Specifics

- Use `Depends(get_current_user_required)` for authenticated endpoints
- Validate all request bodies with Pydantic models
- Use parameterized queries via SQLAlchemy ORM — never raw string SQL
- Store secrets in `.env`, never hardcode in source

### Next.js Specifics

- Sanitize all user-rendered content to prevent XSS
- Use server-side validation for form submissions
- Never expose API keys or secrets in client-side code
- Use `next/headers` for secure cookie handling

### Related Rules
- Rule Priority @rule-priority.md
- Error Handling @error-handling.md
- API Design @api-design.md
