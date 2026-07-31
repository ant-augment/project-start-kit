---
description: Audit an existing ICM workspace for drift: stale routing, dead links, naming violations, empty outputs, missing CONTEXT.md files, stale Inputs tables, archived files in active folders, and unpropagated Layer 3 changes. Reports findings by severity and offers discrete fixes you confirm before applying.
---

Load the `icm-architect` skill from `.claude/skills/icm-architect/SKILL.md` and run it in **sync mode**.

The skill will handle everything: confirming this is an ICM workspace, reading the workspace, running all eight drift checks, reporting findings, and applying confirmed fixes. Do not begin any of those steps before loading the skill.

If the skill file does not exist at `.claude/skills/icm-architect/SKILL.md`, say: "The icm-architect skill is not installed. Copy it to `.claude/skills/icm-architect/` and run `/icm-sync` again."
