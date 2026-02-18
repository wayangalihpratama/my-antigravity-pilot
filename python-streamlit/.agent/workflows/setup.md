---
description: How to set up and run the python-streamlit stack
---

# Setup Workflow

This guide walks you through the initial setup and running of the python-streamlit stack.

## Prerequisites

- Docker and Docker Compose installed
- Git installed

## Steps

### 1. Configure Environment Variables

If your application requires environment variables, create a `.env` file in the `python-streamlit/` directory.

```bash
cp .env.example .env
# Edit .env with your configuration
```

### 2. Start the Application

Use the provided `dc.sh` script to manage the Docker containers.

```bash
./dc.sh up -d
```

This command will:
- Build the Docker image (or pull the base image).
- Install dependencies specified in `requirements.txt`.
- Start the Streamlit server on port 8501.

### 3. Verify Installation

Open your browser and navigate to:

[http://localhost:8501](http://localhost:8501)

You should see the "Hello Streamlit" welcome page.

### 4. Development Workflow

The local directory is mounted into the container, so changes to your code will be reflected immediately (hot reloading is enabled via Streamlit).

- **View Logs:** `./dc.sh logs -f`
- **Stop App:** `./dc.sh down`
- **Open Shell:** `./dc.sh exec streamlit bash`
- **Lint Code:** `./dc.sh exec streamlit flake8 .`
- **Format Code:** `./dc.sh exec streamlit black .`

## Troubleshooting

If the app fails to start, check the logs:

```bash
./dc.sh logs
```

Common issues:
- Port 8501 already in use.
- Missing dependencies in `requirements.txt`.
