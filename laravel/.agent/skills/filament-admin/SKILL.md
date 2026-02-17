---
name: filament-admin
description: Filament 3 admin panel patterns and conventions. Use when creating admin resources, custom pages, widgets, or configuring the admin panel.
---

# Filament 3 Admin Panel

## Overview

Filament provides a robust, auto-generated admin interface. It is **isolated** from the user-facing Inertia frontend.

## Key Principles

1. **Isolation:** Admin logic lives in `app/Filament/` — never in `app/Http/Controllers/`
2. **Authorization:** All Resources must use Policy classes
3. **Styling:** Uses its own Tailwind theme — do not mix with `resources/css/app.css`
4. **Routes:** Auto-registered at `/admin` — no manual route definitions needed

## Creating a Resource

```bash
docker compose exec app php artisan make:filament-resource Post --generate
```

This generates:
```
app/Filament/Resources/
└── PostResource.php
    ├── Pages/
    │   ├── CreatePost.php
    │   ├── EditPost.php
    │   └── ListPosts.php
```

## Resource Structure

```php
// app/Filament/Resources/PostResource.php
class PostResource extends Resource
{
    protected static ?string $model = Post::class;
    protected static ?string $navigationIcon = 'heroicon-o-document-text';

    public static function form(Form $form): Form
    {
        return $form->schema([
            Forms\Components\TextInput::make('title')
                ->required()
                ->maxLength(255),
            Forms\Components\RichEditor::make('body')
                ->required()
                ->columnSpanFull(),
            Forms\Components\DateTimePicker::make('published_at'),
        ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->columns([
                Tables\Columns\TextColumn::make('title')->searchable(),
                Tables\Columns\TextColumn::make('user.name')->label('Author'),
                Tables\Columns\TextColumn::make('published_at')
                    ->dateTime()
                    ->sortable(),
            ])
            ->filters([
                Tables\Filters\Filter::make('published')
                    ->query(fn ($query) => $query->whereNotNull('published_at')),
            ]);
    }
}
```

## Dashboard Widgets

```bash
docker compose exec app php artisan make:filament-widget StatsOverview
```

```php
class StatsOverview extends BaseWidget
{
    protected function getStats(): array
    {
        return [
            Stat::make('Total Posts', Post::count()),
            Stat::make('Published', Post::published()->count()),
            Stat::make('Users', User::count()),
        ];
    }
}
```

## Access Control

Ensure the User model implements `FilamentUser`:

```php
use Filament\Models\Contracts\FilamentUser;

class User extends Authenticatable implements FilamentUser
{
    public function canAccessPanel(Panel $panel): bool
    {
        return $this->is_admin; // Or any authorization logic
    }
}
```

## Asset Management

```bash
# After updating Filament or its plugins
docker compose exec app php artisan filament:upgrade

# If admin appears unstyled
docker compose exec app php artisan vendor:publish --tag=filament-panels-assets --force
```

## Cross-Skill Dependency

| Dependency | Notes |
|------------|-------|
| `laravel-backend` | Resources depend on Eloquent models |
| `security-mandate` | Policies required for all resources |
| Frontend styling | Filament uses its own Tailwind — don't mix purge paths |

## Rule Compliance

- Laravel Backend @laravel-backend.md
- Security Mandate @security-mandate.md
- Docker Commands @docker-commands.md
