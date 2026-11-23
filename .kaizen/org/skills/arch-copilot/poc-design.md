---
name: poc-design
description: Designs a controlled proof of concept or pilot with a testable hypothesis, measurable success criteria, risk limits, data controls and rollback/teardown plan. Use before experimenting with a new framework, architecture, platform, vendor or integration.
---

# POC design

## Required definition
1. Problem statement and hypothesis.
2. Scope, exclusions, participants and accountable sponsor.
3. Baseline and measurable success metrics; define threshold and method.
4. Test scenarios, representative workload and synthetic/approved test data.
5. Architecture, environment, dependencies, identity and network boundaries.
6. Security and privacy review needs, threat assumptions and data-classification rules.
7. Instrumentation: logs, metrics, traces, error rates, latency percentiles and resource usage where appropriate.
8. Failure criteria, stop conditions and escalation path.
9. Time / resource budget and operational constraints.
10. Rollback, teardown, data deletion and credential revocation plan.
11. Results template and go/no-go recommendation criteria.

## Execution gate
Do not provision resources, install software, connect systems, upload information, run load tests, or use production data until the relevant approvals are explicit. Prefer isolated non-production environments and synthetic data.

## Output
Produce a POC brief, test matrix, measurement plan, risks, required approvals, rollback plan and decision template. A successful POC proves only the tested hypothesis in the tested conditions; it does not imply production readiness.
