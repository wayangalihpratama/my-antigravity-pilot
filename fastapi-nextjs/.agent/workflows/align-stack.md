---
description: Align the copied .agent config to the destination project's real stack, conventions, and feature doc standard.
---

# Align Project Stack

> **Context**: Run from within the **destination project directory** (where BMAD assets were copied via `setup.sh`), NOT from `my-antigravity-pilot`.

## Purpose

After `setup.sh` copies BMAD assets into a project, the `.agent/` config may not match the project's real setup — especially when initiated by another toolchain (Claude, Cursor, Windsurf). This workflow makes BMAD respect what the existing team already decided.

---

## Steps

### 1. Scan for External AI Convention Files (Highest Priority)

Check for existing convention files from other AI toolchains — these **win over BMAD defaults**:

| File | Toolchain |
|------|-----------|
| `CLAUDE.md`, `CLAUDE.local.md` | Claude (Anthropic) |
| `AGENTS.md` | Generic multi-agent |
| `.cursorrules` | Cursor AI |
| `WINDSURF.md` | Windsurf |
| `.github/copilot-instructions.md` | GitHub Copilot |
| `.aider.conf.yml` | Aider |

For each file found, extract: tech stack, coding conventions, architecture decisions, run/test/lint commands, and any "do not do X" rules.

**Report** all files found and their key rules. If none found: "No external AI convention files found — BMAD defaults are authoritative."

### 2. Scan Project Structure

Read to identify the real stack:
- **Dependency manifests**: `package.json`, `composer.json`, `requirements.txt`, `pyproject.toml`, `Pipfile`, `Cargo.toml`, `go.mod`
- **Runners**: `Makefile`, `docker-compose.yml`, `dc.sh`, `justfile`, `.env.example`
- **README**: `README.md` or `README.rst`
- **Existing agent config**: `.agent/rules/`, `.agent/workflows/`

Extract: language/framework, test runner, package manager, how the app runs, env vars, linter/formatter.

### 3. Identify Conflicts and Gaps

Compare Steps 1–2 findings against `.agent/` files. Flag:
- **Conflicts**: external convention says X but BMAD config says Y
- **Gaps**: project reality not mentioned in `.agent/` at all

### 4. Ask for Clarification (If Needed)

For direct conflicts, present them and ask. **Default rule**: external convention files win. Only ask when the conflict is genuinely ambiguous.

### 5. Create / Update `project-context.md`

Create or update `.agent/rules/project-context.md` using the template at `bmad-team/templates/PROJECT_CONTEXT.md`.

> **Re-run Safety**: If the file already exists, **merge** new findings into it — do not overwrite. Append `<!-- last-aligned: YYYY-MM-DD -->`.

### 6. Discover the Project's Feature Documentation Standard

Scan doc directories for existing feature doc patterns:
- `docs/`, `documentation/`, `docs/features/`, `docs/specs/`, `docs/stories/`, `docs/tickets/`, `doc/`, `wiki/`, `.docs/`

For each `.md` found, detect: naming convention, frontmatter fields, section headings, folder structure (in-progress vs done), PRD/LLD references.

**Confidence threshold** (pick 2–3 representative files):
- **3+ consistent** → High confidence; adapt template.
- **1–2 found** → Medium; use them, note "may not be fully representative."
- **0 found** → Keep BMAD defaults. Report: "No existing feature docs found."
- **Inconsistent** → Ask user: "Which file is the standard?"

**Update `.agent/templates/FEATURE_SPEC.md`**: Adapt section headings, naming convention, and file location to match the project's pattern. Preserve BMAD core content (architecture, backend/frontend, verification, estimation) but restructured.

**Update `.agent/rules/documentation-hierarchy.md`**: Set the Feature Spec path/naming to the discovered convention.

**Report** to user: discovered pattern vs BMAD default, and proposed changes.

### 7. Update `.agent/` Configs for Conflicts Only

Update only files that conflict with project standards:
- `4-verify.md` — actual test/lint commands
- `2-implement.md` — correct directory paths
- `5-commit.md` — commit conventions
- `coding-standards.md` — project addendums (do not replace BMAD defaults)
- `bmad-dev/SKILL.md` — real stack and commands

> Only modify files that *conflict*. Leave BMAD defaults that aren't contradicted.

### 8. Configure & Filter Unneeded Agent Skills (Token Optimization)

Strip out unnecessary domain skills (science/medical DBs, mobile frameworks, heavy cloud/BigQuery pipelines) to minimize token consumption per turn:

1. **Check / Create `.agent/config.yaml` (or `.agents/config.yaml`)** from `bmad-team/templates/CONFIG.yaml`.
2. **Align `skills.allowlist`** to match what the detected stack actually needs:
   - Web/Fullstack/Python: `modern-web-guidance`, `managing-python-dependencies`, `uv`, `debugging-protocol`, `add-stack`, `troubleshooting`, `debug-optimize-lcp`, `chrome-devtools`, `a11y-debugging`, `memory-leak-debugging`
   - Mobile: `flutter-*`, `dart-*`, `xcode-*`, `android-*` (only if mobile project)
   - Data Engineering: `gcp-*`, `bigquery-*`, `dataform-*`, `dbt-*` (only if dedicated data pipeline)
3. **Set `skills.blocklist`** to filter out domain categories irrelevant to the stack:
   ```yaml
   skills:
     allowlist:
       - modern-web-guidance
       - managing-python-dependencies
       - uv
       - debugging-protocol
       - add-stack
       - troubleshooting
       - debug-optimize-lcp
       - chrome-devtools
       - a11y-debugging
       - memory-leak-debugging
     blocklist:
       - "flutter-*"
       - "dart-*"
       - "xcode-*"
       - "android-*"
       - "*-database"
       - "alphafold-*"
       - "alphagenome-*"
       - "protein-*"
       - "literature-search-*"
       - "science-skills-*"
       - "scienceskillscommon"
       - "pymol"
       - "gcp-*"
       - "bigquery-*"
       - "dataform-*"
       - "dbt-*"
       - "firebase-*"
   ```
4. **Automatically Reload Cache & Verify**:
   - The agent executing `/align-stack` **MUST automatically run**:
     ```bash
     antigravity reload --clear-cache
     ```
     *(or `agy reload --clear-cache` depending on CLI alias)* to apply the pruned skill set immediately.
   - Run `antigravity status --skills` to verify that blocked skills are eliminated from active context.

### 9. Validate & Report

Sanity check: confirm runtime accessible, test discovery works, dir layout matches `.agent/rules/`, and skills configuration is trimmed and reloaded.

**Summarize**: convention files found, feature doc pattern adapted, `project-context.md` updated, `.agent/config.yaml` skill filters configured, cache cleared/reloaded, workflows aligned, any open decisions for the user.

---

## Completion Criteria

- [ ] External AI convention files scanned; key rules extracted
- [ ] `project-context.md` created/updated in `.agent/rules/`
- [ ] Feature doc directories scanned; naming, location, template discovered
- [ ] `.agent/templates/FEATURE_SPEC.md` adapted to project's feature doc standard
- [ ] `.agent/rules/documentation-hierarchy.md` updated with correct feature spec path
- [ ] `.agent/config.yaml` created/updated with optimized `skills.allowlist` and `skills.blocklist`
- [ ] `antigravity reload --clear-cache` executed to apply skill filtering immediately
- [ ] `.agent/workflows/` updated to project's actual commands
- [ ] No BMAD rule silently overrides project's external conventions
- [ ] Alignment confirmed with the user


