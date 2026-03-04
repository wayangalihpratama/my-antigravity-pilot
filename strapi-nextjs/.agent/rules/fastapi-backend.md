---
trigger: model_decision
description: When writing or modifying Python backend code (FastAPI routers, models, services, tests)
---

## FastAPI Backend Standards

### Code Style

- Follow **PEP 8** guidelines
- Use **Black** formatter with **79 character** line limit
- Use **flake8** for linting
- Run linter: `./dc.sh exec backend flake8`

### Pydantic v2 Multi-Model Pattern

Always use the multi-model pattern for API schemas:

| Model | Purpose |
|-------|---------|
| `Base` | Common fields shared across models |
| `Create` | Request body for creation (required fields) |
| `Update` | Request body for updates (all optional) |
| `Response` | API response with all fields |

```python
from pydantic import BaseModel, Field
from typing import Optional
from datetime import datetime

class UserBase(BaseModel):
    email: str = Field(..., description="User email")
    name: str = Field(..., min_length=1)

class UserCreate(UserBase):
    password: str = Field(..., min_length=8)

class UserUpdate(BaseModel):
    email: Optional[str] = None
    name: Optional[str] = Field(None, min_length=1)

class UserResponse(UserBase):
    id: int
    created_at: datetime

    class Config:
        from_attributes = True
```

### FastAPI Router Conventions

```python
from fastapi import APIRouter, Depends, HTTPException, status

router = APIRouter(prefix="/api/users", tags=["users"])

@router.get("/", response_model=list[UserResponse])
async def list_users(): ...

@router.get("/{user_id}", response_model=UserResponse)
async def get_user(user_id: int): ...

@router.post("/", response_model=UserResponse, status_code=status.HTTP_201_CREATED)
async def create_user(data: UserCreate): ...

@router.patch("/{user_id}", response_model=UserResponse)
async def update_user(user_id: int, data: UserUpdate): ...

@router.delete("/{user_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_user(user_id: int): ...
```

### Authentication Patterns

```python
# Optional auth - returns None if not authenticated
current_user: Optional[User] = Depends(get_current_user)

# Required auth - raises 401 if not authenticated
current_user: User = Depends(get_current_user_required)
```

### Architecture

- **SQLAlchemy ORM** for database models
- **Alembic** for database migrations (auto-run on startup)
- **Service layer** for business logic (keep routers thin)
- **Modular routers** mounted in `main.py`

### Testing

- Use **pytest** with coverage reporting
- Class-based test grouping: `class TestUserCRUD:`
- Run tests: `./dc.sh exec backend python -m pytest tests/ -v`
- Always test happy path + at least 2 error paths

### Related Rules
- API Design @api-design.md
- Docker Commands @docker-commands.md
- Testing Strategy @testing-strategy.md
