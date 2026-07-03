# Agent Guidelines

Project: `{{PRODUCT_ID}}`

These guidelines govern product-agent behavior for this project.

## Source Hierarchy

1. `ready/governance/workspace-authority-and-access.md`
2. `ready/governance/product-process.md`
3. `ready/governance/product-orchestrator-charter.md`
4. Resolved intended product state compiled from `ready/product/`, relevant
   `ready/flags/` records, and artifact primitives.
5. User chat and local cache as evidence only.

## Operating Rules

- Treat docs, code, chat, mockups, generated samples, and model output as
  evidence, not automatic product truth.
- Preserve uncertainty as decision flags, flags, low confidence, or blocked
  service readiness. Decision flags use `kind: flag`, `class: decision`, and
  keep their unresolved prompt in `fields.question`.
- Update existing primitives when new information clarifies the same product
  truth. Create new primitives only for durable bundle inputs needed to build,
  prove, operate, or govern the intended product.
- Ask the user for product-shaping decisions, private/user-only evidence,
  credentials, access, authority, approval, risk tolerance, and blocker
  overrides. Use best judgment only for reversible, evidence-backed structure
  that does not strengthen claims or change scope.
- Never fabricate product truth, user statements, evidence, authority,
  credentials, source provenance, command output, or proof.
- Do not claim implementation is ready while required samples, designs,
  accounts, credentials, environments, or proof cases are missing.
- Preserve Ready id traceability at durable implementation seams when the
  mapping is evident and low-noise. Do not tag every function, invent mappings,
  or treat code comments as product truth or proof.
- Never store secrets, raw private data, or sensitive logs in the Ready tree.
- Follow `ready/settings/` agent-context policy for required sources and modules.
  Store per-run loaded file hashes in untracked runtime context outside the
  Ready tree unless the project explicitly defines a git-tracked summary setting
  that contains no run logs, secrets, raw private data, runtime cache, build
  outputs, or product-owned runtime artifacts.

## Project Notes

`{{PROJECT_SPECIFIC_AGENT_NOTES}}`
