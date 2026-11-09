# Reading a package

A Ready Intent Package (RIP) lives at `<repo>/product/`.

## Where to start

1. `product/product.ready`: the outcome, boundary, exclusions, measures,
   default DCL, and product-wide rationale.
2. The capabilities: `product/capabilities/*/capability.ready`, each an outcome
   some actor gets, in their `order`, with their own DCL or the product default.
   If neither sets a DCL, the capability has none.
3. The relevant capability's flows. A flow whose `subject` is an actor is a
   journey; one whose `subject` is an entity is that entity's lifecycle. Read
   the steps in the flow's `steps` order, and follow each step's `edges`: the
   trigger that takes the edge, its guard, and the sequence and outcome it
   runs.
4. The sequences those edges run, then the rules and triggers the capability
   holds.
5. The shared records the capability links: `product/shared/data/` (entities
   and data groups), `interfaces/` (the surfaces steps show on and the
   operations messages call), `actors/`, `systems/` (topology and
   connections), and shared `triggers/`, `rules/`, `constants/`, and `terms/`.
   Read the owner rather than inferring behavior from the consumer.

A record's `rationale` explains why it is shaped that way; read it before
proposing to change the design.

## What is derived

These are not stored in any record; the viewer and the export work them out
from references:

- where a sequence starts, decides, and ends (from the edges that name it);
- which records a capability owns (from their `capability`);
- where an interface is shown or called (from `step.interface` and
  `msg.interface`);
- an entity's lifecycle (the flow whose `subject` it is);
- which flows lead to or come from others (from `entries[].from`);
- which journeys move lifecycles, and which journeys a lifecycle is moved by
  (from shared edge sequences or journey steps' `data[].state` references);
- effective DCL: the capability's own level, else the product default, else
  none; shared records take the highest effective level among the capabilities
  that use them;
- the overview diagram of a record split into parts, and "used in" lists.

## Export a readable view

The records are optimized for checking and diffing; for reading a whole
capability, export the package:

```sh
npx @readyroom/ready export <repo> <out>                     # Markdown book
npx @readyroom/ready export <repo> <out>.json --format json  # one JSON bundle
```

`<repo>` is the directory that contains `product/`.

- Markdown writes a readable book under `<out>/product/` with derived diagrams
  (flow, sequence, and entity diagrams) and links between records, plus the
  supplementary files they link. The README shows the product DCL default;
  each capability chapter shows its effective level, its basis, and whether it
  uses the product default.
- JSON writes every loaded record and the supplementary files to one file, for
  scripts.
- Records that fail validation are left out of the export, and the command says
  so. Validate first.

Write exports to a scratch directory, never into the repository's `product/`,
and never edit an export: it is regenerated from the records.

## Find things

- Every reference to a record: `grep -rn '<id>' product/`.
- A record by display id: `grep -rln 'display_id: SEQ-PREVIEW' product/`.
- All records of a kind: `grep -rl '^kind: rule' product/`.
- Every edge that runs a sequence: `grep -rn 'sequence: <sequence id>' product/`.
- Everything a capability owns: `grep -rl '^capability: <capability id>' product/`.
- A package summary: `npx @readyroom/ready validate <repo>` ends with counts per kind.

## A small example

[`assets/template-package/product/`](../assets/template-package/product/) is a
complete small package: one capability with a journey and a lifecycle, two
sequences with outcomes, triggers on every edge, a decision and a quality rule,
and the shared entity, data group, interfaces, actor, system, constant, and
term they use.
