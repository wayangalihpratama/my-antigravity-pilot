---
description: Compact active session state into a <=25-line checkpoint summary to reset context windows cleanly without losing sprint progress.
---

# Session Compaction Handoff (`/handoff`) 📦

## Purpose
Prevent quadratic context-window token growth on long sprints by emitting a deterministic, <= 25-line checkpoint that can bootstrap a fresh session or accompany `/compact`.

---

## Steps

### 1. Gather Verified Workspace State
Inspect read-only:
1. Active branch and working tree: `git status -sb`
2. Sprint progress: `task.md` (`[x]` done vs `[ ]` remaining)
3. Active Feature Specification path under `docs/features/` (or `project-context.md` path)

### 2. Emit <= 25-Line Handoff Packet
Output this exact compact block (never dump raw code or full logs):

```markdown
## 📦 Session Handoff Checkpoint
- **Issue & Branch**: `[#N]` on `feature/N-slug`
- **Feature Spec**: `docs/features/NNN_name_spec.md`
- **Completed**: `T-001, T-002` (verified passing)
- **Next / Active**: `T-003` — [1-line objective + touchpoint paths]
- **Test & Gate Status**: [last test command + pass/coverage metric]
- **Open Decisions / Blockers**: [None or bulleted 1-liners]
- **Resume Command**: `Run /2-implement starting at T-003 using task.md`
```

### 3. Sync `task.md` & Recommend Reset
Ensure `task.md` checkboxes match the packet, then instruct the user to run `/compact` or paste the checkpoint into a fresh chat session.
