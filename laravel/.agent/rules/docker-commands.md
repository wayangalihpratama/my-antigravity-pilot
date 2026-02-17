---
trigger: always_on
---

## Docker Commands

**All commands MUST be executed via `docker compose exec`. Never run bare commands outside Docker.**

### Docker Services

| Service | Container | Purpose |
|---------|-----------|---------|
| `app` | PHP-FPM | Laravel application (Artisan, Composer, tests) |
| `web` | Nginx | Web server, proxies to PHP-FPM |
| `db` | MySQL 8.0 | Persistent database |
| `redis` | Redis | Cache and queue driver |
| `node` | Node 20 | Vite, npm, frontend build |

### Service Access URLs

| Service | URL |
|---------|-----|
| Web App | http://localhost:8000 (or `$APP_PORT`) |
| Filament Admin | http://localhost:8000/admin |
| Vite Dev Server | http://localhost:5173 |
| MySQL | localhost:3306 (or `$FORWARD_DB_PORT`) |
| Redis | localhost:6379 (or `$FORWARD_REDIS_PORT`) |

### Environment Management

```bash
docker compose up -d              # Start all services
docker compose down               # Stop all services
docker compose ps                 # View running services
docker compose logs -f            # Follow all logs
docker compose logs app           # View specific service logs
```

### Backend Commands (PHP/Artisan)

```bash
docker compose exec app php artisan test              # Run tests
docker compose exec app php artisan migrate            # Run migrations
docker compose exec app php artisan migrate:rollback   # Rollback migrations
docker compose exec app php artisan make:model Name -mf  # Model + migration + factory
docker compose exec app php artisan make:controller NameController  # Controller
docker compose exec app php artisan make:request NameRequest  # Form Request
docker compose exec app php artisan make:class Services/NameService  # Service class
docker compose exec app php artisan route:list         # List routes
docker compose exec app php artisan tinker             # REPL
docker compose exec app composer install               # Install deps
docker compose exec app ./vendor/bin/pint              # Code formatting (Laravel Pint)
docker compose exec app bash                           # Open shell
```

### Frontend Commands (Node/NPM)

```bash
docker compose exec node npm run dev -- --host   # Vite dev server
docker compose exec node npm run build           # Production build
docker compose exec node npm install             # Install dependencies
docker compose exec node npx prettier --write .  # Format code
```

### Filament Commands

```bash
docker compose exec app php artisan filament:upgrade   # Upgrade Filament assets
docker compose exec app php artisan make:filament-resource Name  # Create resource
docker compose exec app php artisan make:filament-page Name      # Create page
docker compose exec app php artisan vendor:publish --tag=filament-panels-assets --force  # Publish assets
```

### Debugging

```bash
docker compose exec app tail -f storage/logs/laravel.log  # Watch Laravel logs
docker compose logs app --tail=50                          # Recent container logs
docker compose exec app php artisan config:clear           # Clear config cache
docker compose exec app php artisan cache:clear            # Clear app cache
docker compose exec app php artisan view:clear             # Clear compiled views
```

### Rules

1. **Never run `php`, `composer`, `node`, `npm`, or `npx` directly** — always prefix with `docker compose exec app` or `docker compose exec node`
2. **Database migrations** must be run explicitly via `docker compose exec app php artisan migrate`
3. **Hot reload** is enabled for Vite via the `node` container
4. **Environment variables** go in `.env` file (based on `.env.example`)
5. **Network**: All services communicate via the `laravel-network` Docker bridge

### Related Rules
- Rule Priority @rule-priority.md
- Laravel Backend @laravel-backend.md
