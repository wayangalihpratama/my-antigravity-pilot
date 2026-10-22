---
name: 9router
description: Connect and route AI agent requests through 9Router for token savings (RTK), automated fallback, and multi-provider load balancing.
---

# 9Router: AI Gateway, Token Saver & Multi-Provider Router

A complete guide for integrating coding agents (Antigravity, Claude Code, Codex, Cursor) with local 9Router.

---

## 🎯 Key Features & Benefits

1. **RTK Token Saver**: Losslessly compresses input context (`git diff`, `grep`, `ls`, file tree) by 20–40% before reaching the model.
2. **Smart 3-Tier Fallback**:
   - Tier 1: Primary Subscription (Antigravity, Claude Code, Codex).
   - Tier 2: Low-cost models (GLM, MiniMax).
   - Tier 3: Free models (Kiro AI, OpenCode Free, Vertex AI credits).
3. **Multi-Account Balancing**: Distribute queries across multiple provider accounts to bypass rate limits.

---

## 🚀 Service Management

Control 9Router using the project helper:
```bash
# Check status
./9router-service.sh status

# Start service in background
./9router-service.sh start

# Open Web Dashboard in browser
./9router-service.sh dashboard

# Stop service
./9router-service.sh stop
```

Default URLs:
- **Dashboard**: `http://127.0.0.1:20128/dashboard`
- **Default Password**: `123456`
- **OpenAI-compatible Endpoint**: `http://127.0.0.1:20128/v1`

---

## 🔌 Connecting Tools

### 1. Environment Variables (Terminal / Scripts)
```bash
export OPENAI_BASE_URL="http://127.0.0.1:20128/v1"
export OPENAI_API_KEY="[your-9router-api-key-from-dashboard]"
```

### 2. Claude Code (`~/.claude/config.json`)
```json
{
  "anthropic_api_base": "http://127.0.0.1:20128/v1",
  "anthropic_api_key": "your-9router-api-key"
}
```

### 3. Cursor IDE / Cline / RooCode
- **Provider**: OpenAI Compatible
- **Base URL**: `http://127.0.0.1:20128/v1`
- **API Key**: `[from 9router dashboard]`
