# Writing a RIP for an existing product

Use this when a product exists and its Ready Intent Package (RIP) is missing,
incomplete, contradicts itself, or is written in some other form. The task is
always the same: write the product's intended end state from scratch, in the
format of [format.md](format.md), using everything that exists as source
material. Nothing is carried over mechanically. An earlier RIP, intent
documents, specs, and tickets are read for what they say the product should
do, then written again as records; their structure, ids, and wording are not
kept for their own sake.

Code, screens, documents, tests, data, old intent documents, and stakeholder
statements are evidence of what exists or was said. None of them is the
intended end state until the owner chooses it (see
[principles.md](principles.md#the-owner-directs-intent)).

## Steps

1. **Work outside the canonical package.** Write the records in a RIP fork (a
   branch, worktree, or separate directory) and keep observations, inferences,
   contradictions, and questions in separate working notes. Never use the
   canonical `product/` as the scratchpad.
2. **Fix the target.** Name the product and release being described and the
   source environments. Describe one end state; do not blend several
   deployments or clients into one implied product.
3. **Read the sources once, end to end:** any existing intent documents, then
   running surfaces, routes, designs, tests, schemas, contracts, integrations,
   operations, and incidents. In the notes, mark each finding as observed (in
   the code or the running product), stated (in a document or by a person),
   or inferred, and note source limits.
4. **Propose the capability map to the owner first.** List the outcomes each
   actor gets (owners, visitors, operators, agents), one capability per
   outcome, and the channels that contribute interfaces to them. Assign each
   behavior to one capability. Old groupings (by module, team, screen, or
   artifact type) are evidence, not the map. Wait for the owner's answer
   before writing records.
5. **Write the shared vocabulary:** actors, systems, the entities that carry
   product meaning, and the interfaces (surfaces and operations) people and
   programs use.
6. **Write each capability from the outside in:** its journeys (steps, the
   trigger on every edge, error and outcome steps), then the sequences those
   edges run with their outcomes, then the lifecycles of the records the
   journeys move, then only the rules, constants, and terms needed to pin down
   product meaning. Pilot one capability and review it with the owner before
   writing the rest.
7. **Give everything new ids** under [ids-and-parts.md](ids-and-parts.md):
   capability-prefixed for behavior, kind-prefixed for shared records. Point
   every code comment, test, `AGENTS.md`, and document that cites an old id or
   anchor at the new record, in the same change.
8. **Ask about each consequential behavior.** For each, the owner decides
   whether it is intended, a defect, a legacy constraint, a different future
   product, or out of scope. Ask one question at a time, with a recommended
   answer. Where an old document and the code disagree, neither wins; ask. Do
   not infer DCL from company stage or code complexity; ask about users,
   waiting, failure consequence, recovery, and load.
9. **Check that nothing was lost.** Walk the sources again and confirm that
   every behavior, copy string, rule, data constraint, and reason the owner
   kept has a home in a record (a typed field, `rationale`, `notes`, or a
   supplementary file), and that everything left out was left out on purpose.
   Keep this check in the working notes.
10. **Write one coherent end state** in the fork: present tense, no evidence
    labels, questions, alternatives, or status. Validate it to 0 errors and
    review every warning.
11. **Adopt it** through the repository's normal review by someone who can
    decide the whole change, and remove the superseded intent documents in the
    same change so there is one canonical package. Until then the canonical
    package is unchanged.
