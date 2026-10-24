# Auditing code against records, and writing tickets

## Audit

The records are the expected behavior. Code, schemas, tests, tickets, logs, and
runtime behavior are evidence of what exists. An audit reports the difference;
it does not edit records to match the code.

An audit compares code with a Ready Intent Package (RIP).

1. **Fix the baseline.** Record the canonical RIP revision (commit) and
   `product.release` in the audit notes, not in the RIP. Validate it: an audit
   against a package with errors is unreliable.
2. **Scope by module.** Use a ticket, if any, only to find the scope and code
   area. Take the expected behavior from the owning records: the module's
   journeys and steps, sequences, rules, constants, entities, and operations.
   Follow direct links (`invokes`, `rules`, `relationships`) into other modules
   only where an exported operation, shared entity, or cross-module invariant is
   involved. A change to what a module promises (result meaning, refusals,
   atomicity, idempotency, privacy, retention) widens the scope to its
   consumers even when signatures are unchanged; missing links do not prove
   there are none.
3. **Map records to code.** Start from the records' own anchors: `operation.http`
   and `owner`, message `call`, `http`, and `owner`, `system.code`,
   `surface.route` and `code`, `entity.table`, index `name`, constant `source`.
   Search code comments for display ids. A named owner is intent: a missing file
   is a finding, not a broken record.
4. **Compare by kind:**
   - *Sequences:* each message happens in that order, with the stated inputs and
     their sources; each `alt`/`opt`/`break` branch exists with its `results`
     (status, code, copy); each `op` reads or writes the named table through the
     named index or keys, inside the stated `transaction`; `invokes` calls the
     named operation rather than reimplementing it.
   - *Rules and constants:* conditions, tables, defaults, and precedence match;
     values come from the constant (or its `source`), not a second literal.
   - *Steps and surfaces:* the user can take every `next`; copy matches `copy`
     verbatim, slots included; error steps exist; the surface matches its exact
     `mockup` target.
   - *Entities:* compare the repository's declared schema (not its migration
     history) with columns, keys, nullability, defaults, checks, indexes (columns,
     predicate, uniqueness), foreign keys, and `access`.
   - *Operations:* method, path, auth, params, return shape (and the contract
     file), and every listed error.
   - *Quality:* the target is measured where the record says.
5. **Report** outside the package, per finding: the record (display id and id),
   the code location, what differs, and severity (security, privacy, money, data
   integrity, and destructive effects first). Report ticket-versus-record drift
   separately from code-versus-record drift. Note unspecified internals that
   engineering may choose freely; they are not findings.
6. **Resolve.** Fix code toward the records when that work is authorized. If the
   team wants the code's behavior to become intent, that is a change the owner
   decides; propose it as a record change for review, never as a silent edit.

Optionally compare the product's target DCL with the implementation's apparent
level, in the audit notes only.

When the product has several clients (web, mobile, a CLI), audit them against
each other from time to time: every difference is either a `platforms` entry
the records state on purpose or a finding. Resolve each with the owner, one at
a time, with a recommended option.

## Implementing from records

- Read the owning records first; name the record ids in the plan.
- Reuse the code owners the records name (`owner`, `code`) instead of adding
  parallel implementations.
- An exact `mockup` target binds the implementation: do not silently add,
  remove, merge, split, or redesign surfaces. Generated or exported design code
  is a reference, not an override. Raise a conflict with the product or design
  owner.
- Change declared state first (schema files, infrastructure config) and generate
  migrations from the diff; the records hold the product-significant subset of
  that declared state. If the repository has only migrations, stop and propose
  a declared schema (generated from the current database) before adding one.
  Review generated migrations for destructive drops, and hand-edit one only for
  what a diff cannot express.
- Pause and ask before a mechanism the records do not state would add a
  classification, split a population, move a rule between stages, add derived
  state or a backfill, or put policy in an index predicate
  (see [principles.md](principles.md#the-owner-directs-intent)).
- Cite records in code comments by display id (`// SEQ-NOTES-SAVE`) or id.
- When the records do not resolve a case you hit, ask the owner and record the
  answer in the owning record before building it.

## Tickets

A ticket links records; it does not restate them.

- **Title:** a short implementation objective, or the display ids.
- **Body:** the canonical revision or release; direct links or ids of the
  records to satisfy; then only execution context: what to touch and not touch,
  verified code anchors, order, hazards, blockers, and the proportional
  verification (core path, required failure and recovery, dangerous edges).
- Split tickets by outcome (a journey, sequence, or operation), not by file or
  layer.
- **Never** copy copy, conditions, acceptance, or data rules into the ticket.
  Completion means alignment with the linked records plus the ticket's own
  evidence.
- If a ticket and a record disagree, the record governs; correct the ticket.
