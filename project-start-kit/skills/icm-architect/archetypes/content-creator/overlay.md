# Archetype: Content Creator

## Pick when

- `work_type` is "content creator"
- OR the primary outcome describes publishing content to an audience: videos, podcasts, newsletters, blog posts, social media, or course materials.

## Default layer model

3-layer (ongoing content production). Override to 5-layer if the builder describes a production pipeline with sequential phases (e.g. record, edit, publish).

## Default workspace names (3-layer)

| Slot | Default name | Adapted from |
|---|---|---|
| Workspace 1 | `script-lab` | Rename to match the builder's content type (e.g. `podcast-scripts`, `article-drafts`) |
| Workspace 2 | `edit-bay` | Rename to match the builder's edit process (e.g. `production`, `video-cuts`) |
| Workspace 3 | `distribution-hub` | Rename to match the builder's publishing channel (e.g. `newsletter`, `youtube`) |

## Default stage names (5-layer, if selected)

| Stage | Default name | Adapted from |
|---|---|---|
| 01 | `01_concept` | Rename to match the builder's first stage (e.g. `01_research`, `01_scripting`) |
| 02 | `02_production` | Rename to match the builder's production process |
| 03 | `03_publishing` | Rename to match the builder's publishing or distribution step |

## Default reference file headings

- **Voice and tone guide**: "Your writing voice in one paragraph. Tone words. What to avoid."
- **Audience profile**: "Who you are making this for. What they care about. What they struggle with."
- **Content calendar notes**: "Cadence, themes, series in progress."
- **Platform-specific rules**: "Channel-by-channel constraints (length, format, tone)."

## Default routing table entries

| Task type | Read first | Also load |
|---|---|---|
| Writing a new piece | CONTEXT.md | references/voice-guide.md |
| Editing or refining | CONTEXT.md | references/voice-guide.md, references/audience-profile.md |
| Planning or scheduling | CONTEXT.md | references/content-calendar.md |
| Storing client files or incoming references | inputs/ | CONTEXT.md |

## Answer fields that drive substantive adaptation

- `project_name`: replaces "Content Creator" in CLAUDE.md identity line.
- `work_description`: replaces the identity line's second clause.
- `primary_outcome`: used in the CONTEXT.md "What good looks like" section.
- `things_to_avoid`: used in the CONTEXT.md "What to avoid" section.
- `workflow_detail`: if stage names are named here, they replace the default stage names above.
- `reference_types`: each named type maps to a reference file heading.

Adaptation is not cosmetic if: workspace names, stage names, reference headings, and routing entries are all drawn from the builder's answers and differ visibly from the archetype defaults above.
