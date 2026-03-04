## Docker Commands

**All commands MUST be executed via `./dc.sh exec`. Never run bare commands outside Docker.**

### Service Access URLs

| Service | URL |
|---------|-----|
| Frontend | http://localhost:3000 |
| Strapi Admin | http://localhost:1337/admin |
| pgAdmin | http://localhost:5050 |
| Mailpit (Web) | http://localhost:8025 |
| Production Entry | http://localhost (via Nginx) |
| Production CMS | http://localhost/cms (via Nginx) |

### Environment Management

```bash
./dc.sh up -d           # Start all services
./dc.sh down            # Stop all services
./dc.sh ps              # View running services
./dc.sh logs -f         # Follow all logs
./dc.sh logs backend    # View specific service logs
```

### Backend Commands (Strapi)

```bash
./dc.sh exec backend npm test                        # Run backend tests
./dc.sh exec backend npm run strapi admin:create    # Create admin user
./dc.sh exec backend npm run config-sync import      # Sync CMS config
./dc.sh exec backend bash                            # Open shell
```

### Frontend Commands (Next.js)

```bash
./dc.sh exec frontend npx prettier --write .         # Format code
./dc.sh exec frontend bash                           # Open shell
./dc.sh exec frontend npm run dev                    # Start dev server
./dc.sh exec frontend npm run lint                   # Run ESLint
./dc.sh exec frontend npm test                       # Run tests
```

### Rules

1. **Never run `npm`, `npx`, or `node` directly** — always prefix with `./dc.sh exec backend` or `./dc.sh exec frontend`
2. **Database health** is managed by Docker Compose dependencies.
3. **Hot reload** is enabled for all development services via volumes.
4. **Environment variables** go in `.env` file (based on `.env.example`)
