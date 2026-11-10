# Common mistakes

## Format

- **Numbers where text is required.** `value: 2000`, `to_card: 1`,
  `params: [{value: 5}]`, a table cell `- 10` all fail as `field.invalid`. Quote
  them, and quote `format_version: "8.0.0"`. (`status` in `errors` and
  `results` is the exception: an integer.)
- **Unquoted `: ` in text.** `text: Note: retry later` is a YAML error. Quote the
  whole value, or use `>-`.
- **`ready: 1`.** Standard 8 records are `ready: 2`; anything else is
  `record.version`.
- **Invented fields.** `description` on a flow, `status` on anything,
  `related` on a flow, `sequences` on a step, `steps` on a sequence: all
  `field.unknown`. Check [format.md](format.md).
- **Surface fields on an operation, or the reverse** (`interface.fields`): a
  `route` on an endpoint, `params` on a page.
- **Empty strings or placeholder text** such as `TODO`: empty strings fail, and
  placeholders are task language in the canonical package.
- **Uppercase or spaced ids.** `id: FLOW-CREATE` is a display id, not an id.
- **HTML or diagram-syntax leftovers:** `<br/>`, `#59;`, colors, or a stored
  overview diagram.

## Flows and edges

- **An edge without a trigger** (`edge.trigger`), or with a trigger written as
  text (`trigger: The person taps Save`). The trigger is a record id; its
  `name` holds the words.
- **An edge without its sequence or outcome.** The edge that leads to a result
  or error step after system work names no `sequence` and `outcome`, so the
  viewer shows a move with no system work and the sequence seems to begin and
  end nowhere. Give each edge that runs a sequence its `sequence` and the
  `outcome` that leads to its `to`, one edge per outcome.
- **Edges for one sequence that start in different places** (`edge.start`):
  the success edge leaves the action step and the failure edge leaves the
  screen, or they use different triggers. All of a sequence's edges leave one
  step with one trigger.
- **An outcome no edge maps** (`sequence.outcome`), or an edge `outcome` the
  sequence does not list (`edge.sequence`). Every way the sequence can end
  leads somewhere, and every outcome an edge names exists.
- **A `sequences` list on a step.** Steps list no sequences; the viewer
  derives them from edges.
- **A sequence with its own trigger and an edge that runs it.** A sequence's
  `trigger` is only for one no edge runs (a schedule, an event, another
  system's call).
- **Mixing journey and lifecycle steps** (`step.kind`): a `state` step in a
  journey, or a `screen` step in a lifecycle.
- **An unreachable step** (`step.unreachable`): the first step has no entry,
  or an error step has no edge into it.
- **A lifecycle copied onto the entity.** The lifecycle is a flow whose
  `subject` is the entity; the entity has no lifecycle or invariants fields.

## Capabilities and shared records

- **Repeating the product DCL on a capability** (`dcl.same`). Omit the
  capability's level when the default fits. A shared record has no `dcl` field;
  its effective level follows the highest effective DCL among its users.
- **A channel as a capability.** "Plugin", "CLI", "Mobile app", or "Admin API"
  is not an outcome; its interfaces belong to the capabilities they serve.
- **An admin capability.** "Admin", "Admin management", or "Operations"
  holding refunds, monitoring, retries, and data fixes for users. Each of
  those serves a user outcome; put it in that outcome's capability with the
  operator among its actors. Only work serving no user outcome stands alone.
- **A capability per team, layer, or table,** or one capability holding several
  unrelated outcomes.
- **A capability-local rule used elsewhere** (`home.shared`). Move it to
  `shared/rules/` and remove its `capability`.
- **A shared record copied into a capability:** an entity's columns restated in
  a step's `does`, an interface's copy repeated on a step, a rule's condition
  copied into a guard. Link instead: `data`, `interface`, `rules`.
- **A flow or sequence with no `capability`** (`home.capability`), or a step
  that sets one: a step takes its flow's.
- **An interface no step or message uses** (`interface.unused`), or a trigger
  no edge or sequence uses (`trigger.unused`).

## Plain words

- **Ids in titles, summaries, guards, and messages.** "After RULE-COST, …" in
  a summary or "(SEQ-PREVIEW)" in a description (`text.id`). Say it in words;
  the link goes in `rules`, `refs`, `invokes`, `interface`, or the edge's
  `sequence`.
- **Ids in diagram text.** A decision node whose `text` says "Apply RULE-COST"
  while its `refs` already holds that record (`text.ref-id`). Name it in words;
  `refs` carries the link.
- **Code in prose.** A message whose `text` is `app.claim_code_send(email)`, a
  node that says `CALL · app._act_as_shop(viewer)`, a summary that says
  "refuses with store_required", a title that is a symbol (`access.authorize`),
  a trigger named `onSubmit`, a constant description that repeats
  `INVITATION_TTL = 7 days` (`text.code`, `text.call`). Put the call in
  `call`, the lock in `ops`, the file in `code` or `files`, the code in a
  `term`, the value in the constant's own fields; write the sentence a person
  would say.
- **A rule or sequence with no summary** (`summary.missing`), so the first
  thing a reader meets is the gate or the graph.
- **A summary that is a paragraph** (`summary.long`): topology, caller lists,
  restated conditions, or a whole specification. Keep one sentence of at most
  160 characters saying what the record is or does; move results to
  `returns`, conditions to the rule's logic, content lists to `elements`, and
  only what has no typed home to `notes`.

## One home per fact

- **Overloaded `sees`.** A step is one moment; a `sees` line stays only when
  it says what the person sees then and no other field holds it. Words on
  screen go in `copy` (the step's, or the surface element's when the screen
  always shows them); actions in `does`; a condition on an edge's `guard` or
  a decision step (`sees.branch`); a client difference in `platforms`
  (`sees.platform`); a screen's standing structure in the interface's
  `elements` and its empty, single-item, or width states in `states`;
  placement and color in the linked design; another flow's content in that
  flow, linked.
- **History in a record** (`text.history`). "Production QA 2026-11-03 round 17
  found…", "Owner decision of 2026-11-03", or "until BY-2212" in `rationale`
  or `notes`. Keep the current reason without its date, round, or ticket; git
  and the tracker hold the rest.
- **A term for a word nobody reads** (`term.unused`). An internal error code
  with no copy that shows it needs no term; a term earns its place when its
  `copy_word` appears in copy.
- **Identifiers parked in `notes`.** Moving a column, call, error code, or
  result key out of prose and into `notes` when `ops[].by`/`set`, `call`,
  `errors`, `returns`, or `results` can hold it.

## References

- **Referencing by display id.** References take the `id`
  (`rule.generation-cost`). `rules: [RULE-COST]` fails as `field.invalid`.
- **A step not listed in its flow,** or a flow listing a step that names
  another flow (`step.flow`). After splitting a flow, each step's `flow` names
  its part.
- **Parts in one direction only.** An overview `parts` entry without the
  part's `part_of`, or the reverse.
- **Participant keys.** A message `from: API` when the participant is listed as
  `system.worker`; a lane listed twice.
- **Index badges with a period.** `I1.1` instead of `I1·1` (middle dot), or a
  badge on a column for an index the entity does not define.
- **A data `state` that is not a lifecycle step id** (`data.state`):
  `state: saved` instead of `state: notes.note.saved`.
- **Unquoted cardinality or inverted sides.** `from_card` is the side of the
  entity that holds the relationship.
- **Supplementary paths.** `files: [{path: files/x.ts}]` must be
  `product/files/x.ts`, and the extension must be one the loader reads.
- **A renamed id with stale citations.** Changing an id or display id without
  updating every record, code comment, and document that cites it. There are
  no old names kept to catch them.

## Ownership and logic

- **Logic in prose.** A requirement in `notes`, `rationale`, `summary`, or a
  `tags` entry when a typed field (`alt`, `guards`, `results`, `when`/`then`,
  an edge `guard`, `copy`) can hold it.
- **Rule records for one-off gates.** A guard used by one message belongs on
  that message; a rule record needs a reason (it is reused or large).
- **The wrong rule kind.** An always-true statement written as a decision with
  no applier, or a "whenever X, then Y" written as a decision; use `invariant`
  and `policy`. A given/when/then test belongs in the code repository.
- **Satisfying the validator instead of the principle.** Listing a rule on an
  unrelated record to clear `rule.orphan`; giving a sequence a trigger record
  to clear `sequence.unreached` when an edge should run it; adding an edge to
  map an outcome the product never reaches; splitting a flow at an arbitrary
  step to clear `size.flow`.
- **Copy invented in `copy`.** `copy` quotes only real user-visible words;
  descriptions go in `sees` and `does`.
- **Layout in records.** Placement, colors, pills, and columns belong to the
  mockup the surface links, unless the design drives behavior. Restate a visual
  cue as the state it signals: "marked unread", not "a purple dot".
- **An invented branch outcome** for a case the owner never decided, or an
  invented runtime check to make a declarative constraint look connected.
- **A control panel for a manual fallback** when the requirement is that the
  responsible operator notices, or a log no one reads standing in for that.

## Intent

- **History and task language:** "now", "no longer", "will", "new", "replaces",
  "migrated from", dates, or ticket ids in any field.
- **Status metadata:** `tags: [{tag: STATUS, text: proposed}]`, "TBD" notes,
  open questions inside the package. Questions go to the owner; tasks go to the
  ticket.
- **Editing records to match the code** during an audit or implementation. Code
  is evidence; report the difference and let the owner decide.
- **Widening a rule silently:** turning "safe to expose" into "eligible to
  retrieve", adding a stored classification, or encoding policy in an index
  `where` without asking the owner.
- **Unproportional packages:** a record per table column, a lifecycle flow for
  every entity with a status column, a named trigger for every guard, an
  index of records.

## Process

- **Editing an export** instead of the records.
- **Skipping validation,** or reporting success with errors or new warnings.
- **Fixing `ref.missing` first** while a record with `field.invalid` is the real
  cause (it was never loaded).
- **Putting audits, rewrite notes, or scripts in `product/`.** Only records and
  the supplementary files they reference live there.
