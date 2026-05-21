# Modelica Agent Workflow Benchmark

**An executable benchmark for evaluating AI agents on agentic Modelica workflows.**

This repository contains the public protocol, schema, scoring notes, and demo tasks for the Modelica Agent Workflow Benchmark v0.1 Preview.

The benchmark evaluates whether an AI agent can work through a Modelica engineering task end to end: inspect a faulty model, edit the Modelica source, run OpenModelica feedback, and submit a final model that passes executable validation.

The official v0.1 evaluation set contains 132 hidden Modelica workflow tasks. The hidden set is not published to reduce benchmark contamination. Public files in this repository document the task format and provide a small demo split for local smoke testing.

## What a Task Looks Like

Each task is a JSON file with:

- `workflow_goal`: what the agent should accomplish;
- `model_name`: the top-level Modelica model to repair;
- `initial_model`: the complete faulty Modelica source;
- `verification`: OpenModelica check/simulation settings;
- `acceptance`: high-level acceptance rules.

The canonical demo task files live in `benchmark/samples/*.json`. For easier reading, the same initial models are mirrored as `.mo` files in `benchmark/samples/modelica/`.

A valid submission is a complete final Modelica model that passes OpenModelica `checkModel` and reaches an accepted simulation status under the task settings.

## Simulation Warning Policy

A clean OpenModelica simulation pass is accepted. A non-fatal warning status is also accepted only when OpenModelica produces a non-empty result file and reports that the simulation finished successfully.

Warnings remain FAIL when they correspond to fatal solver errors, missing result files, failed initialization, division by zero, integrator failure, or any simulation output that does not successfully complete.

## Task Sources and Dependencies

The public demo split is intentionally small and self-contained. All four public demo tasks are standalone Modelica models with no external library dependency.

The hidden official set is broader. It contains standalone tasks, Modelica Standard Library based tasks, and tasks derived from public Modelica libraries. The full hidden task contents and construction metadata are not released.

| split | visibility | dependency types | purpose |
| --- | --- | --- | --- |
| `public_demo` | public | standalone only | format inspection and tooling smoke tests |
| `hidden_official_v0.1` | private | standalone, MSL, public Modelica libraries | official aggregate evaluation |

## Difficulty Buckets

Difficulty is assigned by empirical agent performance and workflow complexity, not by source-code length alone.

| bucket | intended meaning |
| --- | --- |
| easy | Localized repair; useful for checking that an agent can parse the task format, edit Modelica, and complete the OMC loop. |
| medium | Requires more Modelica context, cross-equation consistency, or nontrivial parameter/interface reasoning. |
| hard | Requires deeper workflow search, larger model context, library interaction, simulation-stage debugging, or robust finalization behavior. |

The public demo split includes two easy and two medium tasks. Hard tasks are kept in the hidden official set to preserve evaluation value.

## v0.1 Hidden-Set Snapshot

All agents were evaluated on the same 132-task hidden set under the same benchmark and wall-clock conditions.

| Agent | Total | easy | medium | hard |
| --- | ---: | ---: | ---: | ---: |
| GateForge | 130/132 | 21/21 | 56/56 | 53/55 |
| Claude Code | 123/132 | 21/21 | 55/56 | 47/55 |
| OpenCode | 120/132 | 21/21 | 50/56 | 49/55 |

| Agent | reported tokens* | wall time |
| --- | ---: | ---: |
| GateForge | ~39.7M | ~14,658s |
| Claude Code | ~15.9M | ~35,191s |
| OpenCode | ~66.1M | ~20,843s |

*Reported tokens are runner-reported estimates; GateForge records provider usage directly, while other runners may omit local context management, compression, retries, or tool-output handling costs.

## Public Demo Tasks

| task | difficulty | dependency | model | task JSON | readable model |
| --- | --- | --- | --- | --- | --- |
| `demo_001` | easy | standalone | `ThermalZone_v0` | `benchmark/samples/demo_001.json` | `benchmark/samples/modelica/demo_001_initial.mo` |
| `demo_002` | easy | standalone | `ExciterAVR_v0` | `benchmark/samples/demo_002.json` | `benchmark/samples/modelica/demo_002_initial.mo` |
| `demo_003` | medium | standalone | `SyncMachineSimplified_v0` | `benchmark/samples/demo_003.json` | `benchmark/samples/modelica/demo_003_initial.mo` |
| `demo_004` | medium | standalone | `HydroTurbineGov_v0` | `benchmark/samples/demo_004.json` | `benchmark/samples/modelica/demo_004_initial.mo` |

These demo tasks are not intended to be a leaderboard. They exist to document the task format and let users validate their tooling.

## Repository Layout

```text
benchmark/
  benchmark_card.md
  schema.json
  scoring.md
  samples/
    demo_001.json
    demo_002.json
    demo_003.json
    demo_004.json
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
python3 scripts/score_submission.py benchmark/samples/demo_001.json path/to/submission.json
```

The scoring script checks schema-level requirements only. Official scoring runs OpenModelica checkModel and simulation using the task verification settings and warning policy.

## Hidden Evaluation Policy

The official 132-task set is kept private. Aggregate results may be published, but hidden task contents and construction metadata are not released. This protects the benchmark from rapid training-data contamination.

## License

Code, scripts, schemas, and tooling are licensed under the Apache License 2.0. Benchmark task data and task content are governed by `DATA_LICENSE.md` and may not be used for model training, fine-tuning, distillation, dataset augmentation, or benchmark memorization without prior written permission.

## Data Use Notice

The public demo tasks are provided for benchmark format inspection and local smoke testing. They are not intended for training or benchmark memorization.
