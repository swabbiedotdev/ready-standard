# Common mistakes

## Format

- **Numbers where text is required.** `value: 2000`, `to_card: 1`,
  `params: [{value: 5}]`, a table cell `- 10` all fail as `field.invalid`. Quote
  them. (`status` in `errors` and `results` is the exception: an integer.)
- **Unquoted `: ` in text.** `text: Note: retry later` is a YAML error. Quote the
  whole value, or use `>-`.
- **`from: [*]`** is a YAML error (an empty alias). Write `from: "[*]"`.
- **Invented fields.** `description` on a journey, `status` on anything,
  `steps` on a sequence: all `field.unknown`. Check [format.md](format.md).
- **Empty strings or placeholder text** such as `TODO`: empty strings fail, and
  placeholders are task language in the canonical package.
- **Uppercase or spaced ids.** `id: FLOW-012` is a display id, not an id.
- **Mermaid or HTML leftovers:** `<br/>`, `#59;`, `classDef`, colors, or a
  stored overview diagram.

## References

- **Referencing by display id or alias.** References take the `id`
  (`access.rule.authorize`). `rules: [RULE-ACCESS]` fails as `field.invalid`
  (not a lowercase id), and a lowercase alias such as
  `rule-access--accessauthorize` fails as `ref.missing`.
- **A step not listed in its journey,** or a journey listing a step that names
  another journey (`step.orphan`, `journey.step`). After splitting a journey,
  each step's `journey` names its part.
- **Parts in one direction only.** An overview `parts` entry without the part's
  `part_of`, or the reverse (`part.mismatch`).
- **Participant keys.** A message `from: API` when the participant is listed as
  `sys.worker`; a lane listed twice.
- **Index badges with a period.** `I1.1` instead of `I1·1` (middle dot), or a
  badge on a column for an index the entity does not define.
- **Unquoted cardinality or inverted sides.** `from_card` is the side of the
  entity that holds the relationship.
- **Supplementary paths.** `files: [{path: files/x.ts}]` must be
  `product/<module>/files/x.ts`, and the extension must be one the loader
  reads.

## Ownership and logic

- **Restating another module.** Copying a rule's condition into a step's `does`,
  another module's columns into your entity, or a sequence's internals into a
  caller. Link instead: `rules`, `invokes`, `relationships`.
- **Logic in prose.** A requirement in `notes`, `rationale`, `summary`, or a
  `tags` entry when a typed field (`alt`, `guards`, `results`, `when`/`then`,
  `next.when`, `copy`) can hold it.
- **Rule records for one-off gates.** A guard used by one message belongs on
  that message; a rule record needs an owner reason (it is shared or large).
- **Satisfying the validator instead of the principle.** Listing a rule on an
  unrelated record to clear `rule.orphan`; giving a called sequence an `event`
  trigger to clear `sequence.unreachable`; splitting a journey at an arbitrary
  step to clear `size.journey`.
- **Copy invented in `copy`.** `copy` quotes only real user-visible words;
  descriptions go in `sees` and `does`.
- **Layout in records.** Placement, colors, pills, and columns belong to the
  mockup the surface links, unless the design drives behavior.
- **A DCL on every sequence.** The product default applies; a sequence sets
  `dcl` only for a real override with its own `basis`.

## Intent

- **History and task language:** "now", "no longer", "will", "new", "replaces",
  "migrated from", "v7", dates, or ticket ids in any field.
- **Status metadata:** `tags: [{tag: STATUS, text: proposed}]`, "TBD" notes,
  open questions inside the package. Questions go to the owner; tasks go to the
  ticket.
- **Editing records to match the code** during an audit or implementation. Code
  is evidence; report the difference and let the owner decide.
- **Changing an `id`** because a title changed. Change `title` or `display_id`
  and keep the old display id in `aliases`.
- **Unproportional packages:** a record per table column, an acceptance record
  restating a sequence, a state machine duplicating what sequences show, an
  index of records.

## Process

- **Editing an export** instead of the records.
- **Skipping validation,** or reporting success with errors or new warnings.
- **Fixing `ref.missing` first** while a record with `field.invalid` is the real
  cause (it was never loaded).
- **Putting audits, conversion notes, or scripts in `product/`.** Only records and
  the supplementary files they reference live there.
