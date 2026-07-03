---
name: ready-standard-update
version: 0.1.0
description: Sync the latest Ready Standard bundle into a product Ready tree and migrate the tree to that version.
---

# Ready Standard Update

Use this module when a user asks to update, upgrade, or migrate a product Ready
tree to the latest Ready Standard or to a named Ready Standard version.

## Authority

Before changing a product repo, read that project's authority document and
confirm the agent is allowed to edit the Ready tree. If the standard source repo
does not have an authority document, say so and keep source-repo edits limited
to the explicitly requested standard bundle or docs work.

## Inputs

- Source standard repo or released standard bundle.
- Target product repo with `ready/manifest.yaml`.
- Target project authority and governance files.

## Process

1. Read the source standard `manifest.yaml` and `skills/manifest.yaml`.
2. Confirm the source standard version is newer than the target
   `ready_standard.version` or the target `ready/standard/manifest.yaml`
   version. If the target is already current, still verify the local bundle
   matches the source bundle.
3. Sync the portable bundle into `ready/standard/`.
   - Include `README.md`, `manifest.yaml`, `vocabulary.yaml`, `skills/`, and
     `templates/`.
   - Exclude `docs/`, `.git/`, `.gitignore`, local cache, raw logs, transcripts,
     private samples, and secrets. The vendored bundle is the local runtime
     contract; `docs_source` points to public reference docs.
4. Update `ready/manifest.yaml` so `ready_standard` points at the local bundle:

   ```yaml
   ready_standard:
     version: "<STANDARD_VERSION>"
     repository: "https://github.com/seanbhart/ready-standard"
     package_path: "ready/standard"
     package_manifest: "ready/standard/manifest.yaml"
     docs_source: "https://github.com/seanbhart/ready-standard/tree/<STANDARD_VERSION>/docs"
   ```

5. Update product manifests that carry standard metadata to the same version and
   local bundle path.
6. Read the new local `ready/standard/skills/ready-skill.md` and modules needed
   for the migration.
7. Migrate product records to the new standard. For the current standard:
   - Primitive records use `kind: primitive`, `class`, and class-specific
     top-level `type`; remove `primitive_class`, `fields.premise_type`, and
     `fields.intent_type`.
   - Flag and Decision records use `kind: flag`, flag `class`, class-specific
     top-level `type`, `compiler_role`, `claimable`, `blocked_by`, and
     `closure_criteria`.
   - Claimable readiness flags with `type: seed` or `type: change` carry
     `fields.scope`, `fields.non_scope`, `fields.dependencies`,
     `fields.required_standards`, `fields.required_services`,
     `fields.required_artifacts`, `fields.setup`, `fields.acceptance`, and
     `fields.blocker_policy`.
   - Legacy unresolved-decision records migrate to `class: decision`,
     `type: product_choice`, stable `XD-*` ids, `fields.safe_default`,
     structured `fields.proposals`, and `fields.decision_needed`; remove
     legacy answer and owner-decision fields.
   - Intent `completion_proof`, `fields.input_types`, `fields.input_samples`,
     `fields.output_types`, `fields.output_samples`, and
     `fields.validation_boundary` are legacy intent fields. Migrate durable IO
     and proof expectations into `proof_cases`; move non-proof interface shape
     into `fields.scope`, `fields.statement`, operating fields, or a governing
     standard.
   - Flag `completion_proof` is a legacy closure field. Rename it to
     `closure_criteria`; flag closure criteria stay plain string lists and are
     not keyed proof targets.
   - Proof evidence artifacts with legacy clause-key `fields.satisfies` migrate
     to `fields.proof_targets`: a non-empty list of `{case, pair}` entries that
     resolve to the owning intent's `proof_cases` keys. Keep `fields.proof_of`;
     remove `satisfies`. Evidence whose old clause keys no longer map to a real
     case/pair needs owner review, not a guessed target.
   - Runnable tests that support proof cases must emit exact per-result runtime
     metadata for the target pair, such as `task.meta.readyRoom = { caseKey,
     pairKey, inputs, outputs }` in Vitest. File comments or proof-target
     citations only link the file; they do not group test results or prove the
     pair. Avoid helper defaults in multi-proof files, and split checks when one
     fixture corpus supports several proof pairs.
   - When splitting a broad proof into multiple proof cases, split the artifacts
     at the same boundary. Each proof pair should name input and output artifacts
     that define the exact case slice and expected result for that pair; a broad
     shared corpus may remain as a parent artifact but should not be the only
     contract visible to implementers.
   - After migrating, verify no stale legacy fields remain: search the product
     tree (excluding the vendored `ready/standard/` bundle, whose migration
     guidance legitimately names old fields) for `completion_proof`,
     `satisfies`, `input_types`, `input_samples`, `output_types`,
     `output_samples`, and `validation_boundary`. Every hit must be resolved or
     explicitly justified before the tree claims the new standard version.
   - Draft records make a bundle incomplete. Orchestrators warn
     before implementation and do not imply a complete product from the build.
   - Blocked records stop implementation unless explicit override instructions
     are present.
   - Records with non-empty `blocked_by` or `fields.blockers` use
     `status: blocked`.
   - Store one structural edge per relationship in `refs`; do not mirror inverse
     refs.
   - Any record may relate to any other record when the structural relationship
     is true and project policy allows the kind/class pairing.
   - Approved stored roles are `peer`, `parent`, and `child`. In compact refs,
     the role describes the target record's position relative to the current
     record.
   - Semantic verbs such as `serves`, `requires`, `governed by`, `refines`,
     and `interrupts` are derived reader labels, not stored
     ref roles.
   - Valid vocabulary lives in `ready/standard/vocabulary.yaml`.
   - Semantic relationship display lookups in vocabulary.yaml include both
     source-to-target and target-to-source phrases for the same stored edge,
     such as `serves` / `served by`.
   - Standards that govern intents, services, flags, or other standards should
     usually migrate to `peer` refs. Do not attach standards or services
     directly to premises; move those refs to the intent that serves the premise.
8. Preserve project-specific governance and product truth. Do not rewrite
   product meaning merely to fit a template.
9. Verify the migrated tree:
   - no stale standard versions or legacy fields;
   - every record has a unique id;
   - every structural ref points to an existing id;
   - no duplicate structural edges;
   - no inverse duplicate edges and no semantic roles left in `refs`;
   - every flag has top-level `class`, `type`, `compiler_role`, `claimable`,
     and non-empty concrete `closure_criteria`;
   - every claimable seed or change flag has the required handoff fields;
   - the vendored bundle differs from the source bundle only by intentionally
     excluded source-repo files.
10. Report the source version, target bundle path, migration changes, and
    verification commands.

## Agent Rule

For ordinary product-tree edits, agents read the target repo's local
`ready/standard/` bundle. They fetch from the source standard repo only when
the task explicitly asks for a latest-version or named-version standard update.
