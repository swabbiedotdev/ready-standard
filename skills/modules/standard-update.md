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
     `completion_proof`.
   - Claimable readiness flags with `type: seed` or `type: change` carry
     `fields.scope`, `fields.non_scope`, `fields.dependencies`,
     `fields.required_standards`, `fields.required_services`,
     `fields.required_artifacts`, `fields.setup`, `fields.acceptance`, and
     `fields.blocker_policy`.
   - Legacy unresolved-decision records migrate to `class: decision`,
     `type: product_choice`, stable `XD-*` ids, `fields.safe_default`,
     structured `fields.proposals`, and `fields.decision_needed`; remove
     legacy answer and owner-decision fields.
   - Intent `completion_proof` is the durable Definition of Done. It must
     contain concrete observable proof, not a one-word status. As of Ready
     Standard 0.4.0, intent clauses must be keyed maps with `key`, `kind`, and
     `statement`; convert every bare-string intent clause during migration.
   - Flag `completion_proof` is closure criteria for a temporary bundle-work
     record, not the canonical product DoD. Flag clauses stay plain string
     lists and are not keyed in 0.4.0.
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
     and non-empty concrete `completion_proof`;
   - every claimable seed or change flag has the required handoff fields;
   - the vendored bundle differs from the source bundle only by intentionally
     excluded source-repo files.
10. Report the source version, target bundle path, migration changes, and
    verification commands.

## Agent Rule

For ordinary product-tree edits, agents read the target repo's local
`ready/standard/` bundle. They fetch from the source standard repo only when
the task explicitly asks for a latest-version or named-version standard update.
