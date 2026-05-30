# Benchmark Card: Modelica Agent Workflow Benchmark v0.2 Preview

## Purpose

The Modelica Agent Workflow Benchmark evaluates AI agents on executable Modelica engineering workflows. The v0.2 Preview covers both repair-style tasks and generation-style tasks.

## Workflow Families

| workflow family | agent input | expected output |
| --- | --- | --- |
| Model Repair | a faulty complete Modelica model | a repaired complete Modelica model |
| Model Generation | requirements for a new Modelica model | a generated complete Modelica model |

## Evaluation Object

Each task contains a workflow goal, a target top-level model name, OpenModelica verification settings, and either an `initial_model` for repair tasks or `requirements` for generation tasks.

A valid solution is a complete final Modelica model that passes OpenModelica checkModel and reaches an accepted simulation status under the task settings.

## Simulation Warning Policy

A simulation is accepted when it completes cleanly. A warning status is accepted only when OpenModelica produces a non-empty result file and reports successful simulation completion. Fatal solver errors, missing result files, failed initialization, division by zero, integrator failure, or incomplete simulation output remain FAIL.

## Evaluation Isolation

Official evaluation runs each task in a fresh agent session and isolated workspace. Agents must not reuse conversation history, scratchpads, repaired candidates, task observations, or tool state across tasks. Read-only infrastructure caches, such as container images and Modelica library caches, may be reused only when they do not reveal task content.

## Submission Interfaces

The public submission interfaces are documented in `benchmark/submission.md`. The v0.2 Preview supports prediction JSONL, local agent command, and Docker image submission formats.

## Splits

| split | visibility | purpose |
| --- | --- | --- |
| public_demo | public | format inspection and smoke testing |
| hidden_official_v0.1 | private | official repair evaluation |
| hidden_official_v0.2 | private | official workflow evaluation |

Public demo tasks are excluded from hidden official scoring.

## Task Sources

The public demo split contains standalone Modelica tasks only. Hidden official sets are broader and include standalone tasks, Modelica Standard Library based tasks, and tasks derived from public Modelica libraries such as AixLib, Buildings, IBPSA, OpenIPSL, and TRANSFORM.

## Difficulty Buckets

Difficulty is assigned by empirical agent performance and workflow complexity, not by source-code length alone.

| bucket | intended meaning |
| --- | --- |
| easy | Basic task parsing and OpenModelica workflow completion. |
| medium | Requires more Modelica context, cross-equation consistency, or nontrivial parameter/interface reasoning. |
| hard | Requires deeper workflow search, larger model context, library interaction, simulation-stage debugging, or robust finalization behavior. |

## Non-Goals

The public demo split is not a leaderboard and should not be used to claim broad Modelica Agent capability. Official claims should use hidden-set evaluation.
