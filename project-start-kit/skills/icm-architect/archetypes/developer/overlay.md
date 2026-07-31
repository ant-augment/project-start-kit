# Archetype: Developer

## Pick when

- `work_type` is "developer"
- OR the primary outcome describes shipping software, building tools, writing code, or maintaining APIs.

## Default layer model

3-layer for single-project development workspaces. 5-layer if the builder describes a development pipeline (e.g. planning, implementation, testing, deployment) or a multi-service architecture with distinct domains.

## Default workspace names (3-layer)

| Slot | Default name | Adapted from |
|---|---|---|
| Workspace 1 | `frontend` | Rename to match the builder's primary code area (e.g. `api`, `backend`, `mobile`) |
| Workspace 2 | `backend` | Rename to match the builder's secondary concern |
| Workspace 3 | `docs` | Rename or omit (e.g. `docs-and-specs`, `testing`) |

## Default stage names (5-layer, if selected)

| Stage | Default name | Adapted from |
|---|---|---|
| 01 | `01_planning` | Rename to match the builder's design or planning stage |
| 02 | `02_implementation` | Rename to match the builder's build phase |
| 03 | `03_testing` | Rename to match the builder's review or deployment phase |

## Default reference file headings

- **Architecture overview**: "System diagram or description. Main components. Tech stack."
- **Coding conventions**: "Language, style guide, naming conventions, linting rules."
- **API or interface contracts**: "Endpoint definitions, data shapes, integration points."
- **Known issues and decisions**: "Open issues. Technical decisions made and why."

## Default routing table entries

| Task type | Read first | Also load |
|---|---|---|
| Writing or reviewing code | CONTEXT.md | references/coding-conventions.md |
| Designing a new feature | CONTEXT.md | references/architecture-overview.md, references/api-contracts.md |
| Debugging or fixing | CONTEXT.md | references/known-issues.md |
| Writing documentation | CONTEXT.md | references/architecture-overview.md |
| Storing client files or incoming references | inputs/ | CONTEXT.md |

## Answer fields that drive substantive adaptation

- `project_name`: replaces workspace name and project title.
- `work_description`: used in identity line; include specific language or framework if named.
- `primary_outcome`: used in "What good looks like".
- `things_to_avoid`: used in "What to avoid".
- `workflow_detail`: if the builder named stages, those replace the default stage names.
- `reference_types`: "technical documentation" maps to architecture overview and API contracts.

Adaptation is substantive if the routing table names the actual system components the builder described.
