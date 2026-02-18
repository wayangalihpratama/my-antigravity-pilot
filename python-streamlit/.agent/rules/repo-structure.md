---
trigger: always_on
description: Repository structure and conventions for the python-streamlit stack.
---

## Repository Structure

This stack follows the **python-streamlit** structure.

### Directory Layout

```
python-streamlit/
├── .agent/           # Agent configuration
│   ├── rules/        # Coding standards
│   ├── skills/       # Task guides
│   └── workflows/    # Development workflows
├── app/              # Application source code
│   └── main.py       # Entry point
├── docker-compose.yml # Docker services
├── run.sh            # Container startup script
├── dc.sh             # Docker wrapper script
└── requirements.txt  # Python dependencies
```

### Rules

1.  **Docker-First**: All commands must run inside the container via `./dc.sh`.
2.  **Streamlit Structure**:
    -   Entry point is `app/main.py`.
    -   Pages can be added to `app/pages/`.
    -   Components and utilities should be organized within `app/`.
3.  **Dependencies**: Managed in `requirements.txt`.
4.  **Linting**: Use `black` and `flake8` for Python code.

### Related Rules
- Docker Commands @docker-commands.md
- Streamlit Best Practices @streamlit-best-practices.md
