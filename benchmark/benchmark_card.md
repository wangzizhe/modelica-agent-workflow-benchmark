# Benchmark Card: Modelica Agent Workflow Benchmark v0.1 Preview

## Purpose

The Modelica Agent Workflow Benchmark evaluates AI agents on executable Modelica engineering workflows. The v0.1 Preview focuses on repair-style tasks where an agent receives a faulty Modelica model and must produce a valid final Modelica model.

## Evaluation Object

Each task contains:

- a workflow goal;
- a complete initial Modelica model;
- the target top-level model name;
- OpenModelica verification settings.

A valid solution is a complete final Modelica model that passes OpenModelica checkModel and reaches an accepted simulation status under the task settings.

## Simulation Warning Policy

A simulation is accepted when it completes cleanly. A warning status is accepted only when OpenModelica produces a non-empty result file and reports successful simulation completion. Fatal solver errors, missing result files, failed initialization, division by zero, integrator failure, or incomplete simulation output remain FAIL.

## Splits

| split | visibility | purpose |
| --- | --- | --- |
| public_demo | public | format inspection and smoke testing |
| hidden_official_v0.1 | private | official aggregate evaluation |

## Task Sources

The public demo split contains standalone Modelica tasks only. The hidden official set is broader and includes standalone tasks, Modelica Standard Library based tasks, and tasks derived from public Modelica libraries.

## Difficulty Buckets

Difficulty is assigned by empirical agent performance and workflow complexity, not by source-code length alone.

| bucket | intended meaning |
| --- | --- |
| easy | Localized repair and basic OpenModelica workflow completion. |
| medium | Requires more Modelica context, cross-equation consistency, or nontrivial parameter/interface reasoning. |
| hard | Requires deeper workflow search, larger model context, library interaction, simulation-stage debugging, or robust finalization behavior. |

## Hidden Official Set

The hidden v0.1 set contains 132 tasks:

| bucket | count |
| --- | ---: |
| easy | 21 |
| medium | 56 |
| hard | 55 |

The hidden set includes Modelica Standard Library, public Modelica libraries, and standalone Modelica examples. Full task contents are not public.

## Non-Goals

The public demo split is not a leaderboard and should not be used to claim broad Modelica Agent capability. Official claims should use hidden-set evaluation.
