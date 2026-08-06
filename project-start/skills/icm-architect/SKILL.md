---
name: icm-architect
description: Fires only in a workspace that has, or is about to have, a root CLAUDE.md governed by the ICM method. Does not fire for source-tree scaffolding (creating a src/ layout, a repo skeleton, or a dependency setup), or for updating documentation content to match code changes. Use whenever a user wants to scaffold an ICM workspace from scratch, inject governance blocks into an existing CLAUDE.md, audit an existing ICM workspace for drift, or run the Stage C + Stage D phases of /project-start. Also use to install the automatic drift-check hook into an existing ICM workspace, when a user asks for routing or docs to stay in sync, self-heal, or be checked automatically rather than by running a command by hand. Triggers on "/project-start" (Stages C+D), "/icm-sync", "scaffold an ICM workspace", "set up a governed CLAUDE.md project folder", "audit this ICM workspace for drift", "sync the ICM routing docs", "is the routing stale in this workspace". Runs in three modes: init (creates a workspace from questionnaire answers), governance-injection (injects the four governed blocks and activates hooks), and sync (audits an existing workspace and offers drift fixes). Always read this file before running any command.
version: 0.3.0
---

# ICM Architect

This skill runs in three modes. Read the mode selection rule below and jump to the correct procedure.

---

## Mode selection

| Trigger | Mode |
|---|---|
| `/project-start` loaded this skill for Stage C | **Init mode** |
| Init mode scaffold complete; Stage D requested | **Governance-injection mode** |
| `/icm-sync` or audit/sync/check-staleness requested | **Sync mode** |

If ambiguous, ask: "Do you want to scaffold a new ICM workspace (init), inject governance blocks into an existing CLAUDE.md (governance-injection), or audit an existing workspace (sync)?"

---

## Init mode (Stage C)

### Before writing any files

Read `setup/architecture-brief.md` if it exists. Use the recommended layer model and archetype as starting-point suggestions.

Check the current folder. If a `CLAUDE.md` already exists, say:
> "This folder already has a CLAUDE.md. If you want to add governance blocks to it, reply INJECT. If you want to audit it for drift, reply SYNC. If you want to start fresh, delete CLAUDE.md and run `/project-start` again."
- If INJECT: switch to governance-injection mode.
- If SYNC: switch to sync mode.
- Otherwise: stop. Write nothing.

---

### Step 1: Run the question protocol

Read `./references/question-protocol.md` in full before asking any questions.

Pre-fill answers from `setup/architecture-brief.md` and `setup/interview.md` where they exist. Show pre-filled answers to the builder and ask only the unanswered groups.

Run all seven question groups in order:
1. Project identity
2. Primary outcomes
3. Workflow shape (highest stakes; drives layer model decision)
4. Reference material
5. Naming conventions
6. Skills and MCPs
7. Confirmation and override (show the plan; wait for YES before writing anything)

Use AskUserQuestion for discrete choices when available. If unavailable, use the free-form fallback from the question protocol. Output (`setup/questionnaire.md`) is identical either way.

Write `setup/questionnaire.md` immediately after Group 7 is confirmed. This is the first file written.

---

### Step 2: Apply decision logic

After collecting all answers, read `./references/decision-logic.md` and determine:
1. **Layer model**: 3-layer or 5-layer. Show the one-line rationale.
2. **Archetype**: one of seven options. Show the one-line rationale.
3. **Confidence tier**: high, medium, low, or by-elimination.
4. **Workspace or stage names**: derived from archetype overlay + user answers.

Present this plan to the builder in Group 7 before proceeding.

---

### Step 3: Load the archetype overlay

Read the appropriate overlay from `./archetypes/[archetype-name]/overlay.md`. Use it to:
- Set default workspace or stage names, then adapt using the builder's answers.
- Set default reference file headings, then adapt to `reference_types` answers.
- Set default routing table entries, then adapt to the builder's actual workflows.

Adaptation must be substantive. The generated workspace must read as if it was built for this builder, not copied from a template.

---

### Step 4: Write files in this order

Do not deviate from this order. Each file may reference the previous.

1. `setup/questionnaire.md` (already done in Step 1).
2. Root `CLAUDE.md` -- from the appropriate template, fully substituted. Use the governed template (`./templates/three-layer/CLAUDE.md.template` or `./templates/five-layer/CLAUDE.md.template`). The four governed blocks are already in the template in the correct order; do not move or remove them.

   **Archetype caveat.** If confidence is medium, low, or by-elimination, insert the Archetype caveat paragraph in the `## Identity` section of CLAUDE.md, immediately after the main identity statement. Use the per-tier boilerplate from `./references/decision-logic.md`. If confidence is high, omit the caveat entirely.

3. Root `CONTEXT.md` -- from the appropriate template, fully substituted.
4. For 3-layer: `REFERENCES.md` (or `references/` folder if more than three reference types named).
5. For 5-layer: `CONTEXT.md` (workspace-level), then for each stage from 1 through N in order:
   - `NN_stage-name/CONTEXT.md`
   - `NN_stage-name/references/` (empty folder)
   - `NN_stage-name/output/` (empty folder)
6. For 5-layer: root `references/`, `_config/`, `shared/` folders.
7. `inputs/` folder (always created, regardless of layer model or archetype).
8. Workspace folders (3-layer) or confirm stage folders are created (5-layer).
9. `specs/` folder if `setup/architecture-brief.md` exists and specs are not yet written.

After writing all files, perform a self-check: for every file path mentioned in a routing table entry in CLAUDE.md, confirm the file exists. Report the result to the builder.

---

### Step 5: Confirm and pass to governance injection

Tell the builder:
- What was created (list of files and folders).
- The layer model and archetype chosen.
- The confidence tier (if below high, point to the Archetype caveat paragraph).
- That Stage D (governance injection) will now run automatically.

Do not ask for a second confirmation. Governance injection runs immediately.

---

## Governance-injection mode (Stage D)

### When this mode runs

Governance-injection mode runs automatically after init mode's self-check passes. It may also be invoked directly on an existing CLAUDE.md.

---

### Step 1: Confirm the four governed blocks

Read the root `CLAUDE.md`. Check whether all four governed blocks are present:

1. **Maintenance protocol** -- `## Maintenance protocol` heading with five rules.
2. **Stance block** -- `## Stance` heading with the four stance rules.
3. **Anti-AI writing block** -- `## Writing rules` heading with the em-dash ban, hype-word blacklist, and English variant.
4. **Model-tiering block** -- `## Model tiering` heading with the three-tier routing table and auto-delegate instruction.

If any block is missing, inject it from the governance templates:
- `./templates/governance/stance-block.md`
- `./templates/governance/anti-ai-block.md`
- `./templates/governance/tiering-block.md`

The maintenance protocol comes from `./references/maintenance-protocol.md`. It is already in the CLAUDE.md template; injection confirms it is present and intact.

**Injection order in CLAUDE.md (after the routing table and folder structure blocks):**
1. Maintenance protocol
2. Stance block
3. Anti-AI writing block
4. Model-tiering block

Do not change this order.

---

### Step 2: Fill the English variant placeholder

In the anti-AI writing block, find the placeholder `[ENGLISH_VARIANT]`. Replace it with the variant from the interview transcript (`setup/interview.md`, Topic 7).

If no variant was given, replace it with `British English (UK)` and note in the session that the builder should review this.

---

### Step 3: Verify the hook files

This step verifies; it does not write. The hook files are part of `bootstrap-kit/`'s initial copy (`INSTALL.md` Step 1), already at `.claude/hooks/icm-drift-check.sh` and `.claude/settings.json` before `/project-start` ever ran. There is no `./templates/hooks/` in this skill: the hook is not a template this step fills in, it is a file the builder already has. Writing a fresh copy here would either trigger the per-file overwrite confirmation required by the Hard Rules below, or silently diverge from whatever the builder actually has in place. Neither is acceptable, so do not write.

Verify, and report any mismatch rather than silently fixing it:
1. `.claude/hooks/icm-drift-check.sh` exists.
2. `.claude/settings.json` exists and its `PostToolUse` hook's `command` field references `.claude/hooks/icm-drift-check.sh` at that exact path (case and location must match; a mismatch means the hook is wired to a script that will not run, and the failure is silent -- no error, the check simply never fires).
3. If either file is missing or the path in `command` does not match, stop and tell the builder to re-run `INSTALL.md` Step 1 before continuing. Do not write a substitute copy from memory: this skill does not carry the hook's content, `bootstrap-kit/hooks/` does.

---

### Step 4: Final self-check and summary

- Confirm all four governed blocks are present in CLAUDE.md in the correct order.
- Confirm `inputs/` exists and is in the routing table.
- Confirm `.claude/settings.json`'s command references `.claude/hooks/icm-drift-check.sh` at the exact path verified in Step 3.
- Confirm `specs/` contains at least one spec file (or is empty with a note if Stage B was skipped).

Tell the builder:
- What was injected.
- What hook files were written and where.
- Next step: "Begin by reading CLAUDE.md, then CONTEXT.md. Run `/icm-sync` after your first working session to check for any drift the hook did not catch."

---

## Sync mode

### Step 1: Locate the workspace root

Confirm the working directory contains a `CLAUDE.md`. If it does not, say:
> "This does not look like an ICM workspace. There is no CLAUDE.md here. Run `/project-start` to create one, or navigate to your workspace root and run `/icm-sync` again."

---

### Step 2: Read the workspace

Read in this order:
1. `CLAUDE.md` -- routing table, layer model, naming conventions.
2. `CONTEXT.md` -- current workspace state.
3. All stage CONTEXT.md files (5-layer) or all workspace folder structure (3-layer).

Do not read `output/` or `archive/` folders unless a drift check requires it.

---

### Step 3: Run drift checks

Read `./references/drift-rules.md` in full before running checks.

Check all eight drift patterns in order:
1. Routing/filesystem mismatch (1a stale entries -- Critical; 1b undocumented files -- Medium)
2. Dead MD-to-MD links (High)
3. Naming-convention violations (Low/Medium)
4. Empty stage outputs (Medium)
5. Missing CONTEXT.md in stage folders (High)
6. Stale references in Inputs tables (High)
7. Archived files in active folders (Medium)
8. Layer 3 changes not propagated (Medium)

Collect all findings before reporting. Do not fix anything yet.

---

### Step 4: Report findings

Present findings prioritised by severity (Critical first, then High, Medium, Low). For each finding:
- Name the drift pattern.
- State the file and location.
- Show the fix proposal.
- Ask: "Apply this fix? [YES / NO / SKIP]"

Collect the response before showing the next finding.

---

### Step 5: Apply confirmed fixes

For each finding where the builder said YES:
- Apply the fix exactly as proposed.
- If the fix requires updating a routing table, update it in the same step.
- Do not make unrequested changes alongside the fix.

After all fixes are applied, summarise: number fixed, number skipped, number declined. Tell the builder to run `/icm-sync` again after any major workspace changes.

---

## References (bundled)

- `./references/question-protocol.md` -- seven question groups, AskUserQuestion phrasing, free-form fallback.
- `./references/decision-logic.md` -- layer model and archetype mapping, confidence tiers, caveat boilerplate.
- `./references/maintenance-protocol.md` -- canonical maintenance protocol text for every CLAUDE.md.
- `./references/drift-rules.md` -- eight drift patterns, detection cues, severity, fix proposals.
- `./references/naming-conventions.md` -- naming rules enforced and embedded.
- `./templates/three-layer/` -- templates for the 3-layer model (governed: four blocks included).
- `./templates/five-layer/` -- templates for the 5-layer model (governed: four blocks included).
- `./templates/governance/` -- standalone governance block templates for injection mode.
- `./archetypes/*/overlay.md` -- seven archetype overlays.
- `./models.config.md` -- tier-to-alias bindings (top/mid/light). The only file with model IDs.

---

## Hard rules (always apply)

- Never write files before the builder has confirmed the plan (init mode).
- Never overwrite an existing file without explicit per-file builder confirmation.
- In init mode, emit the Archetype caveat paragraph when confidence is medium, low, or by-elimination. Suppress it when confidence is high.
- Always embed the maintenance protocol verbatim. Never paraphrase or abbreviate it.
- Always run the self-check after init: confirm every routing table path resolves to an existing file.
- Always create `inputs/` and route it. No workspace leaves init mode without `inputs/`.
- Model IDs appear only in `./models.config.md`. Tiers are named top, mid, and light everywhere else.
- The four governed blocks must appear in CLAUDE.md in this order: maintenance protocol, stance, anti-AI, tiering.
- UK English throughout all generated files. No em dashes.
