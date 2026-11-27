"""Unit and integration tests for bmad-team/scripts/validate-bmad-assets."""

import importlib.util
from pathlib import Path
import tempfile
import unittest

REPO_ROOT = Path(__file__).resolve().parents[1]
SCRIPT_PATH = REPO_ROOT / "bmad-team" / "scripts" / "validate-bmad-assets.py"


def _load_validator():
    """Load hyphenated validator script as a Python module."""
    spec = importlib.util.spec_from_file_location(
        "validate_bmad_assets", SCRIPT_PATH
    )
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


validator = _load_validator()


class ValidatorUnitTests(unittest.TestCase):
    """Unit tests covering pure helper functions and error paths."""

    def test_parse_frontmatter_valid(self) -> None:
        raw = "---\nname: demo\ndescription: \"Hello\"\n---\n# Body\n"
        parsed = validator.parse_frontmatter(raw)
        self.assertEqual(parsed["name"], "demo")
        self.assertEqual(parsed["description"], "Hello")

    def test_parse_frontmatter_errors(self) -> None:
        with self.assertRaises(ValueError):
            validator.parse_frontmatter("# No frontmatter\n")
        with self.assertRaises(ValueError):
            validator.parse_frontmatter("---\nname: unclosed\n")
        with self.assertRaises(ValueError):
            validator.parse_frontmatter("---\nbadline\n---\n")

    def test_validate_config_yaml_valid_and_invalid(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            cfg = Path(tmp) / "CONFIG.yaml"
            cfg.write_text(
                "skills:\n  allowlist:\n    - uv\n"
                "  blocklist:\n    - \"chembl-*\"\n",
                encoding="utf-8",
            )
            parsed = validator.validate_config_yaml(cfg)
            self.assertEqual(parsed["allowlist"], ["uv"])
            self.assertEqual(parsed["blocklist"], ["chembl-*"])

            bad = Path(tmp) / "bad.yaml"
            bad.write_text("skills:\n  allowlist:\n    - uv\n", "utf-8")
            with self.assertRaises(ValueError):
                validator.validate_config_yaml(bad)

            broken = Path(tmp) / "broken.yaml"
            broken.write_text("other:\n  - x\n", encoding="utf-8")
            with self.assertRaises(ValueError):
                validator.validate_config_yaml(broken)

            empty = Path(tmp) / "empty.yaml"
            empty.write_text(
                "skills:\n  allowlist:\n    - \n", encoding="utf-8"
            )
            with self.assertRaises(ValueError):
                validator.validate_config_yaml(empty)

            with self.assertRaises(ValueError):
                validator.validate_config_yaml(Path(tmp) / "missing.yaml")

    def test_check_line_budget(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            sample = Path(tmp) / "sample.md"
            sample.write_text("a\nb\nc\n", encoding="utf-8")
            self.assertEqual(validator.check_line_budget(sample, 3), 3)
            with self.assertRaises(ValueError):
                validator.check_line_budget(sample, 2)
            with self.assertRaises(ValueError):
                validator.check_line_budget(Path(tmp) / "nope.md", 2)

    def test_scan_local_path_leaks(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            clean = Path(tmp) / "clean.md"
            clean.write_text("Use bmad-team/skills/humanizer\n", "utf-8")
            dirty = Path(tmp) / "dirty.md"
            bad_prefix = "/" + "Users" + "/alice/project"
            dirty.write_text(f"Path: {bad_prefix}\n", encoding="utf-8")
            missing = Path(tmp) / "missing.md"
            leaks = validator.scan_local_path_leaks([clean, dirty, missing])
            self.assertEqual(len(leaks), 1)
            self.assertEqual(leaks[0][0], dirty)
            self.assertEqual(leaks[0][1], 1)

    def test_validate_repository_detects_failures(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            for sub in (
                "bmad-team/rules",
                "bmad-team/skills/demo",
                "bmad-team/workflows",
                "bmad-team/templates",
            ):
                (root / sub).mkdir(parents=True)
            (root / "bmad-team/rules/bad.md").write_text("no fm\n", "utf-8")
            (root / "bmad-team/skills/demo/SKILL.md").write_text(
                "---\nname: demo\n---\n", encoding="utf-8"
            )
            (root / "bmad-team/workflows/bad.md").write_text(
                "---\n---\n", encoding="utf-8"
            )
            bad_prefix = "/" + "Users" + "/alice/work"
            (root / "AGENTS.md").write_text(bad_prefix, encoding="utf-8")
            errors = validator.validate_repository(root)
            self.assertTrue(any("bad.md" in e for e in errors))
            self.assertTrue(any("demo" in e for e in errors))
            self.assertTrue(any("Local path leak" in e for e in errors))


class RepositoryIntegrationTests(unittest.TestCase):
    """Live repository assertions matching Issue #26 acceptance criteria."""

    def test_live_repository_integration(self) -> None:
        errors = validator.validate_repository(REPO_ROOT)
        self.assertEqual(errors, [], msg="\n".join(errors))

    def test_cli_main_passes(self) -> None:
        self.assertEqual(validator.main(), 0)


if __name__ == "__main__":
    unittest.main()
