# 3-layer template notes

## What this template produces

Running `/project-start` with a 3-layer decision produces:

- `CLAUDE.md` -- the map: identity, routing table, naming conventions, the four governed blocks (maintenance protocol, stance, writing rules, model tiering).
- `CONTEXT.md` -- the workspace context: current project, success criteria, active tasks.
- `REFERENCES.md` -- background material: headings seeded from setup questionnaire answers.
- `inputs/` -- a routed folder for client files, decision notes, and incoming reference material.
- `specs/` -- spec documents authored in Stage B.
- Workspace folders named from the chosen archetype, adapted to the builder's domain.
- `setup/questionnaire.md` -- the permanent setup record.

## When the skill chooses this template

The skill picks 3-layer when the questionnaire answers describe a single ongoing workspace with no sequential stage hand-offs. See `references/decision-logic.md` for the full decision rules.

## Template substitution

All `{{PLACEHOLDER}}` tokens are replaced by the skill during init. A reader should never see raw template tokens in a generated workspace. If tokens appear, the init run is incomplete and should be re-run.

## The four governed blocks

This template carries all four governed blocks in the correct order. Do not move or remove them during substitution:
1. `## Maintenance protocol` -- the five workspace-decay prevention rules.
2. `## Stance` -- neutral, no flattery, devil's advocate, co-partner.
3. `## Writing rules` -- em-dash ban, hype-word blacklist, English variant.
4. `## Model tiering` -- top/mid/light routing table and auto-delegate instruction.

## The inputs/ folder

The `inputs/` folder is always created and always routed. It receives client files, decision notes, and incoming reference material that does not yet have a home. Do not remove it from the routing table.

## Reference file splitting

For simple workspaces, all reference material fits in a single `REFERENCES.md`. If the setup questionnaire names more than three distinct reference types, the skill creates a `references/` folder and individual files.
