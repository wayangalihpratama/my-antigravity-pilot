---
trigger: always_on
description: Docker commands and service URLs for the python-streamlit stack.
---

## Docker Commands

**All commands MUST be executed via `./dc.sh exec`. Never run bare commands outside Docker.**

### Service Access URLs

| Service | URL |
|---------|-----|
| Streamlit App | http://localhost:8501 |

### Environment Management

```bash
./dc.sh up -d           # Start the app
./dc.sh down            # Stop the app
./dc.sh ps              # View running services
./dc.sh logs -f         # Follow logs
```

### Streamlit Commands

```bash
./dc.sh exec streamlit bash                          # Open shell
./dc.sh exec streamlit run app/main.py               # Run app manually (if needed)
./dc.sh exec streamlit flake8 .                      # Run linter
./dc.sh exec streamlit black .                       # Run formatter
./dc.sh exec streamlit pip install -r requirements.txt # Install dependencies manually
```

### Rules

1.  **Never run `python`, `pip`, or `streamlit` directly** — always prefix with `./dc.sh exec streamlit`.
2.  **Hot reload** is enabled via volume mounting.
3.  **Dependencies** are installed at startup via `run.sh`.
