---
name: adr-authoring
description: Creates or updates an Architecture Decision Record with context, decision drivers, alternatives, trade-offs, consequences, security, operations, validation and provenance. Use whenever a material technical decision is made or reconsidered.
---

# ADR authoring

1. Read the existing ADR index and nearby decisions to avoid duplicates or conflicts.
2. Define one decision per ADR. Use a stable ID and date.
3. Record the actual context and source-backed constraints; do not retrofit a false rationale.
4. List alternatives genuinely considered and explain why each was accepted or rejected.
5. Record security, privacy, operational, migration, cost and compatibility consequences.
6. Identify the accountable decision owner and approval status. The agent's recommendation is not an approval.
7. Link requirements, projects, systems, repositories, policies and related ADRs.
8. Include evidence and review triggers (version change, incident, scale threshold, policy change).
9. Use `context/schemas/adr-template.md`.

Keep status accurate: `proposed`, `accepted`, `rejected` or `superseded`. Never label a proposal as accepted without evidence of approval.
