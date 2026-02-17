## Rule Priority (When Rules Conflict)

When two rules pull in opposite directions, use this priority to decide:

1. **Security Mandate** — never compromise security for convenience
2. **Docker Commands** — all commands must run through Docker Compose
3. **Error Handling** — consistent error handling is non-negotiable
4. **Testing Strategy** — tests define correctness
5. **Laravel Backend / Inertia-React Frontend / API Design** — framework conventions
6. **Git Workflow** — commit hygiene and branch naming

### Conflict Resolution

- If Security conflicts with Convenience → Security wins
- If Docker conflicts with Local → Docker wins
- If Laravel convention conflicts with imported pattern → Laravel convention wins
- If Filament convention conflicts with Frontend → they are separate concerns; both apply in their own scope

### Related Rules
- Security Mandate @security-mandate.md
- Docker Commands @docker-commands.md
- Error Handling @error-handling.md
- Testing Strategy @testing-strategy.md
- Laravel Backend @laravel-backend.md
- Inertia React Frontend @inertia-react-frontend.md
- API Design @api-design.md
- Git Workflow @git-workflow.md
