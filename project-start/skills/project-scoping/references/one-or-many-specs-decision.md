# One or Many Specs Decision

This file defines when the `project-scoping` skill produces one spec per deliverable versus one combined spec, and how to recommend a layer model from the spec structure.

---

## One spec per deliverable: use when

- The brief names two or more deliverables that have **different success criteria**. A brand identity and a website have different definitions of "done".
- The deliverables have **different owners or timelines**. Even if they are related, if different people will work on them or they will be completed at different times, separate specs keep accountability clean.
- A deliverable could be **cancelled or descoped** independently. If you can imagine dropping the launch video without affecting the brand spec, they should be separate.
- The deliverables require **different skills or tools**. Design work and video production rarely share the same process or success criteria.

**When in doubt about multi-deliverable briefs, produce separate specs.** A separate spec is never harmful; a combined spec that obscures scope is often harmful.

---

## Combined spec: use when

- The brief names **one deliverable** (no decision needed).
- Multiple items named are **facets of the same deliverable**, not independent deliverables. Example: "logo, colour palette, and typography" are facets of a brand identity, not separate deliverables.
- The deliverables are **so tightly coupled** that they share the same success criteria and could not sensibly be judged independently. This is rare.

If you are unsure whether items are deliverables or facets, present the builder with the distinction and ask for confirmation.

---

## Layer model recommendation from spec structure

The spec structure informs the layer model recommendation passed to the `icm-architect` skill. Use this table:

| Spec structure | Layer model recommendation |
|---|---|
| Single spec, single deliverable, no sequential phases described | 3-layer |
| Single spec, single deliverable, sequential phases described in the interview | 5-layer |
| Multiple specs, deliverables are sequential (brand first, then site, then video) | 5-layer (one track per deliverable) |
| Multiple specs, deliverables are parallel or independent | 3-layer with a `projects/` or `deliverables/` folder, or separate workspaces |
| Multiple specs, one deliverable is a production pipeline (e.g. video) | 5-layer |

Record this recommendation in `setup/architecture-brief.md`. The `icm-architect` skill reads it as a starting-point suggestion, not a binding instruction. The skill applies its own decision logic and may override the recommendation.

---

## Architecture brief format

The architecture brief is a one-page summary written to `setup/architecture-brief.md`:

```markdown
# Architecture brief

**Project:** [project name]
**Date:** [date]

## Deliverables

[N] deliverables identified:

1. [deliverable name] -- [one-sentence description]
2. [deliverable name] -- [one-sentence description]
N. [deliverable name] -- [one-sentence description]

## Spec structure

[one spec per deliverable | combined spec] -- [one-sentence rationale]

## Layer model recommendation

[3-layer | 5-layer] -- [one-sentence rationale]

## Suggested archetype

[archetype name] -- [one-sentence rationale]

## Cross-deliverable concerns

[Anything shared across deliverables: voice guide, brand assets, shared references, shared inputs folder]

## Notes for icm-architect

[Any interview flags, open questions, or constraints the architect should know before proposing a plan]
```
