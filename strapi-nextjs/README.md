# Strapi-NextJS Stack (v5 + 15)

A premium, production-ready fullstack skeleton featuring Strapi v5 (Backend) and Next.js 15 (Frontend).

## Quick Start

1. **Setup Environment**:
   ```bash
   cp .env.example .env
   # Modify .env with your secrets
   ```

2. **Launch Services**:
   ```bash
   ./dc.sh up -d
   ```

3. **Initialize Strapi**:
   Access the admin panel at `http://localhost:1337/admin` to create your first admin user.

## Tech Stack

- **Backend**: [Strapi v5](https://docs.strapi.io/)
- **Frontend**: [Next.js 15](https://nextjs.org/) (App Router)
- **Database**: PostgreSQL 16
- **Styling**: Tailwind CSS
- **Testing**: Vitest (TDD)
- **Developer Workflow**: Docker-first with automated schema syncing (`config-sync`).

## Testing

Run tests for both services:
```bash
./dc.sh exec backend npm test
./dc.sh exec frontend npm test
```

## Documentation

- [Strapi Learning Guide](../agent_docs/strapi-learning-guide.md)
- [UX Design Specification](../agent_docs/ux-design-specification.md)
