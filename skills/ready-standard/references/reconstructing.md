# Reconstructing intent from an existing product

Use this when a product exists but its Ready Intent Package (RIP) is missing,
incomplete, or contradicts itself. Converting an existing Markdown PIP is a
different task: see [converting.md](converting.md).

Screens, code, documents, tests, data, and stakeholder statements are evidence
of what exists or was said. None of them is the intended end state until the
owner chooses it (see [principles.md](principles.md#the-owner-directs-intent)).

1. **Work outside the canonical package.** Write the records in a RIP fork (a
   branch, worktree, or separate directory) and keep observations, inferences,
   contradictions, and questions in separate working notes. Never use the
   canonical `product/` as the scratchpad.
2. **Fix the target.** Name the product and release being described and the
   source environments. Describe one end state; do not blend several
   deployments or clients into one implied product.
3. **Gather only useful evidence:** running surfaces, routes, designs, documents,
   tests, schemas, contracts, integrations, operations, and incidents. In the
   notes, mark each finding as observed or inferred, and note source limits.
4. **Work from the outside in:** actors and journeys with their steps and
   surfaces first, then capabilities, then systems and modules, then only the
   sequences, rules, entities, operations, and constants needed to pin down
   product meaning.
5. **Ask about each consequential behavior.** For each, the owner decides
   whether it is intended, a defect, a legacy constraint, a different future
   product, or out of scope. Ask one question at a time, with a recommended
   answer. Do not infer DCL from company stage or code complexity; ask about
   users, waiting, failure consequence, recovery, and load.
6. **Write one coherent end state** in the fork: present tense, no evidence
   labels, questions, alternatives, or status. Validate it to 0 errors.
7. **Adopt it** through the repository's normal review by someone who can
   decide the whole change. Until then the canonical package is unchanged.
