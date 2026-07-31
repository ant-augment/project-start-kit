# 5-layer template notes

## What this template produces

Running `/project-start` with a 5-layer decision produces:

- `CLAUDE.md` -- the map: identity, routing table, stage hand-off protocol, naming conventions, the four governed blocks.
- `CONTEXT.md` -- the workspace context: stages overview, success criteria, shared references.
- One `NN_stage-name/` folder per stage, each containing `CONTEXT.md`, `references/`, and `output/`.
- `references/` -- shared cross-stage references.
- `inputs/` -- always created, always routed. Receives client files, decision notes, incoming material.
- `_config/` and `shared/` folders.
- `specs/` -- spec documents from Stage B.
- `setup/questionnaire.md`, `setup/interview.md`, `setup/architecture-brief.md`.

## When the skill chooses this template

The skill picks 5-layer when the questionnaire answers describe sequential stages that hand off to each other. See `references/decision-logic.md` for the full decision rules.

## Template substitution

All `{{PLACEHOLDER}}` tokens are replaced by the skill during init. A reader should never see raw template tokens in a generated workspace.

## The four governed blocks

This template carries all four governed blocks in the correct order. Do not move or remove them during substitution:
1. `## Maintenance protocol` -- the five workspace-decay prevention rules.
2. `## Stance` -- neutral, no flattery, devil's advocate, co-partner.
3. `## Writing rules` -- em-dash ban, hype-word blacklist, English variant.
4. `## Model tiering` -- top/mid/light routing table and auto-delegate instruction.

## Stage count flexibility

The template carries three stage rows by default. During substitution:
- Expand to N rows when the questionnaire's `stage_count` is greater than 3.
- Trim to fewer rows when `stage_count` is less than 3.
- Do not leave the placeholder `(repeat per stage as needed)` row in the rendered file.
