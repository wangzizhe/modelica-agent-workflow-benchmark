# Submission Spec

This document describes the public submission interfaces for the Modelica Agent Workflow Benchmark v0.1 Preview.

The official hidden set is evaluated in a controlled environment. Participants do not receive hidden tasks or hidden-set keys. The evaluator gives an agent one task at a time and scores the submitted final Modelica model with OpenModelica.

## Evaluation Modes

| mode | purpose | input from participant |
| --- | --- | --- |
| `prediction_jsonl` | Evaluate precomputed final model outputs. | A JSONL file with one final model per task. |
| `agent_command` | Evaluate an agent executable in a fresh local workspace. | A command that reads one task JSON and writes one submission JSON. |
| `agent_docker_image` | Evaluate a containerized agent. | A Docker image plus an optional command inside the container. |

Official leaderboard-style evaluation should use `agent_command` or `agent_docker_image`. `prediction_jsonl` is mainly useful for reproducibility checks and controlled comparisons.

## Prediction JSONL

Each line is one JSON object:

```json
{"task_id": "demo_001", "final_model": "model ThermalZone_v0\n  ...\nend ThermalZone_v0;"}
```

Required fields:

- `task_id`: task identifier provided by the evaluator.
- `final_model`: complete final Modelica source code.

Optional compatibility fields:

- `case_id` or `id` may be accepted as task id aliases.
- `model_text` may be accepted as a `final_model` alias.

## Agent Command

The evaluator runs the command in a fresh workspace for each task. The command receives the current task and writes a submission file.

The task JSON contains only the agent-visible task fields: task id, workflow goal, model name, initial model, verification settings, and optional constraints/acceptance notes. It does not include hidden-set provenance, source metadata, construction metadata, or other private evaluator fields.

Environment variables:

| variable | meaning |
| --- | --- |
| `MODELICA_BENCHMARK_TASK_JSON` | Path to the current task JSON. |
| `MODELICA_BENCHMARK_SUBMISSION_JSON` | Path where the agent must write its submission JSON. |
| `MODELICA_BENCHMARK_WORKSPACE` | Path to the case-local workspace. |

The submission file must contain:

```json
{"final_model": "model ... end ...;"}
```

The command working directory is the case-local workspace. If the command references a script, use an absolute path or a command available on `PATH`.

## Docker Image

For containerized agents, the evaluator runs the image with only the current case workspace mounted:

```text
docker run --rm \
  -v <case_workspace>:/workspace \
  -w /workspace \
  -e MODELICA_BENCHMARK_TASK_JSON=/workspace/task.json \
  -e MODELICA_BENCHMARK_SUBMISSION_JSON=/workspace/submission.json \
  -e MODELICA_BENCHMARK_WORKSPACE=/workspace \
  <agent_image> <optional_command>
```

The container must write `/workspace/submission.json`.

The official evaluator does not mount the host home directory, repository root, hidden task bundle, or benchmark keys into the agent container.

## Isolation Policy

Official evaluation uses one fresh agent session per task.

Agents must not carry across tasks:

- conversation history;
- scratchpads;
- repaired candidates;
- task observations;
- tool state;
- task-specific caches.

Read-only infrastructure caches may be reused only when they do not contain task content. Examples include container images and Modelica library caches.

## Scoring

A submission is accepted only when the final model:

1. is complete Modelica source code;
2. declares the expected top-level model;
3. passes OpenModelica `checkModel`;
4. reaches an accepted simulation status under the task settings;
5. preserves the public model interface unless a change is required for validity.

See `benchmark/scoring.md` for the simulation warning policy and failure-stage definitions.

## Reported Metadata

Official reports may include aggregate pass rates, wall time, failure stages, and runner-reported token estimates when available. Public reports do not include hidden task contents, full model outputs, private source metadata, or raw private logs.
