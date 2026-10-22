# The `.ready` format (schema 1)

This is the canonical specification of the `.ready` standard in this
repository. It follows Ready Room's schema, `app/src/shared/intent/types.ts`
(zod), which defines every field and is authoritative where the two disagree;
the loader and its checks are `app/src/shared/intent/model.ts`. The generated
JSON Schema ships with this skill at
[`assets/ready.schema.json`](../assets/ready.schema.json) for editor
completion; `npm run rip -- schema` in a Ready Room checkout prints the current
one.

A Ready Intent Package (RIP) is a graph of typed records. Each record is one YAML file ending in
`.ready` under `product/`. Records refer to each other by `id`. Every diagram,
outline, export, and diff is derived from the records; nothing visual is
stored.

**Goal: no loss.** Everything a RIP expresses has a home: a typed field, a prose
field (`notes`, `rationale`), an open `tags` entry, or a supplementary file the
record references. If something has no home, the format needs a field, not a
workaround.

## Principles of the format

1. **One record, one file, one fact.** A record owns its fact; others link to it by id.
2. **Typed where software uses it.** Anything a viewer draws, checks, links, or
   searches is a typed field: who calls whom, which table and index, which rule
   applies, the copy shown to users. Explanations stay prose.
3. **Derived, never stored:** diagram layout, colors, themes, legends,
   autonumbering, overview diagrams of parts, "used in", "writes", and "reads"
   lists, reference boxes for another module's entities, Mermaid escapes.
4. **Clean text.** No Mermaid or HTML escapes (`#59;`, `<br/>`); use lists
   instead of line breaks. Markdown is allowed only in `rationale` and `notes`.
5. **Readable chunks.** Journeys over 12 steps and sequences over 16 messages
   are split into lettered parts; the overview is derived.

## Package layout

```
product/
  product.ready
  actors/<name>.ready
  systems/<name>.ready
  capabilities/<name>.ready
  <module>/module.ready
  <module>/journeys/*.ready      <module>/steps/<journey>/*.ready
  <module>/surfaces/*.ready      <module>/operations/*.ready
  <module>/sequences/*.ready     <module>/rules/*.ready
  <module>/constants/*.ready
  <module>/data/*.ready          entities, entity groups, state machines
  <module>/quality/*.ready       <module>/terms/*.ready
  <module>/acceptance/*.ready
  <module>/files/…               supplementary files
```

Folders are a convention for people. The loader reads every `.ready` file under
`product/` (any depth) and ignores folder names, so a record's kind comes only
from its `kind` field.

## YAML rules

- One mapping per file. Duplicate keys are a parse error.
- Every text field is a non-empty string after trimming. Quote values YAML
  would read as numbers or booleans when the field is text: `value: "2000"`,
  `to_card: "1"`, `from: "[*]"`.
- Quote any plain scalar that contains `: ` or starts with `{`, `[`, `*`, `&`,
  `!`, `|`, `>`, `'`, `"`, `%`, or `@`.
- Unknown fields are errors at every level (every object is strict).

## Fields every record has

| Field        | Meaning                                                                                                      |
| ------------ | ------------------------------------------------------------------------------------------------------------ |
| `ready`      | Schema version; always `1`.                                                                                  |
| `kind`       | Record kind (below).                                                                                         |
| `id`         | Lowercase dotted machine id, e.g. `shops.claim-shop.enter-email`. Never changes.                             |
| `display_id` | Optional stable human id, e.g. `FLOW-012`, `SEQ-014a`, `DATA-ACCOUNT`, `RULE-ACCESS`. Unique in the package. |
| `aliases`    | Retired ids and old heading anchors that still resolve here (`flow-012-claim-a-shop`).                       |
| `rationale`  | Current rationale: why the design is shaped this way (Markdown).                                             |
| `notes`      | Other prose that belongs with the record (Markdown).                                                         |
| `files`      | Supplementary files: `{path, title?, role?}`; `role` is contract, prompt, mockup, config, schema, doc, or example. |
| `tags`       | `{tag, text}` annotations with no dedicated field.                                                           |

`id` matches `^[a-z0-9]+([-_][a-z0-9]+)*(\.[a-z0-9]+([-_][a-z0-9]+)*)*$`. It is
for machines and links between records; `display_id` is for people and code
citations. Viewers resolve an id, display id, or alias for search and deep
links, and the loader rejects a display id or alias that names two records. See
[ids-and-parts.md](ids-and-parts.md) for naming conventions.

## Parts

Journeys, sequences, rules, and entity groups can be split into lettered parts.
The overview record lists `parts: [ids]` in order; each part has
`part_of: <overview id>` and its own `display_id` (`SEQ-014a`). The overview
diagram is derived from the parts. Parts reference each other directly: a
step's `next`, a sequence's `continue`.

## Record kinds

`?` marks an optional field. Lists of ids name other records; the kinds each may
point at are checked (`ref.kind`).

### Context

- **product** (exactly one): `name, outcome, summary?, release?, format_version?,
  boundary?` (text, or `{text?, includes?, excludes?}`), `exclusions?, measures?,
  dcl? {level (integer 0–9), basis}`.
- **module**: `name, summary, owns?, invariants?, runs_in?` (systems).
- **actor**: `name, description?, goal?, side?` (user, product, operator,
  third_party), `connections? [{to (system or actor), label?, direction? (to, both)}]`
  for an actor's own links on the system map.
- **capability**: `name, outcome, actors?, owners?` (modules, journeys, or
  sequences that deliver it).
- **system**: `name, role, system_kind?` (platform, app, service, worker,
  database, storage, queue, external), `hosting?, within?` (the hosting system),
  `code?` (repository path), `responsibilities?, connections? [{to, label?, direction?}],
  environments? [{name, notes?}], units? [{name, unit_kind? (function, job,
  schedule, service, queue), schedule?, resources?, notes?}], secrets?` (names
  only, never values).

### Experience

- **journey**: `module, actors` (at least one), `title, summary, audience?, trigger?,
  entries? [{label, from? (step, journey, or surface), to? (the step it opens),
  edge? (label on the way in)}], steps` (ordered; empty only on an overview with
  parts), `sequences?, related? [{to (journey), label, relation? (leads_to,
  shares, alternative)}], parts?, part_of?`.
- **step**:
  - Identity: `journey, title, step_kind` (screen, action, system, decision,
    outcome, error).
  - Where and how it shows: `surface?, presentation?` (screen, inline, sheet,
    dialog, toast, email, notification, external), `platforms?` (ios, android,
    web, mobile, desktop), `roles?`.
  - Content: `copy? {title?, body?, actions?, hints?}` with `{slot}`
    placeholders, plus `sees?` and `does?` (lists) for descriptions.
  - Links: `next? [{to (step, journey, or $return), label?, when?, next_kind?
    (action, result, auto), channel? (email, push, async, link), both_ways?,
    platforms?, roles?, target_label?}], sequences?, rules?, data? [{entity,
    access? (read, write, read-write)}]`.
  - `$return` sends the person back where the journey started.
- **surface**:
  - Identity: `module, name, surface_kind?` (app, page, screen, section, sheet,
    dialog, email, notification, provider, user_side).
  - Placement: `parent?` (surface), `system?, route?, audience?, platforms?, code?`.
  - Content: `summary?, elements? [{name, description?, states?, copy?}], states?,
    mockup? {url?, file?, frame?, version?}` (the binding design target).
  - A named screen used in several flows is a surface with a parent.

User-visible copy goes in `copy`, verbatim. `sees` and `does` describe; `copy`
quotes.

### Logic

- **operation** (a public operation, RPC, or endpoint): `module, name, summary,
  params? [{name, source, source_kind?, type?}], returns?, errors? [{code,
  status?, when?, copy?, maps_to?}], http? {method, path}, auth?, sequence?` (the
  sequence that carries it out), `owner?` (code, `path::symbol`). Payload types go
  in a contract file listed in `files`.
- **sequence**: `module, title, summary?, trigger? {trigger_kind (user, event,
  schedule, call, operator), text}, operation?, participants, dcl?` (override
  only), `items, diagram?, parts?, part_of?`.
  - **Participants:** an actor or system id, used as its own key, or
    `{id (key), is?, label?, component?, owner?}` for a lane such as "Mobile app
    or web page". `is` may name actors, systems, sequences, or operations; omit
    it for a component lane. Messages and notes use participant keys.
  - **Items** (each is a one-key mapping):
    - `msg {from, to, text}`, plus optional `reply` (a dashed return),
      `http {method, path, body?}`, `call` (function and arguments), `auth`,
      `invokes` (sequences or operations it starts), `inputs [{name, source,
      source_kind?}]`, `guards`, `ops`, `rules`, `constants`, `results [{status?,
      code?, copy?, when?}]` (one per outcome), `owner`, `timeout`, `retry`,
      `idempotency`, `note`, `tags`.
    - `note {over (participant keys), text, ops?, rules?, tags?}` for annotations
      that belong to no message, including branches that hold only data effects.
    - `alt {branches [{when, items}]}`, `opt {when, items}`, `loop {while, max?,
      items}`, `par {branches [{label?, items}]}`, `break {when, items}`,
      `transaction {label?, items}`.
    - `continue {to (sequence), text?}` hands off to the next part or sequence.
  - A part that is a flowchart rather than a message exchange uses `diagram` (the
    graph shape below) with `items: []`.
  - **Data operations (`ops`):** `{op, entity?, by?, index?, where?, join?
    [{entity, on}], set?, conflict?, order?, limit?, mode?, path?, returns?,
    triggers?, shared_with? (sequences contending for a lock), note?}`. `op` is
    read, insert, update, upsert, delete, lock, audit, enqueue, write, or append.
    `entity` is an entity or entity group; an object addressed only by path sets
    `path` and no entity. `index` names an index badge of the entity (`U1`), or
    `PK` / `FK`.
  - **source_kind** (inputs and params): surface, parameter, return, stored,
    payload, session, constant, config, derived.
- **rule**: `module, title, summary?, owner?`, then the logic in whichever forms
  fit (they may combine):
  - `when`, `then`, `otherwise` for a single gate;
  - `decision` (a graph) for a decision tree;
  - `rules` for rules this rule applies;
  - `table {columns, rows}` for quota or decision tables;
  - `judge {evidence, output, gate?, prompt? (file path)}` for model-judged decisions;
  - plus `default` (the outcome when nothing matches), `priority` (number),
    `precedence`, `constraints [{text, hard?}]`, `inputs`, `params [{name, value,
    unit?, source?}]`, `constants`, `sets [{name, members}]`, `calculations
    [{name, expr, notes?}]`, `parts?, part_of?`.
- **constant**: `module, name, value?` (text; omit when the RIP only names it),
  `unit?, source?` (config `path#key` when code owns the value), `description?,
  table? {columns, rows}`. Use it for named values (`INVITATION_TTL = 7 days`)
  and value tables (tiers).

**Graphs** (`rule.decision`, `sequence.diagram`, `entity_group.diagram`):
`nodes [{id, node_kind, text, ops?, refs?}]` (at least one) and `edges [{from,
to, label?, undirected?}]`. `node_kind` is input, decision, calc, judge, action,
outcome, data, or note. Node ids are free text local to the graph; `refs` names
any records the node stands for or uses.

### Data

- **entity**:
  - `module, entity_kind?` (table, view, object, projection, external), `schema?,
    table` (physical name or object path template), `name, summary`.
  - `columns [{name, type, keys? (PK, FK, UK), fk? {entity, column, on_delete?,
    on_update?}, nullable?, default?, check?, values?, generated?, visibility?,
    rule?, indexes? (badges), constants?}]`.
  - `column_groups? [{name, display_id?, columns, summary?}]` and
    `derivations? [{by, columns, text}]` (columns a function computes).
  - `primary_key?` (an ordered composite key).
  - `indexes? [{id (badge), display_id?, name, requested_by? (the module that needs
    it), unique?, method?, columns?, include?, where?, params?, definition?,
    purpose, serves? (sequences)}]`.
  - `checks? [{name?, expr, purpose?}]`.
  - `coordination? [{id, coordination_kind? (lease, lock, admit, fence, other),
    scope?, owner?, fence?, expires?, limit?, protects?, text}]`.
  - `triggers? [{name, timing?, event?, does}]`.
  - `access? {rls?, grants?, readers?, writers?}, lifecycle?, invariants?, volume?`.
  - `view? {source, security_invoker?}, projection_of?` (entity).
  - `relationships? [{to (entity), on? [{from, to}], from_card?, to_card?, link
    (fk, logical), on_delete?, label, reason?}]`. Cardinalities are `1`, `0..1`,
    `0..many`, `1..many`, or bounded like `0..2`, always quoted. `from_card` is
    this entity's side. Two foreign keys to the same table are two relationships.
  - Column badges carry suffixes after a middle dot (`·`, U+00B7): `U1·1` (first
    key), `P1·where`, `P1·expr`, `I2·inc`. The part before `·` must be an index
    id on the entity, or `PK`.
  - Another module's entity is never copied: relationships point at its record,
    and viewers draw it as a reference box.
- **entity_group**: `module, title, summary?, entities, diagram?, parts?,
  part_of?`. Use it for one DATA id spanning several tables, for a module's data
  diagram, and for lettered data diagrams.
- **state_machine**: `module, title, entity?, field?, states [{name, description?,
  initial?, terminal?}]` (at least one), `transitions [{from, to, trigger, via?
  (sequences or rules)}]`. `[*]` is the start or end of a transition.

### Quality and vocabulary

- **quality** (QC): `module, title, applies_to` (at least one record of any
  kind), `measure, scope?, target`.
- **term**: `module?, name, definition, synonyms?, copy_word?` (the word
  user-visible copy uses).
- **acceptance** (exceptions only): `module, title, why_not_diagram, verifies`
  (at least one record of any kind), `given, when, then`.

## Supplementary files

Text files under `product/` with extensions `.md .txt .json .yaml .yml .ts .sql
.csv .svg` travel with the package and are referenced from records by package
path (`product/<module>/files/…`) in `files`, `surface.mockup.file`, and
`rule.judge.prompt`. Use them for payload and contract types, model prompts,
long reference prose that is not one record's rationale, and SVG mockups. Never
put logic in them: logic stays in records, where it is typed and checked.

Code is never copied into the RIP. Refer to it with `owner` and `code` paths
(`apps/web/app/api/claim/code/route.ts`, `60_app_core.sql::app.claim_code_send`)
and to code-owned config with `source` (`data/crawl_limits.yml#max_pages`).

## Validation

`npm run rip -- validate <dir>` (where `<dir>` contains `product/`; `npm run
pip` is an alias) and Ready Room's viewer run the same loader. It never stops at the first problem: valid
records still load, and each problem is reported as an error (E) or a warning
(W). The command exits non-zero when there is any error. How to work through
the output is in [validation.md](validation.md).

| Code | Sev. | Meaning |
| --- | --- | --- |
| `yaml.parse` | E | Not valid YAML (including duplicate keys). |
| `record.shape` | E | The file is not one mapping. |
| `record.version` | E | `ready` is not `1`. |
| `record.kind` | E | Unknown `kind`. |
| `record.id` | E | `id` missing or not a lowercase dotted id. |
| `field.invalid` | E | A field has the wrong type or value. |
| `field.unknown` | E | A field is not in the format. |
| `record.duplicate` | E | Two records share an `id`. |
| `display.duplicate` | E | A display id or alias names two records (or another record's id). |
| `product.count` | E | The package does not have exactly one product record. |
| `ref.missing` | E | A reference points at no record. |
| `ref.kind` | E | A reference points at the wrong kind of record. |
| `ref.file` | E | A referenced supplementary file is not in the package. |
| `part.mismatch` | E | An overview's `parts` and the parts' `part_of` disagree. |
| `journey.step` | E | A journey lists a step that names another journey. |
| `journey.empty` | E | A journey has neither steps nor parts. |
| `step.orphan` | E | A step's journey does not list it. |
| `sequence.participant` | E | A message or note uses an unlisted participant key, or a key is listed twice. |
| `ops.target` | E | A data operation has neither `entity` nor `path`. |
| `rule.empty` | E | A rule has no logic: no when/then, decision, table, judge, rules, or parts. |
| `rule.orphan` | E | Nothing references the rule. |
| `rule.decision` | E | A decision edge names an unknown node. |
| `state.unknown` | E | A transition names an unknown state. |
| `entity.column` | E | `primary_key` or a column `fk` names an unknown column. |
| `ops.index` | W | A data operation's `index` is not an index of its entity. |
| `entity.index` | W | A column badge names no index on the entity. |
| `table.shape` | W | A rule table row has the wrong number of cells. |
| `sequence.unreachable` | W | Nothing starts the sequence (see below). |
| `size.journey` | W | A journey has more than 12 steps. |
| `size.sequence` | W | A sequence has more than 16 messages, counted through nested blocks. |
| `size.module` | W | A module has more than 14 ungrouped entities and top-level entity groups. |

A sequence is reachable when its trigger is `event`, `schedule`, or `operator`;
when any record other than its own overview or part references it (a step,
journey, operation, invoking message, `continue`, and so on); or when it is a
part or overview of a reachable sequence.
