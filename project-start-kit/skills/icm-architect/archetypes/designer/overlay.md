# Archetype: Designer

## Pick when

- `work_type` is "designer"
- OR the primary outcome describes visual, UX, brand, print, or motion design deliverables.

## Default layer model

3-layer for ongoing design work (brand maintenance, ongoing client design work). 5-layer if the builder describes a project pipeline (e.g. discovery, design, handoff) or a multi-phase campaign process.

## Default workspace names (3-layer)

| Slot | Default name | Adapted from |
|---|---|---|
| Workspace 1 | `projects` | Rename to match the builder's primary design work (e.g. `brand-work`, `ux-design`, `illustration`) |
| Workspace 2 | `brand-assets` | Rename to match the builder's asset management approach |
| Workspace 3 | `client-files` | Rename or omit based on whether the builder works with clients |

## Default stage names (5-layer, if selected)

| Stage | Default name | Adapted from |
|---|---|---|
| 01 | `01_discovery` | Rename to match the builder's first phase (e.g. `01_brief`, `01_research`) |
| 02 | `02_design` | Rename to match the builder's main design phase |
| 03 | `03_handoff` | Rename to match the builder's delivery phase (e.g. `03_client-review`, `03_production`) |

## Default reference file headings

- **Brand guidelines**: "Colours, typefaces, logo rules, tone of voice. The rules you always follow."
- **Design system notes**: "Components, tokens, spacing system, grid. How things fit together."
- **Client brief**: "The brief or spec for the current project. What the client wants."
- **Design decisions log**: "Decisions made and why. What was rejected and why."

## Default routing table entries

| Task type | Read first | Also load |
|---|---|---|
| Creating new visual work | CONTEXT.md | references/brand-guidelines.md, references/design-system.md |
| Reviewing or critiquing | CONTEXT.md | references/design-decisions.md |
| Presenting to a client | CONTEXT.md | references/client-brief.md |
| Storing client files or incoming references | inputs/ | CONTEXT.md |

## Answer fields that drive substantive adaptation

- `project_name`: replaces workspace name.
- `work_description`: used in identity line; include the discipline (UX, brand, motion) if named.
- `primary_outcome`: used in "What good looks like".
- `things_to_avoid`: used in "What to avoid".
- `workflow_detail`: if the builder named phases, those replace the default stage names.
- `reference_types`: "brand or visual identity" maps to brand guidelines; "design system" maps to design system notes.

Adaptation is substantive if the routing table and reference headings use the builder's design discipline vocabulary.
