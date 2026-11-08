# Ids, display ids, and parts

## `id`: the machine name

- Lowercase dotted: segments of `a-z0-9`, joined inside a segment by `-` or
  `_`, separated by `.`. No uppercase, spaces, or `$`.
- Unique across the package (`record.duplicate`).
- **References always use the target's `id`.** Fields such as `steps`,
  `edges[].to`, `trigger`, `sequence`, `interface`, `rules`, `invokes`,
  `capability`, and `fk.entity` are looked up by id only; a display id there
  is an error. Display ids resolve only for people: search, deep links, and
  citations.
- **Behavior ids start with their capability.** A capability's id is its short
  name, and every flow, step, sequence, and capability-local rule or trigger
  starts with it.
- **Shared ids start with their kind:** `data.`, `interface.`, `actor.`,
  `system.`, `trigger.`, `rule.`, `constant.`, `term.`.

| Kind | id pattern | Example |
| --- | --- | --- |
| product | `product` | `product` |
| capability | `<cap>` | `generate` |
| flow | `<cap>.<flow>` | `generate.create-font` |
| step | `<cap>.<flow>.<step>` | `generate.create-font.use-handwriting` |
| sequence | `<cap>.<sequence>` | `generate.source-preview` |
| rule, trigger used in one capability | `<cap>.<name>` | `generate.confirm-source` |
| shared rule, trigger | `rule.<name>`, `trigger.<name>` | `rule.generation-cost` |
| entity, data group | `data.<name>` | `data.fonts` |
| interface | `interface.<name>` | `interface.preview-screen` |
| actor, system | `actor.<name>`, `system.<name>` | `actor.owner`, `system.mobile` |
| constant, term | `constant.<name>`, `term.<name>` | `constant.invitation-ttl` |

Flows, sequences, and capability-local rules and triggers share the
`<cap>.<name>` namespace, so give each a distinct name (`generate.create-font`
for the flow, `generate.source-preview` for a sequence).

## `display_id`: the human name

- The id people and code cite. Each kind has a prefix: `CAP-`, `FLOW-`,
  `SEQ-`, `DATA-`, `IF-`, `RULE-`, `TRIG-`, `ACTOR-`, `SYS-`, `CONST-`, `TERM-`,
  followed by a short mnemonic in capitals (`FLOW-CREATE`, `SEQ-PREVIEW`,
  `RULE-COST`, `IF-PREVIEW`).
- Give one to records that people, tickets, or code comments cite:
  capabilities, flows, sequences, rules, triggers, entities, and interfaces.
  Steps rarely need one.
- Unique across every id and display id in the package (`display.duplicate`).
- Each record has its own display id; lowercase letters mark only the parts of
  one record.

## Changing an id or display id

Nothing keeps an old name resolving. Change an id or
display id only when it is wrong (the record moved to another capability, two
records merged, the name misleads), and in the same change:

1. Rename it in the record.
2. Update every reference in `product/`: `grep -rn '<old id>' product/`.
3. Update every citation outside the RIP: code comments, tests, documents,
   `AGENTS.md`, and open tickets that cite the old id or display id.
4. Validate to 0 errors; any `ref.missing` points at a reference you missed.

A changed title, name, or summary does not change the id.

## Lettered parts

Flows, sequences, rules, and data groups can be split into parts. Split a flow
over 12 steps or a sequence over 16 messages (the `size.*` warnings); also
split when one record mixes separately readable phases.

The overview record:

- keeps the original `id` and `display_id`, so citations still land on it;
- lists `parts: [<id>.a, <id>.b, …]` in reading order;
- holds what applies to the whole: `summary`, `rationale`, `subject`,
  `entries`;
- carries no content of its own: a flow overview has `steps: []`, a sequence
  overview has `items: []` (its `participants` are still required; list the
  lanes the parts share).

Each part:

- has id `<overview id>.a` (`.b`, …), `part_of: <overview id>`, and display id
  `<overview display id>-a` (`SEQ-PREVIEW-a`);
- is a complete record of the same kind (a flow part needs `capability`,
  `title`, `summary`, `subject`, `steps`);
- links to the next part directly: a sequence part ends with
  `continue: {to: <next part id>}`, and a step's edge points at the first step
  of the next flow part.

Step ids in a split flow use the overview's namespace
(`generate.create-font.name`, with `flow: generate.create-font.b`), so a later
re-split moves steps between parts without renaming them.

Every id in `parts` names a record of the same kind whose `part_of` is the
overview, and every `part_of` is listed in its overview's `parts`.

File names are free; a convention is `create-font.ready`,
`create-font-a.ready`, … in the kind's folder.
