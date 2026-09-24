---
name: mcp-integration
description: Comprehensive guide for connecting, configuring, debugging, and authoring Model Context Protocol (MCP) servers and tools. Use when integrating external APIs, Figma, GitHub, databases, or debugging MCP communication.
---

# Model Context Protocol (MCP) Integration

## Overview
Model Context Protocol (MCP) is an open standard that enables AI agents to securely connect with external tools, databases, development services, and design platforms via standardized JSON-RPC protocols.

## Transport Modes & Configuration

### 1. Stdio Transport (Local Process)
Best for local CLIs, database bridges, and development servers:
```json
{
  "mcpServers": {
    "sqlite-db": {
      "command": "uvx",
      "args": ["mcp-server-sqlite", "--db-path", "./data/app.db"],
      "env": {
        "DEBUG": "false"
      }
    }
  }
}
```

### 2. SSE Transport (Server-Sent Events / Remote HTTP)
Best for remote services, cloud endpoints, and shared team tools:
```json
{
  "mcpServers": {
    "remote-analytics": {
      "url": "https://mcp.internal.company.com/sse",
      "headers": {
        "Authorization": "Bearer ${AUTH_TOKEN}"
      }
    }
  }
}
```

## Essential MCP Integrations

| Server Name | Primary Use Cases | Configuration Key |
|---|---|---|
| **Figma Dev Mode** | Extract design tokens, component frames, typography directly from Figma URLs | `figma-dev-mode-mcp-server` |
| **Chrome DevTools** | DOM inspection, network tracing, accessibility tree, performance audits | `chrome-devtools` |
| **GitHub MCP** | Issue lookup, PR creation, repository tree queries | `github-mcp-server` |
| **PostgreSQL / MySQL** | Schema inspection, read-only query testing | `postgres-mcp` |

## Best Practices & Security
- **Lazy Loading**: Configure heavy or rarely used MCP servers with lazy tool schemas to avoid bloating initial prompt contexts.
- **Credential Hygiene**: Never hardcode API keys or database passwords in `mcp.json`. Use environment variable expansion (`${ENV_VAR}`).
- **Read-Only Guards**: Enforce read-only database connections for exploratory agent turns to prevent accidental data modifications.
