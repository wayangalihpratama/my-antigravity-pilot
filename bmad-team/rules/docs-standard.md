---
trigger: always_on
description: Standardizes the split between local agent_docs/ and git-tracked docs/ directories.
---

## Documentation Standard

## Documentation Standard

Documentation is strictly streamlined to minimize overhead and document clutter. We rely on the git-tracked `docs/` directory for system designs, and a single local `task.md` file for task checklists:

### Local Coordination (Not in Git)
- **`task.md`**: Created in the workspace root for step-by-step checklist tracking during implementation. This is the only local execution document needed. No other local tracking folders (like `agent_docs/`) should be created.
- **`spike_notes.md`** (optional): Root-level gitignored file used to temporarily log details during Spike Mode prototyping.

### `docs/` — Shared Project Documentation (IN git)

The versioned source of truth for all developers, agents, and stakeholders. Structured in subdirectories:

```
docs/
├── architecture_map.md       # Living global system overview & module registry
├── product_brief.md          # Alternative/Override Product Brief (if present, always respect)
├── api_contract.md           # API JSON Contract specification (if present, always respect)
├── briefs/                   # Product Briefs (1 per product or major release)
│   └── product_v2_brief.md
├── prd/                      # Product Requirements Documents (1 per initiative/epic)
│   └── agent_memory_prd.md
└── lld/                      # Low-Level Designs (1 per feature, component, or service)
    ├── tool_schema_validation_lld.md
    └── memory_retrieval_lld.md
```

### System Architecture Map

`docs/architecture_map.md` is a living, global document mapping the overall system modules, shared code locations, main database entities/schemas, and API prefixes. Feature-specific LLDs under `docs/lld/` must reference this map (via Markdown links) for shared components to avoid duplicating schemas and code structures.

### Product Brief & PRD Development

Every new product release or major cycle starts with a Product Brief in `docs/briefs/`. Once approved, it is translated by the PM into one or more initiative-level PRDs under `docs/prd/`. These documents must be reviewed and approved before LLDs or development begins. If a `product_brief.md` is available directly under the `docs/` folder, it must always be respected and followed as the primary product brief/source of truth.

### LLD (Low-Level Design) Development

Every feature, component, or service listed in a PRD must have its own dedicated LLD file under `docs/lld/{feature}_lld.md` following the template in `bmad-team/templates/LLD.md`. The LLD is the technical blueprint that must be completed and reviewed before task implementation.

### Spike Mode Documentation

During experimental prototyping spikes, all intermediate notes, schema changes, and API updates are tracked in `agent_docs/spike_notes.md` under the header `## Micro-Retrofit Log`. Developers must log these changes incrementally immediately after completing each subtask or test case. When a spike is ready for production merge, these logged changes are used to create the git-tracked PRD and LLD documents before the merge request can be opened.

### "Dirty LLD" Tagging Standard

If a design constraint is modified mid-sprint, the developer appends a tag to the top of the relevant `docs/lld/{feature}_lld.md` file:
```markdown
<!-- DIRTY_AMENDMENT: [Brief description of change, e.g. Added user_type to USERS table, approved by Winston 2026-05-28] -->
```
This serves as a visual indicator to all other engineers that the LLD is out-of-sync with active code execution. The Tech Writer (`bmad-writer`) is responsible for compiling these tags, updating the LLD specifications, and clearing the tags during Phase 8.

**Git Diff Safety Net Audit**: To safeguard against omitted tags, the Tech Writer MUST execute `git diff origin/main --name-only` at the beginning of the Document phase to systematically discover any undocumented changes in database schemas, model files, or API routes, aligning them before finalizing docs.

### Implementation-Doc Synchronization

> [!IMPORTANT]
> For every completed task, you MUST ensure that all relevant documentation (`docs/lld/{feature}_lld.md`, the corresponding `docs/prd/{initiative}_prd.md`, `docs/architecture_map.md`, `docs/api_contract.md` if present, and `README.md`) is perfectly aligned with the actual implementation.
> 1. **Check Discrepancies**: Look for mismatches in API contracts (such as `docs/api_contract.md` specifications, payloads, types, or endpoints), data models, or feature behavior.
> 2. **Resolve**: Update the documentation if the implementation is correct, or fix the implementation if it deviates from the approved specification or contract. If `docs/api_contract.md` exists, its API structures must be strictly respected.
> 3. **Verify with User**: Explicitly ask the user to confirm the alignment before proceeding to the commit phase.

### No Credentials Policy

> [!CAUTION]
> Files in `docs/` are pushed to the repository. NEVER include:
> - API keys, passwords, or database credentials
> - Private tokens or secrets
> - Personally Identifiable Information (PII)
>
> Use placeholders like `YOUR_API_KEY` or `dbuser_example` in examples.
