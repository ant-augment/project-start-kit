## Model tiering

This workspace uses a three-tier capability model. All workspace files name tiers by capability only (top, mid, light). Model aliases for each tier are recorded solely in `.claude/skills/icm-architect/models.config.md`. To change which model handles a tier, edit that file. No other file needs to change.

**Auto-delegate instruction.** When a session recognises that a task belongs to a different tier than the current model, it should delegate: spawn a subagent at the appropriate tier for the task, or ask the user to invoke the relevant model directly. Do not silently execute a top-tier task on a light model because it was convenient.

**Try effort before changing tier.** Claude Code exposes an `effort` level (`low`, `medium`, `high`, `xhigh`, `max`) that controls how much thinking and tool use a model spends on a task. It is a separate lever from tier and often the better one. Before promoting a task class to a higher tier, try the current tier at a higher effort. Before demoting one to save cost, try the same tier at `effort: low`, which is usually cheaper and better than a smaller model at default effort. Tier is about the kind of thinking a task needs; effort is about how much of it. A subagent can set `effort` in its own frontmatter, so a delegated task can carry its own setting.

### Tier routing

| Tier | Task classes | Delegate when |
|---|---|---|
| **top** | Planning and architecture decisions; spec authoring and requirements analysis; complex coding (multi-system, algorithmic, security-sensitive); verification and review of mid/light output; any task where reasoning quality is the limiting factor | The task requires sustained reasoning, high-stakes decisions, or verification of another model's output |
| **mid** | Isolated coding tasks (single-file, bounded scope); content production (drafts, copy, summaries); analysis and recommendations; multi-file edits within a defined spec | The task requires capability but not deep reasoning; the scope is bounded and the contract is clear |
| **light** | Reading `.md` files for sync and audit; mechanical transforms (bulk renames, reformatting, search-and-replace); structured data extraction from clearly formatted files; any high-volume, low-reasoning task | The task is repetitive, bounded, and does not require judgement; errors would be caught by a subsequent review step |

### What belongs at top (detail)

Route these task classes to the top tier without exception:
- Initial planning for a new project or workstream (deciding what to do and in what order).
- Architecture decisions (choosing between approaches with significant trade-offs).
- Authoring or reviewing specs, briefs, or requirements documents.
- Complex coding that spans multiple systems, involves security properties, or requires novel algorithms.
- Verification: reviewing mid or light output for correctness, completeness, and alignment with the spec.

### What belongs at light (detail)

Route these task classes to the light tier when delegation is possible:
- Running `/icm-sync` drift-pattern checks across `.md` files.
- Mechanical text transforms: renaming variables, reformatting tables, replacing strings.
- Extracting structured data from clearly formatted source files.
- Any task where the instructions are fully specified and no judgement is needed.

When light output feeds into top-tier work, the top tier always verifies before accepting.
