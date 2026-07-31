# 5-layer stage folder structure

This document describes the layout of each numbered stage folder in a 5-layer ICM workspace.

---

## Per-stage layout

Each stage folder follows this structure:

```
NN_stage-name/
  CONTEXT.md          (stage contract: inputs, process, outputs, hand-off checklist)
  references/         (stage-specific reference files)
  output/             (working artefacts produced by this stage)
```

`NN` is a zero-padded two-digit number (01, 02, 03...). Stage numbering starts at 01.

---

## Root-level shared folders

In addition to the numbered stage folders, a 5-layer workspace has:

```
references/           (cross-stage shared reference files available to all stages)
inputs/               (client files, decision notes, incoming material; always present and routed)
_config/              (workspace configuration files; not loaded into stage context)
shared/               (cross-stage shared assets: templates, style guides, brand files)
specs/                (spec documents authored in Stage B of /project-start)
```

---

## Output folder conventions

- The `output/` folder inside each stage holds files produced during that stage.
- Files in `output/` are the hand-off artefacts; the next stage reads them from its Inputs table.
- When a stage is complete, its `output/` files are referenced in the receiving stage's CONTEXT.md.
- Superseded outputs are moved to `output/archive/` rather than deleted.

---

## References folder conventions

- Each stage has a `references/` folder for stage-specific material.
- The root `references/` folder holds material that any stage may need.
- Stage CONTEXT.md files specify which reference folder files to load in their Inputs table.
- When a file in `references/` is updated, all stage CONTEXT.md files that list it in their Inputs table are flagged for review (Rule 4 of the maintenance protocol).

---

## inputs/ folder

The `inputs/` folder is always present and always has a routing table entry. It receives:
- Client-supplied files before they are classified into a stage.
- Decision notes and meeting records.
- Reference material that has not yet been placed in a stage's references folder.

Files in `inputs/` should be moved to the appropriate stage folder or references folder once their role is understood.
