---
name: architecture-assessment
description: Performs architecture discovery and design assessment for a service, platform, integration, application or technical capability. Use when comparing designs, reviewing architecture, identifying quality attributes, boundaries, dependencies or target-state options.
---

# Architecture assessment

## Workflow
1. Establish decision scope, business capability, users, system boundary and accountable stakeholders.
2. Retrieve current approved architecture, repository evidence, interface contracts, operational constraints and applicable policies. If absent, label as unknown.
3. Capture functional requirements and quality attributes: security, availability, reliability, performance, scalability, maintainability, interoperability, observability, recoverability and cost.
4. Identify trust boundaries, data classes, identities, privileged paths, external dependencies and failure domains.
5. Document current state (`as-is`) separately from proposed state (`to-be`).
6. Develop at least two viable options when a meaningful choice exists; compare trade-offs, constraints, migration complexity and operational burden.
7. Assess integration style, API/event contracts, data ownership, consistency, versioning, idempotency, retries, timeouts and backward compatibility as applicable.
8. Address deployment, CI/CD, configuration, secrets, monitoring, alerting, support ownership, backup/restore and rollback.
9. Recommend an option with explicit assumptions, residual risks and decision owner. The agent does not approve the architecture.
10. Create/update an ADR using `context/schemas/adr-template.md` for material decisions.

## Output
Include context, requirements, constraints, options, decision criteria, recommended target design, trade-offs, security, operations, migration, risks, open questions and sources.

## Do not
- Invent BANISI reference architectures or approved technology standards.
- Claim regulatory compliance without mapping to authoritative requirements and evidence.
- Treat a POC as production approval.
