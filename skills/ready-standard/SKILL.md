---
name: ready-standard
description: Read, author, change, validate, convert, or audit a Ready Intent Package (RIP), the bundle of `.ready` records (typed YAML files) under a repository's `product/` directory that Ready Room loads. Use when the user asks to work on a RIP, ready package, or `.ready` files (journeys, steps, sequences, rules, entities, and the other kinds), to convert a Markdown + Mermaid PIP (the older Product Intent Package format) to a RIP, or to check code against `.ready` records. Do not use for ordinary planning, coding, or documentation in a repository with no ready package.
---

# Ready standard

A Ready Intent Package (RIP) is the product's current intended end state, written as a graph
of typed records: one YAML file per product, module, actor, capability, system,
journey, step, surface, operation, sequence, rule, constant, entity, entity
group, state machine, quality constraint, term, and acceptance exception.
Records refer to each other by `id`. Every diagram, outline, and export is
derived from the records; nothing visual is stored.

Ready Room's schema (`app/src/shared/intent/types.ts`) is authoritative for
every field. [references/format.md](references/format.md) is the readable
specification: layout, kinds, fields, and validator codes. Never invent a
field; if something has no home, it goes in `notes`, `rationale`, `tags`, or a
supplementary file, or the owner adds a field to the schema.

## Principles

These carry over from the older Markdown PIP format, restated for records. Read
[references/principles.md](references/principles.md) before changing intent.

- **One owner.** Each behavior belongs to one module's records. Consumers link
  to the owning record by id; they never restate it.
- **No orphan logic.** Every rule is applied by a step, a sequence message or
  note, or another applied rule, and every sequence is started by a step,
  journey, operation, invoking message, or its own event, schedule, or
  operator trigger.
- **Typed fields hold logic; prose holds purpose.** Conditions, outcomes, data
  access, and copy go in typed fields. `rationale` explains why; `notes` holds
  other context. Neither hides a requirement.
- **Plain words first.** Titles, summaries, step text, copy, guards, and
  message and node text are written for someone returning after a month: no
  identifiers, no ids, no code vocabulary. The identifier goes in its typed
  field (`call`, `owner`, `ops`, `refs`, `constants`) or in `notes`; a rule or
  sequence opens with a one-sentence `summary`. See
  [references/authoring.md](references/authoring.md#write-for-the-returning-reader).
- **Present-tense end state.** No history, status, task, or migration language.
- **The owner directs intent.** Code, tickets, tests, and agent suggestions are
  evidence, not authority. Tickets link records; they do not restate them.
- **Proportional.** Add a record only when it resolves a real ambiguity.

## Workflow

1. **Find the package and the validator.** The package is `<repo>/product/`.
   Validate with `npx @readyroom/ready validate <repo>` (Node 24+, no Ready
   Room checkout needed). Follow the repository's own `AGENTS.md` if it names
   a command.
2. **Read before changing.** Start from `product/product.ready`, then the
   module's `module.ready` and its journeys, sequences, rules, and data. For a
   readable view, export it and read the export; never edit an export. See
   [references/reading.md](references/reading.md).
3. **Change records.** Edit the owning record; add links from consumers. Follow
   the per-kind checklist in [references/authoring.md](references/authoring.md)
   and the id rules in [references/ids-and-parts.md](references/ids-and-parts.md).
   [assets/template-package/](assets/template-package/) holds one minimal valid
   record per kind; copy the kind you need.
4. **Validate.** The validator must report 0 errors. Fix shape errors before
   reference errors, and treat warnings as real unless the owner accepts them.
   See [references/validation.md](references/validation.md).
5. **Report** the records changed (by display id or id), any product question
   left for the owner, and the validator's summary line.

## Other tasks

- Converting a Markdown + Mermaid PIP to a RIP: [references/converting.md](references/converting.md),
  including the fidelity audit that proves nothing was lost.
- Reconstructing intent for an existing product with no reliable package:
  [references/reconstructing.md](references/reconstructing.md).
- Auditing code against records, or writing tickets that link them:
  [references/auditing.md](references/auditing.md).
- Before finishing any change, scan [references/mistakes.md](references/mistakes.md).

## Rules

- Keep implementation notes, research, tasks, open questions, review results,
  and conversion audits outside `product/`.
- Keep `id` stable forever. Renaming means a new `display_id` or title, with the
  old display id or anchor added to `aliases`.
- Cite records in code comments and tickets by display id (or id).
- A record naming a runtime owner (`owner`, `code`, a system) states intent; it
  is not evidence that the file exists.
- This skill does not authorize commits, pushes, or ticket changes by itself.
