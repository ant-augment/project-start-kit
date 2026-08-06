# Changelog

All notable changes to the project-start pattern are recorded here in reverse chronological order.

---

## 0.3.0 -- 2026-08-06

- **The 0.2.3 fix introduced a Critical-severity regression, caught by adversarial review before this release, and fixed in the same cycle.** Scoping DRIFT-1a to the `## Routing table` section fixed the false-positive class 0.2.3 targeted, but if that exact heading (case-sensitive) is not found, the check silently scans nothing and reports nothing, which is indistinguishable from "no stale entries found". `drift-rules.md` rates 1a Critical; a silently-skipped Critical check is a worse failure than the false positives it replaced. The hook now reports `DRIFT-1a-SKIPPED` when the heading is not found, and the dependency is documented in `INSTALL.md` and `PATTERN.md`'s known limitations.
- **The hook's install path never actually worked, independent of the above.** `icm-architect/SKILL.md`'s Stage D instructed reading the hook from `./templates/hooks/icm-drift-check.sh`, a directory that does not exist anywhere in this kit. No builder following the documented flow could have gotten a working hook from Stage D alone. Stage D now verifies the hook files already placed by `INSTALL.md` Step 1, instead of trying (and failing) to write them itself.
- **Hook and `settings.json` location is now singular: `.claude/hooks/icm-drift-check.sh` and `.claude/settings.json`.** Every prior version offered a workspace-root alternative "depending on your Claude Code version", hedged across four documents that did not agree with each other on which one `settings.json`'s `command` field actually pointed at. That hedge is also what caused Stage D to write two undocumented files at the workspace root, which then tripped DRIFT-1b on the very first edit of every newly scaffolded workspace. One location, stated once, fixes both.
- **`settings.json`'s command string now resolves absolutely** (`sh "$CLAUDE_PROJECT_DIR/.claude/hooks/icm-drift-check.sh"`), rather than a bare `icm-drift-check.sh` that only worked if the hook happened to be invoked with the workspace root as its current directory.
- **The `chmod +x` guidance is removed everywhere** (`INSTALL.md`, `WORKFLOW.md`, `example/notes.md`). The hook is invoked through `sh`, which never consulted the executable bit; the guidance was a plausible wrong cause handed to anyone actually debugging a dead hook.
- **`icm-architect`'s description no longer over-triggers on ordinary phrases.** "Set up a project folder" and "sync the docs" matched verbatim regardless of context, firing the ICM scaffold-or-audit flow for a source-tree setup request or a documentation update with no relation to `CLAUDE.md` governance. The description now states the precondition (a workspace that has, or is about to have, a governed `CLAUDE.md`) and qualifies the trigger phrases accordingly. Also now explicitly advertises installing the hook into an *existing* workspace, which no prior description covered.
- **`interview-transcript-template.md` now exists.** `project-scoping/SKILL.md` Stage A referenced this file at `./references/interview-transcript-template.md` since the pattern's first release; it was never created. `setup/interview.md`'s shape, including the structured-summary section `icm-architect` depends on to pre-fill Stage C, was previously undefined by any file.
- **The dead-link false positive is fixed at the source, not hidden.** 0.2.3's `.claude/` exclusion on DRIFT-2 suppressed two literal link-syntax examples in `drift-rules.md`'s own prose, but `drift-rules.md`'s prose still claimed the check scans "all `.md` files", so `/icm-sync` (which reads that file, not the shell exclusion) kept reporting the same two false positives. The two examples are now rephrased so they do not form a matched link pattern, and the `.claude/` exclusion is removed; the check now covers `.claude/` like everywhere else.
- **The hook carries a version marker** (`# version: 0.3.0` at the top of `icm-drift-check.sh`, echoed into every emitted fix directive), and `INSTALL.md` gained an "Upgrading" section, because nothing previously let a builder or a session tell a stale installed copy from a current one. Eleven copies of this hook were found across machines during this release's adversarial review; two of the three actually executing anywhere (the plugin marketplace and cache copies for this kit specifically) were pre-fix, and there was no way to tell without diffing source by hand.
- Found by a full adversarial review pass (`forge/patterns/project-start/refutation-2026-08-06.md`, excluded from the released copy): 2 confirmed criticals (both above) and 7 majors (all fixed in this release; see the report for the two criticals' exact reproductions and the additional detail behind each major).

---

## 0.2.3 -- 2026-08-04

- **Fixed two false-positive drift patterns in `icm-drift-check.sh`.** DRIFT-1a now scans only the `## Routing table` section instead of the whole `CLAUDE.md`, and strips the table's leading "Task type" column before matching, so prose mentions of filenames (for example "Planning the design.md format...") are no longer misread as stale routing entries. DRIFT-2 now excludes `.claude/` from its dead-link scan, so a skill's own reference documentation that shows the `[text](path.md)` link pattern as a literal example is no longer misread as a broken link. Fix originated and was verified in a destination workspace running an exported copy of this hook, then synced forward into the pattern's canonical source per the local-install-guard convention.

---

## 0.2.2 -- 2026-07-30

- **Model bindings refreshed to the current lineup.** `models.config.md` moves `top` from `claude-opus-4-8` to `claude-opus-5` and `mid` from `claude-sonnet-4-6` to `claude-sonnet-5`; `light` stays on `claude-haiku-4-5`. The aliases (`opus`, `sonnet`, `haiku`) are unchanged, so nothing downstream of the config moves. Added an explicit verification date to the bindings table, and named `fable` as the more capable option along with the three reasons it is deliberately not the default: pricing above the opus tier, always-on thinking (no cheap mode), and a stricter data-retention requirement. The v0.2.1 entry below predicted this staleness and this release is the first time that prediction was acted on.
- **Effort added as a routing lever.** Both `models.config.md` and the `tiering-block.md` governance template now say to try `effort` before changing tier: a lower tier at high effort often beats a higher tier at low effort, and the reverse is the cheaper way to economise than dropping a tier. Tier is about the kind of thinking a task needs; effort is about how much. Subagents can carry their own `effort` in frontmatter, so a delegated task keeps its setting.
- No behavioural change to the interview, the scaffold, the hook, or the governed blocks' structure.

## 0.2.1 -- 2026-06-23

- **Model-tiering rationale made principle-based.** `models.config.md` no longer pins a specific model as "the strongest" (a claim that goes stale on every model release). It now states the rule -- bind `top` to the most capable model available to you -- defaults to `claude-opus-4-8`, and tells the builder to verify against the current lineup rather than trusting a fixed name. Bindings table and behaviour unchanged; this is a wording/maintenance fix.

## 0.2.0 -- 2026-06-22

Revision driven by the v0.1.0 retro.

- **Hook now reaches the model (correctness fix).** `icm-drift-check.sh` was rewritten to emit a `hookSpecificOutput.additionalContext` JSON envelope on exit 0, verified against the current Claude Code PostToolUse contract and validated by live functional test. The v0.1.0 hook printed plain stdout, which reaches the user's terminal only and never entered the model's context, so its self-healing directive was a no-op. The four structural drift checks and graceful degradation are unchanged.
- **Top tier bound to Opus 4.8** (was sonnet), mid to sonnet, light to haiku, with a documented rationale.
- **Routing-row drift fixed** across both templates and the worked example.
- **Worked example regenerated** from the templates via the example-renderer tool, with `example/render-log.md`.
- **Hook caveat resolved** in WORKFLOW.md and PATTERN.md.

## 0.1.0 -- 2026-06-22

Initial release.

- Four-stage flow: Stage A adversarial discovery interview, Stage B spec authoring, Stage C ICM workspace scaffold, Stage D governance injection.
- Bundled `project-scoping` skill (new): Stage A interview protocol and Stage B spec authoring engine.
- Bundled `icm-architect` skill (extended from `icm-init` v0.2.1): adds governance injection mode (Stage D), three-tier model-tiering rules, and hook activation. Sync mode carried forward intact.
- `icm-sync` command carried forward from `icm-init` v0.2.1.
- `project-start` command (new): thin wrapper loading project-scoping for Stages A+B, then icm-architect for Stages C+D.
- Three governance templates: `stance-block.md`, `anti-ai-block.md` (English variant as placeholder), `tiering-block.md`.
- `models.config.md` (new): three-tier capability model (top/mid/light) mapped to current model aliases. No dead bindings.
- `icm-drift-check.sh` (new): PostToolUse hook checking four structural drift patterns, resolves root via `$CLAUDE_PROJECT_DIR`, degrades gracefully outside a hook context.
- `settings.json` (new): wires the hook to `Write|Edit` tool events.
- Both layer templates (three-layer, five-layer) updated to carry the four governed blocks in order and include a routed `inputs/` folder.
- Worked example: Camellia & Co. tea brand launch (mixed brand + web + launch-video project).
- Hook shape unverified against live Claude Code runtime; flagged for verification before v0.2.0.
