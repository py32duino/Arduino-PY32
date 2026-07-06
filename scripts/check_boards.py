import json
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


def property_map(properties):
    return {key: value for _, key, value in properties}


def board_part_entries(properties):
    for line_no, key, value in properties:
        if ".menu.pnum." in key and key.endswith(".build.variant"):
            yield line_no, key.removesuffix(".build.variant"), value


def require_positive_int(values, key, errors):
    value = values.get(key)
    if value is None:
        errors.append(f"boards.txt: missing {key}")
        return
    if not value.isdigit() or int(value) <= 0:
        errors.append(f"boards.txt: {key} must be a positive integer")


def main() -> int:
    root = Path(__file__).resolve().parents[1]
    errors = []

    boards = read_properties(root / "boards.txt", errors)
    platform = read_properties(root / "platform.txt", errors)
    board_values = property_map(boards)
    platform_values = property_map(platform)

    board_parts = {}
    for line_no, prefix, value in board_part_entries(boards):
        if not (root / "variants" / value).is_dir():
            errors.append(f"boards.txt:{line_no}: missing variant directory variants/{value}")
        require_positive_int(board_values, f"{prefix}.upload.maximum_size", errors)
        require_positive_int(board_values, f"{prefix}.upload.maximum_data_size", errors)
        board_parts[prefix] = value

    board_entry_parts = {}
    for entry in (root / "variants").glob("*/*/boards_entry.txt"):
        text = entry.read_text(encoding="utf-8")
        if "_TODO_" in text:
            errors.append(f"{entry.relative_to(root)}: remove _TODO_ placeholder")
        properties = read_properties(entry, errors)
        relative_variant = entry.parent.relative_to(root / "variants").as_posix()
        for line_no, prefix, value in board_part_entries(properties):
            if value != relative_variant:
                errors.append(f"{entry.relative_to(root)}:{line_no}: variant must be {relative_variant}")
            board_entry_parts[prefix] = value

    for prefix, value in sorted(board_parts.items()):
        if board_entry_parts.get(prefix) != value:
            errors.append(f"boards.txt: {prefix} missing from variants/{value}/boards_entry.txt")

    package = json.loads((root / "package" / "package_py32_index.template.json").read_text(encoding="utf-8"))
    package_platform = package["packages"][0]["platforms"][0]
    if package_platform["version"] != platform_values.get("version"):
        errors.append("package_py32_index.template.json: platform version does not match platform.txt")

    if errors:
        print("\n".join(errors), file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
