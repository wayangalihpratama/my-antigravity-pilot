---
trigger: always_on
---

## Docker Commands

**All commands MUST be executed via `./dc.sh exec`. Never run bare commands outside Docker.**

### Service Access URLs

| Service | URL |
|---------|-----|
| Frontend | http://localhost:3000 |
| Backend API | http://localhost:8000 |
| API Documentation | http://localhost:8000/api/docs |
| pgAdmin | http://localhost:5050 |

### Environment Management

```bash
./dc.sh up -d           # Start all services
./dc.sh down            # Stop all services
./dc.sh ps              # View running services
./dc.sh logs -f         # Follow all logs
./dc.sh logs backend    # View specific service logs
```

### Backend Commands

```bash
./dc.sh exec backend tests                          # Run backend tests
./dc.sh exec backend flake8                          # Run linter
./dc.sh exec backend bash                            # Open shell
./dc.sh exec backend python -m pytest tests/ -v      # Run tests (verbose)
```

### Frontend Commands

```bash
./dc.sh exec frontend prettier --write .             # Format code
./dc.sh exec frontend bash                           # Open shell
./dc.sh exec frontend yarn dev                       # Start dev server
./dc.sh exec frontend yarn lint                      # Run ESLint
./dc.sh exec frontend yarn test                      # Run tests
```

### Rules

1. **Never run `python`, `pip`, `node`, `yarn`, or `npm` directly** — always prefix with `./dc.sh exec backend` or `./dc.sh exec frontend`
2. **Database migrations** run automatically on backend startup via Alembic
3. **Hot reload** is enabled for all development services
4. **Environment variables** go in `.env` file (based on `.env.example`)
