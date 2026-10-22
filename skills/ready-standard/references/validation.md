# Validation

## Run it

The validator for a Ready Intent Package (RIP) is Ready Room's loader behind
its CLI, `npm run ready`. `<repo>` is the directory that contains
`product/`.

```sh
# from a Ready Room checkout's root
npm run ready -- validate <repo>
# or from anywhere, without changing directory
npm --prefix <ready-room> run ready -- validate "$PWD"
```

Ready Room validates its own package with `npm run ready -- validate .`. The CLI
needs Node 24 or later and the checkout's dependencies installed (`npm install`).

Output is one line per issue, then a summary:

```
product/notes/data/note.ready: warning entity.index Column owner_id badge I9·1 names no index
18 records: 1 product, 1 module, …; 1 supplementary file
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
   `record.kind`, `record.id`. Usually unquoted `: ` in text, a tab, a duplicate
   key, or a missing `ready: 1`.
2. **Field problems:** `field.invalid`, `field.unknown`. Check the field against
   [format.md](format.md) or the JSON Schema in `assets/ready.schema.json`. Common
   causes: a number where text is required (`value: 2000`, `to_card: 1`), an
   empty string, a misspelled or invented field, a value outside an enum, a
   display id where an id is required, or a file path not under `product/`.
3. **Identity problems:** `record.duplicate`, `display.duplicate`,
   `product.count`.
4. **Re-run.** Many `ref.missing` errors disappear once the records above load.
5. **Graph problems:** `ref.missing` (a typo, an alias used where an id is
   required, or a record that was removed), `ref.kind` (pointing a step's
   `next` at a surface, a message's `invokes` at a rule), `ref.file` (the file
   must exist in the package with an allowed extension).
6. **Structure problems:** `part.mismatch`, `journey.step`, `step.orphan`,
   `journey.empty`, `sequence.participant`, `ops.target`, `rule.empty`,
   `rule.orphan`, `rule.decision`, `state.unknown`, `entity.column`.
7. **Warnings:** `ops.index` and `entity.index` (a badge with no index, or
   `I1.1` written with a period instead of `·`), `table.shape`,
   `sequence.unreachable`, and the `size.*` budgets.

Fix the cause, not the symptom: do not satisfy `rule.orphan` by listing the rule
on an unrelated record, or `sequence.unreachable` by giving a called sequence
an `event` trigger. Find the process that actually applies or starts it; if
there is none, ask the owner whether the logic is still intended.

## What the validator does not check

Passing validation means the graph is well formed, not that the intent is
right. It does not check:

- that the content is present tense and free of history and task language;
- that a rule is applied by a process rather than merely referenced (a quality
  record's `applies_to` satisfies `rule.orphan`);
- that `entries[].to` names a real step;
- that logic lives in typed fields rather than `notes`;
- that copy is verbatim, or that a consumer does not restate its owner;
- that the RIP matches the code.

Those are the reviewer's job; see [principles.md](principles.md) and
[mistakes.md](mistakes.md).

## In CI

A repository with a ready package should run the validator in CI (Ready Room
runs it, and `app/test/intent-readyroom.test.ts` checks the same). Until the
planned standalone CLI (`@ready-standard/cli`, binary `ready`) exists, a product
repository without Ready Room's code can check out Ready Room (or a pinned
release of it) in the job and run
`npm --prefix <ready-room> run ready -- validate "$PWD"`.
