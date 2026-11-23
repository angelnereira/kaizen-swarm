---
name: work-task-intake
description: Classifies a work request, identifies applicable role and project context, retrieves evidence, defines deliverables and acceptance criteria, and routes the work to the right specialist skill. Use at the start of non-trivial architecture, engineering, Jira, research or documentation tasks.
---

# Work task intake

## Purpose
Turn an informal request into a bounded, evidence-backed work item without losing the user's intent.

## Workflow
1. Restate the requested outcome in one sentence.
2. Classify scope (`work`, `personal`, or explicitly approved shared), activity type, urgency and expected output.
3. Check `context/manifest.md`; load only relevant context packs. For work involving employer data, read `context/security/ai-use-boundaries.md` first.
4. Inspect repository instructions, current branch/status and relevant docs before proposing code changes. Do not assume the current stack from the general technology register.
5. Identify requirements, constraints, dependencies, stakeholders/approvers, risks, unknowns and data sensitivity.
6. Separate facts from assumptions. For every critical unknown, either find an approved source or state it as unresolved.
7. Define deliverables and acceptance criteria that can be verified.
8. Choose the narrowest specialist skill; do not load unrelated skills.
9. For multi-step work, propose a short plan with checkpoints and required approvals.

## Output
- Objective
- Scope / out of scope
- Evidence and context loaded
- Constraints and risks
- Assumptions / unknowns
- Deliverables and acceptance criteria
- Proposed workflow and approvals

## Do not
- Treat a user request as authorization to access or disclose bank data.
- Create Jira tickets, send messages, deploy, or mutate systems without explicit approval.
- Invent internal policies, ownership, project status or architecture details.
