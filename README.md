# Modelica Agent Workflow Benchmark

**An executable benchmark for evaluating AI agents on agentic Modelica workflows.**

This repository contains the public protocol, schema, scoring notes, and demo tasks for the Modelica Agent Workflow Benchmark v0.2 Preview.

The benchmark evaluates whether an AI agent can work through a Modelica engineering task end to end: inspect task requirements, edit or generate Modelica source, run OpenModelica feedback, and submit a final model that passes executable validation.

The official evaluation sets are hidden and maintainer-run to reduce benchmark contamination. Public files in this repository document the task format and provide a small demo split for local smoke testing. Public demo tasks are excluded from hidden official scoring.

## Workflow Families

| workflow family | agent input | expected output |
| --- | --- | --- |
| Model Repair | a faulty complete Modelica model | a repaired complete Modelica model |
| Model Generation | requirements for a new Modelica model | a generated complete Modelica model |

## What a Task Looks Like

Each task JSON contains:

- `workflow_goal`: what the agent should accomplish;
- `task_type`: `model_repair` or `model_generation`;
- `model_name`: the expected top-level Modelica model name;
- `initial_model`: the faulty source for repair tasks;
- `requirements`: the model requirements for generation tasks;
- `verification`: OpenModelica check/simulation settings;
- `acceptance`: high-level acceptance rules.

The canonical demo task files live in `benchmark/samples/*.json`. Repair demo initial models are also mirrored as `.mo` files in `benchmark/samples/modelica/` for easier reading.

A valid submission is a complete final Modelica model that passes OpenModelica `checkModel` and reaches an accepted simulation status under the task settings.

## Simulation Warning Policy

A clean OpenModelica simulation pass is accepted. A non-fatal warning status is also accepted only when OpenModelica produces a non-empty result file and reports that the simulation finished successfully.

Warnings remain FAIL when they correspond to fatal solver errors, missing result files, failed initialization, division by zero, integrator failure, or any simulation output that does not successfully complete.

## Task Sources and Dependencies

The public demo split is intentionally small and self-contained. All public demo tasks are standalone Modelica tasks with no external library dependency.

The hidden official sets are broader. They contain standalone tasks, Modelica Standard Library based tasks, and tasks derived from public Modelica libraries such as AixLib, Buildings, IBPSA, OpenIPSL, and TRANSFORM. The full hidden task contents and construction metadata are not released.

| split | visibility | dependency types | purpose |
| --- | --- | --- | --- |
| `public_demo` | public | standalone only | format inspection and tooling smoke tests |
| `hidden_official_v0.1` | private | standalone, MSL, public Modelica libraries | official repair evaluation |
| `hidden_official_v0.2` | private | standalone, MSL, public Modelica libraries | official workflow evaluation |

## Difficulty Buckets

Difficulty is assigned by empirical agent performance and workflow complexity, not by source-code length alone.

| bucket | intended meaning |
| --- | --- |
| easy | Localized task; useful for checking that an agent can parse the task format, edit or generate Modelica, and complete the OMC loop. |
| medium | Requires more Modelica context, cross-equation consistency, or nontrivial parameter/interface reasoning. |
| hard | Requires deeper workflow search, larger model context, library interaction, simulation-stage debugging, or robust finalization behavior. |

The public demo split includes repair and generation examples. Hard tasks are kept in hidden official evaluation to preserve benchmark value.

## Benchmark Snapshot

*Benchmark snapshot as of May 29, 2026.*

All agents use the same foundation model family and are evaluated under the same benchmark and wall-clock conditions. Public demo tasks are excluded from hidden official scoring after release.

### Model Repair

All agents were evaluated on the same 132-task hidden repair set.

| Agent | Total | easy | medium | hard |
| --- | ---: | ---: | ---: | ---: |
| GateForge | 130/132 | 21/21 | 56/56 | 53/55 |
| Claude Code | 123/132 | 21/21 | 55/56 | 47/55 |
| OpenCode | 120/132 | 21/21 | 50/56 | 49/55 |

GateForge beats both baselines: executing faster with fewer tokens than OpenCode, and finishing quicker with a higher success rate than Claude Code.

| Agent | reported tokens* | wall time |
| --- | ---: | ---: |
| GateForge | ~39.7M | ~14,658s |
| Claude Code | ~15.9M | ~35,191s |
| OpenCode | ~66.1M | ~20,843s |

### Model Generation

All agents were evaluated on the same 22-task private generation benchmark snapshot.

| Agent | Total | easy | medium | hard |
| --- | ---: | ---: | ---: | ---: |
| GateForge | 21/22 | 2/2 | 10/10 | 9/10 |
| Claude Code | 19/22 | 2/2 | 10/10 | 7/10 |
| OpenCode | 18/22 | 2/2 | 10/10 | 6/10 |

GateForge leads the generation benchmark while using fewer reported tokens and less wall time than both baselines.

| Agent | reported tokens* | wall time |
| --- | ---: | ---: |
| GateForge | ~1.31M | ~1,343s |
| Claude Code | ~1.57M | ~4,474s |
| OpenCode | ~9.81M | ~3,693s |

*Reported tokens are runner-reported estimates. GateForge records provider usage directly, while other runners may include or omit local context management, compression, retries, and tool-output handling costs.

## Evaluation Isolation

Official evaluation runs each task in a fresh agent session and isolated workspace. Agents must not carry conversation history, scratchpads, repaired candidates, task observations, or tool state from one task to another. Read-only infrastructure caches, such as container images and Modelica library caches, may be reused when they do not expose task content.

## Public Demo Tasks

| task | type | difficulty | dependency | model | task JSON | readable model |
| --- | --- | --- | --- | --- | --- | --- |
| `demo_001` | Model Repair | easy | standalone | `ThermalZone_v0` | `benchmark/samples/demo_001.json` | `benchmark/samples/modelica/demo_001_initial.mo` |
| `demo_002` | Model Repair | easy | standalone | `ExciterAVR_v0` | `benchmark/samples/demo_002.json` | `benchmark/samples/modelica/demo_002_initial.mo` |
| `demo_003` | Model Repair | medium | standalone | `SyncMachineSimplified_v0` | `benchmark/samples/demo_003.json` | `benchmark/samples/modelica/demo_003_initial.mo` |
| `demo_004` | Model Repair | medium | standalone | `HydroTurbineGov_v0` | `benchmark/samples/demo_004.json` | `benchmark/samples/modelica/demo_004_initial.mo` |
| `demo_gen_001` | Model Generation | easy | standalone | `WorkflowV02_GenRCCharge` | `benchmark/samples/demo_gen_001.json` | n/a |
| `demo_gen_002` | Model Generation | medium | standalone | `WorkflowV02_MediumGenThermalChain` | `benchmark/samples/demo_gen_002.json` | n/a |

These demo tasks are not intended to be a leaderboard. They exist to document the task format and let users validate their tooling.

## Repository Layout

```text
benchmark/
  benchmark_card.md
  schema.json
  scoring.md
  submission.md
  samples/
    demo_001.json
    demo_002.json
    demo_003.json
    demo_004.json
    demo_gen_001.json
    demo_gen_002.json
    modelica/
      demo_001_initial.mo
      demo_002_initial.mo
      demo_003_initial.mo
      demo_004_initial.mo
scripts/
  validate_sample.py
  score_submission.py
```

## Basic Validation

Validate public sample files:

```bash
python3 scripts/validate_sample.py benchmark/samples/demo_001.json
python3 scripts/validate_sample.py benchmark/samples/*.json
```

Validate a submission JSON against a task JSON:

```bash
python3 scripts/score_submission.py benchmark/samples/demo_gen_001.json path/to/submission.json
```

The scoring script checks schema-level requirements only. Official scoring runs OpenModelica checkModel and simulation using the task verification settings and warning policy.

## Submission Interfaces

The benchmark supports three public submission interfaces:

- `prediction_jsonl`: submit precomputed final Modelica models;
- `agent_command`: run an agent command in one fresh workspace per task;
- `agent_docker_image`: run a containerized agent with only the current task workspace mounted.

See `benchmark/submission.md` for the full submission spec.

## Official Evaluation Access

The public demo split can be run locally for format checks, tooling smoke tests, and submission preparation. It is not an official leaderboard split.

For official evaluation, participants may provide a prediction JSONL file, an agent command, or a Docker image following `benchmark/submission.md`. The maintainers run the controlled evaluator and return a public-safe aggregate report.

The hidden tasks, hidden-set keys, and evaluator backend are not distributed. This protects the benchmark from leakage and training-data contamination.

## Hidden Evaluation Policy

Hidden official sets are kept private. Aggregate results may be published, but hidden task contents and construction metadata are not released. Public demo tasks are excluded from hidden official scoring.

## License

Code, scripts, schemas, and tooling are licensed under the Apache License 2.0. Benchmark task data and task content are governed by `DATA_LICENSE.md` and may not be used for model training, fine-tuning, distillation, dataset augmentation, or benchmark memorization without prior written permission.

## Data Use Notice

The public demo tasks are provided for benchmark format inspection and local smoke testing. They are not intended for training or benchmark memorization.
