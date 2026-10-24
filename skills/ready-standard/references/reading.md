# Reading a package

A Ready Intent Package (RIP) lives at `<repo>/product/`.

## Where to start

1. `product/product.ready`: the outcome, boundary, exclusions, measures, default
   DCL, and product-wide rationale.
2. The root records: `actors/`, `systems/` (topology and connections), and
   `capabilities/` (which modules deliver what).
3. The relevant module: `product/<module>/module.ready` (what it owns, where it
   runs, its invariants and rationale), then its journeys and steps, sequences,
   rules, constants, and `data/`.
4. Follow links by id. A step's `sequences` and `rules`, a message's `invokes`,
   and an entity's `relationships` lead to the owners; read those rather than
   inferring behavior from the consumer.

A record's `rationale` explains why it is shaped that way; read it before
proposing to change the design.

## Export a readable view

The records are optimized for checking and diffing; for reading a whole module,
export the package:

```sh
npx @readyroom/ready export <repo> <out>                     # Markdown book
npx @readyroom/ready export <repo> <out>.json --format json  # one JSON bundle
```
`<repo>` is the directory that contains `product/`.

- Markdown writes `<out>/product/README.md` (product, actors, systems,
  capabilities) and `<out>/product/modules/<module>.md`, with derived Mermaid
  diagrams and links between records, plus the supplementary files they link.
- JSON writes every loaded record and the supplementary files to one file, for
  scripts.
- Records that fail validation are left out of the export, and the command says
  so. Validate first.

Write exports to a scratch directory, never into the repository's `product/`,
and never edit an export: it is regenerated from the records.

## Find things

- Every reference to a record: `grep -rn '<id>' product/`.
- A record by display id or alias: `grep -rln 'SEQ-014' product/`, then keep the
  file whose `display_id` or `aliases` holds it.
- All records of a kind: `grep -rl '^kind: rule' product/`.
- A package summary: `npx @readyroom/ready validate <repo>` ends with counts per kind.

## Reading Ready Room's own package

Ready Room's `product/` (about 450 records in seven modules) is a complete
example of the standard in use. `product/notifications/` is a small module that
shows most kinds: a journey with steps, surfaces, operations, a sequence with
`alt` branches and data `ops`, table rules, and entities with partial indexes.
