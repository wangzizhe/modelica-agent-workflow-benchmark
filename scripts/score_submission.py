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
    if submission.get("task_id") != task.get("task_id"):
        errors.append("task_id mismatch")
    if submission.get("model_name") != task.get("model_name"):
        errors.append("model_name mismatch")
    final_model = str(submission.get("final_model") or "")
    if not final_model.strip():
        errors.append("missing final_model")
    if f"model {task.get('model_name')}" not in final_model:
        errors.append("final_model does not declare the expected top-level model")
    if errors:
        print(json.dumps({"status": "REVIEW", "errors": errors}, indent=2))
        return 1
    print(json.dumps({"status": "SCHEMA_PASS", "note": "Run OpenModelica for official scoring."}, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))
