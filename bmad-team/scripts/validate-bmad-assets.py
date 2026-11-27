#!/usr/bin/env python3
"""Zero-dependency validator for BMAD v6 rules, skills, workflows, and cfg."""

from pathlib import Path
import re
import sys
from typing import Dict, List, Tuple

LOCAL_LEAK_RE = re.compile(
    r"/(?:U"
    + r"sers|h"
    + r"ome)/(?!username\b)[A-Za-z0-9._-]+|C:\\\\U"
    + r"sers\\\\(?!username\b)"
)
LEGACY_EXEMPT_RULES = {"rule-priority.md"}
REQUIRED_BLOCKED = (
    "chembl-*",
    "cheminformatics-*",
    "uniprot-*",
    "biomolecular-*",
)


def parse_frontmatter(text: str) -> Dict[str, str]:
    """Parse YAML frontmatter block into a flat key-value dictionary."""
    lines = text.splitlines()
    if not lines or lines[0].strip() != "---":
        raise ValueError("Missing YAML frontmatter opening '---'")
    end_idx = None
    for idx in range(1, len(lines)):
        if lines[idx].strip() == "---":
            end_idx = idx
            break
    if end_idx is None:
        raise ValueError("Unclosed YAML frontmatter block")

    data: Dict[str, str] = {}
    for raw in lines[1:end_idx]:
        stripped = raw.strip()
        if not stripped or stripped.startswith("#"):
            continue
        if ":" not in stripped:
            raise ValueError(f"Malformed frontmatter line: {stripped}")
        key, val = stripped.split(":", 1)
        data[key.strip()] = val.strip().strip('"').strip("'")
    return data


def validate_config_yaml(path: Path) -> Dict[str, List[str]]:
    """Validate skills.allowlist and skills.blocklist YAML structure."""
    if not path.is_file():
        raise ValueError(f"Missing config file: {path}")
    sections: Dict[str, List[str]] = {}
    in_skills = False
    current_list = None
    for lineno, raw in enumerate(
        path.read_text(encoding="utf-8").splitlines(), start=1
    ):
        stripped = raw.strip()
        if not stripped or stripped.startswith("#"):
            continue
        if stripped == "skills:":
            in_skills = True
            current_list = None
            continue
        if not in_skills:
            raise ValueError(
                f"Unexpected root key at line {lineno}: {stripped}"
            )
        if stripped in ("allowlist:", "blocklist:"):
            current_list = stripped[:-1]
            sections[current_list] = []
            continue
        if stripped.startswith("- ") and current_list is not None:
            item = stripped[2:].strip().strip('"').strip("'")
            if not item:
                raise ValueError(f"Empty list item at line {lineno}")
            sections[current_list].append(item)
            continue
        raise ValueError(f"Malformed CONFIG.yaml line {lineno}: {stripped}")

    for req in ("allowlist", "blocklist"):
        if req not in sections or not sections[req]:
            raise ValueError(f"Missing or empty skills.{req} in {path}")
    return sections


def check_line_budget(path: Path, max_lines: int) -> int:
    """Return line count if within budget, otherwise raise ValueError."""
    if not path.is_file():
        raise ValueError(f"Missing file for line budget check: {path}")
    count = len(path.read_text(encoding="utf-8").splitlines())
    if count > max_lines:
        raise ValueError(
            f"{path.name} exceeds budget: {count} > {max_lines} lines"
        )
    return count


def scan_local_path_leaks(paths: List[Path]) -> List[Tuple[Path, int, str]]:
    """Return list of (path, line_number, line) containing local host paths."""
    leaks: List[Tuple[Path, int, str]] = []
    for path in paths:
        if not path.is_file():
            continue
        for lineno, line in enumerate(
            path.read_text(encoding="utf-8").splitlines(), start=1
        ):
            if LOCAL_LEAK_RE.search(line):
                leaks.append((path, lineno, line.strip()))
    return leaks


def _collect_markdown_files(root: Path) -> List[Path]:
    """Collect tracked markdown and test files for path-leak scanning."""
    files: List[Path] = []
    for folder in ("bmad-team", "docs/features", "tests"):
        base = root / folder
        if base.is_dir():
            files.extend(sorted(base.rglob("*.md")))
            files.extend(sorted(base.rglob("*.py")))
    for name in ("AGENTS.md", "CLAUDE.md", "README.md", "task.md"):
        candidate = root / name
        if candidate.is_file():
            files.append(candidate)
    return files


def validate_repository(root: Path) -> List[str]:
    """Validate all BMAD v6 integration contracts; return error list."""
    errors: List[str] = []
    bmad = root / "bmad-team"

    for rule in sorted((bmad / "rules").glob("*.md")):
        if rule.name in LEGACY_EXEMPT_RULES:
            continue
        try:
            fm = parse_frontmatter(rule.read_text(encoding="utf-8"))
            if not fm.get("trigger") or not fm.get("description"):
                errors.append(f"{rule.name}: missing trigger/description")
        except ValueError as exc:
            errors.append(f"{rule.name}: {exc}")

    for skill in sorted((bmad / "skills").glob("*/SKILL.md")):
        try:
            fm = parse_frontmatter(skill.read_text(encoding="utf-8"))
            if not fm.get("name") or not fm.get("description"):
                errors.append(f"{skill.parent.name}: missing name/description")
        except ValueError as exc:
            errors.append(f"{skill.parent.name}: {exc}")

    for wf in sorted((bmad / "workflows").glob("*.md")):
        try:
            fm = parse_frontmatter(wf.read_text(encoding="utf-8"))
            if not fm.get("description"):
                errors.append(f"{wf.name}: missing description")
        except ValueError as exc:
            errors.append(f"{wf.name}: {exc}")

    budgets = [
        (bmad / "skills" / "humanizer" / "SKILL.md", 60),
        (bmad / "workflows" / "handoff.md", 45),
    ]
    for path, limit in budgets:
        try:
            check_line_budget(path, limit)
        except ValueError as exc:
            errors.append(str(exc))

    checks = [
        (
            bmad / "rules" / "coding-standards.md",
            ("Decision Ladder", "trigger: model_decision"),
        ),
        (bmad / "skills" / "bmad-reviewer" / "SKILL.md", ("[BLOAT]",)),
        (bmad / "subagents" / "bmad-reviewer.md", ("[BLOAT]",)),
        (bmad / "skills" / "bmad-writer" / "SKILL.md", ("humanizer",)),
        (bmad / "subagents" / "bmad-writer.md", ("humanizer",)),
        (bmad / "workflows" / "6-pr.md", ("humanizer",)),
        (
            bmad / "workflows" / "0-planning.md",
            ("Domain Glossary", "Ambiguity"),
        ),
    ]
    for path, tokens in checks:
        text = path.read_text(encoding="utf-8") if path.is_file() else ""
        for token in tokens:
            if token not in text:
                errors.append(f"{path.name}: missing '{token}'")

    try:
        cfg = validate_config_yaml(bmad / "templates" / "CONFIG.yaml")
        blocked = set(cfg["blocklist"])
        for pattern in REQUIRED_BLOCKED:
            if pattern not in blocked:
                errors.append(f"CONFIG.yaml: missing blocklist '{pattern}'")
    except ValueError as exc:
        errors.append(str(exc))

    for leak_path, lineno, _ in scan_local_path_leaks(
        _collect_markdown_files(root)
    ):
        errors.append(f"Local path leak at {leak_path}:{lineno}")

    return errors


def main() -> int:
    """CLI entrypoint returning 0 on clean pass, 1 on validation errors."""
    root = Path(__file__).resolve().parents[2]
    errors = validate_repository(root)
    if errors:
        for err in errors:
            print(f"[FAIL] {err}", file=sys.stderr)
        return 1
    print("[PASS] All BMAD assets, budgets, and path-leak checks passed.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
