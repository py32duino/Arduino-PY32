import sys
from pathlib import Path


def read_properties(path: Path, errors: list[str]):
    seen = {}
    properties = []
    for line_no, line in enumerate(path.read_text(encoding="utf-8").splitlines(), 1):
        stripped = line.strip()
        if not stripped or stripped.startswith("#") or "=" not in stripped:
            continue
        key, value = stripped.split("=", 1)
        key = key.strip()
        if key in seen:
            errors.append(f"{path.name}:{line_no}: duplicate key {key} (first seen on line {seen[key]})")
        else:
            seen[key] = line_no
        properties.append((line_no, key, value.strip()))
    return properties


def main() -> int:
    root = Path(__file__).resolve().parents[1]
    errors = []

    boards = read_properties(root / "boards.txt", errors)
    read_properties(root / "platform.txt", errors)
    for line_no, key, value in boards:
        if key.endswith(".build.variant") and not (root / "variants" / value).is_dir():
            errors.append(f"boards.txt:{line_no}: missing variant directory variants/{value}")

    if errors:
        print("\n".join(errors), file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
