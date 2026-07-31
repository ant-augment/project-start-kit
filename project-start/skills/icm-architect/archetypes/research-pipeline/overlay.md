# Archetype: Research Pipeline

## Pick when

- `work_type` is "researcher or analyst"
- OR the primary outcome describes producing a report, synthesis document, data product, or evidence-based recommendation.
- OR the workflow describes reviewing sources, then analysing, then writing up findings.

## Default layer model

5-layer (research work almost always has sequential phases). Override to 3-layer only if the builder explicitly describes a single ongoing research space without distinct deliverable phases.

## Default stage names (5-layer)

| Stage | Default name | Adapted from |
|---|---|---|
| 01 | `01_literature-review` | Rename to match the builder's gathering phase (e.g. `01_data-collection`, `01_source-review`) |
| 02 | `02_analysis` | Rename to match the builder's analysis phase (e.g. `02_synthesis`, `02_coding`) |
| 03 | `03_write-up` | Rename to match the builder's output phase (e.g. `03_report`, `03_recommendations`) |

## Default workspace names (3-layer, if selected)

| Slot | Default name | Adapted from |
|---|---|---|
| Workspace 1 | `sources` | Rename to match the builder's input type (e.g. `papers`, `data`, `interviews`) |
| Workspace 2 | `analysis` | Rename to match the builder's working process |
| Workspace 3 | `outputs` | Rename to match the builder's deliverable type |

## Default reference file headings

- **Research question or brief**: "The central question. What this research needs to answer."
- **Methodology notes**: "How you are approaching the research. What counts as evidence."
- **Source list**: "Key sources, papers, datasets. Organised by relevance."
- **Findings log**: "Emerging findings. Things to confirm. Contradictions to resolve."

## Default routing table entries (5-layer)

| Task type | Read first | Also load |
|---|---|---|
| Reviewing or adding sources | 01_literature-review/CONTEXT.md | references/source-list.md |
| Analysing or synthesising | 02_analysis/CONTEXT.md | references/methodology.md, references/findings-log.md |
| Writing up or reporting | 03_write-up/CONTEXT.md | references/findings-log.md, references/research-question.md |
| General orientation | CONTEXT.md | CLAUDE.md |
| Storing client files or incoming references | inputs/ | CONTEXT.md |

## Answer fields that drive substantive adaptation

- `project_name`: replaces the workspace name and research project title.
- `work_description`: used in identity line; include the specific domain if named.
- `primary_outcome`: used in "What good looks like".
- `things_to_avoid`: used in "What to avoid".
- `workflow_detail`: if the builder named specific phases, those replace the default stage names.
- `reference_types`: "research notes" maps to the findings log; "methodology" maps to methodology notes.

Adaptation is substantive if the stage names, routing entries, and reference headings use the builder's specific research domain vocabulary rather than the generic defaults above.
