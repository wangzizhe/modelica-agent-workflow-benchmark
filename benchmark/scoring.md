# Scoring

A task is scored as PASS when the submitted final Modelica model satisfies all of the following:

1. The submission is complete Modelica source code.
2. The declared top-level model can be loaded by OpenModelica.
3. `checkModel(model_name)` succeeds.
4. `simulate(model_name, stopTime=..., numberOfIntervals=...)` reaches an accepted simulation status with the task verification settings.
5. The public model interface is preserved unless a change is required to make the model valid.

## Simulation Warning Policy

A simulation is accepted as PASS when it completes cleanly. A warning status is accepted as `warning_pass` only when OpenModelica produces a non-empty result file and reports successful simulation completion.

The following remain FAIL:

- missing or empty result file;
- failed initialization;
- fatal solver errors;
- division by zero;
- integrator failure;
- simulation output without a successful completion message.

## Evaluation Isolation

Official scoring assumes one fresh agent session per task. Cross-task memory, shared conversation context, shared scratchpads, reused candidate repairs, or task-content caches are not allowed. Reusable read-only infrastructure caches are allowed only when they do not contain task-specific content.

For v0.1 Preview, the public scoring script performs schema-level validation only. Official hidden-set scoring is run with OpenModelica.

## Submission Interfaces

Submission formats are documented in `benchmark/submission.md`. Official evaluation may run either precomputed predictions or an agent executable, but each task is still scored by the same OpenModelica acceptance policy.

## Submission Format

```json
{
  "task_id": "demo_001",
  "model_name": "ThermalZone_v0",
  "final_model": "model ThermalZone_v0\n  ...\nend ThermalZone_v0;"
}
```

The final model must be self-contained for standalone demo tasks.
