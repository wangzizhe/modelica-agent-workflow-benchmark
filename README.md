# Modelica Agent Workflow Benchmark

**An executable benchmark for evaluating AI agents on agentic Modelica workflows.**

This repository contains the public protocol, schema, scoring notes, and demo tasks for the Modelica Agent Workflow Benchmark v0.1 Preview.

The official v0.1 evaluation set contains 132 hidden Modelica workflow tasks. The hidden set is not published to reduce benchmark contamination. Public files in this repository are intended to document the task format and allow smoke testing on a small demo subset.

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

The public demo split contains four standalone Modelica repair tasks:

| task | difficulty | model |
| --- | --- | --- |
| `demo_001` | easy | `ThermalZone_v0` |
| `demo_002` | easy | `ExciterAVR_v0` |
| `demo_003` | medium | `SyncMachineSimplified_v0` |
| `demo_004` | medium | `HydroTurbineGov_v0` |

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

The scoring script checks schema-level requirements only. Official scoring runs OpenModelica checkModel and simulate using the task verification settings.

## Hidden Evaluation Policy

The official 132-task set is kept private. Aggregate results may be published, but hidden task contents and construction metadata are not released. This protects the benchmark from rapid training-data contamination.

## License

Code, scripts, schemas, and tooling are licensed under the Apache License 2.0. Benchmark task data and task content are governed by `DATA_LICENSE.md` and may not be used for model training, fine-tuning, distillation, dataset augmentation, or benchmark memorization without prior written permission.

## Data Use Notice

The public demo tasks are provided for benchmark format inspection and local smoke testing. They are not intended for training or benchmark memorization.
