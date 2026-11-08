# The `.ready` format (Ready standard 8, schema 2)

This is the canonical specification of the `.ready` standard in this
repository. It follows Ready Room's schema, `app/src/shared/intent/types.ts`
(zod), which defines every field and is authoritative where the two disagree;
the loader and its checks are `app/src/shared/intent/model.ts`.
The generated JSON Schema ships with this skill at
[`assets/ready.schema.json`](../assets/ready.schema.json) for editor
completion; `npx @readyroom/ready schema` prints the current one.

A Ready Intent Package (RIP) describes a product as it is meant to be, as a
graph of typed records. Each record is one YAML file ending in `.ready` under
`product/`. Records refer to each other by `id`. Every diagram, outline,
export, and diff is derived from the records; nothing visual is stored.

## The model

The product is organized into **capabilities**: outcomes that some actor gets.
Inside a capability, behavior is drawn with four forms. Named parts, defined
once, are referenced from everywhere they apply.

```
product
├─ capability                      an outcome some actor gets
│  ├─ flow                         how one subject moves
│  │  ├─ subject: a person   → shown as a journey
│  │  ├─ subject: a record   → shown as a lifecycle
│  │  └─ step                      a place the subject can be
│  │     └─ edge                   a way out: trigger, guard, and the sequence it runs
│  ├─ sequence                     what happens between two steps, across systems
│  └─ rule                         logic used only in this capability
└─ shared (used by several capabilities, owned by none)
   ├─ data           entities and their fields and relationships
   ├─ interface      surfaces for people; operations for programs and agents
   ├─ actor, system, trigger, rule, constant, term
```

| Form | Record kinds | Drawn as |
| --- | --- | --- |
| Data schema | `entity`, `data_group` | entity diagram |
| Flow | `flow`, `step` | flow diagram (journey or lifecycle) |
| Sequence | `sequence` | sequence diagram |
| Interface | `interface` | surface or operation card |

**Named parts.** Triggers, rules, actors, systems, constants, and terms already
sit inside the four forms: a trigger on an edge, a rule in a guard, an actor as
a subject or participant. A named record exists when the part is reused, or
when it is important enough to be found on its own.

**Neutral definitions.** The standard does not define interruption, failure,
compensation, or resting versus transit states. A step is a place the subject
can be. A sequence is what runs between steps, and its outcomes say where the
subject ends up.

## Principles of the format

1. **One home per fact.** Every record has one home: a capability, or shared.
   Consumers link to it by id; nothing is restated.
2. **Typed where software uses it.** Anything Ready Room draws, checks, links,
   or searches is a typed field. Explanations stay in `rationale` and `notes`.
3. **Derived, never stored.** Layout, overview diagrams of parts, "used in"
   lists, a step's sequences, a capability's records, where an interface is
   used, and an entity's lifecycle are derived from references.
4. **Plain words first.** Titles, summaries, step text, copy, guards, labels,
   trigger names, and message text are written for someone returning after a
   month, with no identifiers or code vocabulary. Identifiers live in typed
   fields (`call`, `code`, `ops`, `returns`, `refs`). Every `summary` is one
   sentence of at most 160 characters.
5. **Present tense, current intent.** No history, tasks, or migration language.
   Git and the tracker hold history.
6. **Readable chunks.** Flows over 12 steps and sequences over 16 messages are
   split into lettered parts.
7. **One way to say each thing.** Where two fields could hold the same fact, the
   format keeps one, and the other is derived.

## Package layout

```
product/
  product.ready
  capabilities/<capability>/capability.ready
  capabilities/<capability>/flows/<flow>.ready
  capabilities/<capability>/flows/<flow>/<step>.ready
  capabilities/<capability>/sequences/<sequence>.ready
  capabilities/<capability>/rules/<rule>.ready        rules used only here
  capabilities/<capability>/triggers/<trigger>.ready  triggers used only here
  shared/data/<entity>.ready
  shared/interfaces/<interface>.ready
  shared/actors/<actor>.ready
  shared/systems/<system>.ready
  shared/triggers/<trigger>.ready
  shared/rules/<rule>.ready
  shared/constants/<constant>.ready
  shared/terms/<term>.ready
  files/…                                              supplementary files
```

Folders are a convention for people. The loader reads every `.ready` file under
`product/` (any depth) and ignores folder names. A record's kind comes from its
`kind` field, and its home from its fields: flows and sequences name their
`capability`, and a step takes its capability from its flow; a rule or
trigger names one only when it is used in one capability; every other kind is
always shared.

## YAML rules

- One mapping per file. Duplicate keys are a parse error.
- Every text field is a non-empty string after trimming. Quote values YAML
  would read as numbers or booleans when the field is text: `value: "2000"`,
  `to_card: "1"`, `format_version: "8.0.0"`.
- Quote any plain scalar that contains `: ` or starts with `{`, `[`, `*`, `&`,
  `!`, `|`, `>`, `'`, `"`, `%`, or `@`.
- Unknown fields are errors at every level (every object is strict).

## Fields every record has

| Field | Meaning |
| --- | --- |
| `ready` | Schema version; always `2`. `ready: 1` is a load error. |
| `kind` | Record kind (below). |
| `id` | Lowercase dotted machine id. Never changes. |
| `display_id` | Stable human id cited in code and tickets, e.g. `FLOW-CREATE`, `SEQ-PREVIEW`, `RULE-COST`. Unique in the package. |
| `title` or `name` | Plain-words name (which one depends on the kind). |
| `summary` | One sentence, at most 160 characters. |
| `rationale` | Why it is shaped this way (Markdown). |
| `notes` | Context: scope, terms, references (Markdown). Never behavior a typed field could hold. |
| `files` | Supplementary files: `{path, title?, role?}`; `role` is contract, prompt, mockup, config, schema, doc, or example. |
| `tags` | `{tag, text}` annotations with no dedicated field. |

## Ids and display ids

`id` matches `^[a-z0-9]+([-_][a-z0-9]+)*(\.[a-z0-9]+([-_][a-z0-9]+)*)*$`. It is
for machines and links between records; `display_id` is for people and code
citations. References always use the target's `id`.

- **Behavior ids start with their capability:** `generate.create-font` (a
  flow), `generate.create-font.use-handwriting` (its step),
  `generate.source-preview` (a sequence), `generate.confirm-source` (a trigger
  used only in that capability). A capability's own id is its name:
  `generate`.
- **Shared ids start with their kind:** `data.fonts`,
  `interface.preview-screen`, `rule.generation-cost`, `trigger.confirm-source`,
  `actor.owner`, `system.mobile`, `constant.<name>`, `term.<name>`.
- **Display-id prefixes:** `CAP-`, `FLOW-`, `SEQ-`, `DATA-`, `IF-`, `RULE-`,
  `TRIG-`, `ACTOR-`, `SYS-`, `CONST-`, `TERM-`.
- **No old names.** An id or display id that changes is changed everywhere it is
  cited, in the RIP and in code. The format has no field that keeps old names
  resolving.

The loader rejects an id or display id that names two records. See
[ids-and-parts.md](ids-and-parts.md) for naming practice.

## Parts

Flows, sequences, rules, and data groups can be split into lettered parts. The
overview record lists `parts: [ids]` in order; each part has
`part_of: <overview id>` and its own `display_id` (`SEQ-PREVIEW-a`). The
overview diagram is derived from the parts. Parts reference each other
directly: a step's edge points at a step in the next flow part, and a sequence
part ends with `continue`.

## Record kinds

`?` marks an optional field. Lists of ids name other records; the kinds each
may point at are checked (`ref.kind`).

### product

Exactly one, at `product/product.ready`: `name` (at most 40 characters),
`summary`, `outcome` (at most 300 characters), `release?`,
`format_version: "8.0.0"`, `boundary? {text?, includes?, excludes?}`,
`exclusions?`, `measures?`, `dcl? {level (integer 1–10), basis}`. The DCL is
product-wide only; an area with stronger needs states them as quality rules.

### capability

`name, summary, outcome, actors` (who gets the outcome), `order?` (position on
the product page).

A capability is any outcome some actor gets: owners, visitors, or operators. An
area with several distinct outcomes is several capabilities. A channel is never
a capability: a plugin, a CLI, or a second app contributes interfaces to
existing capabilities. A capability owns the records that name it; it lists
none of them.

### flow

`capability, title, summary, subject, steps` (ordered), `entries?`, `related?`,
`parts?`, `part_of?`.

- **`subject`** is an actor id or an entity id. An actor makes the flow a
  **journey**; an entity makes it a **lifecycle**. Journey and lifecycle are
  display names, not separate kinds.
- **`entries`** are `[{label, from? (a step in another flow), to (a step in this
  flow), trigger?}]`: where the subject comes in from.
- **`related`** are `[{to (a flow), label, relation (leads_to,
  moves_lifecycle)}]`. A journey links the lifecycles it moves.

### step

`flow, title, step_kind, edges?`, plus fields by subject. A step takes its
capability from its flow.

- **`step_kind`:**
  - for a journey: `screen`, `action`, `decision`, `system`, `outcome`,
    `error`;
  - for a lifecycle: `state`, with `initial?` and `final?`.
- **For a journey step:**
  - `interface?` (the surface it shows on), `presentation?` (screen, inline,
    sheet, dialog, toast, email, notification, external), `platforms?` (ios,
    android, web, mobile, desktop), `roles?`;
  - `copy? {title?, body?, actions?, hints?}`, quoted verbatim with `{slot}`
    placeholders;
  - `sees?` and `does?` (lists), which describe and never quote.
- **For a lifecycle step:** `description?`, and the entity field and value that
  hold the state (`field?`, `value?`).
- **For both:** `data? [{entity, access (read, write), state?}]`, where
  `state` is the id of a `state` step in that entity's lifecycle; `rules?`.
- **`edges`** (optional; a final step has none) are `[{to | $return, trigger,
  guard?, rules?, label?, sequence?, outcome?, channel? (email, push, async,
  link), platforms?, roles?}]`:
  - `to` is a step, or `$return` to send the subject back where the flow
    began.
  - `trigger` is a trigger id. Every edge names a trigger record.
  - `sequence` names the sequence this move runs, and `outcome` names which of
    its outcomes leads to `to`. The edges that share a sequence all leave the
    same step with the same trigger, one per outcome.
  - A move with no system work has no `sequence`.
  - `label` marks a decision branch ("Yes", "No"); `guard` states, in plain
    words, the condition under which the edge is taken; `rules` lists the
    rules the move applies.

The steps a sequence starts, ends at, or decides in are derived from these
edges, so a step lists no sequences.

### sequence

`capability, title, summary, participants, items, outcomes`, plus `trigger?`,
`parts?`, `part_of?`.

- **`participants`:** actor, system, or interface ids, used as their own keys,
  or `{id (key), is?, label?}` lanes such as "Mobile app or web page". Messages
  and notes use participant keys.
- **`outcomes`** are `[{id, label}]`, the ways the sequence can end. An `alt`
  branch that ends the sequence names its `outcome`. A sequence with one
  outcome reaches it at the end of its items. Flow edges map outcomes to
  steps.
- **`trigger`** is a trigger id, only for a sequence no edge runs: a
  `schedule`, an `event`, or another system's `call`, such as a nightly batch
  or an inbound webhook.
- **Items** (each is a one-key mapping):
  - `msg {from, to, text}`, plus optional `reply` (a dashed return),
    `interface` (the operation it calls), `call` (function and arguments),
    `http {method, path, body?}`, `auth` (the credential or role it runs
    with), `owner` (owning code, `path::symbol`), `invokes` (sequences it
    runs), `inputs [{name, source, source_kind?}]`, `guards` (plain words),
    `ops`, `rules`, `constants`, `results [{status?, code?, copy?, when?}]`
    (one per outcome), `timeout`, `retry`, `idempotency`, `note`, `tags`.
  - `note {over (participant keys), text, ops?, rules?, tags?}` for annotations
    that belong to no message, including branches that hold only data effects.
  - `alt {branches [{when, outcome?, items}]}`, `opt {when, items}`,
    `loop {while, max?, items}`, `par {branches [{label?, items}]}`,
    `break {when, items}`, `transaction {label?, items}`.
  - `continue {to (sequence), text?}` hands off to the next part or sequence.
- **Data operations (`ops`):** `{op, entity?, by?, index?, where?, join?
  [{entity, on}], set?, conflict?, order?, limit?, mode?, path?, returns?,
  triggers?, shared_with? (sequences contending for a lock), note?}`. `op` is
  read, insert, update, upsert, delete, lock, audit, enqueue, write, or append.
  `entity` is an entity or data group; an object addressed only by path sets
  `path` and no entity. `index` names an index badge of the entity (`U1`), or
  `PK`. `by` and `set` are lists.
- **`source_kind`** (message inputs and rule inputs): surface, parameter,
  return, stored, payload, session, constant, config, derived.
- A sequence is run by an edge, invoked by another sequence, or has its own
  `trigger`.

### entity

`entity_kind?` (table, view, object, projection, external), `schema?`, `table`
(physical name or object path template), `name, summary, columns`,
`column_groups?`, `derivations?`, `primary_key?`, `indexes?`, `checks?`,
`coordination?`, `triggers?`, `access?`, `view?`, `projection_of?`,
`relationships?`, `volume?`.

- `columns [{name, type, keys? (PK, FK, UK), fk? {entity, column, on_delete?,
  on_update?}, nullable?, default?, check?, values?, generated?, visibility?,
  rule?, indexes? (badges), constants?}]`.
- `column_groups [{name, display_id?, columns, summary?}]` and
  `derivations [{by, columns, text}]` (columns a function computes).
- `primary_key` is an ordered composite key.
- `indexes [{id (badge), display_id?, name, requested_by? (the capability that
  needs this shared index), unique?, method?, columns?, include?, where?,
  params?, definition?, purpose, serves? (sequences)}]`.
- `checks [{name?, expr, purpose?}]`.
- `coordination [{id, coordination_kind? (lease, lock, admit, fence, other),
  scope?, owner?, fence?, expires?, limit?, protects?, text}]`.
- `triggers [{name, timing?, event?, does}]` (database triggers, not trigger
  records).
- `access {rls?, grants?, readers?, writers?}`, `view {source,
  security_invoker?}`, `projection_of` (entity).
- `relationships [{to (entity), on? [{from, to}], from_card?, to_card?, link
  (fk, logical), on_delete?, label, reason?}]`. Cardinalities are `1`, `0..1`,
  `0..many`, `1..many`, or bounded like `0..2`, always quoted. `from_card` is
  this entity's side. Two foreign keys to the same table are two
  relationships.
- Column badges carry suffixes after a middle dot (`·`, U+00B7): `U1·1` (first
  key), `P1·where`, `P1·expr`, `I2·inc`. The part before `·` is an index id on
  the entity, or `PK`.

An entity's lifecycle is the flow whose `subject` is that entity, and what is
always true of it is an invariant rule; an entity has neither field.

### data_group

`title, summary?, entities, diagram?, parts?, part_of?`. Use it for one data
diagram spanning several tables, and for lettered data diagrams.

### interface

`interface_kind` (`surface` or `operation`), `name, summary`, `system?`,
`audience?` (actors), `code?`.

- **A surface** (for people) has `surface_kind` (app, page, screen, section,
  dialog, sheet, email, notification, provider), `parent?` (a surface),
  `route?`, `platforms?`, `elements? [{name, description?, states?, copy?}]`,
  `states?`, `mockup? {url?, file?, frame?, version?}` (the binding design
  target).
- **An operation** (for programs and agents) has `operation_kind` (endpoint,
  rpc, mcp_tool, mcp_resource, cli_command, webhook, function), `params?
  [{name, type, source}]`, `returns?`, `errors? [{code, status?, when?,
  copy?}]`, `http? {method, path}`, `auth?`. Payload types go in a contract
  file listed in `files`.

A step shows on a surface (`step.interface`). A message calls an operation
(`msg.interface`). The viewer derives where each interface is used.

### trigger

`name, trigger_kind` (action, event, schedule, call), `summary?`,
`capability?` (only when used in one capability), `actor?` (who acts),
`interface?` (where it fires: a button's surface, a webhook operation),
`schedule?` (when).

Every edge names a trigger record, and so does every sequence that runs without
an edge. One trigger can serve several edges: the outcomes of one action, or
the same button in two flows. The trigger's `name` is the plain words shown on
the edge.

### rule

`rule_kind, title, summary`, `capability?` (only when used in one
capability), `rules?` (rules this rule applies), `constants?`, `constraints?
[{text, hard?}]`, plus the logic for its kind:

| `rule_kind` | Logic |
| --- | --- |
| `decision` | `when` / `then` / `otherwise`, a `decision` graph, a `table {columns, rows}`, or a `judge {evidence, output, gate?, prompt? (file path)}`; with `default?`, `precedence?`, `inputs?`, `params? [{name, value, unit?, source?}]`, `calculations? [{name, expr, notes?}]`, `sets? [{name, members}]` |
| `invariant` | `holds` (what is always true), `scope` (entities or flows it covers) |
| `policy` | `whenever` (an event or state), `then` (what follows), `sequence?` (the sequence that carries it out) |
| `quality` | `applies_to` (flows, sequences, or interfaces), `measure`, `target`, `scope?` |

Every rule is applied somewhere: through the `rules` field of a step, an
edge, a sequence message or note, or another rule. A policy is also applied by
its own `sequence`. Quality and invariant rules apply through their
`applies_to` or `scope`.

### actor

`name, description?, goal?, side` (person, operator, agent, third_party,
product), `connections? [{to (system or actor), label?, direction? (to,
both)}]` for an actor's own links on the system map.

### system

`name, role, system_kind?` (platform, app, service, worker, database, storage,
queue, external), `hosting?`, `within?` (the hosting system), `code?`
(repository path), `responsibilities?`, `connections? [{to, label?,
direction?}]`, `environments? [{name, notes?}]`, `units? [{name, unit_kind?
(function, job, schedule, service, queue), schedule?, resources?, notes?}]`,
`secrets?` (names only, never values).

### constant

`name, value?` (text; omit when the RIP only names it), `unit?`, `source?`
(config `path#key` when code owns the value), `description?`, `table?
{columns, rows}`. Use it for named values (`INVITATION_TTL = 7 days`) and value
tables (tiers).

### term

`name, definition, synonyms?, copy_word?` (the word user-visible copy uses).

### Graphs

`rule.decision` and `data_group.diagram` share one shape: `nodes [{id,
node_kind, text, ops?, refs?}]` (at least one) and `edges [{from, to, label?,
undirected?}]`. `node_kind` is input, decision, calc, judge, action, outcome,
data, or note. Node ids are local to the graph; `refs` names the records the
node stands for or uses, and the node's `text` names them in words.

## Supplementary files

Text files under `product/` with extensions `.md .txt .json .yaml .yml .ts .sql
.csv .svg` travel with the package and are referenced from records by package
path (`product/files/…`) in `files`, `mockup.file`, and `judge.prompt`. Use
them for payload and contract types, model prompts, long reference prose that
is not one record's rationale, and SVG mockups. Never put logic in them: logic
stays in records, where it is typed and checked.

Code is never copied into the RIP. Refer to it with `code` paths and `call`,
and to code-owned config with `source` (`data/crawl_limits.yml#max_pages`).

## Validation

`npx @readyroom/ready validate <dir>` (where `<dir>` contains `product/`;
`@readyroom/ready` 1.0 reads standard 8) and Ready Room's viewer run the same
loader. It never stops at the first problem: valid records still load, and each
problem is reported as an error (E) or a warning (W). The command exits
non-zero when there is any error. How to work through the output is in
[validation.md](validation.md).

| Code | Sev. | Meaning |
| --- | --- | --- |
| `yaml.parse` | E | Not valid YAML (including duplicate keys). |
| `record.shape` | E | The file is not one mapping. |
| `record.version` | E | `ready` is not `2`. |
| `record.kind` | E | Unknown `kind`. |
| `record.id` | E | `id` missing or not a lowercase dotted id. |
| `field.invalid` | E | A field has the wrong type or value. |
| `field.unknown` | E | A field is not in the format. |
| `record.duplicate` | E | Two records share an `id`. |
| `display.duplicate` | E | A display id names two records (or another record's id). |
| `product.count` | E | The package does not have exactly one product record. |
| `part.mismatch` | E | An overview's `parts` and the parts' `part_of` disagree. |
| `ref.missing` | E | A reference points at no record. |
| `ref.kind` | E | A reference points at the wrong kind of record. |
| `ref.file` | E | A referenced supplementary file is not in the package. |
| `home.capability` | E | A flow or sequence names no capability, or a capability that doesn't exist. |
| `home.shared` | W | A rule that names a capability is used outside it. |
| `flow.subject` | E | A flow's subject is not an actor or an entity. |
| `flow.empty` | E | A flow has no steps. |
| `step.flow` | E | A step and its flow disagree. |
| `step.unreachable` | W | No entry or edge reaches a step. |
| `step.kind` | E | A journey step is a `state`, or a lifecycle step isn't. |
| `edge.trigger` | E | An edge has no trigger, or names something that isn't a trigger record. |
| `edge.sequence` | E | An edge's `outcome` is not one of its sequence's outcomes. |
| `edge.start` | E | The edges that run one sequence leave different steps or use different triggers. |
| `sequence.participant` | E | A message or note uses a participant that isn't listed. |
| `sequence.outcome` | W | A sequence outcome that no edge maps to a step. |
| `sequence.unreached` | W | No edge runs the sequence, no sequence invokes it, and it has no trigger. |
| `rule.empty` | E | A rule has no logic for its kind. |
| `rule.orphan` | E | Nothing applies a decision or policy rule through a `rules` field (or, for a policy, its `sequence`). |
| `rule.decision` | E | A decision graph refers to a node that doesn't exist. |
| `entity.column` | E | `primary_key` or a column `fk` names an unknown column. |
| `ops.target` | E | A data operation has neither `entity` nor `path`. |
| `ops.index` | W | A data operation's `index` is not an index of its entity. |
| `entity.index` | W | A column badge names no index on the entity. |
| `table.shape` | W | A rule table row has the wrong number of cells. |
| `data.state` | W | A step's data `state` is not a `state` step of that entity's lifecycle. |
| `interface.fields` | E | Surface fields on an operation, or the reverse. |
| `interface.unused` | W | Nothing shows or calls an interface. |
| `trigger.unused` | W | A trigger record no edge or sequence uses. |
| `text.code` | W | A prose field reads as code: `path::symbol`, a file path, `call(args)`, a `WRITE ·` verb, a `dotted.reference`, a `snake_case` or `camelCase` identifier, or a `CONSTANT_NAME`. Product words and domain names are not code. |
| `text.id` | W | A prose field (title, summary, step text, copy, guard, label, trigger name, message, note, or node text) names another record by id or display id; link it from the typed field. |
| `text.call` | W | A message's `text` repeats its `call`. |
| `text.ref-id` | W | A graph node's text repeats an id or display id that is also in its `refs`. |
| `text.history` | W | `rationale`, `notes`, a `summary`, or a step's `sees` or `does` carries a date, a QA round, a dated decision, or a ticket id. |
| `summary.missing` | W | A record that needs a summary has none. |
| `summary.long` | W | A `summary` is longer than 160 characters or more than one sentence. |
| `name.long` | W | The product `name` is longer than 40 characters. |
| `outcome.long` | W | The product `outcome` is longer than 300 characters. |
| `sees.branch` | W | A step's `sees` line describes a condition that belongs on an edge's `guard` or a decision step. |
| `sees.platform` | W | A step's `sees` line describes one client and the step sets no `platforms`. |
| `term.unused` | W | A term's `copy_word` appears in no `copy` in the package. |
| `size.flow` | W | A flow has more than 12 steps. |
| `size.sequence` | W | A sequence has more than 16 messages, counted through nested blocks. |
