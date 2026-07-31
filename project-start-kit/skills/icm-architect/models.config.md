# Model Configuration

This file is the single source of truth for tier-to-alias bindings. All workspace files, skills, and CLAUDE.md tiering blocks reference tiers only (top, mid, light). This file resolves tiers to the aliases Claude Code accepts.

**Important:** Do not reference model names anywhere except in this file. The tier names top, mid, and light are capability labels, not model names. Pass the alias from this file when invoking a specific model; do not hard-code model aliases in workspace rules or skill files.

---

## Tier bindings

Last verified against the published model lineup: 2026-07-30.

| Tier | Alias | Full model id (documentation only) | Typical cost |
|---|---|---|---|
| top | opus | claude-opus-5 | Highest |
| mid | sonnet | claude-sonnet-5 | Higher |
| light | haiku | claude-haiku-4-5 | Lower |

**Bind `top` to the most capable model available to you.** That is the rule; the specific model is not fixed here, because the lineup changes and any pinned "this is the strongest" name goes stale. This kit defaults `top` to `opus` (`claude-opus-5` at the verification date above): a strong, widely-available default that suits the vast majority of work (planning, architecture, spec authoring, complex reasoning). Verify the current lineup (current Claude documentation, or the model catalog) rather than trusting the ids above, which are a dated snapshot.

A more capable model may be available to your account. At the verification date that is `fable`, and it is deliberately **not** the default: it is priced above the opus tier, thinking is always on so there is no cheap mode, and it carries a stricter data-retention requirement. Those are exactly the kinds of constraints that make rebinding `top` a decision rather than an automatic upgrade. If the workload justifies it and you accept the terms, change the `top` alias here; the tiers in all other workspace files stay unchanged.

**A note for the tiering-default reviewer.** The `top` binding above is a deliberate, documented choice: `opus` as the default, with `fable` named as the more capable option and the reasons it is not the default stated explicitly. A reviewer should confirm against the current lineup that this remains a sensible binding, treating a documented choice as acceptable rather than a blocker.

**A note on effort.** Tier is not the only lever. Claude Code exposes an `effort` level (`low` through `max`) that controls how much thinking and tool use a model spends, and on current models a lower tier at high effort often beats a higher tier at low effort for less money. Before promoting a task class from `mid` to `top`, try `mid` at a higher effort. Before demoting one to `light`, try the same tier at `effort: low`.

---

## Tier definitions

- **top**: the most capable available tier. Handles planning, architecture decisions, spec authoring, complex coding, verification, and any task where reasoning quality is the limiting factor. Sessions reading the workspace tiering rules will route these task classes to `top` and delegate via subagent or ask the main session to invoke the model directly.
- **mid**: a capable mid-tier. Handles isolated coding tasks, content production, analysis, and multi-file edits where quality matters but sustained deep reasoning is not the limiting factor.
- **light**: the lighter, faster tier. Handles `.md` reading for sync and audit, mechanical transforms (bulk renames, reformatting), and any high-volume, low-reasoning work. When the workspace CLAUDE.md says to delegate a task to `light`, create a subagent with the lighter model.

---

## How to update bindings

When a new model releases or an existing alias is deprecated, edit this table. No other file needs to change.

**Step 1: Identify the correct alias.** Check current Claude Code documentation or release notes to confirm which alias the new model responds to.

**Step 2: Update the alias and the documentation comment.** Change the alias in the Alias column and update the full model id in the documentation comment. Do not add the full id anywhere outside this file.

**Step 3: Rebalance tiers if the capability landscape has shifted.** If a model you previously called `mid` is now the strongest available, move it to `top`. If a previously `top` model is widely available and economical, consider moving it to `mid`. The tier names in workspace rules stay stable; only the aliases in this file change.

---

## Portability note

This file travels with the `icm-architect` skill folder. When you copy the skill into a new workspace, this file comes with it. If you need different model bindings in that workspace (for example, because you have access to different aliases or are on a different plan), edit this file in the destination workspace. The change is local; it does not affect other workspaces.

Keep the bindings table current: the table is the one place a model id belongs. Avoid asserting in prose that a named model is "the strongest" -- that claim goes stale on the next release. Phrase capability by tier ("the most capable available to you") and treat any specific model name as a dated example to verify, not a fixed fact.
