# Ids, display ids, aliases, and parts

## `id`: the machine name, forever

- Lowercase dotted: segments of `a-z0-9`, joined inside a segment by `-` or
  `_`, separated by `.`. No uppercase, spaces, or `$`.
- Unique across the package (`record.duplicate`), and never changed once other
  records, code comments, tickets, or Ready Room links use it.
- **References always use the target's `id`.** Fields such as `steps`,
  `rules`, `invokes`, `module`, and `fk.entity` are looked up by id only; a
  display id or alias there is `ref.missing`. Aliases and display ids resolve
  only for people: search, deep links, and citations.
- If a record must move (it changes module, or two records merge), give the
  surviving record the new id, add the old id to its `aliases`, and rewrite every
  reference to the new id in the same change.

Conventions used by Ready Room's own package (`<m>` is the module id, which is
also the module's folder name):

| Kind | id pattern | Example |
| --- | --- | --- |
| product | `product` | `product` |
| actor / system / capability | `actor.<name>` / `sys.<name>` / `cap.<name>` | `actor.admin`, `sys.d1` |
| module | `<m>` | `notifications` |
| journey | `<m>.<journey>` | `notifications.inbox` |
| step | `<m>.<journey>.<step>` | `notifications.inbox.open` |
| surface | `<m>.surface.<name>` | `notifications.surface.bell` |
| operation | `<m>.op.<name>` | `notifications.op.notify` |
| sequence | `<m>.seq.<name>` | `notifications.seq.notify` |
| rule | `<m>.rule.<name>` | `notifications.rule.audience` |
| constant | `<m>.const.<name>` | `access.const.invitation-ttl` |
| entity | `<m>.data.<table>` | `notifications.data.notification` |
| entity group | `<m>.data` or `<m>.data.<name>` | `notifications.data` |
| state machine | `<m>.state.<name>` | `catalog.state.listing-lifecycle` |
| quality / term / acceptance | `<m>.quality.<name>` / `<m>.term.<name>` / `<m>.acceptance.<name>` | `shops.quality.qc-143` |

A package may use another scheme, but keep one scheme throughout.

## `display_id`: the human name

- The id people and code cite: `FLOW-012`, `SEQ-014`, `RULE-ACCESS`,
  `DATA-ACCOUNT`, `QC-020`. Operations usually use their code name
  (`access.authorize`).
- Optional. Give one to records that people, tickets, or code comments cite:
  journeys, sequences, shared rules, entities, quality constraints, and public
  operations. Steps, surfaces, and constants rarely need one.
- Unique across every id, display id, and alias in the package
  (`display.duplicate`).
- Stable like `id`. When a display id must change, add the old one to `aliases`.
- Keep a converted package's existing display ids (`FLOW-012`) rather than
  renumbering. For sections that had no id, a compact id with a module mnemonic
  works (`FLOW-NOTIFY-INBOX`, `SEQ-REPO-INSPECT`).
- Each record has its own number; lowercase letters mark only the parts of one
  record.

## `aliases`: names that still resolve

- Retired ids, retired display ids, and old heading anchors from a Markdown PIP
  (GitHub-style slugs: lowercase, punctuation removed, spaces to hyphens, so
  `## RULE-ACCESS · access.authorize` becomes `rule-access--accessauthorize`).
- An alias must not equal any other record's id, display id, or alias.
- Never remove an alias that something outside the package may still link to.

## Lettered parts

Journeys, sequences, rules, and entity groups can be split into parts. Split a
journey over 12 steps or a sequence over 16 messages (the `size.*` warnings);
also split when one record mixes separately readable phases.

The overview record:

- keeps the original `id`, `display_id`, and `aliases`, so existing links still
  land on it;
- lists `parts: [<id>.a, <id>.b, …]` in reading order;
- holds what applies to the whole: `summary`, `rationale`, `trigger`,
  `operation`, `entries`, `sequences`, `related`;
- carries no content of its own: a journey overview has `steps: []`, a sequence
  overview has `items: []` (its `participants` are still required; list the
  lanes the parts share).

Each part:

- has id `<overview id>.a` (`.b`, …), `part_of: <overview id>`, and display id
  `<overview display id>a` (`SEQ-014a`), or with a hyphen when the display id
  ends in letters (`SEQ-REPO-INSPECT-a`);
- is a complete record of the same kind (a journey part needs `module`,
  `actors`, `title`, `summary`, `steps`);
- links to the next part directly: a sequence part ends with
  `continue: {to: <next part id>}`, and a step's `next` points at the first step
  of the next journey part.

Step ids in a split journey use the overview's namespace
(`product-intent.review.chat`, with `journey: product-intent.review.a`), so a
later re-split moves steps between parts without renaming them.

The validator checks both directions (`part.mismatch`): every id in `parts`
names a record of the same kind whose `part_of` is the overview, and every
`part_of` is listed in its overview's `parts`.

File names are free; Ready Room uses `inspect.ready`, `inspect-a.ready`, … in
the kind's folder.
