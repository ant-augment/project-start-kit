---
name: project-start
description: >
  Bootstrap kit for brand-new projects: runs an adversarial discovery interview, authors one
  spec per deliverable, and scaffolds a governed ICM workspace whose CLAUDE.md carries the
  maintenance protocol, stance, anti-AI writing rules, and model-tiering, with a PostToolUse
  hook that self-heals routing drift (emits additionalContext to the session). Supersedes
  icm-init for new projects. Use it at the very start of a new project, before any code.
version: 0.2.2
tags: onboarding, icm, project-setup, model-tiering, governance, hooks
---

# project-start

## When to use

Use this pattern when starting a brand-new project of any kind in an empty or near-empty folder, before any `CLAUDE.md` or workspace structure exists. The pattern covers any project type: branding, marketing, a launch video, a custom web application, a research pipeline, or a multi-deliverable combination.

The pattern runs an adversarial discovery interview, authors one or more spec documents, and scaffolds a fully governed ICM workspace whose `CLAUDE.md` already carries a maintenance protocol, a stance block, an anti-AI writing block, and model-tiering rules, with auto-sync hooks active from the first session.

**Do not use this pattern:**
- To migrate an existing populated folder. That is `icm-init`'s `/icm-migrate` job.
- On a healthy ICM workspace that already has a `CLAUDE.md`. Use `/icm-sync` for ongoing drift audits.
- When you already have clear specs and only need the workspace scaffold. The interview phase adds time; skip to Stage C by running `/icm-init` directly if specs are already agreed.

---

## Roles

### Role 1: Interviewer (Stage A)

**Responsibility.** Run an adversarial discovery interview. Challenge vague answers, surface unstated assumptions, and confirm the project type, scope, deliverables, non-goals, reference material, integrations, and the builder's preferred English variant.

**Suggested model.** Sonnet or better. The interview requires reasoning about ambiguity and choosing good follow-up questions.

**Suggested tools.** AskUserQuestion (for discrete choices when available), free-form text fallback.

**Definition of done.**
- [ ] All eight Stage A topics covered: project type, primary outcomes, non-goals and risks, tackling flow, reference material, integrations, English variant, multi-deliverable confirmation.
- [ ] Vague answers challenged at least once before being accepted.
- [ ] Interview transcript recorded verbatim.
- [ ] Multi-deliverable decision made explicit: one spec per deliverable, or one combined spec.

---

### Role 2: Spec Author (Stage B)

**Responsibility.** Convert the interview transcript into one or more spec documents, one per deliverable when the brief is multi-deliverable. Each spec must contain five sections: goal, scope, success criteria, deliverables, non-goals.

**Suggested model.** Sonnet or better. Spec authoring requires synthesis and careful scoping.

**Suggested tools.** Write.

**Definition of done.**
- [ ] One spec file per deliverable (or one combined spec if the builder confirmed single-scope).
- [ ] Each spec contains all five sections.
- [ ] No silent assumptions: any ambiguity surfaced in the interview is resolved or flagged in the spec.
- [ ] Builder confirms the specs before Stage C proceeds.

---

### Role 3: Workspace Architect (Stage C)

**Responsibility.** Scaffold the ICM workspace: choose the layer model (3-layer or 5-layer), choose the archetype, derive workspace/stage names, and write all structural files. Always include a routed `inputs/` folder.

**Suggested model.** Sonnet or better. Layer model and archetype decisions require reasoning about the project's shape.

**Suggested tools.** Write, Read.

**Definition of done.**
- [ ] Layer model chosen and rationale stated.
- [ ] Archetype chosen and rationale stated.
- [ ] All structural files written: `CLAUDE.md`, `CONTEXT.md`, stage files (5-layer), `REFERENCES.md` or `references/` folder (3-layer).
- [ ] `inputs/` folder created and appears in the routing table.
- [ ] `setup/questionnaire.md` written.
- [ ] Every routing table path resolves to an existing file (self-check performed).

---

### Role 4: Governance Injector (Stage D)

**Responsibility.** Inject the four governed blocks into the root `CLAUDE.md` in the correct order, write the `specs/` folder with the authored specs, activate hooks by writing `settings.json`.

**Suggested model.** Sonnet or better.

**Suggested tools.** Write, Edit.

**Definition of done.**
- [ ] Root `CLAUDE.md` contains the four governed blocks in order: maintenance protocol, stance block, anti-AI block, tiering block.
- [ ] The anti-AI block's English variant placeholder is filled from the interview answer.
- [ ] `specs/` folder exists with one spec file per deliverable.
- [ ] `settings.json` written with the `PostToolUse` hook wired to `icm-drift-check.sh`.
- [ ] Hook script and `settings.json` are at the workspace root or `.claude/` as appropriate.

---

## Coordination

**Starting condition.** The builder has copied `bootstrap-kit/` into an empty project folder and runs `/project-start`.

**Order of operations.**

1. `/project-start` loads the `project-scoping` skill and runs it in interview mode (Stage A). The skill records the transcript verbatim to `setup/interview.md`.
2. `project-scoping` switches to spec-authoring mode (Stage B). The builder confirms the specs. Specs are written to `specs/`.
3. `/project-start` then loads the `icm-architect` skill and runs it in init mode (Stage C). The architect reads `setup/interview.md` to inform questionnaire answers. It proposes a plan and waits for builder confirmation before writing any files.
4. `icm-architect` runs governance injection (Stage D). The four governed blocks are injected into `CLAUDE.md`. The hook files are written.
5. The skill performs a self-check: every routing table path resolves to a file. It then confirms completion to the builder.

**Shared state.** `setup/interview.md` is the handoff artefact between Stage A/B and Stage C/D. It carries the verbatim transcript and a structured summary used by `icm-architect` to pre-fill questionnaire answers.

**Handoffs.**
- Stage A writes `setup/interview.md`. Stage B reads it to author specs.
- Stage B writes `specs/*.md`. Stage C reads the specs to understand deliverable shape.
- Stage C writes all structural files. Stage D edits `CLAUDE.md` to inject the governed blocks.

**Terminating condition.** The root `CLAUDE.md` contains all four governed blocks, all routing table paths resolve, `inputs/` exists and is routed, `specs/` contains at least one spec, and `settings.json` is present with the hook wired.

**Fan-out note.** Subagents cannot spawn subagents in Claude Code. All stage transitions happen in the main session. The command files load the skills; the skills contain all stage logic.

---

## Worked example

See `example/` for a complete walkthrough of a mixed brand, web, and launch-video project.

The example contains:

- `brief.md` -- the vague multi-deliverable brief the builder arrived with.
- `interview.md` -- the verbatim Stage A interview transcript, the primary coordination artefact.
- `specs/` -- three generated specs: one for brand identity, one for the marketing website, one for the launch video.
- `generated-CLAUDE.md` -- the scaffolded root `CLAUDE.md` showing all four governed blocks in order, plus the routed `inputs/` entry.
- `notes.md` -- what worked during the run, what would break in edge cases.

The example uses a tea brand launch (Camellia & Co.) as the project. It demonstrates how a vague brief ("I need a brand, a website, and a video") becomes three distinct specs and a fully governed ICM workspace.

---

## Adapting to a new workspace

This pattern ships as a portable `bootstrap-kit/`. The adaptation guide below assumes you are sitting in an empty project folder in a workspace that does not look like the forge.

**Step 1: Copy the bootstrap kit.**

Copy the contents of `bootstrap-kit/` into the root of your empty project folder. The kit installs:
- `.claude/commands/project-start.md`
- `.claude/commands/icm-sync.md`
- `.claude/skills/project-scoping/` (with `SKILL.md` and `references/`)
- `.claude/skills/icm-architect/` (with `SKILL.md`, `references/`, `templates/`, `archetypes/`)
- `bootstrap-kit/hooks/icm-drift-check.sh` and `bootstrap-kit/hooks/settings.json` (copy to your workspace root or `.claude/hooks/` as your project requires)

See `bootstrap-kit/INSTALL.md` for the exact copy commands.

**Step 2: Configure models.**

Open `.claude/skills/icm-architect/models.config.md`. The file maps `top`, `mid`, and `light` tiers to current model aliases. Edit the alias column to match the models available in your workspace. No other file needs changing when you update models.

**Step 3: Translate roles if you use agents instead of skills.**

This pattern bundles skills (instruction sets the main session reads and follows) rather than agent files. If your workspace uses `.claude/agents/` files instead, translate each role spec above into an agent system prompt:

- The Interviewer role becomes an `interviewer.md` agent whose system prompt encodes the Stage A protocol from `project-scoping/SKILL.md`.
- The Spec Author role becomes a `spec-author.md` agent.
- The Workspace Architect and Governance Injector roles fold into a single `icm-architect.md` agent whose prompt encodes the Stage C and D procedures.

Each agent's description field should be pushy: state the capability and the trigger condition.

**Step 4: Run the pattern.**

In a new Claude Code session in your project folder, run `/project-start`. The command loads the `project-scoping` skill. You will be interviewed about your project. At the end of Stage B you confirm your specs. At the end of Stage D you have a governed workspace.

**Step 5: Post-install customisation.**

After the first run:
- Fill in the reference files under `references/` with your actual content.
- Review the anti-AI block in `CLAUDE.md` and adjust the hype-word blacklist to your domain.
- Verify that the hook script is executable (`chmod +x icm-drift-check.sh`) and that `settings.json` is where Claude Code expects it.
- Run `/icm-sync` after your first working session to catch any immediate drift.

**Customising the governance blocks.**

The four governed blocks are templates; you own them once they are generated. Common adjustments:
- Stance block: remove the devil's advocate prompt if you prefer a more collaborative tone.
- Anti-AI block: add domain-specific hype words to the blacklist.
- Tiering block: adjust the task-class routing if your project type concentrates work differently across tiers.
- Maintenance protocol: add a Rule 6 if your workspace has a recurring pattern the five existing rules do not cover.

**No forge-specific paths.** The `bootstrap-kit/` has no references to `forge/`, `released/`, `specs/`, `catalog/`, or `retros/`. It has no dependencies on this workspace. Every path in the kit is relative to the destination project root.

---

## Known limitations

**Shell hook catches structural drift only.** The `icm-drift-check.sh` hook emits `hookSpecificOutput.additionalContext` (verified against current Claude Code), so its drift directive reaches the model on the next turn. It checks four structural patterns: stale routing entries, undocumented top-level files, dead MD links, and missing stage CONTEXT.md files. Semantic drift patterns (Layer 3 propagation, naming judgement) are not amenable to shell inspection; run `/icm-sync` for those.

**Interview quality depends on builder engagement.** The adversarial interview is only as good as the builder's answers. Sparse one-word answers produce a weaker spec and a less well-adapted workspace. The skill challenges vague answers once; it does not loop indefinitely.

**Multi-track projects are approximated.** A brief with three radically different deliverables (brand, web, video) ends up in one workspace with one layer model. If the deliverables have divergent workflow shapes (one is a single ongoing space, another is a production pipeline), the layer model is a compromise. The builder may want to scaffold separate workspaces for each deliverable in that case.

**Migration is out of scope.** If the project folder already has files, use `icm-init`'s `/icm-migrate` command instead. This pattern assumes an empty or near-empty starting point.

**Model IDs must be kept current.** The `models.config.md` file maps tiers to current model aliases. When new models release or old ones are deprecated, the builder must update this file. The pattern does not self-update model bindings.

**English variant is a placeholder.** The anti-AI block's English variant field is filled from the interview answer. If the builder did not answer the English variant question, the placeholder remains and must be filled manually.
