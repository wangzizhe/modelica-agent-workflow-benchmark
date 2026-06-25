#!/usr/bin/env python3
from __future__ import annotations

import json
import sys
from pathlib import Path


def main(argv: list[str]) -> int:
    if len(argv) != 3:
        print("usage: score_submission.py TASK.json SUBMISSION.json")
        return 2
    task_path = Path(argv[1])
    submission_path = Path(argv[2])
    task = json.loads(task_path.read_text(encoding="utf-8"))
    submission = json.loads(submission_path.read_text(encoding="utf-8"))
    errors: list[str] = []

    if submission.get("task_id") and submission.get("task_id") != task.get("task_id"):
        errors.append("task_id mismatch")
    if submission.get("model_name") and submission.get("model_name") != task.get("model_name"):
        errors.append("model_name mismatch")

    task_type = task.get("task_type")
    expected_model = str(task.get("model_name") or "")
    if task_type == "model_tuning":
        parameter_set = submission.get("parameter_set")
        if not isinstance(parameter_set, dict) or not parameter_set:
            errors.append("missing parameter_set")
        else:
            allowed = set(task.get("tunable_parameters") or [])
            unknown = sorted(set(parameter_set) - allowed)
            if unknown:
                errors.append(f"parameter_set contains non-tunable parameter(s): {', '.join(unknown)}")
            ranges = task.get("parameter_ranges") or {}
            for name, value in parameter_set.items():
                try:
                    numeric = float(value)
                except (TypeError, ValueError):
                    errors.append(f"parameter {name} is not numeric")
                    continue
                bounds = ranges.get(name)
                if not isinstance(bounds, dict):
                    continue
                if numeric < float(bounds.get("min")) or numeric > float(bounds.get("max")):
                    errors.append(f"parameter {name} is outside the public range")
    else:
        final_model = str(submission.get("final_model") or submission.get("model_text") or "")
        if not final_model.strip():
            errors.append("missing final_model")
        if expected_model and f"model {expected_model}" not in final_model:
            errors.append("final_model does not declare the expected top-level model")
    if errors:
        print(json.dumps({"status": "REVIEW", "errors": errors}, indent=2))
        return 1
    print(json.dumps({"status": "SCHEMA_PASS", "note": "Run OpenModelica for official scoring."}, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))
