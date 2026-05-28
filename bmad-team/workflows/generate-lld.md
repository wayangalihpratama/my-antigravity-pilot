---
description: Analyze the codebase and generate an initial Low-Level Design (LLD) document under `docs/lld/{feature}_lld.md`.
---

# 🏗️ Generate Initial LLD

Use this workflow when a project lacks comprehensive documentation or when you need to bootstrap a specific LLD under `docs/lld/{feature}_lld.md` with structural insights from the existing codebase.

## Steps

### 1. Research & Official Documentation
- Load the `bmad-architect` skill.
- Perform a **Docs-First** research to identify the best practices for the current stack.
- Check `.agent/rules/` and existing `docs/` for stack-specific context.

### 2. Analyze Core Components
// turbo
- Identify main application entry points.
- Map out the directory structure and module boundaries.
- Extract data schemas (database, API contracts) for the component.

### 3. Draft the LLD
Create `docs/lld/{feature}_lld.md` using this structure:
- **System Summary**: High-level purpose and stack.
- **Module Decomposition**: Breakdown of folders and their responsibilities.
- **Data Architecture**: Schema definitions and flow.
- **Integration Points**: External APIs, services, or webhooks.
- **Security & Safety**: Auth patterns and data protection rules.

### 4. Review for Safety
// turbo
- Verify that the LLD contains NO credentials, API keys, or PII.
- Follow the `docs-standard.md` no-credentials policy.

### 5. Finalize
- Present the generated LLD to the user for approval.
