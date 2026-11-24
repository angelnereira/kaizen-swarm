---
name: secure-code-review
description: Reviews code changes for correctness, maintainability, security, dependency and operational risks without modifying code by default. Use for pull requests, diffs, shared libraries, APIs, authentication, authorization, data handling or infrastructure-as-code changes.
---

# Secure code review

## Review procedure
1. Confirm repository guidance, change scope, language/framework versions and review target (diff, commit or branch).
2. Read relevant code paths and tests; understand callers, data flow and trust boundaries.
3. Prioritize findings by exploitability and impact: authentication, authorization, injection, unsafe deserialization, secrets, cryptography, data leakage, SSRF, path traversal, race conditions, resource exhaustion, dependency/supply-chain risk and insecure defaults.
4. Check correctness, edge cases, error handling, concurrency, idempotency, input validation, output encoding and backward compatibility.
5. Check tests, static analysis, dependency scanning and build output when tools are available and authorized.
6. Verify claims against exact code lines and actual tool output. Do not claim a test passed if it was not run.
7. Separate confirmed defects from questions and hardening suggestions.
8. Do not modify code during a review unless the user explicitly asks for a fix.

## Finding format
- Severity and confidence
- File and line range
- What is wrong
- Why it matters / plausible impact
- Conditions required to trigger it
- Suggested remediation
- Evidence / test

## Constraints
- Never copy secrets or confidential code into external services without approval.
- Do not run destructive tests, production scans or load tests without authorization.
- Do not present a generic checklist item as a confirmed vulnerability.
