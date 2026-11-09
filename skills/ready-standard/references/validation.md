# Validation

## Run it

The validator for a Ready Intent Package (RIP) is Ready Room's loader,
published as the `@readyroom/ready` package (Node 24 or later; version 1.0
reads Ready standard 8). `<repo>` is the directory that contains `product/`.

```sh
npx @readyroom/ready validate <repo>
```

Inside a Ready Room checkout, `npm run ready -- validate <repo>` runs the same
code from source; Ready Room validates its own package that way.

Output is one line per issue, then a summary:

```
product/shared/data/notes.ready: warning entity.index Column owner_id badge I9·1 names no index
24 records: 1 product, 1 capability, 2 flows, …; 1 supplementary file
0 errors, 1 warning
```

The command exits 1 when there is any error. A change is not done until it
reports **0 errors**. Treat each warning as a real problem to fix or to raise
with the owner; do not add new warnings silently.

The codes and their meanings are listed in [format.md](format.md#validation).

## Fix in this order

A record that fails its shape check is not loaded at all, so every record that
references it then reports `ref.missing`. Work from the top:

1. **File problems:** `yaml.parse`, `record.shape`, `record.version`,
   `record.kind`, `record.id`. Usually unquoted `: ` in text, a tab, a
   duplicate key, or `ready` not `2`.
2. **Field problems:** `field.invalid`, `field.unknown`, `interface.fields`.
   Check the field against [format.md](format.md) or
   `npx @readyroom/ready schema`. Common causes: a number where text is
   required (`value: 2000`, an unquoted `format_version`), an empty string, a
   misspelled or invented field, a value outside an enum, a display id where
   an id is required, a surface field on an operation, or a file path not
   under `product/`.
3. **Identity problems:** `record.duplicate`, `display.duplicate`,
   `product.count`, then `part.mismatch`.
4. **Re-run.** Many `ref.missing` errors disappear once the records above load.
5. **Graph problems:** `ref.missing` (a typo, a display id used where an id is
   required, a renamed id still cited, or a record that was removed),
   `ref.kind` (an edge's `to` pointing at a flow, a message's `interface` at a
   surface), `ref.file` (the file must exist in the package with an allowed
   extension).
6. **Homes:** `home.capability` (a flow or sequence with no `capability`, or
   one that does not exist), then `home.shared` (a
   capability-local rule used elsewhere: move it to shared).
7. **Flows:** `flow.subject`, `flow.empty`, `step.flow`, `step.kind`. Fix the
   flow's subject first, since it decides whether its steps are journey steps
   or `state` steps.
8. **Edges:** `edge.trigger` (add or correct the trigger record), then
   `edge.sequence` (the edge's `outcome` must be one of its sequence's
   `outcomes`), then `edge.start` (all edges that run one sequence leave one
   step with one trigger).
9. **Sequences and rules:** `sequence.participant`, `ops.target`,
   `rule.empty`, `rule.orphan`, `rule.decision`, `entity.column`.
10. **Reachability warnings:** `step.unreachable`, `sequence.outcome`,
    `sequence.unreached`, `interface.unused`, `trigger.unused`. Each means a
    part of the graph leads nowhere or nothing leads to it. Find the real
    entry, edge, or trigger; if there is none, ask the owner whether the
    record is still intended.
11. **Data warnings:** `ops.index` and `entity.index` (a badge with no index,
    or `I1.1` written with a period instead of `·`), `table.shape` (a rule
    table row with the wrong number of cells), `data.state` (a step's data
    `state` that is not the id of a `state` step in that entity's lifecycle).
12. **Plain-words warnings:** `text.code` (a prose field reads as code; the
    message names the match and where it belongs), `text.id` (a prose field
    names a record by id; link it from the typed field), `text.call` (a
    message's text repeats its `call`), `text.ref-id` (a graph node's text
    repeats a ref), `summary.missing`, `summary.long`, `name.long`,
    `outcome.long`. Fix these by moving the identifier into its typed field
    and writing the sentence in words; see
    [authoring.md](authoring.md#write-for-the-returning-reader). Work
    capability by capability, worst records first, and never satisfy a
    warning by deleting the detail the owner cares about.
13. **One-home warnings:** `text.history`, `sees.branch`, `sees.platform`,
    `term.unused`. Move each fact to its home (see
    [mistakes.md](mistakes.md#one-home-per-fact)): the reason to `rationale`
    without its date, the condition to an edge's `guard`, the client to
    `platforms`, the word to `copy`.
14. **DCL warnings:** `dcl.same` means a capability repeats the product
    default's level. Remove the capability's duplicate `dcl` so it uses the
    default; a separate basis alone does not justify repeating the level.
15. **Size warnings:** `size.flow` and `size.sequence`. Split into lettered
    parts at a phase boundary (see [ids-and-parts.md](ids-and-parts.md#lettered-parts)).

Fix the cause, not the symptom: do not satisfy `rule.orphan` by listing the
rule on an unrelated record, `sequence.unreached` by giving an edge-run
sequence a trigger, or `sequence.outcome` by adding an edge to a step the
product never reaches. Find the process that actually applies, runs, or ends
it; if there is none, ask the owner whether the logic is still intended.

## What the validator does not check

Passing validation means the graph is well formed, not that the intent is
right. It does not check:

- that the content is present tense and free of history and task language;
- that a rule is applied by a process rather than merely referenced;
- that capabilities are outcomes rather than channels, teams, or layers;
- that a shared record is really shared, or a local one really local, beyond
  `home.shared`;
- that a trigger's name, an edge's guard, and a sequence's outcomes describe
  what really happens;
- that logic lives in typed fields rather than `notes`;
- that copy is verbatim, or that a consumer does not restate its owner;
- that the RIP matches the code.

Those are the reviewer's job; see [principles.md](principles.md) and
[mistakes.md](mistakes.md).

## In CI

A repository with a ready package should run the validator in CI (Ready Room
runs it, and `app/test/intent-readyroom.test.ts` checks the same). Any other
repository adds a job step `npx @readyroom/ready@<version> validate .`, pinning
the version so a format change lands as a deliberate upgrade.
