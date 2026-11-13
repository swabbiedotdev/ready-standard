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

## Reading a repository of any size

The method is the same for a small repository and a large one: divide the
sources into sections, read the key content of each section, and read detail
in full only where the work needs it. A larger repository takes more reading,
never a different method, and no part of it is left out; only the depth of
reading varies.

**Sections are capabilities.** Until the owner confirms the capability map
(step 4), work from a survey: the entry points (routes, screens, commands,
jobs, webhooks) and the data schema. Once the map is confirmed, assign each
source file to a capability by the strongest signal it gives:

1. record ids the file cites;
2. the systems, operations, and surfaces a capability's records name;
3. reachability from the capability's entry points;
4. its directory, as a last resort.

Code that several capabilities use forms a shared section. Code that maps to
no capability is a finding to raise with the owner. A section too large to
read in one sitting is divided by its flows, and the same method applies one
level down.

**Key content is what tells you whether you need the detail.** Keep two
things per section in the working notes:

- an index, with one line for every source file (its path and what it
  exports, serves, or stores) and, once records exist, one line for every
  record (id, kind, title, summary);
- a brief, written after reading the section in full once: what crosses the
  section's boundary (shared entities, operations other sections call), then
  its rules and anything that moves money, changes access, loses data, or
  acts outside the product, then its flows by step title.

The index covers everything, always. Rewrite a brief only when its section
changes.

**Read in full whatever you are about to write, assert, or judge.** Read a
capability's whole section before writing its records, and read every source
a record's claim rests on. Say that the sources are silent on a behavior only
after checking the section's index and reading the candidates it names. After
the capabilities are written, make one pass over the boundaries between them.

## Steps

1. **Work outside the canonical package.** Write the records in a RIP fork (a
   branch, worktree, or separate directory) and keep observations, inferences,
   contradictions, and questions in separate working notes. Never use the
   canonical `product/` as the scratchpad.
2. **Fix the target.** Name the product and release being described and the
   source environments. Describe one end state; do not blend several
   deployments or clients into one implied product.
3. **Survey the sources; do not read them end to end yet.** Read any existing
   intent documents, then list the entry points (running surfaces, routes,
   commands, jobs, webhooks), the data schema, and the integrations. In the
   notes, mark each finding as observed (in the code or the running product),
   stated (in a document or by a person), or inferred, and note source
   limits.
4. **Propose the capability map to the owner first.** List the outcomes each
   user gets (owners, visitors, agents), one capability per outcome, with
   each piece of admin or operator work placed in the capability it serves,
   and the channels that contribute interfaces to them. Assign each
   behavior to one capability. Old groupings (by module, team, screen, or
   artifact type) are evidence, not the map. Ask from the survey alone, and
   wait for the owner's answer before reading any capability in detail or
   writing records: a wrong map wastes all the reading that follows it.
5. **Write the shared vocabulary:** actors, systems, the entities that carry
   product meaning, and the interfaces (surfaces and operations) people and
   programs use.
6. **Write each capability from the outside in,** after reading its section
   in full: its journeys (steps, the
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
9. **Check that nothing was lost.** Walk every section's index and confirm that
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
