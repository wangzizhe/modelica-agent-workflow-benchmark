#!/usr/bin/env python3
from __future__ import annotations

import json
import sys
from pathlib import Path

REQUIRED = {
    "task_id",
    "benchmark",
    "benchmark_version",
    "split",
    "task_type",
    "difficulty",
    "model_name",
    "workflow_goal",
    "initial_model",
    "verification",
    "acceptance",
}


def validate(path: Path) -> list[str]:
    errors: list[str] = []
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except Exception as exc:
        return [f"{path}: invalid JSON: {exc}"]
    missing = sorted(REQUIRED - set(data))
    if missing:
        errors.append(f"{path}: missing keys: {', '.join(missing)}")
    if data.get("benchmark") != "Modelica Agent Workflow Benchmark":
        errors.append(f"{path}: benchmark must be Modelica Agent Workflow Benchmark")
    if data.get("split") != "public_demo":
        errors.append(f"{path}: public samples must use split=public_demo")
    if data.get("task_type") != "modelica_repair":
        errors.append(f"{path}: unsupported task_type")
    if data.get("difficulty") not in {"easy", "medium", "hard"}:
        errors.append(f"{path}: invalid difficulty")
    if not str(data.get("model_name") or "").strip():
        errors.append(f"{path}: empty model_name")
    if "model " not in str(data.get("initial_model") or ""):
        errors.append(f"{path}: initial_model does not look like Modelica source")
    verification = data.get("verification") or {}
    if verification.get("tool") != "OpenModelica":
        errors.append(f"{path}: verification.tool must be OpenModelica")
    simulate = verification.get("simulate") or {}
    if "stop_time" not in simulate or "intervals" not in simulate:
        errors.append(f"{path}: verification.simulate requires stop_time and intervals")
    return errors


def main(argv: list[str]) -> int:
    if len(argv) < 2:
        print("usage: validate_sample.py SAMPLE.json [...]")
        return 2
    all_errors: list[str] = []
    for item in argv[1:]:
        all_errors.extend(validate(Path(item)))
    if all_errors:
        for error in all_errors:
            print(error)
        return 1
    print(f"validated {len(argv) - 1} sample(s)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))
