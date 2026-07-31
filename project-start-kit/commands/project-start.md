---
description: Start a new project from scratch: run an adversarial discovery interview, author specs, scaffold a governed ICM workspace, and activate auto-sync hooks. Run this in an empty or near-empty project folder before any CLAUDE.md exists.
allowed-tools: Read, Write, Edit, Glob
---

Load `.claude/skills/project-scoping/SKILL.md` and run Stages A and B (interview, then spec authoring). After Stage B is confirmed, load `.claude/skills/icm-architect/SKILL.md` and run Stages C and D (scaffold, then governance injection). The skills handle everything; do not begin any step before loading them.

If the skill files do not exist at the paths above, say: "The project-start skills are not installed. Copy `bootstrap-kit/` to your project root and run `/project-start` again."
