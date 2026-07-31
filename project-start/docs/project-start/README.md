# project-start

A portable bootstrap kit that takes an empty project folder to a fully governed ICM workspace in one flow. Run `/project-start`, get interviewed about what you are building, review the generated specs, and end with a `CLAUDE.md` that already carries a maintenance protocol, a stance block, an anti-AI writing block, and model-tiering rules, with auto-sync hooks active from the first session.

---

## What it does

1. **Stage A -- adversarial discovery interview.** The `project-scoping` skill interviews you about your project: what you are building, who it is for, what success looks like, what to avoid, whether you are working in English or another variant. Vague answers are challenged. Nothing is assumed silently.

2. **Stage B -- spec authoring.** One spec document per deliverable. Each spec has five sections: goal, scope, success criteria, deliverables, non-goals. A multi-deliverable brief (e.g. brand + website + video) produces three distinct specs.

3. **Stage C -- workspace scaffold.** The `icm-architect` skill proposes a layer model (3-layer or 5-layer) and an archetype, derives workspace and stage names from your answers, and writes all structural files. An `inputs/` folder is always created and routed.

4. **Stage D -- governance injection.** The root `CLAUDE.md` receives four governed blocks in order: maintenance protocol, stance block, anti-AI writing block, model-tiering block. Auto-sync hooks are activated.

---

## When to use

Use `/project-start` when:
- You are starting a new project of any kind in an empty or near-empty folder.
- No `CLAUDE.md` or workspace structure exists yet.
- You want specs authored and governance baked in from the first session.

Do not use `/project-start` when:
- You are migrating an existing populated folder. Use `icm-init`'s `/icm-migrate` instead.
- You already have agreed specs and only need the workspace scaffold. Use `/icm-init` directly.
- The workspace already exists and you want a drift audit. Use `/icm-sync`.

---

## Supersedes `icm-init` for new projects

`project-start` is the recommended path for new projects. It wraps `icm-architect` (from `icm-init`) and adds the interview, spec authoring, and governance injection that `icm-init` does not do. `icm-init` stays released for migration of existing folders and for situations where specs are already agreed.

---

## Installation

1. Copy the contents of `bootstrap-kit/` into the root of your empty project folder.
2. See `bootstrap-kit/INSTALL.md` for the exact steps and a verification checklist.
3. Run `/project-start` in a new Claude Code session.

---

## Bundle contents

```
bootstrap-kit/
  commands/
    project-start.md    Thin wrapper: loads project-scoping (A+B), then icm-architect (C+D).
    icm-sync.md         Full workspace drift audit; the manual fallback after hooks.
  skills/
    project-scoping/    Stage A adversarial interview + Stage B spec authoring.
    icm-architect/      Stage C scaffold + Stage D governance injection + sync mode.
  hooks/
    icm-drift-check.sh  PostToolUse hook: four structural drift checks, emits fix directives.
    settings.json       Wires the hook to Write|Edit tool events.
  INSTALL.md            Copy instructions and verification checklist.
```

---

## Pattern documentation

- `PATTERN.md` -- roles, coordination, worked example reference, adaptation guide, known limitations.
- `WORKFLOW.md` -- stage-by-stage walkthrough, hook behaviour, `/icm-sync` fallback, common mistakes.
- `CHANGELOG.md` -- version history.
- `example/` -- a complete walkthrough of a mixed brand, web, and launch-video project.
