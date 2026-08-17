# Modelica Agent Workflow Benchmark

**An executable benchmark for evaluating AI agents on agentic Modelica workflows.**

This repository contains the public protocol, schema, scoring notes, and demo tasks for the Modelica Agent Workflow Benchmark v0.2 Preview.

The benchmark evaluates whether an AI agent can work through a Modelica engineering task end to end: inspect task requirements, edit, generate, or tune Modelica artifacts, run OpenModelica feedback, and submit a final answer that passes executable validation.

The official evaluation sets are hidden and maintainer-run to reduce benchmark contamination. Public files in this repository document the task format and provide a small demo split for local smoke testing. Public demo tasks are excluded from hidden official scoring.

## Workflow Families

| workflow family | agent input | expected output |
| --- | --- | --- |
| Model Repair | a faulty complete Modelica model | a repaired complete Modelica model |
| Model Generation | requirements for a new Modelica model | a generated complete Modelica model |
| Model Tuning | a complete Modelica model, tunable parameters, and behavior targets | a parameter set and short tuning report |

## What a Task Looks Like

Each task JSON contains:

- `workflow_goal`: what the agent should accomplish;
- `task_type`: `model_repair`, `model_generation`, or `model_tuning`;
- `model_name`: the expected top-level Modelica model name;
- `initial_model`: the faulty source for repair tasks;
- `requirements`: the model requirements for generation tasks;
- `tunable_parameters` and `target_metrics`: the public tuning interface for tuning tasks;
- `verification`: OpenModelica check/simulation settings;
- `acceptance`: high-level acceptance rules.

The canonical demo task files live in `benchmark/samples/*.json`. Repair demo initial models are also mirrored as `.mo` files in `benchmark/samples/modelica_models/` for easier reading.

A valid repair or generation submission is a complete final Modelica model that passes OpenModelica `checkModel` and reaches an accepted simulation status under the task settings. A valid tuning submission is a parameter set that keeps the model executable and satisfies the task behavior targets under the same OpenModelica validation policy.

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

The public demo split includes repair, generation, and tuning examples. Hard tasks are kept in hidden official evaluation to preserve benchmark value.

## Benchmark Snapshot

*Benchmark snapshot as of August 17, 2026.*

Each comparison uses the same backend model for Pufibara and Claude Code. Public demo tasks are excluded from hidden official scoring.

### Backend: DeepSeek v4 Flash

#### Model Repair

| Agent | Total | Easy | Medium | Hard | Pass rate | Tokens | Runtime |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **Pufibara** | **130/132** | 21/21 | 56/56 | 53/55 | **98.48%** | **39.8M** | **4.07h** |
| Claude Code | 124/132 | 21/21 | 56/56 | 47/55 | 93.94% | 227M | 9.78h |

Pufibara vs Claude Code: **Pass rate ↑ 4.8% · Tokens ↓ 82.5% · Runtime ↓ 58.4%**

#### Model Generation

| Agent | Total | Easy | Medium | Hard | Pass rate | Tokens | Runtime |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **Pufibara** | **35/50** | 2/2 | 10/10 | 23/38 | **70.00%** | **17.0M** | **2.34h** |
| Claude Code | 27/50 | 2/2 | 10/10 | 15/38 | 54.00% | 81.1M | 2.49h |

Pufibara vs Claude Code: **Pass rate ↑ 29.6% · Tokens ↓ 79.0% · Runtime ↓ 6.1%**

#### Model Tuning

| Agent | Total | Easy | Medium | Hard | Pass rate | Tokens | Runtime |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **Pufibara** | **37/50** | 4/4 | 24/24 | 9/22 | **74.00%** | **22.9M** | **3.56h** |
| Claude Code | 34/50 | 4/4 | 23/24 | 7/22 | 68.00% | 111.6M | 6.96h |

Pufibara vs Claude Code: **Pass rate ↑ 8.8% · Tokens ↓ 79.5% · Runtime ↓ 48.8%**

### Backend: Sonnet 5

#### Model Repair

| Agent | Total | Easy | Medium | Hard | Pass rate | Tokens | Runtime |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **Pufibara** | **131/132** | 21/21 | 56/56 | 54/55 | **99.24%** | **36.2M** | **3.68h** |
| Claude Code | 125/132 | 21/21 | 56/56 | 48/55 | 94.70% | 177.7M | 8.76h |

Pufibara vs Claude Code: **Pass rate ↑ 4.8% · Tokens ↓ 79.6% · Runtime ↓ 58.1%**

#### Model Generation

| Agent | Total | Easy | Medium | Hard | Pass rate | Tokens | Runtime |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **Pufibara** | **32/50** | 2/2 | 10/10 | 20/38 | **64.00%** | **13.6M** | **2.73h** |
| Claude Code | 26/50 | 2/2 | 10/10 | 14/38 | 52.00% | 77.1M | 2.91h |

Pufibara vs Claude Code: **Pass rate ↑ 23.1% · Tokens ↓ 82.4% · Runtime ↓ 6.3%**

#### Model Tuning

| Agent | Total | Easy | Medium | Hard | Pass rate | Tokens | Runtime |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **Pufibara** | **39/50** | 4/4 | 24/24 | 11/22 | **78.00%** | **20.5M** | **5.12h** |
| Claude Code | 36/50 | 4/4 | 24/24 | 8/22 | 72.00% | 86.7M | 10.43h |

Pufibara vs Claude Code: **Pass rate ↑ 8.3% · Tokens ↓ 76.4% · Runtime ↓ 51.0%**

*Metrics use relative pass-rate improvement, matched logical-token accounting, and sequential runtime excluding infrastructure-only attempts.*

Across these benchmark runs, Pufibara's prompt-cache management achieved a **90%–93% cache hit rate**, enabling efficient context reuse across long-running Modelica workflows.

## Evaluation Isolation

Official evaluation runs each task in a fresh agent session and isolated workspace. Agents must not carry conversation history, scratchpads, repaired candidates, task observations, or tool state from one task to another. Read-only infrastructure caches, such as container images and Modelica library caches, may be reused when they do not expose task content.

## Public Demo Tasks

| task | type | difficulty | dependency | model | task JSON | readable model |
| --- | --- | --- | --- | --- | --- | --- |
| `demo_repair_001` | Model Repair | easy | standalone | `ThermalZone_v0` | `benchmark/samples/demo_repair_001.json` | `benchmark/samples/modelica_models/demo_repair_001_initial.mo` |
| `demo_repair_002` | Model Repair | easy | standalone | `ExciterAVR_v0` | `benchmark/samples/demo_repair_002.json` | `benchmark/samples/modelica_models/demo_repair_002_initial.mo` |
| `demo_repair_003` | Model Repair | medium | standalone | `SyncMachineSimplified_v0` | `benchmark/samples/demo_repair_003.json` | `benchmark/samples/modelica_models/demo_repair_003_initial.mo` |
| `demo_repair_004` | Model Repair | medium | standalone | `HydroTurbineGov_v0` | `benchmark/samples/demo_repair_004.json` | `benchmark/samples/modelica_models/demo_repair_004_initial.mo` |
| `demo_generation_001` | Model Generation | easy | standalone | `WorkflowV02_GenRCCharge` | `benchmark/samples/demo_generation_001.json` | n/a |
| `demo_generation_002` | Model Generation | medium | standalone | `WorkflowV02_MediumGenThermalChain` | `benchmark/samples/demo_generation_002.json` | n/a |
| `demo_tuning_001` | Model Tuning | easy | standalone | `WorkflowV02_TuneRLDemo` | `benchmark/samples/demo_tuning_001.json` | `benchmark/samples/modelica_models/demo_tuning_001_initial.mo` |

These demo tasks are not intended to be a leaderboard. They exist to document the task format and let users validate their tooling.

## Repository Layout

```text
benchmark/
  benchmark_card.md
  schema.json
  scoring.md
  submission.md
  samples/
    demo_repair_001.json
    demo_repair_002.json
    demo_repair_003.json
    demo_repair_004.json
    demo_generation_001.json
    demo_generation_002.json
    demo_tuning_001.json
    modelica_models/
      demo_repair_001_initial.mo
      demo_repair_002_initial.mo
      demo_repair_003_initial.mo
      demo_repair_004_initial.mo
      demo_tuning_001_initial.mo
scripts/
  validate_sample.py
  score_submission.py
```

## Basic Validation

Validate public sample files:

```bash
python3 scripts/validate_sample.py benchmark/samples/demo_repair_001.json
python3 scripts/validate_sample.py benchmark/samples/*.json
```

Validate a submission JSON against a task JSON:

```bash
python3 scripts/score_submission.py benchmark/samples/demo_generation_001.json path/to/submission.json
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
