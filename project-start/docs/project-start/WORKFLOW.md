# project-start workflow

This document describes the runtime flow from the moment the builder runs `/project-start` to the moment the governed workspace is ready. It is written for someone who has installed `bootstrap-kit/` and is about to run the command for the first time.

---

## Prerequisites

- You have copied `bootstrap-kit/` into an empty project folder, with the hook at `.claude/hooks/icm-drift-check.sh` and `.claude/settings.json` (the only supported location as of 0.3.0; the hook is invoked via `sh`, so no executable bit is required).
- You have an active Claude Code session in that folder.

See `bootstrap-kit/INSTALL.md` if you have not done these steps yet.

---

## Stage A: adversarial discovery interview

`/project-start` loads the `project-scoping` skill and runs it in **interview mode**.

The skill asks about eight topics in order:

1. **Project type.** What are you building? The skill accepts any project type.
2. **Primary outcomes.** What does success look like for each deliverable?
3. **Non-goals and risks.** What is explicitly out of scope? What could go wrong?
4. **Tackling flow.** How do you intend to approach the work (e.g. brand first, then website, then video)?
5. **Reference material.** What background material should always be available (brand guidelines, voice guide, briefs)?
6. **Integrations.** Any third-party tools, APIs, or MCP servers to wire in?
7. **English variant.** UK, US, AU, or other? This fills the anti-AI block's variant placeholder.
8. **Multi-deliverable confirmation.** If the brief covers more than one deliverable, the skill names them and asks: "One spec per deliverable, or one combined spec?" Your answer drives Stage B.

**Adversarial behaviour.** The skill is designed to push back on vague answers. If you say "I want a nice website", it will ask "What makes it nice? Who is it for? What does the visitor do on it?" It challenges answers once. If you give a second vague answer, it records it as-is with a flag in the interview transcript.

**Output.** The transcript is written verbatim to `setup/interview.md`. This is the handoff artefact; nothing else is written in Stage A.

---

## Stage B: spec authoring

The `project-scoping` skill switches to **spec-authoring mode**.

Using the interview transcript, the skill drafts one spec document per deliverable (or one combined spec if you confirmed single-scope in Stage A).

Each spec contains five sections:
- **Goal.** One or two sentences stating what this deliverable is for.
- **Scope.** What is included and what is explicitly excluded.
- **Success criteria.** How you will know the deliverable is done.
- **Deliverables.** The specific outputs (files, artefacts, decisions).
- **Non-goals.** What this spec does not cover, repeated explicitly.

The skill presents the draft specs to you. You can request changes. When you confirm, the specs are written to `specs/`. Confirmation is required before Stage C begins.

---

## Stage C: workspace scaffold

`/project-start` loads the `icm-architect` skill and runs it in **init mode**.

The skill reads `setup/interview.md` to pre-fill its questionnaire answers. It proposes:

- **Layer model.** 3-layer (single ongoing space) or 5-layer (sequential stages). The rationale is shown.
- **Archetype.** One of seven options based on your project type. The rationale is shown.
- **Workspace or stage names.** Derived from the archetype and your interview answers.
- **Reference files to seed.** Based on the reference material you named in Stage A.

The skill waits for your confirmation (Group 7 of the question protocol) before writing any files.

After confirmation, files are written in this order:

1. `setup/questionnaire.md`
2. Root `CLAUDE.md` (from the appropriate template, fully substituted, maintenance protocol verbatim)
3. Root `CONTEXT.md`
4. `REFERENCES.md` or `references/` folder (3-layer), or stage folders (5-layer)
5. `inputs/` folder (always created, always routed in `CLAUDE.md`)

The skill performs a self-check after writing: every path in the routing table resolves to a file.

---

## Stage D: governance injection

Still within the `icm-architect` skill, governance injection runs automatically after the scaffold self-check.

The four governed blocks are injected into the root `CLAUDE.md` in this order:

1. **Maintenance protocol.** The canonical five rules (verbatim from `references/maintenance-protocol.md`). Already placed by the template; injection confirms it is present and intact.
2. **Stance block.** Neutral, no flattery, devil's advocate, co-partner. Injected from `templates/governance/stance-block.md`.
3. **Anti-AI writing block.** Em-dash ban, hype-word blacklist, no "just/simply", English variant filled from your Stage A answer. Injected from `templates/governance/anti-ai-block.md`.
4. **Model-tiering block.** Task classes per tier (top, mid, light) plus auto-delegate instruction. Injected from `templates/governance/tiering-block.md`.

The hook files are verified, not written: `.claude/hooks/icm-drift-check.sh` and `.claude/settings.json` came from the Step 1 copy in `INSTALL.md`, before `/project-start` ever ran. Stage D confirms `settings.json`'s `PostToolUse` command points at the hook script at its actual path, and stops rather than improvising a replacement if either file is missing.

The skill writes the `specs/` folder contents if not already written.

Final confirmation message lists all files created, the layer model and archetype chosen, and next steps.

---

## Auto-sync hook behaviour

After Stage D, the `icm-drift-check.sh` hook runs automatically after every `Write` or `Edit` tool call.

The hook checks four structural drift patterns:

1. **Stale routing entry.** A path in the `CLAUDE.md` routing table does not exist on disk. This check depends on the routing section being headed exactly `## Routing table`; if that heading is not found, the hook reports `DRIFT-1a-SKIPPED` instead of silently reporting nothing, so a missing or renamed heading is visible rather than indistinguishable from a clean pass.
2. **Undocumented new top-level file.** A file exists at the workspace root but has no routing table entry (checked against the whole file, not just the routing section, so a mention anywhere in `CLAUDE.md` counts).
3. **Dead MD link.** A `.md` file contains a link to another `.md` file that does not exist.
4. **Missing stage `CONTEXT.md`.** A numbered stage folder (`NN_*`) exists but has no `CONTEXT.md`.

When the hook detects any of these, it emits a fix directive to the session. The directive names the specific file and proposes the fix. The session applies the fix immediately in the same tool call sequence.

**The hook does not fix things silently.** It emits a directive and the session acts on it. You can see what it found.

**What the hook does not catch.** Semantic drift patterns require human or model judgement and are not amenable to shell checking:
- Whether a Layer 3 reference file change has been propagated to downstream stages.
- Whether naming conventions have been violated in file content (as opposed to file names).
- Whether a stage CONTEXT.md's Inputs table still accurately reflects the current reference files.

For these patterns, run `/icm-sync`. It runs all eight drift checks including the four semantic ones.

---

## `/icm-sync`: the manual full-audit fallback

`/icm-sync` loads the `icm-architect` skill in sync mode and runs all eight drift checks. Use it:
- After the first few working sessions, to catch anything the hook missed.
- After any major structural change (renaming stages, adding a track, reorganising references).
- Whenever you suspect semantic drift that the hook cannot detect.

`/icm-sync` proposes fixes discretely. You confirm or skip each one.

---

## Hook output contract

The hook emits `hookSpecificOutput.additionalContext` (verified against current Claude Code). This is the only output shape that routes the drift directive into the model's context on the next turn. Plain stdout on exit 0 is shown to the user's terminal only, and does not reach the model. The v0.2 hook uses the correct envelope.

Shell hooks catch structural drift only. The four checks (stale routing entry, undocumented top-level file, dead MD link, missing stage CONTEXT.md) are amenable to mechanical shell inspection. Semantic patterns remain with `/icm-sync`:
- Whether a Layer 3 reference file change has been propagated to downstream stages.
- Whether naming conventions have been violated in file content (not just file names).
- Whether a stage CONTEXT.md's Inputs table still accurately reflects the current reference files.

Run `/icm-sync` periodically or after any major structural change.

---

## Common mistakes

**Running `/project-start` in a non-empty folder.** The skill will warn you and ask whether to scaffold alongside existing files or cancel. It will not overwrite anything without explicit confirmation.

**Skipping the interview.** The `/project-start` command requires running Stage A before Stage C. You cannot jump straight to scaffolding. If you already have specs, use `/icm-init` directly.

**Not confirming the plan.** The `icm-architect` skill will not write a single file until you reply YES to the plan in Group 7. Silence is not confirmation.

**Leaving the English variant blank.** If you skip the English variant question, the anti-AI block will contain a placeholder. Fill it in manually before your first working session, or run `/project-start` again with a clearer answer to the variant question.

**Placing the hook somewhere other than `.claude/hooks/`.** The hook is invoked as `sh "$CLAUDE_PROJECT_DIR/.claude/hooks/icm-drift-check.sh"`, so no executable bit is required, but the path in `.claude/settings.json` must match exactly. A hook at the workspace root with `settings.json` still pointing at `.claude/hooks/` (or vice versa) fails silently: no error, the check simply never fires.

**Forgetting to update `models.config.md`.** When a new model releases or an old one is deprecated, open `models.config.md` and update the alias column. No other file needs changing. Tiers are always named by capability (top, mid, light) everywhere else.
