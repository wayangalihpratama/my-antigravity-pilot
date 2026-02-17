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

### Laravel Backend Specifics

- Use **Form Request** classes for all input validation — never validate inline in controllers
- Use **Eloquent ORM** with parameterized queries — never raw string SQL (`DB::raw()` only when absolutely necessary)
- Use **Policies** and **Gates** for authorization — never check permissions in controller logic directly
- Store secrets in `.env` — never hardcode in source
- Use `bcrypt()` or `Hash::make()` for password hashing
- Use **CSRF protection** (enabled by default) — never disable `VerifyCsrfToken` middleware
- Protect against **mass assignment** — always define `$fillable` or `$guarded` on models
- Use **signed URLs** for sensitive actions (email verification, password reset)
- Enable **rate limiting** on authentication and API routes

### Inertia/React Frontend Specifics

- Sanitize all user-rendered content to prevent XSS
- Never expose API keys or secrets in client-side code
- Use Inertia's built-in CSRF handling — don't bypass it
- Use `Link` component from `@inertiajs/react` for navigation (SPA-safe)

### Filament Admin Specifics

- Implement `FilamentUser` interface on User model for access control
- All Resources must implement authorization via Policy classes
- Admin routes are `/admin` — ensure they are auth-protected

### Related Rules
- Rule Priority @rule-priority.md
- Error Handling @error-handling.md
- Laravel Backend @laravel-backend.md
