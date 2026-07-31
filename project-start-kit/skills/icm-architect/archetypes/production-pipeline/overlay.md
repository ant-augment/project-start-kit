# Archetype: Production Pipeline

## Pick when

- `work_type` is "something else" and `work_description` matches production work vocabulary: animation, animator, video, videographer, podcast, podcaster, film, filmmaker, photographer, photography, illustrator (with multi-stage commission flow), director, producer, editor, cinematographer.
- OR `workflow_detail` describes a pre-production to production to post-production sequence: research or brief, then script or storyboard, then production or shoot or record, then post or edit or grade or mix, then delivery.
- OR `primary_outcome` describes shipping discrete creative content with explicit production phases (episodes, films, animations, photo series, audio series).

Do not pick production-pipeline when:
- The deliverable is a static visual or brand artefact (logo, web design, print layout). Use `designer` instead.
- The deliverable is a knowledge artefact (report, synthesis, dataset). Use `research-pipeline` instead.
- The builder publishes content to an audience without describing distinct production phases. Use `content-creator` instead.

## Default layer model

5-layer (production work almost always has sequential phases). Override to 3-layer only if the builder explicitly describes a single ongoing production space without discrete deliverable phases.

## Default stage names (5-layer)

| Stage | Default name | Adapted from |
|---|---|---|
| 01 | `01_research` | Rename to match the builder's first phase (e.g. `01_brief`, `01_concept`, `01_pre-production`) |
| 02 | `02_script-or-storyboard` | Rename to match the builder's planning medium (e.g. `02_script`, `02_storyboard`, `02_shot-list`) |
| 03 | `03_production` | Rename to match the builder's production phase (e.g. `03_animation`, `03_shoot`, `03_recording`) |
| 04 | `04_post` | Rename to match the builder's post-production phase (e.g. `04_edit`, `04_grade`, `04_mix`) |

## Default workspace names (3-layer, if selected)

| Slot | Default name | Adapted from |
|---|---|---|
| Workspace 1 | `pre-production` | Rename to match the builder's planning and prep work |
| Workspace 2 | `production` | Rename to match the builder's active production area |
| Workspace 3 | `post-and-delivery` | Rename to match the builder's finishing and handoff work |

## Default reference file headings

- **Brand guidelines**: "Your client's or project's visual identity. Colours, typefaces, logo usage, tone of voice."
- **Voice and tone**: "How the work should feel and sound. Tone words. Audience expectations. What to avoid."
- **Script template**: "Your standard script or storyboard format. Scene numbering conventions."
- **Production schedule**: "Timeline, milestones, deliverable deadlines. Format for tracking progress across phases."
- **Asset library**: "Where finished and in-progress assets live. Naming conventions for renders, exports, and raw files."

## Default routing table entries

| Task type | Read first | Also load |
|---|---|---|
| Briefing or concept development | 01_research/CONTEXT.md | references/brand-guidelines.md |
| Writing or reviewing a script or storyboard | 02_script-or-storyboard/CONTEXT.md | references/voice-and-tone.md, references/script-template.md |
| Active production work | 03_production/CONTEXT.md | references/production-schedule.md, references/asset-library.md |
| Post-production or editing | 04_post/CONTEXT.md | references/production-schedule.md, references/asset-library.md |
| Cross-project or general orientation | CONTEXT.md | CLAUDE.md |
| Storing client files or incoming references | inputs/ | CONTEXT.md |

## Answer fields that drive substantive adaptation

- `project_name`: replaces "Production Pipeline" in CLAUDE.md identity line.
- `work_description`: used in identity line. Include the specific medium explicitly.
- `primary_outcome`: used in CONTEXT.md "What good looks like".
- `things_to_avoid`: used in CONTEXT.md "What to avoid".
- `workflow_detail`: if the builder named specific phases, those replace the default stage names.
- `reference_types`: "brand guidelines" maps to the brand guidelines file; "script template" maps to the script template file.

Adaptation is substantive if the generated workspace reads as though it was built for this specific medium and not copied from a generic production template.

## Inheritance: stage CONTEXT.md template

All stage CONTEXT.md files for this archetype inherit the `Last reviewed` column on Inputs tables from the stage-CONTEXT.md.template. Do not omit this column. The column defaults to `<!-- last reviewed: pending -->` at init.
