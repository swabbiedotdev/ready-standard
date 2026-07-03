---
name: ready
version: 0.5.1
description: Lead creation of a Ready product tree from docs, code, or discovery, then make it complete enough for coding agents to build without avoidable blockers.
---

# Ready Skill

Use this skill to create or revise a Ready product tree. The skill is about the
Ready Standard and about acting as a strong product leader: discover the real
problem, shape the smallest useful solution, gather the evidence and resources
needed to build it, identify the services and standards that make it safe, and
cut away what is unnecessary for the intended product version.

This is an orchestration skill. Load specialist Ready Skill modules when the
tree needs focused work:

- [modules/ready-tree-maintenance.md](modules/ready-tree-maintenance.md) -
  ongoing bundle maintenance, draft primitive creation, clarification policy,
  anti-fabrication rules, and code-discovered gaps.
- [modules/evidence-resource-review.md](modules/evidence-resource-review.md) -
  evidence, proof corpora, online resources, generated fixtures, and user-only
  information.
- [modules/access-readiness.md](modules/access-readiness.md) -
  accounts, credentials, environments, secret-location references, and setup
  verification.
- [modules/design-artifact-readiness.md](modules/design-artifact-readiness.md) -
  designs, mockups, screenshots, flows, component specs, and modular UI snippets.
- [modules/coding-handoff-readiness.md](modules/coding-handoff-readiness.md) -
  resolved target-state handoffs, blockers, acceptance proof, and coding-agent
  constraints.
- [modules/perspective-review.md](modules/perspective-review.md) -
  subagent review from psychological, physical, logical, evidence, design, and
  access perspectives.
- [modules/standard-update.md](modules/standard-update.md) -
  sync a newer Ready Standard bundle into a product repo and migrate the tree.

This skill bundle is the portable agent procedure. Product repos that need
deterministic agent edits should keep the full portable standard bundle at
`ready/standard/`; agents read `ready/standard/manifest.yaml` and
`ready/standard/vocabulary.yaml` for authoritative bundle and vocabulary
definitions. Pulling from the source standard repo happens only for explicit
standard-update work.

The Ready Skill does not prescribe internal code files, functions, components,
migrations, or implementation strategy unless those choices are product
constraints, standards, interfaces, artifacts, proof expectations, or user-given
requirements. Its job is to ensure coding agents know exactly what product
outcome to build and have the resources to do it.

## Outputs

The primary output is a `ready/` tree:

```text
ready/
  manifest.yaml
  standard/
    manifest.yaml
    vocabulary.yaml
    skills/
    templates/
  governance/
    agent-guidelines.md
    product-orchestrator-charter.md
    product-process.md
    workspace-authority-and-access.md
  settings/
    product-agent-context.ready.yml
  product/
    manifest.yaml
    README.md
    premises/
    intents/
    standards/
    services/
    artifacts/
      samples/
      resources/
      snippets/
      designs/
      manifests/
  flags/
    decisions/        # optional; declare project flag paths in manifests/policy
    blockers/
    discrepancies/
    readiness/
    proof/
```

The root `manifest.yaml` must declare product, flags, governance, settings, and
standard bundle locations:

```yaml
schema: ready/product-tree-root/v1
kind: manifest
class: product
product: example
source_root: ready
product_directory: ready/product
flags_directory: ready/flags
flag_directories:
  decisions: ready/flags/decisions
  blockers: ready/flags/blockers
  discrepancies: ready/flags/discrepancies
  readiness: ready/flags/readiness
  proof: ready/flags/proof
governance_directory: ready/governance
settings_directory: ready/settings
ready_standard:
  version: "0.5.1"
  repository: "https://github.com/seanbhart/ready-standard"
  package_path: "ready/standard"
  package_manifest: "ready/standard/manifest.yaml"
  docs_source: "https://github.com/seanbhart/ready-standard/tree/0.5.1/docs"
```

Use `ready/settings/` for git-tracked workspace and app settings that help tools
manage the Ready tree. Settings files should use explicit settings schemas,
avoid raw secrets, and not duplicate product truth that belongs in primitives,
governance, artifacts, or flags. Do not store runtime artifacts, build outputs,
uploaded product data, generated product manifests, runtime cache, or
product-owned assets in `ready/settings/`.

Use `ready/product/` for canonical intended product truth for this Ready tree
version, including premises, intents, standards, services, product artifacts,
and reusable proof material that may not be fully implemented yet. Use
`ready/flags/` for temporary bundle-work records: unresolved bundle decisions,
proposed changes, blockers, discrepancies, readiness gates, and proof gaps. File
location is interpreted through the manifest-declared `product_directory` and
`flags_directory`; tools should not infer ownership from undeclared directory
names.

A complete Ready bundle has no flags and no status-bearing records in `draft`
or `blocked`. An orchestrator may try to build an incomplete bundle, but it
must warn first when records are still draft and a complete product should not
be expected. It must not implement a bundle with blockers unless the user or
governing process gives explicit override instructions.

Primitive source records are `.ready.yml` files with:

```yaml
schema: ready/primitive/v1
kind: primitive
id: I-001
class: intent
type: behavior
compiler_role: source_truth
title: Human-readable title
status: draft
fields:
  statement: Concise product-truth statement
refs: []
artifacts: []
owner_notes: []
```

Reader-friendly docs, app views, resolved target-state coding handoffs, tickets,
and briefs compile from the tree. They are not the primitive source of truth.

## Product-Leadership Stance

Act like a product leader, discoverer, and practical unblocker:

- Start with the user's problem, need, desire, constraint, or success condition.
- Separate observed evidence from approved product truth.
- Ask the fewest questions that materially change the tree.
- Assume the user is busy, tired, distracted, or missing context; provide exact
  next steps, examples, and safe options instead of vague requests.
- Proactively gather public resources, generated fixtures, examples, and
  source-shape references when they can fill safe gaps.
- Direct the user only for information, samples, credentials, accounts, business
  judgment, or private resources that cannot be safely obtained another way.
- Preserve uncertainty as decision flags, draft fields, low confidence, or flags.
- Prefer a smaller coherent product version that proves the core promise.
- Cut nice-to-have work until it clearly supports the intended product version.
- Keep implementation details out of primitives unless they are true product
  constraints, interfaces, standards, artifacts, services, or proof expectations.
- Treat the Ready tree on the current branch as the intended product state for
  that branch. Use Git branches or worktrees for substantial hypothetical
  concepts instead of storing speculative fragments in canonical product truth.

Docs, code, conversation, public sources, generated samples, designs, and model
output are evidence. They do not automatically become approved product truth.

## Input Modes

Ready tree creation starts from one of three modes.

### Human Documentation Only

Use this mode when the project has planning docs, specs, decks, notes, issue
lists, design docs, or strategy prose, but no reliable codebase signal.

Process:

1. Inventory the docs and note source age, author intent, and confidence.
2. Extract premise candidates from observations, beliefs, assumptions, needs,
   problems, motivations, risks, opportunities, and success claims.
3. Extract intent candidates from product promises, observable product
   behaviors, workflows, modules, outcomes, capabilities, experiences, safety
   behavior, failure behavior, and requirements.
4. Extract standards from constraints, explicit rules, quality bars, compliance
   needs, measurement rules, and non-negotiable behavior.
5. Extract services from dependencies needed to build, prove, run, or monitor
   the product.
6. Identify missing samples, resources, designs, accounts, credentials, and
   environments needed to make the intended product buildable.
7. Preserve conflicts instead of averaging them.
8. Ask the user to resolve only product-shaping gaps that affect the intended product.
9. Create draft or ready `.ready.yml` primitives with evidence artifact refs
   that carry provenance and confidence.
10. Create flags or decision flags where work is not ready.

Documentation-only trees should be explicit about whether a fact is user-stated,
doc-stated, inferred, stale, generated, gathered from public sources, or
unresolved.

### Codebase Only

Use this mode when the project has code but little or no reliable product
documentation.

Process:

1. Inspect the visible product surfaces: routes, screens, commands, APIs,
   schemas, tests, fixtures, configuration, workflows, README material, design
   assets, and environment examples.
2. Infer what the product currently does.
3. Infer possible actors, outcomes, services, resources, and standards from code
   evidence.
4. Do not assume current behavior is desired behavior.
5. Mark user problems and product motivations as inferred or unknown until the
   user confirms them.
6. Ask questions that connect implementation reality to product truth: who uses
   it, what need it serves, what success looks like, what must not break, what
   resources are missing, what credentials or accounts are needed, and what
   should be cut from the intended product.
7. Create a Ready tree that separates existing behavior from approved direction.
8. Use flags or decision flags for gaps that code cannot answer.

Codebase-only trees should be conservative. They can describe observed behavior
with medium or high evidence confidence, but user need and product priority
usually remain lower confidence until confirmed.

### Ongoing Product Work

Use this mode when a product or coding agent is working in an existing project
and learns something that may change the Ready tree.

Process:

1. Read the local `ready/standard/` bundle, root manifest, governance, and
   affected product records.
2. Decide whether the new information changes intended product truth, evidence,
   proof, services, standards, artifacts, or temporary bundle-work state. If it
   only describes coding progress, do not create a primitive.
3. Update the existing record when the new information clarifies the same stable
   promise, premise, rule, dependency, or artifact purpose.
4. Create a new intent when the product now has a distinct implementation bundle:
   a separable promise that can be built, proven, accepted, deferred, or governed
   independently.
5. Create other primitives only when they are durable inputs needed to build,
   prove, operate, or govern the intended product bundle.
6. Create flags for unresolved choices, blockers, discrepancies, readiness gates,
   proposed changes, and proof gaps.
7. Mark incomplete or unapproved primitives `status: draft`; mark records
   `status: blocked` when blockers prevent build, proof, operation, or claim.
8. Ask the user for product-shaping decisions, private resources, credentials,
   authority, approval, risk tolerance, and blocker overrides.
9. Use best judgment for reversible, evidence-grounded structure: ids, file
   locations, subtypes, titles, relationships, public resources, and synthetic
   fixtures clearly labeled as synthetic.
10. Never fabricate product truth, user statements, evidence, authority,
    credentials, source provenance, command output, or proof. If a field cannot
    be filled safely, keep it draft, create a flag, or ask the user.

Coding agents may maintain the Ready tree when implementation reveals gaps or
contradictions, but they should preserve target-state truth rather than write
implementation deltas. They must not promote product decisions, mark product
completion, or turn current implementation into desired truth without user,
governance, or evidence support.

### From Scratch Discussion

Use this mode when the product is being discovered in conversation.

Process:

1. Understand the situation.
2. Identify the user, buyer, operator, or system actor.
3. Discover the problem, need, desire, motivation, constraint, or success
   condition.
4. Understand current alternatives and why they fail.
5. Shape one or more solution candidates.
6. Choose the smallest coherent intended product version.
7. Cut scope until that product version can prove the core promise.
8. Identify standards, services, artifacts, proof corpora, resources, accounts,
   credentials, designs, and proof expectations.
9. Create the Ready tree and review it with the user.

Ask follow-up questions like a product leader, not a form. Start broad, then
become concrete. When the user seems overloaded, offer a short checklist,
default assumptions, and one or two high-leverage questions.

## Discovery Questions

Use these as a question bank. Do not ask all of them at once.

Problem and need:

- Who has the problem?
- What are they trying to accomplish?
- What is painful, slow, risky, expensive, confusing, or unsatisfying today?
- Why does this matter now?
- How often does it happen?
- What happens if it is not solved?
- What does the user already do instead?
- What emotional, operational, financial, or strategic desire is underneath it?

Success:

- What would make the user say this worked?
- What observable outcome should change?
- What must be true for the product to be trusted?
- What would make the product unacceptable even if it technically works?

Solution:

- What solution shape seems most likely?
- What workflow should the user experience first?
- What should the product decide, automate, reveal, prevent, or simplify?
- What should stay manual for now?
- What should not be built yet?

Resources and evidence:

- What real samples, screenshots, documents, exports, data, examples, or edge
  cases would help a coding agent understand the target?
- Can safe synthetic data prove the workflow, or does this need user-provided
  data?
- Are there public datasets, API docs, marketplace examples, competitor
  references, or source-shape docs that should be gathered and cited?
- What samples are privacy-sensitive, bulky, licensed, stale, or unavailable?
- What is the expected output for each important sample input?

Access and services:

- What external systems, data sources, APIs, people, models, stores, queues, or
  environments are required?
- What accounts must exist before coding starts?
- Where should credentials live so coding agents can access them safely?
- What `.env.example`, `.env.local`, secret manager, CLI login, vault, or
  provider-owned session is required?
- What command or UI check proves the service is usable enough for the intended
  product?

Design and handoff:

- What mockups, flows, screenshots, copy, states, assets, or component specs are
  needed before implementation?
- Does the coding agent need modular prototype code, snippets, fixtures, or
  component contracts?
- Which acceptance proof tells the product lead the coding work is done?

Product version:

- What is the smallest useful coherent product version?
- What does this product version need to prove?
- What can be faked, mocked, manually operated, or deferred without breaking the
  core promise?
- What must be real for the proof to matter?
- What should be removed from scope because it only serves later scale, polish,
  or automation?

## Ready Object Model

Create only the primitives needed to make the intended product legible. A Ready
primitive is a typed, addressable, durable bundle input required to build,
prove, operate, or govern the intended product bundle.

Use `kind` to distinguish Ready object families:

- `primitive`: durable product bundle input.
- `flag`: temporary bundle-work record for unresolved Ready-bundle decisions,
  proposed changes, blockers, discrepancies, readiness gates, and proof gaps.
- `governance`: authority, process, policy, and agent guidance.
- `setting`: git-tracked workspace or app configuration.
- `manifest`: structural bundle metadata.

Primitive records use these classes:

- `premise`: why the product or feature should exist.
- `intent`: what the product promises to do. User-facing views may call an
  intent an implementation bundle.
- `standard`: how the product must be built, measured, judged, or maintained.
- `service`: external or separately maintained things the product depends on to
  build, prove, run, or monitor.
- `artifact`: durable supporting content. The artifact descriptor is the
  primitive; bulky or sensitive payload files are attachments or safe refs.

Use top-level `type` for the subtype valid under that class. Do not write
`primitive_class`, `fields.premise_type`, or `fields.intent_type`.

Intents are the Ready bundle focus points. Premises, standards, services,
artifacts, and flags enhance, constrain, prove, or coordinate intents, but the
Ready Standard is about implementing solutions and intents are the primitives
that define those solutions.

Use intents for product behavior the team builds or owns, regardless of where it
runs. Use services for external or separately maintained dependencies the
product relies on, such as Vercel, Supabase, an LLM provider, a third-party API,
or a managed runtime.

### Product Primitives

Premises:

- Capture why the product or feature should exist.
- Use top-level `type` to clarify the discovery role. Valid values are in
  `ready/standard/vocabulary.yaml`.
- Put constraints, rules, quality bars, compliance needs, and measurement rules
  in `standard` records, not premise records.
- Do not attach services or standards directly to premises. If a service or
  standard seems related to a premise, attach it to the intent that serves the
  premise.
- Link evidence artifacts that carry provenance and confidence.
- Include product implications: what the premise requires, rules out, or
  prioritizes.
- If the premise is not clear enough to support intent work, create a discovery
  flag or decision flag.

Intents:

- Capture product promises.
- Use top-level `type` to clarify the commitment shape. Valid values are in
  `ready/standard/vocabulary.yaml`.
- Keep `statement` concise, then decompose the promise into actor, trigger,
  action, expected end state, value, scope, non-scope, failure behavior,
  claim level, process decision, required surfaces, operating envelope, and
  proof cases.
- Use `claim_level` to name the strongest supported evidence posture, such as
  `concept`, `process_proof`, `simulation_baseline`, `fixture_validated`,
  `human_labeled_validated`, or `production_monitored`. Do not use it as proof
  status.
- Put required services, governing standards, and intent dependencies in `refs`,
  not in duplicate `fields`.
- Author subordinate intent-to-intent decomposition from the parent intent with a
  `child` ref to the subordinate intent. Use `peer` refs for lateral intents that
  coordinate or should be considered together without either intent parenting the
  other.
- Every committed intent should trace to at least one premise unless explicitly
  marked exploratory.
- Quality-bearing or live-variable intents need an operating envelope.

Standards:

- Capture rules for implementation, behavior, measurement, judgment,
  maintenance, safety, privacy, accessibility, and proof.
- Make standards concrete enough to validate.
- Prefer `peer` refs when a standard governs an intent, service, flag, or
  another standard. Do not attach standards directly to premises; route that
  governance through the serving intent. Use `child` standard refs only as
  fallback semantics for an older tree or when a record intentionally nests a
  subordinate standard.
- Avoid vague standards like "make it clean" or "good UX" unless the rule says
  what that means.
- Do not put deferred or future-only rules on ready standards. Use a Ready
  branch or worktree for a coherent alternate future product. Use a flag on the
  current branch only when a decision, blocker, discrepancy, or proof gap needs
  attention.

Services:

- Capture external or separately maintained dependencies required to build,
  prove, run, or monitor the product.
- Do not model owned product behavior as a service merely because it runs on an
  external platform. If the team builds the API route, background job, edge
  function, schema, prompt flow, or UI behavior, model that owned behavior as an
  intent and attach the required external platform or provider as a service ref.
- Put `role` first in service fields and use top-level `status` for readiness
  state.
- Capture blockers, access requirements, credential location, evidence,
  proof required, permissions, setup steps, verification commands, simulation
  policy, input/output types and samples, implementation instructions,
  off-limits work, and failure modes when relevant.

### Flags

Decision flags:

- Capture unresolved product-shaping ambiguity.
- Use them when a decision blocks product truth, proof, service readiness,
  resource readiness, access readiness, design readiness, or coding claim
  readiness.
- When decided, update the affected product records or explicitly defer the
  decision, then remove the unresolved decision flag.

Flags:

- Capture unresolved Ready-bundle decisions, proposed changes, version
  divergence, blockers, drift, proof gaps, claim coordination, and closure
  criteria for bundle truth that is unsatisfied, unproven, or not yet accepted.
- Keep coding readiness out of primitive bodies.
- Flags use `kind: flag`; they are temporary Ready-bundle records, not
  canonical product truth, tickets, or coding deltas.
- Seed and change flags become claimable only after blockers are absent,
  top-level `claimable: true`, top-level `closure_criteria`, and workspace
  policy allow it. Flags omit `status` unless they are blocked.
- Intent `proof_cases` are the durable Definition of Done for rebuilding the
  product. A flag's `closure_criteria` is only the closure criterion for that
  temporary bundle-work record.
- Apps may derive unstored discrepancies by comparing Ready truth to code,
  evidence, generated views, assessments, or prior Ready commits. Store a flag
  when the discrepancy needs durable attention, blocker tracking, claim
  coordination, explicit closure criteria, or review history.

### Artifact Primitives

Artifact descriptors:

- Capture resources, samples, snippets, designs, manifests, screenshots,
  generated views, and handoff material.
- Name provenance, privacy state, freshness, expected use, and linked product
  or proof roles.
- Store large, binary, private, generated, or licensed payloads as attached
  files or safe refs instead of inline product truth.
- May carry source artifacts that the product should persist, but the
  orchestrator must copy, transform, or compile those artifacts into
  product-owned paths or storage. The product must not depend on the Ready tree
  for runtime assets.

### Governance Records

Governance records:

- Capture project authority, product process, and agent behavior.
- Constrain how primitives and flags may be edited, approved, claimed, or
  handed to coding agents.
- Do not store governance in artifact directories.

## Specialist Module Loading

Load modules based on gaps, not ceremony:

- Load ready-tree maintenance whenever an existing Ready tree needs updates from
  product work, coding work, new evidence, implementation drift, draft records,
  clarification questions, or uncertainty about whether to create or update
  records.
- Load evidence-resource review for every nontrivial product tree and any tree with
  missing samples, expected outputs, user-only data, public-source references,
  or resource provenance questions.
- Load access readiness when a service, environment, account, login, API key,
  OAuth app, provider session, CLI auth, or deployment target is required.
- Load design artifact readiness when the product has a UI, user workflow,
  visual review surface, component contract, or customer-facing copy.
- Load coding handoff readiness before making seed or change flags claimable.
- Load perspective review before implementation handoff, after major
  discovery changes, or when confidence is low.
- Load standard update when the user asks to update, upgrade, or migrate a
  product Ready tree to the latest Ready Standard.

For substantial Ready tree creation, use subagents when available. Assign
distinct perspectives instead of duplicating the same review:

- psychological: motivation, trust, fear, desire, adoption, and user emotion;
- physical: real-world environment, devices, time, handoffs, manual steps, and
  operational constraints;
- logic: rules, data, state transitions, edge cases, and failure modes;
- evidence/resources: samples, public sources, generated data, licenses, and
  provenance;
- design: workflows, visual states, interaction details, assets, and component
  handoff;
- access/handoff: accounts, credentials, environments, blockers, proof, and
  coding-agent readiness.

Each subagent should state missing facts, risky assumptions, suggested cuts, and
the exact primitives, artifacts, services, or flags affected.

## Writing Rules

Use `.ready.yml` for `.ready` source records. Primitive records use
`kind: primitive`, a primitive `class`, and a class-specific top-level `type`.
Flags use `kind: flag`, a flag `class`, and a class-specific top-level `type`.
Use specialized Ready schemas such as `ready/artifact/v1` when they are the
clearer machine contract for artifact primitives.

Tree directory rules:

- Use `product_directory` for `ready/product/`.
- Use `flags_directory` for `ready/flags/`.
- Use `settings_directory` for `ready/settings/`.
- Use `governance_directory` for `ready/governance/`.
- Keep canonical intended product truth in `ready/product/`.
- Keep temporary bundle-work records for proposed changes, discrepancies,
  blockers, decisions, readiness gates, and proof gaps in `ready/flags/`.
- Use Git commits, branches, and worktrees for product history, alternatives,
  and substantial hypothetical concepts.

Required primitive fields:

- `schema` (`ready/primitive/v1` by default;
  `ready/artifact/v1` is allowed for artifact primitives)
- `kind: primitive`
- `id`
- `class`
- `type`
- `compiler_role`
- `title`
- `status`
- `fields`
- `refs`

Product/workflow ownership is derived from the record's `kind` and its file
location under the manifest-declared `product_directory` or `flags_directory`.
Settings files under `settings_directory` are not primitive source records.

Do not add root `summary` to primitives. If summary text is truly source data,
it belongs under `fields.summary`; otherwise use the type's primary field.

Use `owner_notes` only for human product-owner annotations that should travel
with the record without becoming product truth. They are not requirements,
evidence, proof cases, closure criteria, or agent instructions. Ignore them for
satisfaction and enforcement; promote anything authoritative into typed
`fields`, `refs`, `artifacts`, or flags.

Premise evidence confidence is derived from linked evidence artifacts, not
stored on the premise. Do not write `fields.evidence_confidence` on premise
records. Every evidence artifact must carry `fields.confidence`; until weighted
evidence is defined, compiled premise confidence is the equal-weight average of
linked evidence artifact confidence values.

Artifact descriptors use `kind: primitive`, `class: artifact`, and `type` for
the specific artifact subtype, not only a broad storage bucket. Common artifact
types include `customer_statement`,
`source_document`, `reference_resource`, `access_reference`, `review_protocol`,
`proof_corpus`, `code_snippet`, `design_artifact`, and `manifest`. Subtype data
belongs under `fields`; do not duplicate it in sibling blocks with local-only
ids.

Every artifact descriptor must carry `fields.confidence`, `fields.provenance`,
`fields.purpose`, `fields.content`, `fields.intended_use`, and
`fields.format`. File-backed descriptors must give every file a `path` and
`role`.

One descriptor records one artifact purpose. A descriptor may list multiple
files only when those files are interchangeable versions or representations of
that same purpose. Files with different purposes, such as
buyer inputs, seller inputs, scoring config, expected scoring outputs, and
diagnostics, need separate descriptors.

Use `proof_corpus` for replayable inputs, configs, expected outputs, diagnostic
outputs, and negative cases used to prove or regress product behavior. Proof
corpus records must state their proof role, authority level, coverage,
dataset contract, oracle policy, replay commands, acceptance contract, and
limitations under `fields`. Do not use proof corpus success as a stronger claim
than its authority level supports.

Proof cases:

- Intent `proof_cases` are the durable Definition of Done. Each proof case has a
  stable `key`, a `kind`, a human-readable `title`, and one or more proof
  `pairs`.
- Proof case and pair keys must match `^[a-z0-9][a-z0-9-]{0,63}$` and be unique
  within their parent scope. Treat keys as append-mostly because evidence
  references them; renaming a key orphans existing evidence links.
- Case `kind` must be one of `unit`, `integration`, `manual`, or `monitored`.
  `unit` means isolated runnable tests over fixtures or pure logic;
  `integration` means runnable tests over services, persistence, or cross-system
  flows; `manual` means human-attached evidence such as reviewed screenshots,
  walkthroughs, or sign-off artifacts; `monitored` means production or
  environment observation over time.
- Each pair names input artifact or service ids and an output contract with
  artifact ids plus `logic`: the rule that determines whether the output proves
  that pair. Do not duplicate artifact labels in the pair; artifact descriptors
  own their labels and content.
- Choose granularity by visible expectations, not fixture rows. Keep one pair
  when a single proof corpus owns the per-row oracle contract; split into
  multiple pairs only when the bundle needs separately visible expectations.
  Create separate cases when the proof `kind` differs or a promise area is
  independently provable; group related pairs under one case for readability.
- Runnable tests bind live results to pairs through runtime test metadata:
  attach `caseKey` and `pairKey` (the intent's case and pair keys, exactly as
  written) to the test framework's assertion metadata — in Vitest,
  `task.meta.readyRoom = { caseKey, pairKey, ... }`. Consuming apps read that
  metadata from the run report to mark pairs passing or failing. Runtime
  metadata and results are display evidence only, never durable product truth,
  and comment citations never drive status.
- A runtime result maps to exactly one proof pair. Do not use default helper
  metadata in a test file that covers multiple pairs; require each tagged test
  or assertion to pass the exact `caseKey` and `pairKey` it proves. If one
  fixture corpus supports several proof pairs, split the checks so each pair
  gets its own result row.
- A tagged test must prove the pair's `logic` using the pair's input and output
  artifacts when those artifacts are the oracle. If the referenced artifacts are
  draft placeholders or only non-runnable contracts, leave the pair unproven
  until a real fixture, hand-reviewed oracle, or integration harness exists.
- When one broad corpus is split into multiple proof cases, split the artifacts
  too. Each proof pair should name input and output artifacts that make the
  exact fixture slice, expected result, and test contract visible without agent
  interpretation. A shared raw corpus may still exist, but proof-specific wrapper
  artifacts should identify which cases and fields belong to each proof.
- Pair satisfaction is derived from linked evidence at read time. Never store
  met/unmet, percentages, or status on the intent, case, or pair.
- Proof evidence must name explicit targets. A `proof_corpus` artifact that
  proves an intent carries `fields.proof_of`, `fields.proof_targets`, and,
  when code-coupled, `fields.git_commit`; `proof_targets` must list at least one
  `{case, pair}` target. There is no catch-all or bundle-level evidence.

Product and workflow records reference supporting artifacts through their own
`artifacts` lists. Artifact descriptors must not keep reverse product/workflow links
such as `linked_primitives`; artifact descriptors may relate to other artifacts
when one artifact depends on, derives from, includes, or carries the other.
Artifact-to-artifact refs may be reciprocal only when each direction is an
independent citation, support, derivation, inclusion, or carrier assertion.

Relationship rules:

- Store relationships in `refs`.
- Store structural roles only: `peer`, `parent`, and `child`.
- In compact refs, the role describes the target record's position relative to
  the current record. `parent` means the target parents the current record;
  `child` means the target is a child of the current record; `peer` means the
  target is lateral.
- If an app needs numeric relationship codes, use `0 = peer`, `1 = parent`,
  and `2 = child`. Source YAML should use the strings.
- Do not store semantic verbs such as `serves`, `requires`, `governed by`,
  `refines`, or `interrupts` as ref roles.
- Derive reader phrases from source kind and class, target kind and class, and structural role.
  The semantic relationship display lookup lives in
  `ready/standard/vocabulary.yaml` and must include source-to-target and
  target-to-source phrases for the same stored edge. For example,
  `intent --parent--> premise` renders as the intent `serves` the premise and
  as the premise is `served by` the intent; `intent --child--> service` renders
  as `requires` / `required by`; `intent --child--> intent` renders as
  `fulfilled by` / `fulfills`; `intent --peer--> intent` renders as
  `coordinates with` in both directions; `intent --peer--> standard` renders as
  `governed by` / `governs`.
- Do not store an inverse ref for the same assertion. Choose one structural edge
  and let views invert parent/child labels when needed.
- Premises should not reference services or standards directly. Services and
  standards apply to implementation-bearing commitments; attach them to the
  intent that serves the premise.
- Artifact descriptors only own artifact-to-artifact relationships. Product and
  workflow records point to artifacts through `artifacts`.
- Reciprocal artifact-to-artifact refs are valid only when both directed edges
  are independently meaningful artifact assertions. Do not add a reciprocal ref
  merely so the target artifact knows about the source artifact.
- Required services and governing standards belong in structural `refs`, not
  duplicated under intent `fields`. Standards usually govern through `peer`
  refs; existing `child` standard refs are retained as fallback display
  semantics.

Lifecycle rules:

- Do not store coding lifecycle state on primitives.
- Update an existing intent when the actor, promise, outcome, proof boundary,
  and failure boundary remain the same. Create a new intent when a new
  independently provable product promise, actor/workflow, module, surface,
  operating envelope, or materially different failure/proof boundary appears.
- Create new non-intent primitives only for durable bundle inputs: premises for
  persistent why/scope pressure; standards for reusable rules or proof bars;
  services for external or separately maintained build/prove/run dependencies;
  artifacts for durable source, proof, design, fixture, snippet, or handoff
  material. Otherwise attach the new information to the nearest existing
  intent, service, standard, or artifact.
- Use `status: draft` for incomplete or not-yet-approved product truth. Use
  decision or discovery flags for unresolved product truth. Use `status:
  blocked` for known blocker lists. Use readiness seed/change flags only when
  target state exists but coding or proof is not claimable yet.
- Ask the user for product-shaping choices, private or user-only evidence,
  credentials/access, approval, authority, one-way-door changes, blocker
  overrides, or any change that would make a claim stronger than evidence
  supports.
- Use best judgment only for reversible, evidence-backed edits that do not
  change product scope, authority, privacy, risk, acceptance, or proof strength.
- Never fabricate product truth, user statements, evidence, authority,
  credentials, source provenance, command output, or proof.
- Use decision flags for unresolved questions and discovery/readiness flags for
  clarification or research gates.
- Seed and change flags are not claimable by default.
- A coding agent should only claim work when the relevant flag is unblocked,
  claimable, and has top-level `closure_criteria`.
- Claimable seed and change flags must carry scope, non-scope, dependencies,
  required standards, required services, required artifacts, setup, acceptance,
  and blocker policy.
- Any record with a non-empty `blocked_by` or `fields.blockers` list must use
  `status: blocked`.
- Blocker flags use `status: blocked` and remain non-claimable.
- Before handoff, validate stable ids, duplicate ids, ref targets, stored ref
  roles, status values, required fields, and manifest-declared directories.
- Warn before implementation when records are still `draft`.
- Do not implement a bundle with `blocked` records
  unless explicit override instructions are present.

Artifact rules:

- Store proof corpora, source-shape resources, snippets, screenshots, mockups,
  manifests, and handoff material as artifact descriptors or as payloads
  referenced by those descriptors.
- If a Ready-carried artifact should persist in the product, copy, transform, or
  compile it into product-owned code, assets, storage, or build inputs during
  implementation. Preserve traceability back to the Ready descriptor.
- Do not use `ready/settings/` for runtime artifacts, build outputs, generated
  product manifests, uploaded product data, product-owned assets, or any file
  the product must read at runtime.
- Store generated or gathered proof data only when privacy, license, size, and
  provenance are acceptable, and state the proof role and authority level.
- Store sanitized excerpts, summaries, paths, hashes, or evidence refs for
  logs/traces when proof needs them; do not commit sensitive raw logs.
- Store references to bulky or sensitive materials, not copied source,
  transcripts, provider secrets, raw customer data, or diffs.
- Link artifacts to primitives, services, flags, or proof by
  descriptor id. Use raw paths only for direct source/file access.

Code traceability rules:

- Ready product records remain the source of intended product truth. Code
  comments, test comments, filenames, commits, and implementation evidence are
  supporting evidence, not product truth.
- When implementing or materially changing code that fulfills a Ready intent,
  preserve Ready id references where they are natural and low-noise.
- Prefer durable seams: module or file headers; route, command, job, or worker
  entrypoints; schema, model, migration, or generated-view sections; test files
  and named test groups; fixture consumers; proof harnesses; and evidence
  artifacts returned after implementation.
- Avoid tagging every function or adding noisy inline comments. Use the
  smallest number of references that makes the implementation discoverable and
  auditable.
- When code is moved, split, deleted, or replaced, update or remove stale Ready
  id references in the same change.
- Do not invent a Ready mapping. If the mapping is uncertain, leave code
  untagged and, when useful, create or update a discrepancy, proof, or readiness
  flag.
- Ready id references in code do not prove completion. Completion still depends
  on the Ready intent's proof cases and the project's verification process.
- Product or maintenance agents may add trace-only Ready id references to code
  as a reversible maintenance action when the mapping is evident from existing
  code, tests, artifacts, comments, or Ready records. Do not change runtime
  behavior under the guise of traceability.
- Proof-target citations bind test files to the specific proof pairs they cover.
  Use `INTENT_ID#case-key/pair-key`, for example
  `// gather parse cases (I-001#parse-sources/shopify-feed)`.
- Put proof-target citations in test files that cover the pair. One file may
  cite multiple pairs. A proof-target citation also counts as a plain Ready id
  citation, but the citation is evidence mapping, not product truth or
  completion. Runtime status still requires exact per-result metadata such as
  `caseKey` and `pairKey`; citations alone never group result rows or prove a
  pair.

Credential rules:

- Never commit raw secrets, tokens, cookies, private keys, or provider
  credentials into the Ready tree.
- Commit `.env.example`-style variable names and setup instructions when useful.
- Store local secrets in untracked `.env.local` files, provider-owned sessions,
  OS keychain, 1Password, Vault, Supabase/Vercel/GitHub secret stores, or another
  user-approved service accessible through a CLI or official SDK.
- Record only safe secret-location references: variable names, storage system,
  owner, required scope, setup status, and verification command.

## Cutting The Product Version

After drafting the tree, cut it down.

Keep only product truth that is required to prove the intended product version:

- the core user problem or desire;
- the minimal solution path;
- the standards that protect trust and proof;
- the services and accounts that must exist now;
- the samples, resources, designs, snippets, and artifacts needed to understand
  or prove the target;
- the flags needed to make gaps visible.

Move everything else out of the current product tree. Use a Ready branch or worktree for a
substantial hypothetical concept that should be evaluated as a coherent possible
end state. Use decision flags or flags on the current branch only when the team
needs to choose, prove, coordinate, or block against that concept.

Good cuts are explicit. Say what was removed and why.

## Completion Checklist

A Ready tree is usable when:

- The intended product version is coherent and bounded.
- Bundle completeness is known: complete bundles have no flags and no
  status-bearing records in `draft` or `blocked`; incomplete bundles are labeled
  before implementation.
- Ready intents trace to premises.
- Required standards and services are represented.
- Service blockers, proof required, access needs, and implementation
  instructions are visible.
- Samples, resources, expected outputs, and difficult cases exist or are blocked
  by specific user-only asks.
- Design artifacts, interaction states, copy, assets, and modular snippets exist
  when coding depends on them.
- Required accounts, credentials, environments, and secret-location references
  are available or explicitly blocked.
- Unknowns are decision flags, low-confidence fields, or flags.
- Coding agents receive the resolved intended product state rather than only
  discrepancy context.
- Claimable flags have clear scope, constraints, acceptance proof, resources,
  environment setup, and blocker policy.
- Artifact descriptors reference sensitive or bulky source safely.
- The user can review the tree and understand what is in, out, blocked, and
  deferred.

If any item is missing, keep the tree draft or blocked rather than pretending it
is ready.
