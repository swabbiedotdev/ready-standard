# Authoring and changing records

## Change workflow

Changes to a Ready Intent Package (RIP) follow one workflow.

1. **Confirm the intent.** The request comes from the owner, or the change is a
   faithful restatement of intent they already gave. If code, a ticket, or your
   own judgment suggests a different outcome, ask instead of editing.
2. **Find the home.** Read `product/product.ready`, then the owning
   capability's `capability.ready`, flows, steps, sequences, rules, and
   triggers, and the shared records they link. Use the export or
   `grep -rn '<id>' product/` to find every record that references the ids you
   will touch.
3. **Edit the owning record.** Change behavior where it lives; add or update
   links (`interface`, `invokes`, `rules`, `relationships`, edges) from
   consumers. Do not copy the owner's content into consumers.
4. **Keep the graph whole.** A new step is listed in its flow and reached by an
   entry or an edge; every new edge names a trigger record; a new sequence
   outcome is mapped by an edge; a new decision rule has an applier; a new
   interface is shown or called; an entity column a sequence uses exists on
   the entity. Remove a record only after removing or redirecting every
   reference to it.
5. **Check what consumers rely on.** If the change alters what an interface or
   shared sequence promises (result meaning, refusals, atomicity, idempotency,
   privacy, retention), find and review every consumer, linked or not, even
   when names and signatures stay the same.
6. **Rewrite rationale.** Update `rationale` on the owning record so it
   explains the current design, and delete reasons that no longer apply.
7. **Validate** (see [validation.md](validation.md)) until there are 0 errors,
   and check every new warning.
8. **Release.** If the repository versions its RIP, set `product.release` to
   the version the RIP now describes, as its `AGENTS.md` directs.

## Where a record lives

| Record | Home | Folder |
| --- | --- | --- |
| flow, step, sequence | its `capability` (always) | `capabilities/<capability>/flows/`, `…/sequences/` |
| rule, trigger used in one capability | that `capability` | `capabilities/<capability>/rules/`, `…/triggers/` |
| rule, trigger used by several capabilities | shared (no `capability`) | `shared/rules/`, `shared/triggers/` |
| entity, data_group, interface, actor, system, constant, term | shared, always | `shared/<kind folder>/` |

A rule that names a capability but is used outside it is the `home.shared`
warning: remove its `capability` and move it to `shared/`.

## Write for the returning reader

The fields a person reads (`title`, `name`, `summary`, `does`, `sees`, `copy`,
`when`, `then`, `otherwise`, guards, labels, trigger names, and message, note,
and node text) are written in plain words for someone coming back after a
month. The identifier goes in its typed field; the viewer shows it beneath the
words. Four pairs:

**A rule's summary.** Before:

```yaml
summary: >-
  Applies RULE-ACCESS, locks the writer's membership row, writes the row as the shop,
  and refuses with store_required when the membership is gone.
```

After, with the code in a term:

```yaml
summary: A member's write counts as their shop's; it is refused when their membership is gone.
```

and a `term` with `name: store_required`, `copy_word: needs a store`.

**A node's text.** Before:

```yaml
- id: lock
  node_kind: action
  text: "CALL · app._act_as_shop(viewer); LOCK · shop_member PK (shop_id, account_id) FOR KEY SHARE"
```

After:

```yaml
- id: lock
  node_kind: action
  text: Hold the writer's membership for the rest of the write
  ops: [{ op: lock, entity: data.shop-members, by: [shop_id, account_id], mode: FOR KEY SHARE }]
  refs: [data.shop-members]
```

The function belongs on the sequence message that calls it (`call`); the lock
mode stays only if the owner cares about it.

**A message.** Before:

```yaml
- msg: { from: system.web, to: system.api, text: "access.authorize(member session, selected project, manage_own_connection)" }
```

After:

```yaml
- msg:
    from: system.web
    to: system.api
    text: Check that the member may manage their own connection
    call: access.authorize(session, project, manage_own_connection)
    interface: interface.authorize
```

**An edge.** Before, with the condition and the handler in the label:

```yaml
- { to: shops.claim.done, label: "onClaimSubmit() if code_valid" }
```

After, with a trigger record and the sequence's outcome:

```yaml
- to: shops.claim.done
  trigger: shops.submit-code
  sequence: shops.verify-code
  outcome: verified
```

where the trigger `shops.submit-code` has `name: Submit code`, and the
sequence's `alt` branch "The code matches" names `outcome: verified`.

A title is the one field always read by a person: `access.authorize` is a
symbol, "Who may do what" is a title. Apply the owner-cares test to every
detail you move: if the owner would not care that it changed, leave it out.

Start a new record by copying the kind's template from
[`assets/template-package/product/`](../assets/template-package/product/) and
replacing every value. The comments in each template list the kind's required
and optional fields; delete them or keep them, as the package prefers.

## Per-kind checklist

Every record: `ready: 2`, `kind`, a lowercase `id` that starts with its
capability (behavior) or its kind (shared), no unknown fields, no empty
strings, present tense, no history or task words, a `summary` of one sentence
of at most 160 characters where the kind has one.

**product** (one, at `product/product.ready`)
- [ ] `name` (40 characters or fewer), `summary`, `outcome` (300 or fewer),
      `format_version: "8.0.0"`.
- [ ] `boundary` (what this release includes and excludes), `exclusions`,
      `measures`.
- [ ] `release` matches the version the RIP describes, if the repository uses one.
- [ ] `dcl` holds the product default with a `basis`.
- [ ] No rules, gates, algorithms, queues, or database mechanics; product-wide
      rationale and topology notes only.

**capability**
- [ ] `name` and `outcome` say what some actor gets, in their terms; `actors`
      lists who gets it.
- [ ] It is an outcome, not a channel, a team, or a layer. Two distinct
      outcomes are two capabilities.
- [ ] It lists none of its records; they name it.
- [ ] `order` places it on the product page when the order matters.

**flow**
- [ ] `capability`, `title`, `summary`, and a `subject`: an actor for a
      journey, an entity for a lifecycle.
- [ ] `steps` in order, each step's `flow` naming this flow (or its part).
- [ ] `entries` say where the subject comes in from, with `to` a step of this
      flow and `from` a step in another flow when there is one, so the first
      step is reachable.
- [ ] A journey's `related` links the lifecycles it moves and the flows it
      leads to, instead of repeating them.
- [ ] 12 steps or fewer, otherwise lettered parts.

**step (journey)**
- [ ] `flow`, `title`, and a `step_kind` that fits (no `capability`; a step
      takes its flow's): `screen`
      shows something, `action` is what the person does, `system` is what the
      product does, `decision` branches, `outcome` ends, `error` is a visible
      failure.
- [ ] `interface` names the surface it shows on; `presentation` when it is not
      a full screen.
- [ ] `copy` quotes exact user-visible words with `{slot}` placeholders;
      `sees`/`does` describe and never invent copy.
- [ ] `edges` cover every way out, and each names a trigger record; an
      outcome step with no way out has no `edges`. A decision branch has a
      `label`; a condition is a `guard` in plain words, and the rules the move
      applies are in the edge's `rules`.
- [ ] An edge that runs system work names its `sequence` and `outcome`, and
      there is one edge per outcome of that sequence, all from this step with
      the same trigger. Failures reach their own `error` steps that way.
- [ ] `rules` and `data` link the logic and data behind the step; a `data`
      entry's `state` is the id of a `state` step in that entity's lifecycle.
      The step does not explain that logic itself, and lists no sequences.
- [ ] Platform or role differences use `platforms` / `roles` on purpose only.

**step (lifecycle)**
- [ ] `step_kind: state`; one state is `initial`, and the states it ends in are
      `final`, with no `edges`.
- [ ] `field` and `value` name the entity column and value that hold the state,
      when one does.
- [ ] Each transition is an edge with a trigger, and with the `sequence` and
      `outcome` that carry it out when it needs system work.
- [ ] A state is a place the record can be. Polling, heartbeats, lease
      renewal, and retries that change no state are not edges; combinable roles
      and flags are rules, not states.

**sequence**
- [ ] `capability`, `title`, `summary`, and `outcomes` listing every way it
      ends, each mapped to a step by an edge.
- [ ] Run by edges, invoked by another sequence, or given a `trigger` record
      (schedule, event, or call) when nothing runs it.
- [ ] Every participant key used by a message or note is listed once.
- [ ] Each `alt` branch that ends the sequence names its `outcome`.
- [ ] Each message says who calls whom, with `interface` for the operation it
      calls, `call` for the function, `inputs` with `source_kind`, `guards`,
      `rules`, `constants`, and `results` per outcome.
- [ ] Every branch, retry, timeout, failure, and recovery is a block (`alt`,
      `opt`, `loop`, `break`, `par`, `transaction`), not prose.
- [ ] Each consequential data step is an `op` with `entity` (or `path`), the
      index badge or `by`/`where`/`join`, and `set` for writes.
- [ ] Another capability's sequence is run with `invokes`; its internals are
      not repeated.
- [ ] A manual path notifies the responsible operator through a watched
      channel with enough context, and keeps the automatic protection that
      stops harm before review.
- [ ] 16 messages or fewer, otherwise lettered parts joined by `continue`.

**trigger**
- [ ] `name` is the plain words shown on the edge; `trigger_kind` is `action`,
      `event`, `schedule`, or `call`.
- [ ] `actor` names who acts, `interface` where it fires (the surface with the
      button, the webhook operation), `schedule` when it runs on one.
- [ ] `capability` only when it is used in one capability; one trigger serves
      every edge it starts, across outcomes and flows.
- [ ] Used by at least one edge or sequence (`trigger.unused`).

**rule**
- [ ] `rule_kind`, `title`, and a one-sentence `summary` saying what it
      decides or requires.
- [ ] Logic for its kind: a `decision` has `when`/`then`/`otherwise`, a
      `decision` graph, a `table`, or a `judge`; an `invariant` has `holds` and
      `scope`; a `policy` has `whenever` and `then`, and `sequence` when one
      carries it out; a `quality` has `applies_to`, `measure`, and `target`.
- [ ] A decision or policy rule is listed in the `rules` of a step, an edge,
      a message, or an applied rule; a policy may instead be applied by its own
      `sequence` (no orphans).
- [ ] `constants` links the constants it uses; `constraints` hold hard or soft
      limits as `{text, hard}`.
- [ ] `inputs` with sources; `default` for the no-match outcome; `precedence`
      when order matters.
- [ ] `decision` edges name existing node ids; `table` rows match the columns.
- [ ] Each `decision` node's records are in its `refs`, and its `text` names
      them in words (`text.ref-id`).
- [ ] A `judge` names its evidence, output shape, gate, and prompt file.
- [ ] `quality` `measure`, `scope`, and `target` are concrete and measurable.
- [ ] `capability` only when one capability uses it; logic used by one message
      only stays in that message instead.

**interface (surface)**
- [ ] `interface_kind: surface`, `name`, `summary`, `surface_kind`; `parent`
      for a section or dialog inside another surface; `system`, `route`,
      `audience` where known.
- [ ] `mockup` names an exact frame, file, or version when a design is binding.
- [ ] Describes content and states, not layout or visual styling.
- [ ] No operation fields (`interface.fields`).

**interface (operation)**
- [ ] `interface_kind: operation`, `operation_kind`, `name` in plain words, and
      `http`, `code`, or the tool or command name callers use.
- [ ] `params` with `type` and `source`; `returns`; every refusal in `errors`
      with `code`, `status`, `when`, and `copy` when the user sees it.
- [ ] Called by a message's `interface`; no surface fields (`interface.fields`).
- [ ] Payload types in a contract file under `files`, not in fields.
- [ ] Guarantees callers rely on (idempotency, atomicity, retention,
      precision) are stated, at the strength the DCL and the owner call for.
- [ ] A CLI command, MCP tool, or plugin action is an operation of the
      capability it serves, not a capability of its own.

**entity**
- [ ] `table` is the exact physical name; `entity_kind` set; `summary` says
      what one row is.
- [ ] Only product-significant columns, each with exact `name` and `type`, keys,
      `nullable`, `default`, `values`, and a `rule` for meaning not captured by
      typed fields.
- [ ] `fk` names an existing column on an existing entity, and each foreign key
      has a `relationships` entry with quoted cardinalities and a `label`.
- [ ] Each index has one badge `id`, exact `columns`, `where`, `unique`,
      `method`, and a `purpose`; columns carry matching badges (`I1·1`,
      `P1·where`); `serves` names the sequences that rely on it.
- [ ] Its lifecycle is a flow with this entity as `subject`; what is always
      true of it is an invariant rule with this entity in `scope`.

**data_group**
- [ ] `entities` lists the records shown together; `rationale` explains the
      data design for the group.
- [ ] A `diagram` names records in node `text` by words and links them in the
      node's `refs` (`text.ref-id`).

**actor / system**
- [ ] Actor `side` set (`person`, `operator`, `agent`, `third_party`,
      `product`); `goal` in the actor's terms. An agent that acts for someone
      is an actor with `side: agent`.
- [ ] System `role`, `system_kind`, `within` (its host), and `connections`
      with labels; `secrets` are names only.

**constant**
- [ ] `name` in code style (`INVITATION_TTL`); `value` quoted as text with `unit`.
- [ ] `source` (`path#key`) when code owns the value; omit `value` when the RIP
      only names it.
- [ ] Records that use it link it (`constants` on messages and columns).

**term**
- [ ] `definition` in product language; `copy_word` is the word copy uses, and
      appears in some `copy`; `synonyms` lists words that mean the same thing.

## Supplementary files

- Put them in `product/files/` with an allowed extension (`.md .txt .json
  .yaml .yml .ts .sql .csv .svg`) and reference them by full package path
  (`product/files/save-contract.ts`).
- They hold contracts, prompts, long reference prose, and SVG mockups, never
  logic or a second copy of a record.
