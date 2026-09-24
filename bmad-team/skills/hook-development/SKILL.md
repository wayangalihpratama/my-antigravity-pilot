---
name: hook-development
description: Guide for authoring and configuring lifecycle hooks in agent environments. Use when creating PreToolUse/PostToolUse hooks, automated pre-commit safeguards, tool-gating scripts, or policy enforcement.
---

# Agent Hook Development Guide

## Overview
Hooks provide event-driven automation that intercepts agent lifecycle events to enforce security rules, format code, validate tool parameters, and prevent accidental data loss.

## Lifecycle Event Matrix

| Hook Event | Trigger Point | Common Use Case |
|---|---|---|
| **PreToolUse** | Immediately before a tool executes | Block dangerous shell commands (`rm -rf /`, dropping production tables, unvetted scripts). |
| **PostToolUse** | Immediately after tool output returns | Automatically run linters/formatters after file edits, log telemetry. |
| **PreCommit** | Before creating a git commit | Verify test suite passing, audit commit message format. |
| **SessionStart** | When a new session begins | Load active sprint state, check branch status, warn about unmerged changes. |

## Implementation Patterns

### 1. PreToolUse Shell Command Guard
Intercept and evaluate dangerous bash commands before execution:
```bash
#!/usr/bin/env bash
# PreToolUse Hook: Block irreversible filesystem or database modifications

TOOL_INPUT="$1"

# Check for broad drop or recursive delete commands
if [[ "$TOOL_INPUT" =~ (DROP[[:space:]]+TABLE|rm[[:space:]]+-rf[[:space:]]+/|git[[:space:]]+reset[[:space:]]+--hard) ]]; then
  echo "❌ [BLOCKED]: Destructive operation detected. Explicit confirmation required." >&2
  exit 1
fi

exit 0
```

### 2. PostToolUse Auto-Linter
Run biome, prettier, or ruff after editing target files:
```bash
#!/usr/bin/env bash
TARGET_FILE="$1"

if [[ "$TARGET_FILE" =~ \.(js|ts|jsx|tsx)$ ]]; then
  npx prettier --write "$TARGET_FILE" >/dev/null 2>&1 || true
fi
```

## Quality Checklist
- [ ] Hook scripts exit with code `0` on success and non-zero on failure.
- [ ] Hook output provides clear, actionable diagnostic messages to the AI agent.
- [ ] Hooks execute quickly (< 500ms) to avoid lagging agent interactions.
