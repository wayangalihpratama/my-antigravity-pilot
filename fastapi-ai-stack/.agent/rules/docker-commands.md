# Docker Commands

**All commands MUST be executed via `./dc.sh`. Never run bare commands outside Docker.**

## Environment Management

```bash
./dc.sh up -d           # Start all services
./dc.sh down            # Stop all services
./dc.sh ps              # View running services
./dc.sh logs -f         # Follow all logs
./dc.sh logs app        # View specific service logs
./dc.sh build           # Rebuild services
```

## Backend Commands (FastAPI)

```bash
./dc.sh exec app bash                          # Open shell in app container
./dc.sh exec app uvicorn app.main:app --host 0.0.0.0 --reload # Run app manually
./dc.sh tests                                  # Run backend tests
./dc.sh exec app pip install <package>         # Install dependencies (persist to requirements.txt manually)
```

## AI & Data Services

```bash
./dc.sh logs worker                            # View Celery worker logs
./dc.sh logs chroma                            # View Chroma logs
./dc.sh logs minio                             # View Minio logs
```

## Rules

1. **Never run `python`, `pip`, or `pytest` directly** — always prefix with `./dc.sh exec app` or use `./dc.sh tests`.
2. **Hot reload** is enabled for the `app` service via volume mounting.
3. **Environment variables** go in `.env` file.
