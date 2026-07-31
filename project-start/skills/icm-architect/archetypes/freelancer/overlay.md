# Archetype: Freelancer

## Pick when

- `work_type` is "freelancer"
- OR the primary outcome describes delivering work to named clients, handling commissions, or managing a service-based business.

## Default layer model

Depends on `workflow_shape`:
- 3-layer if the builder manages multiple concurrent clients in one space.
- 5-layer if the builder describes a sequential process per project or commission (intake, work, delivery).

## Default workspace names (3-layer)

| Slot | Default name | Adapted from |
|---|---|---|
| Workspace 1 | `client-intake` | Rename to match the builder's intake process (e.g. `briefs`, `commissions`) |
| Workspace 2 | `active-work` | Rename to match the builder's working process (e.g. `illustrations`, `copywriting`, `builds`) |
| Workspace 3 | `admin` | Rename or omit if the builder has no admin layer (e.g. `invoicing`, `proposals`) |

## Default stage names (5-layer, if selected)

| Stage | Default name | Adapted from |
|---|---|---|
| 01 | `01_intake` | Rename to match the builder's first stage (e.g. `01_brief`, `01_commission`) |
| 02 | `02_delivery` | Rename to match the builder's working/delivery stage |
| 03 | `03_admin` | Rename or extend to match the builder's close-out process (e.g. `03_invoicing`, `03_archive`) |

## Default reference file headings

- **Client brief template**: "Standard questions to ask every new client."
- **Pricing and rates**: "Your current rates. What is included. What costs extra."
- **Style guide or process notes**: "Your working process. What you deliver. What format."
- **Current clients**: "Active client names, project titles, deadlines."

## Default routing table entries

| Task type | Read first | Also load |
|---|---|---|
| Working on a client deliverable | CONTEXT.md | references/style-guide.md, client folder |
| Writing a proposal or brief | CONTEXT.md | references/client-brief-template.md, references/pricing.md |
| Admin or invoicing | CONTEXT.md | references/pricing.md |
| Storing client files or incoming references | inputs/ | CONTEXT.md |

## Answer fields that drive substantive adaptation

- `project_name`: replaces the workspace name in CLAUDE.md identity.
- `work_description`: used in identity line and CONTEXT.md workspace purpose.
- `primary_outcome`: used in "What good looks like".
- `things_to_avoid`: used in "What to avoid".
- `workflow_detail`: if the builder named specific stages, those replace the default stage names.
- `reference_types`: each named type maps to a reference file heading.

Adaptation is substantive if the generated workspace uses the builder's domain vocabulary throughout CLAUDE.md, CONTEXT.md, and reference headings.
