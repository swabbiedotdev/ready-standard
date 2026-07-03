---
name: ready-tree-maintenance
version: 0.1.0
description: Keep a Ready bundle current as product agents, coding agents, users, and evidence reveal new product truth, gaps, and contradictions.
---

# Ready Tree Maintenance

Use this module whenever work on a product reveals new product truth, missing
truth, contradictions, implementation drift, proof gaps, access gaps, or a
possible new implementation bundle. Maintenance keeps the Ready tree useful as a
source language for future product builds; it is not ticket grooming.

## Responsibilities

- Keep `ready/product/` focused on current intended product truth.
- Keep incomplete or unapproved truth as `status: draft`, a flag, a decision
  flag, or `status: blocked`.
- Keep implementation deltas, coding lifecycle state, and task progress out of
  primitives.
- Ask the user only when the answer materially changes product truth,
  authority, private resources, credentials, business judgment, or irreversible
  scope.
- Use agent judgment only for reversible structure, explicit evidence
  extraction, conservative defaults named as defaults, and safe public or
  generated resources.
- Never fabricate product truth, evidence, user intent, authority, credentials,
  proof, or source provenance.

## Maintenance Triggers

Review and update the Ready tree when any of these happen:

- the user describes a new product promise, workflow, module, quality bar,
  failure behavior, or acceptance proof;
- coding work discovers that existing product truth is missing, ambiguous,
  contradicted by implementation, or too coarse to build cleanly;
- a mockup, screenshot, prototype, fixture, trace, source document, API shape, or
  customer statement becomes relevant to implementation or proof;
- a required service, account, credential, environment, dependency, or setup step
  appears or changes;
- proof fails, proof is missing, or the current proof cases are too vague to
  rebuild the product from scratch;
- a decision, blocker, discrepancy, readiness gate, or proof gap needs durable
  attention;
- a broad intent becomes hard to review or implement because it contains multiple
  independently useful promises.
- an intent still carries legacy `completion_proof`, intent IO fields, or
  `validation_boundary` that need migration into `proof_cases` or non-proof
  intent fields.

If nothing changes product truth, evidence, proof, services, standards,
artifacts, or readiness, do not create records just to summarize activity.

## Create Or Update

Prefer updating an existing record when the new information clarifies the same
stable product promise, premise, standard, service, artifact purpose, or flag.

Create a new intent when the product now has a distinct implementation bundle:

- it has a separable user/system promise or behavior;
- it can be built, proven, accepted, or deferred independently;
- it has its own actor, trigger, end state, surface, operating envelope, or
  proof cases;
- it changes which premises, standards, services, artifacts, or proof corpora
  apply;
- it is a subordinate promise inside a parent intent and should be authored from
  the parent with a `child` ref.

Create a new premise when the reason, risk, need, assumption, belief, or
opportunity is distinct enough that changing it would change intent priority,
scope, proof, or design.

Create a new standard when the new rule is reusable, externally binding,
  security/privacy/accessibility/compliance relevant, or needed to validate more
  than one implementation detail. Do not create a standard for a one-off
  preference that belongs in an intent's operating envelope or proof cases.

Create a new service when an external or separately maintained dependency has
its own readiness, access, proof, setup, credentials, permissions, failure
modes, or simulation policy. Services are things someone else builds,
maintains, operates, or supplies, such as Vercel, Supabase, an LLM provider, a
third-party API, a managed queue, a package, or a deployment target.

Do not create a service for product behavior the team builds or owns. If the
team builds the API route, background job, edge function, schema, prompt flow,
or UI behavior, create or update an intent for that owned behavior and attach
the external platform or provider as a service ref. If a dependency is only a
library choice inside an implementation, keep it out of the Ready tree unless
it is a product constraint or proof dependency.

Create a new artifact descriptor when a piece of evidence, fixture, mockup,
snippet, source reference, manifest, or proof corpus needs a stable id, reusable
purpose, provenance, confidence, or privacy policy. Do not create artifact
descriptors for incidental files that no agent or proof process needs to
address.

Create a flag when the issue is temporary bundle-work state: unresolved choice,
blocker, discrepancy, readiness gate, proposed change, or proof gap. Update or
remove the flag when product truth is resolved.

## Draft, Blocked, Or Ready

Use `status: draft` for primitives that are useful to record but incomplete,
unapproved, low confidence, missing proof, or not yet connected to enough
supporting records. Draft records may help implementation planning, but
orchestrators must warn that a complete product should not be expected.

Use `status: blocked` when a record cannot be built, proven, operated, or
claimed without a blocker being resolved or an explicit override. Records with
non-empty `blocked_by` or `fields.blockers` must use `status: blocked`.

Use `status: ready` only when the record is resolved for its kind, has adequate
evidence or owner judgment, has required relationships, and contains enough
structured content for an agent to use without inventing missing truth.

Flags omit status unless blocked. The existence of a non-blocked flag already
means temporary work remains.

## Ask, Infer, Or Defer

Ask the user when the answer controls:

- product promise, scope, non-scope, priority, or acceptance;
- user, buyer, operator, business model, risk tolerance, or success definition;
- authority, approval, legal/compliance meaning, pricing, brand, or policy;
- private samples, credentials, accounts, data access, or sensitive source
  material;
- whether a blocker may be overridden;
- whether an inferred product direction should become approved product truth.

Use best judgment when the action is safe, reversible, and evidence-grounded:

- choosing a draft id, file location, subtype, title, or relationship shape;
- extracting statements from supplied docs, code, mockups, traces, or tests;
- gathering public resources from authoritative sources;
- generating synthetic fixtures that are clearly labeled synthetic;
- writing conservative defaults that are explicitly marked as defaults,
  assumptions, or draft content;
- cutting redundant or speculative records that do not affect the intended
  product version.

Defer instead of guessing when the missing answer would change product meaning,
proof authority, privacy/security posture, credentials, legal/compliance
behavior, user trust, or implementation scope. Use a decision flag, blocker
flag, proof-gap flag, `status: draft`, or `status: blocked`.

Never fill a field with invented evidence, fake user statements, guessed
approval, guessed credentials, fake URLs, fake command output, fake proof, or
uncited source claims. If a placeholder would mislead a future agent, leave the
field draft, mark the gap, or create a flag.

## Coding Agent Rules

Coding agents may update the Ready tree when implementation reveals product
truth gaps, contradictions, proof gaps, required services, or missing artifacts.
They should:

- preserve the intended target state, not just describe code changes;
- preserve low-noise Ready id references at durable implementation seams when
  the mapping is evident, such as file headers, entrypoints, schema sections,
  test groups, fixture consumers, and proof harnesses;
- attach implementation evidence as artifact descriptors or safe refs when it
  matters to future rebuilds;
- avoid inventing Ready id mappings when code-to-Ready traceability is unclear;
- create discrepancy or proof flags when code and Ready truth diverge;
- ask for clarification before changing product promise, scope, acceptance,
  authority, or private-resource assumptions;
- report blockers instead of silently coding around missing truth;
- avoid treating current implementation as desired product truth without user,
  governance, or evidence support.

Coding agents should not close product decisions, mark product completion, or
promote draft product truth to ready based only on their own implementation.
Ready id references in code are traceability evidence, not proof.

Migrating legacy intent `completion_proof` and IO fields to `proof_cases` is
best-judgment maintenance only when the proof meaning is preserved. Changing
proof meaning, output logic, or acceptance strength is product truth work and
follows the normal approval rules. Flag `completion_proof` is renamed to
`closure_criteria`; it remains a plain closure-criteria string list, not proof
targets.

## Maintenance Loop

1. Read the local `ready/standard/` bundle, root manifest, governance, and
   affected records.
2. Identify what changed: product truth, evidence, proof, services, standards,
   artifacts, or temporary bundle-work state.
3. Decide whether to update an existing record, create a new primitive, create a
   flag, or leave no Ready change.
4. Classify every new or changed assertion as user-stated, evidence-stated,
   code-observed, inferred, generated, public-source, private-source, or
   unresolved.
5. Fill only fields supported by evidence, user input, governance, or explicit
   conservative judgment.
6. Mark incomplete records `draft`; mark blocked records `blocked`; create flags
   for unresolved decisions, blockers, discrepancies, readiness gates, and proof
   gaps.
7. Ask the fewest user questions that materially change product truth or unblock
   private/user-only inputs.
8. Validate ids, vocabulary, refs, statuses, manifest-declared directories,
   proof cases, and closure criteria.
9. Report what changed, what remains draft or blocked, what was inferred, and
   what user input would improve the bundle.

## Completion Check

Maintenance is complete when the Ready tree reflects the current intended
product state as far as safely known, incomplete truth is visibly draft or
blocked, unresolved work is carried by flags, coding agents can distinguish
target state from gaps, and no product truth or evidence has been fabricated.
