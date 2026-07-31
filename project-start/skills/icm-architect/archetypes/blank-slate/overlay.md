# Archetype: Blank Slate

## Pick when

- `work_type` is "something else" and `work_description` does not clearly match any of the five named archetypes.
- The builder's work is unusual, interdisciplinary, or hybrid in a way that none of the named archetypes capture.
- The builder explicitly requests a blank-slate workspace with no archetype assumptions.

## Default layer model

3-layer unless `workflow_shape` explicitly names sequential stages, in which case use 5-layer. The blank-slate archetype must never assume a layer model; it must always follow the decision logic.

## Default workspace names (3-layer)

No default workspace names. The skill asks one additional question when blank-slate is selected:

> "Since your work does not fit a standard template, what are the two or three main areas of your work? I will use these as your workspace folder names."

The builder's answer provides the workspace names directly.

## Default stage names (5-layer, if selected)

No default stage names. The skill uses the names from `workflow_detail` or `stage_count`. If no names were given, it asks:

> "What are the names of your stages, in order?"

## Default reference file headings

No pre-seeded headings. The skill uses only the reference types named in Group 4 of the question protocol.

## Default routing table

The routing table is built entirely from the builder's answers. Each workspace folder or stage becomes a routing entry; the reference files become the "also load" column. The `inputs/` row is always present.

## Answer fields that drive substantive adaptation

All fields drive adaptation. The blank-slate archetype has no defaults to fall back to; every element of the generated workspace is drawn from questionnaire answers.

## Important note

The blank-slate archetype is the last resort. The skill must attempt all five named archetypes before selecting blank-slate. If any archetype matches even partially, prefer it over blank-slate.
