# Benchmark Card: Modelica Agent Workflow Benchmark v0.1 Preview

## Purpose

The Modelica Agent Workflow Benchmark evaluates AI agents on executable Modelica engineering workflows. The v0.1 Preview focuses on repair-style tasks where an agent receives a faulty Modelica model and must produce a valid final Modelica model.

## Evaluation Object

Each task contains:

- a workflow goal;
- a complete initial Modelica model;
- the target top-level model name;
- OpenModelica verification settings.

A valid solution is a complete final Modelica model that passes OpenModelica checkModel and simulation under the task settings.

## Splits

| split | visibility | purpose |
| --- | --- | --- |
| public_demo | public | format inspection and smoke testing |
| hidden_official_v0.1 | private | official aggregate evaluation |

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
