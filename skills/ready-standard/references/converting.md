# Converting a Markdown + Mermaid PIP to `.ready`

A conversion changes representation, not meaning. Every fact in the Markdown
PIP lands in a typed field, a prose field, a tag, or a supplementary file, and a
fidelity audit proves it. If something truly has no home, stop and ask the
owner for a schema field instead of inventing one or dropping it.

Ready Room converted its own PIP (23 Markdown and YAML files to 419 records),
and byword-social converted 99 files to about 2,600 records. Both kept their
display ids as `display_id` and their old anchors as aliases, split oversized
diagrams into lettered parts, and validate with no errors.

## Plan

1. **Freeze the source.** Note the source revision. Read `product.yaml`, the
   stack context, and every module file once end to end.
2. **Choose ids.** Decide the id scheme ([ids-and-parts.md](ids-and-parts.md)).
   Keep every existing display id (`FLOW-012`, `SEQ-014a`, `DATA-ACCOUNT`) and
   record each source heading's anchor as an alias, so old links still resolve.
3. **Pilot one module.** Convert the smallest module that has a flow, a
   sequence, and data. Validate, audit it, and review it with the owner before
   converting the rest.
4. **Fan out.** Convert the remaining modules with the reviewed pilot as the
   example, one module per agent or pass, each with its own audit section.
   Generating records with a script per source file is fine; keep the scripts
   outside `product/`.
5. **Integrate.** Validate the whole package to 0 errors, resolve every
   cross-module reference, and point code comments, tests, `AGENTS.md`, and
   docs that cited Markdown anchors at the records (by display id).
6. **Remove the Markdown PIP** in the same change, so there is one canonical
   package.

## Mapping

| Markdown + Mermaid | `.ready` |
| --- | --- |
| `product.yaml` fields | `product` record; `stack-context` becomes an alias of `product` |
| Stack-context systems, edges, and module paragraphs | `system` records with `connections`; each module's `summary` and `runs_in`; operator links in `actor.connections` |
| `## FLOW-012 Claim a shop` | journey with `display_id: FLOW-012`, `aliases: [flow-012-claim-a-shop]` |
| `### FLOW-012a …` lettered part | journey with `part_of`, listed in the overview's `parts` |
| Flowchart node with copy `"Claim your shop · Shop email · Send code"` | step with `copy {title, body, actions}` |
| `"Inline: That code isn't right…"` | step with `step_kind: error`, `presentation: inline`, `copy` |
| Edge label `-->|"web"|`, "on the phone" | `next.platforms`, `step.platforms` |
| `"Admin · invite…"` | `step.roles` |
| `subgraph SURFACE · Landing page at /` | surface with `route`, `audience`; `PROVIDER ·` becomes `surface_kind: provider` |
| `→ FLOW-010b`, `(["shops FLOW-020"])` | `next.to` the journey or step |
| "Back where sign-in started" | `next.to: $return` |
| `-.->` email or async edge | `next.channel` |
| A link node whose text differs from the target's title | `next.target_label` |
| `Runtime: [SEQ-010]` | `journey.sequences` / `step.sequences` |
| `## SEQ-014` + `### SEQ-014a/b/c` + `rect` overview | sequence overview with `parts`; one sequence per part; overview derived |
| `participant A as ARCH-001 Mobile app or ARCH-002 web page` | `{id: A, is: [sys.mobile, sys.web], label: Mobile app or web page}` |
| `->>` / `-->>` / self message | `msg` / `msg` with `reply: true` / `from` equal to `to` |
| `POST /api/claim/code {email}` | `msg.http` |
| `rpc app.claim_code_send(clerk_user_id, email)` | `msg.call`, plus `invokes` when that function has its own sequence or operation |
| `429 too_soon · Wait a moment…` | `msg.results [{status, code, copy}]` |
| `OWNER ·` | `msg.owner` or participant `owner` |
| `GUARD ·` | `msg.guards` |
| `INPUT ·` | `msg.inputs` with `source_kind` |
| `READ / INSERT / UPDATE / UPSERT / DELETE / LOCK / AUDIT / ENQUEUE / WRITE ·` | `msg.ops` with `op`, `entity` or `path`, `by`, `index`, `where`, `set`, `conflict`, `mode` |
| `ACCESS · … [I1]` | `ops[].index` |
| `CONSTRAINT · … [P1]` | `ops[].conflict`, or `ops[].note` naming the index |
| `JOIN ·` | `ops[].join [{entity, on}]` |
| `TRANSACTION ·` | a `transaction` block around the messages |
| `CALL · app.claim_store`, `access.authorize(…)` | `msg.invokes` (and `rules` when it applies a rule record) |
| `→ SEQ-014c` | `continue {to}` |
| `alt` / `opt` / `loop` / `par` / `break` | the same block |
| `Note over A,B` with no message | `note {over: [A, B], text, ops?, rules?}` |
| Other tags (`SUPPRESSED ·`, `FAILURE ·`, …) | `msg.tags` / `note.tags` |
| `**DCL:** 3 (product default)` | nothing (the product default applies); an override sets `sequence.dcl` |
| `Public operation: intent.establish(…)` | `operation` record, linked by `sequence.operation` and `operation.sequence` |
| `INVITATION_TTL = 7 days`, tier tables | `constant` records (a named constant with no value omits `value`) |
| `RULE-xxx` decision flowchart | rule `decision {nodes, edges}`; a simple gate uses `when`/`then`/`otherwise` |
| Decision or quota table | rule `table {columns, rows}` |
| Entity HTML table node | entity `columns` with `keys`, `fk`, `default`, `check`, `values`, `rule`; `INDEXES` becomes `indexes`; `COORDINATION` becomes `coordination` |
| "PK part 1", "PK part 2" | `primary_key: [a, b]` |
| `REFERENCE · DATA-020` box | nothing: the relationship points at the owning record |
| Relationship edge `a.x = b.y · 1 : 0..many · FK cascade` | `relationships {on, from_card, to_card, link, on_delete, label}` |
| `stateDiagram` | `state_machine` |
| `QC-020` YAML | `quality` record |
| Glossary entry | `term` record |
| `Acceptance exceptions` entry | `acceptance` record |
| `### Current rationale` | `rationale` on the record it explains (the module, or the product, for file-level rationale) |
| Prose paragraphs after diagrams | `notes` |
| Payload types, prompts, long reference prose | supplementary files in `product/<module>/files/`, listed in `files` |
| Theme, `classDef`, legends, link bars, overview maps, autonumbering | derived; not stored |

## Judgment calls that recur

- **Keep source words.** Titles, labels, `when` text, copy, and rationale are
  verbatim. `<br/>` becomes a space or a list item; Mermaid escapes become the
  character. Authored text (a `summary` the source lacked) is listed as authored
  in the audit.
- **Several facts on one line.** "READ / INSERT / UPDATE · DATA-ACCOUNT" becomes
  three ops. A data note covering two tables becomes two ops.
- **Calls written inside a note.** Turn them into messages (often self-messages
  in an `opt`) so each can carry `invokes`; the audit explains the added count.
- **Inline gates.** A guard used once stays on its message. Give a gate a rule
  record only when several records apply it, and then link it from each.
- **Nodes outside every subgraph that have outgoing edges.** Keep them as steps
  (with no surface) rather than only a `next.to` another journey, or their edges
  are lost.
- **Cross-module targets.** A flowchart node that stands for another module's
  journey becomes `next.to` that journey, not a copied step.
- **A JOIN with no column.** Use the only foreign key between the tables, and
  say so in the audit.
- **Constants without a value.** Keep the constant, omit `value`, and set
  `source` to where the value lives.
- **Rationale for a file with several journeys.** Put it on the module or on the
  first journey, and say which in the audit.
- **Stale or contradictory source.** Do not resolve it silently. Convert what
  the source says, list the conflict outside the package, and ask the owner.

## Fidelity audit

Write the audit outside `product/` (for example
`research/intent-model/<product>/FIDELITY.md`). It is the proof that nothing was
lost, organized so a reviewer can check it module by module.

1. **Totals:** records per kind, from the validator's summary line.
2. **Counts, source versus `.ready`,** per module, computed from the loaded
   model, not by hand: sequence messages, flowchart nodes to steps (plus
   cross-module targets), edges to `next` entries, entity columns, indexes,
   column badges, relationships, named rules to rule records, constants, public
   operations. Explain every difference (an added hand-off edge, messages
   created from calls in a note).
3. **Display ids:** a table of each display id, its record id, and the source
   heading it aliases. Note any compact ids you introduced.
4. **Per source file, a checklist:** each heading, diagram, subgraph, note tag,
   table, and paragraph, and the record and field it became. Mark derived things
   (themes, link bars, legends) as derived.
5. **Judgment calls:** each place you interpreted the source, with the reason.
6. **Not representable:** anything without a typed home, and what you did
   instead. The goal is "none"; each item here is a schema request for the
   owner, not a permanent workaround. A tag kept by choice says so.
7. **Rules applying rules:** each `rule.rules` link and the source sentence that
   justifies it.
8. **Checks:** the validator command and its final `0 errors` line, and any
   repository test that loads the package.

Byte-compare long prose (rationale, notes) against the source with a script
rather than by eye.

## After the conversion

- The repository's `AGENTS.md` names `product/` as the canonical PIP, the record
  layout, the validator command, and that ids stay stable.
- Code comments cite records by display id or id.
- Tickets link records, not Markdown anchors.
