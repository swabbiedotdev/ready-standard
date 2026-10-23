# Authoring and changing records

## Change workflow

Changes to a Ready Intent Package (RIP) follow one workflow.

1. **Confirm the intent.** The request comes from the owner, or the change is a
   faithful restatement of intent they already gave. If code, a ticket, or your
   own judgment suggests a different outcome, ask instead of editing.
2. **Find the owner.** Read `product/product.ready`, then the owning module's
   `module.ready`, journeys, sequences, rules, and data. Use the export or
   `grep -rn '<id>' product/` to find every record that references the ids you
   will touch.
3. **Edit the owning record.** Change behavior where it is owned; add or update
   links (`sequences`, `rules`, `invokes`, `relationships`) from consumers.
   Do not copy the owner's content into consumers.
4. **Keep the graph whole.** A new rule needs an applier; a new sequence needs a
   starter; a new step must be listed in its journey; a new entity column used
   by a sequence must exist on the entity. Remove a record only after removing
   or redirecting every reference to it.
5. **Rewrite rationale.** Update `rationale` on the owning record (or its module)
   so it explains the current design, and delete reasons that no longer apply.
6. **Validate** (see [validation.md](validation.md)) until there are 0 errors,
   and check every new warning.
7. **Release.** If the repository versions its RIP, set `product.release` to the
   version the RIP now describes, as its `AGENTS.md` directs.

Start a new record by copying the kind's template from
[`assets/template-package/product/`](../assets/template-package/product/) and
replacing every value. The comments in each template list the kind's required
and optional fields; delete them or keep them, as the package prefers.

## Per-kind checklist

Every record: `ready: 1`, `kind`, a stable lowercase `id`, no unknown fields,
no empty strings, present tense, no history or task words.

**product** (one, at `product/product.ready`)
- [ ] `name`, `outcome` (the user or product result), `boundary` (what this
      release includes), `exclusions`, `measures`.
- [ ] `release` matches the version the RIP describes, if the repository uses one.
- [ ] `dcl` holds the product default with a `basis`.
- [ ] No rules, gates, algorithms, queues, or database mechanics; product-wide
      rationale and topology notes only.

**module**
- [ ] `id` equals the folder name and prefixes the module's record ids.
- [ ] `summary` names what it owns and where it runs; `runs_in` lists systems.
- [ ] `owns` and `invariants` are short labels, not a second specification.
- [ ] `rationale` holds module-level reasons.

**actor / system / capability**
- [ ] Actor `side` set; `goal` in the actor's terms.
- [ ] System `role`, `system_kind`, `within` (its host), and `connections` with
      labels; `secrets` are names only.
- [ ] Capability `outcome` is outward-facing; `owners` name the delivering
      modules, journeys, or sequences.

**journey**
- [ ] `module`, at least one `actors` id, `title`, one-sentence `summary`.
- [ ] `steps` in order, each step's `journey` naming this journey (or its part).
- [ ] `sequences` lists the runtime behind the journey; `entries` say where people
      come from; `related` links other journeys instead of repeating them.
- [ ] 12 steps or fewer, otherwise lettered parts.

**step**
- [ ] Listed in its journey's `steps`.
- [ ] `step_kind` fits: `screen` shows something, `action` is what the person
      does, `system` is what the product does, `decision` branches, `outcome` ends,
      `error` is a visible failure.
- [ ] `surface` where it shows; `presentation` when not a full screen.
- [ ] `copy` quotes exact user-visible words with `{slot}` placeholders;
      `sees`/`does` describe and never invent copy.
- [ ] `next` covers every way out, with `label` for choices and `when` for
      conditions; failures and recovery have their own `error` steps.
- [ ] `sequences`, `rules`, and `data` link the logic behind the step; the step
      does not explain that logic itself.
- [ ] Platform or role differences use `platforms` / `roles` on purpose only.

**surface**
- [ ] `module`, `name`, `surface_kind`; `parent` for a section or dialog inside
      another surface; `system`, `route`, `audience` where known.
- [ ] `mockup` names an exact frame, file, or version when a design is binding.
- [ ] Describes content and states, not layout or visual styling.

**operation**
- [ ] `name` as callers see it (`POST /api/notes`, `access.authorize(…)`), with
      `display_id` set to the code name when code cites it.
- [ ] `params` with `source_kind`; `returns`; every refusal in `errors` with
      `code`, `status`, `when`, and `copy` when the user sees it.
- [ ] `sequence` names the sequence that carries it out, and that sequence's
      `operation` points back.
- [ ] Payload types in a contract file under `files`, not in fields.

**sequence**
- [ ] `trigger` with the right `trigger_kind`: `user` or `call` must be started
      by a step, journey, operation, `invokes`, or `continue`; `event`,
      `schedule`, and `operator` start themselves.
- [ ] Every participant key used by a message or note is listed once.
- [ ] Each message says who calls whom, with `http`/`call`, `inputs` with
      `source_kind`, `guards`, `rules`, `constants`, and `results` per outcome.
- [ ] Every branch, retry, timeout, failure, and recovery is a block (`alt`,
      `opt`, `loop`, `break`, `par`, `transaction`), not prose.
- [ ] Each consequential data step is an `op` with `entity` (or `path`), the
      index badge or `by`/`where`/`join`, and `set` for writes.
- [ ] Calls into another module use `invokes` on that module's operation or
      sequence; its internals are not repeated.
- [ ] `owner` names the intended code owner where it prevents duplication.
- [ ] 16 messages or fewer, otherwise lettered parts joined by `continue`.
- [ ] `dcl` only as a narrow override with its own `basis`.
- [ ] A flowchart part (`diagram` with `items: []`) names records in node
      `text` by words and links them in the node's `refs` (`text.ref-id`).

**rule**
- [ ] At least one form of logic: `when`/`then`/`otherwise`, `decision`,
      `table`, `judge`, `rules`, or `parts`.
- [ ] Applied by a step, message, note, or applied rule (no orphans).
- [ ] `inputs` with sources; `constants` linked, not restated; `default` for the
      no-match outcome; `precedence` when order matters.
- [ ] `decision` edges name existing node ids; `table` rows match the columns.
- [ ] Each `decision` node's records are in its `refs`, and its `text` names
      them in words, not by id, display id, or alias (`text.ref-id`).
- [ ] A `judge` names its evidence, output shape, gate, and prompt file.
- [ ] Logic used by one message only stays in that message instead.

**constant**
- [ ] `name` in code style (`INVITATION_TTL`); `value` quoted as text with `unit`.
- [ ] `source` (`path#key`) when code owns the value; omit `value` when the RIP
      only names it.
- [ ] Records that use it link it (`constants` on messages, rules, columns).

**entity**
- [ ] `table` is the exact physical name; `entity_kind` set; `summary` says what
      one row is.
- [ ] Only product-significant columns, each with exact `name` and `type`, keys,
      `nullable`, `default`, `values`, and a `rule` for meaning not captured by
      typed fields.
- [ ] `fk` names an existing column on an existing entity, and each foreign key
      has a `relationships` entry with quoted cardinalities and a `label`.
- [ ] Each index has one badge `id`, exact `columns`, `where`, `unique`,
      `method`, and a `purpose`; columns carry matching badges (`I1·1`,
      `P1·where`); `serves` names the sequences that rely on it.
- [ ] Another module's table is linked by relationship, never copied.

**entity_group**
- [ ] `entities` lists the records shown together; `rationale` explains the data
      design for the group.
- [ ] A `diagram` names records in node `text` by words and links them in the
      node's `refs` (`text.ref-id`).

**state_machine**
- [ ] Only when sequences do not already show the lifecycle clearly.
- [ ] One `initial` state; `terminal` where it ends; transitions name existing
      states (or `[*]`) and `via` the sequences or rules that cause them.

**quality**
- [ ] `applies_to` names the sequences or records it constrains; `measure`,
      `scope`, and `target` are concrete and measurable.

**term**
- [ ] `definition` in product language; `copy_word` is the word copy uses;
      `synonyms` lists words that mean the same thing.

**acceptance**
- [ ] Only for a case no journey, sequence, or rule can show, and
      `why_not_diagram` says why.
- [ ] `verifies` names the records it checks; `given`/`when`/`then` are concrete.

## Supplementary files

- Put them in `product/<module>/files/` with an allowed extension (`.md .txt
  .json .yaml .yml .ts .sql .csv .svg`) and reference them by full package path
  (`product/notes/files/save-contract.ts`).
- They hold contracts, prompts, long reference prose, and SVG mockups, never
  logic or a second copy of a record.
