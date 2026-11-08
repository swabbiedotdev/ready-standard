---
name: ready-standard
description: Read, write, change, validate, or audit a Ready Intent Package (RIP), the `.ready` records (typed YAML files) under a repository's `product/` directory that Ready Room loads. Use when the user asks to work on a RIP, ready package, or `.ready` files (capabilities, flows, steps, sequences, rules, triggers, interfaces, entities, and the other kinds), to write a RIP for an existing product from its code and documents, or to check code against `.ready` records. Do not use for ordinary planning, coding, or documentation in a repository with no ready package.
---

# Ready standard

A Ready Intent Package (RIP) is the product's current intended end state,
written as a graph of typed records under `product/`, one YAML file per
record. The product is organized into capabilities, outcomes some actor gets.
Each capability draws its behavior as flows (journeys for people, lifecycles
for records), the sequences that run between their steps, and the rules used
only there. Data, interfaces, actors, systems, triggers, shared rules,
constants, and terms are shared and defined once. Records refer to each other
by `id`; every diagram, outline, and export is derived from them.

Ready Room's schema (`app/src/shared/intent/types.ts`) is authoritative for
every field. [references/format.md](references/format.md) is the readable
specification of Ready standard 8: layout, kinds, fields, ids, and validator
codes. Never invent a field; if something has no home, it goes in `notes`,
`rationale`, `tags`, or a supplementary file, or the owner adds a field to the
schema.

## Principles

Read [references/principles.md](references/principles.md) before changing
intent.

- **Capabilities own behavior; shared records are defined once.** Flows,
  sequences, and single-use rules and triggers name the capability that owns
  them; a step takes its flow's. Data, interfaces, actors, systems, and anything used by
  several capabilities are shared, and consumers link to them by id. A
  channel (a plugin, a CLI, a second app) is never a capability.
- **Flows have a subject.** An actor subject makes a journey; an entity
  subject makes a lifecycle with `state` steps. Links between flows are
  derived from entries, shared edge sequences, and lifecycle state references.
- **DCL follows use.** A capability uses its own DCL, else the product default,
  else none. A shared record uses the highest effective DCL of the capabilities
  that use it. See [references/principles.md](references/principles.md#development-complexity-level-dcl).
- **Every edge names a trigger record.** An edge that runs system work
  carries `sequence` and `outcome`, one edge per outcome, all leaving the same
  step with the same trigger. Steps list no sequences; that is derived.
- **Rule kinds.** A rule is a `decision`, `invariant`, `policy`, or `quality`,
  and it is applied somewhere: through the `rules` field of a step, an edge,
  a sequence message, or another rule; a policy also by its own `sequence`;
  quality and invariant rules through `applies_to` or `scope`.
- **Interfaces.** Surfaces are for people and operations for programs and
  agents. A step shows on a surface; a message calls an operation.
- **Plain words first.** Titles, summaries, step text, copy, guards, labels,
  trigger names, and message text carry no identifiers or code vocabulary;
  the identifier goes in its typed field. Every `summary` is one sentence of
  at most 160 characters. See
  [references/authoring.md](references/authoring.md#write-for-the-returning-reader).
- **One home per fact.** A fact lives in one record and one field; the rest
  link to it or derive it.
- **Present tense.** The intended end state, with no history, status, task, or
  migration language.
- **The owner directs intent.** Code, tickets, tests, old documents, and agent
  suggestions are evidence, not authority.
- **No old names.** Nothing keeps a retired id resolving: a changed id or
  display id is updated everywhere it is cited, in the RIP and in code, in
  the same change.

## Workflow

1. **Find the package and the validator.** The package is `<repo>/product/`.
   Validate with `npx @readyroom/ready validate <repo>` (Node 24+, no Ready
   Room checkout needed). Follow the repository's own `AGENTS.md` if it names
   a command.
2. **Read before changing.** Start from `product/product.ready`, then the
   capability's `capability.ready` and its flows, steps, sequences, rules, and
   triggers, then the shared records they link. For a readable view, export
   it and read the export; never edit an export. See
   [references/reading.md](references/reading.md).
3. **Change records.** Edit the owning record; add links from consumers.
   Follow the per-kind checklist in
   [references/authoring.md](references/authoring.md) and the id rules in
   [references/ids-and-parts.md](references/ids-and-parts.md).
   [assets/template-package/](assets/template-package/) holds a minimal valid
   package with a record of every kind; copy the kind you need.
4. **Validate.** The validator must report 0 errors. Fix shape errors before
   reference errors, and treat warnings as real unless the owner accepts them.
   See [references/validation.md](references/validation.md).
5. **Report** the records changed (by display id or id), any product question
   left for the owner, and the validator's summary line.

## Other tasks

- Writing a RIP for an existing product from its code and any old intent
  documents: [references/reconstructing.md](references/reconstructing.md).
- Auditing code against records, or writing tickets that link them:
  [references/auditing.md](references/auditing.md).
- Before finishing any change, scan [references/mistakes.md](references/mistakes.md).

## Rules

- Keep implementation notes, research, tasks, open questions, review results,
  and rewrite notes outside `product/`.
- Keep `id` and `display_id` stable. When one must change, change it in every
  record, code comment, test, and document that cites it, in the same change.
- Cite records in code comments and tickets by display id (or id).
- A record naming a runtime owner (`code`, `call`, a system) states intent; it
  is not evidence that the file exists.
- This skill does not authorize commits, pushes, or ticket changes by itself.
