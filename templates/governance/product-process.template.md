# Product Process

Project: `{{PRODUCT_ID}}`

This document defines how product truth is created, changed, approved, and
handed to coding agents for this project.

## Source Of Truth

- Durable product truth lives in `ready/product/`.
- Ready primitives are typed, addressable durable product-bundle inputs.
  Flags use `kind: flag`; they are temporary Ready-bundle records, not
  canonical product truth, tickets, or coding deltas. Governance records,
  settings, and manifests use their own Ready kinds.
- Generated views compile from primitives, flags, artifact primitives,
  governance records, settings, and manifests.
- Chat and local cache are evidence until promoted into the tree.

## Discovery

Start with the product-user problem, need, desire, constraint, or success
condition. Capture premises before solutioning. Preserve unresolved ambiguity as
decision flags or discovery flags.

## Bundle Maintenance

Product and coding agents should update the Ready tree when work reveals new
product truth, missing truth, contradictions, implementation drift, proof gaps,
service or access gaps, or new durable artifacts. Update an existing primitive
when the new information clarifies the same stable promise, premise, rule,
dependency, or artifact purpose. Create a new intent only when there is a
distinct implementation bundle: a separable promise that can be built, proven,
accepted, deferred, or governed independently.

Use `status: draft` for incomplete or unapproved primitives. Use decision,
readiness, discrepancy, blocker, or proof flags for temporary bundle-work state.
Use `status: blocked` when a blocker prevents build, proof, operation, or claim.
Flags omit `status` unless blocked; non-blocked flag state is implied by
`kind: flag`.

Ask the user for product-shaping decisions, private resources, credentials,
authority, approval, risk tolerance, and blocker overrides. Use agent judgment
only for reversible, evidence-backed structure that does not change product
scope, authority, privacy, risk, acceptance, or proof strength. Never fabricate
product truth, user statements, evidence, authority, credentials, source
provenance, command output, or proof.

## Evidence And Resources

Every build-critical intent or service should have proof corpus inputs, expected
outputs, public resources, user-only asks, or explicit blockers. Store safe
resources as artifact descriptors under `ready/product/artifacts/` and
sensitive material as refs.

## Access And Services

Every required service should be an external or separately maintained dependency
the product relies on, such as hosting, storage, auth, a third-party API, or an
LLM provider. Product behavior the team builds or owns remains an intent even
when it runs on that service. Service records should use top-level `status` for
state and name blockers, account owner, access requirements, credential
location reference, evidence, proof required, setup or implementation
instructions, input/output types and samples, off-limits work, simulation
policy, and failure modes. Never commit raw secrets.

## Design And Artifacts

UI or interaction work should have enough mockups, flows, states, copy, assets,
component snippets, or design refs for coding agents to implement faithfully.
Record the design metadata as artifact descriptors; large binaries or
external sources can remain attached payloads or safe refs.

Ready-carried artifacts may become product assets, templates, fixtures, or
manifests, but implementation must copy, transform, or compile those files into
product-owned paths or storage. The running product must not depend on
`ready/settings/` or any Ready directory for runtime artifacts.

## Coding Handoff

Seed and change flags become claimable only when the resolved target-state
handoff, scope, non-scope, required standards, services, artifacts, setup,
samples, expected outputs, intent proof cases, and blocker policy are
clear. A handoff gives coding agents the intended end state plus proof gates,
not a delta or edit instructions. Intent proof cases are the durable Definition
of Done; flag `closure_criteria` is only closure criteria for the temporary
flag.

## Code Traceability

Coding agents should preserve Ready id references at durable implementation
seams when the mapping is evident and low-noise: module or file headers, route
or command entrypoints, schema or migration sections, test files, fixture
consumers, proof harnesses, and implementation evidence. Code comments,
filenames, commits, and evidence support auditability; they do not become
product truth and do not prove completion.

Avoid tagging every function or adding noisy inline comments. When code is
moved, split, deleted, or replaced, update or remove stale Ready id references
in the same change. If the mapping is uncertain, leave code untagged and create
or update a discrepancy, proof, or readiness flag when useful. Product or
maintenance agents may add trace-only references as a reversible maintenance
action when they do not change runtime behavior.

## Review

Product agents close flags only after their recorded closure criteria are
satisfied. Decision flags close when decided and reflected or deferred; blocker
flags close when resolved or explicitly overridden; discrepancy flags close when
reconciled; proof and readiness flags require proof where applicable. Coding
agents attach evidence and request review; they do not decide product
completion.
