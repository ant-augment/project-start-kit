# Changelog

All notable changes to the project-start pattern are recorded here in reverse chronological order.

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
