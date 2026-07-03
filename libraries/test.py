import os
import subprocess
import sys
from pathlib import Path


def main() -> int:
    arduino_cli = os.environ.get("ARDUINO_CLI", "arduino-cli")
    board = os.environ.get("BOARD", "GenF030")
    fqbn = os.environ.get("FQBN", f"PY32Duino:PY32:{board}")
    libraries = Path(__file__).resolve().parent
    failures = []

    for library in sorted(path for path in libraries.iterdir() if path.is_dir()):
        examples = library / "examples"
        if not examples.is_dir():
            continue
        for example in sorted(path for path in examples.iterdir() if path.is_dir()):
            print(f"compile {fqbn}: {example}", flush=True)
            result = subprocess.run(
                [arduino_cli, "compile", "-b", fqbn, str(example)],
                check=False,
            )
            if result.returncode:
                failures.append(example)

    if failures:
        print("\nfailed examples:", file=sys.stderr)
        for example in failures:
            print(f"  {example}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
