# Decision Logic

This file defines how the `icm-architect` skill maps questionnaire answers to a layer model (3-layer or 5-layer) and an archetype (one of seven options). It also defines the one-line rationale format, the override step, the confidence flag tiers, and the Archetype caveat boilerplate used when confidence is below high.

---

## Layer model decision

### 3-layer: pick when

All of the following are true:
- `workflow_shape` is "single ongoing space" or "not sure".
- `stage_count` is absent or 0 or 1.
- The `work_type` answer does not name a pipeline, a production process, or a sequence of hand-offs.
- The `primary_outcome` does not describe a multi-step assembly process.

**3-layer rationale template:**
> "Your work is a single ongoing space with no sequential stage hand-offs, so the 3-layer model (Map, Rooms, Tools) is the right fit."

---

### 5-layer: pick when

One or more of the following are true:
- `workflow_shape` is "sequential stages" or the detail describes a hand-off sequence.
- `stage_count` is 2 or more and stages are described in an ordered sequence.
- The `primary_outcome` or `workflow_detail` uses words like "pipeline", "phases", "stages", "hand-off", or "first... then... finally...".
- The `work_type` is "researcher or analyst" with multiple distinct deliverable types.
- The architecture brief from Stage B recommended 5-layer.

**5-layer rationale template:**
> "Your work moves through [N] sequential stages that hand off to each other ([stage names]), so the 5-layer model with numbered stage folders is the right fit."

---

### Ambiguous: surface before deciding

If `workflow_shape` is "a mix" or the detail contains both ongoing and staged work:
1. Do not silently pick a model.
2. Present the builder with a short analysis and a recommendation.
3. If the builder does not respond to the ambiguity prompt, default to 3-layer and note the ambiguity in `setup/questionnaire.md`.

**Ambiguous rationale template:**
> "Your work combines ongoing tasks with some project stages. I am suggesting [3-layer / 5-layer] because [one-line reason], but this is a close call. Reply with '3' or '5' to override."

---

## Archetype decision

### Archetype map

| Archetype | Pick when |
|---|---|
| `content-creator` | `work_type` is "content creator" or the primary outcome describes publishing to an audience without explicit production phases |
| `freelancer` | `work_type` is "freelancer" or the primary outcome describes delivering work to named clients |
| `developer` | `work_type` is "developer" or the primary outcome describes shipping software, APIs, or tools |
| `designer` | `work_type` is "designer" or the primary outcome describes visual, brand, or UX deliverables that are static |
| `research-pipeline` | `work_type` is "researcher or analyst" or the primary outcome describes producing a report or knowledge artefact |
| `production-pipeline` | `work_type` is "something else" AND `workflow_detail` describes a pre-production to post-production sequence for a time-based creative deliverable (animation, video, podcast, film) |
| `blank-slate` | `work_type` is "something else" and `work_description` does not clearly fit any archetype above |

### Tie-breaking rules

**production-pipeline vs designer:** production-pipeline wins when the deliverable is time-based media (a video, an animation, a podcast). designer wins when the deliverable is static visual work (a logo, a web design, a print layout).

**freelancer vs production-pipeline:** production-pipeline wins when the brief is primarily defined by sequential production phases for time-based creative deliverables. freelancer wins when the brief is primarily defined by the client relationship and revision loop.

**General tie-breaking:** prefer the archetype that matches `work_type` over one that only matches `primary_outcome`. If still tied, prefer in this order: production-pipeline > freelancer > content-creator > developer > designer > research-pipeline > blank-slate.

---

## Confidence flag tiers

| Tier | Definition |
|---|---|
| **High** | A single archetype matches all "Pick when" conditions without tie-breaking. |
| **Medium** | Two archetypes matched conditions and tie-breaking selected one. The other remains plausible. |
| **Low** | No archetype's conditions match cleanly. The skill selected the best partial match. |
| **By-elimination** | The skill selected `blank-slate` or selected an archetype because all others were ruled out. |

Emit the Archetype caveat paragraph when confidence is medium, low, or by-elimination.
Do not emit it when confidence is high.

---

## Archetype caveat boilerplate

The caveat is a single paragraph placed in the `## Identity` section of CLAUDE.md, immediately after the main identity statement.

### Medium confidence

> **Archetype caveat.** This workspace uses the `[SELECTED_ARCHETYPE]` archetype as its closest match. Your brief also matched `[OTHER_ARCHETYPE]` in part ([ONE_SENTENCE_REASON_FOR_PARTIAL_MATCH]). If the [OTHER_ARCHETYPE] label describes your work more precisely, switch the archetype overlay manually or run `/project-start` again with a more specific brief.

### Low confidence

> **Archetype caveat.** This workspace uses the `[SELECTED_ARCHETYPE]` archetype as the closest available match, but the match is partial. Your brief does not fully satisfy the `[SELECTED_ARCHETYPE]` "pick when" conditions ([ONE_SENTENCE_GAP_DESCRIPTION]). Stage names, reference headings, and routing entries may need more manual adjustment than a high-confidence archetype would. Run `/icm-sync` after the first session to tune anything that does not fit.

### By-elimination

> **Archetype caveat.** No built-in archetype closely matched your brief, so this workspace uses `[SELECTED_ARCHETYPE]` (blank-slate or nearest available). Your work pattern ([ONE_SENTENCE_WORK_DESCRIPTION]) may be a candidate for a future dedicated archetype. Treat the default folder names and reference headings as starting points and rename them freely. Run `/icm-sync` after the first session to record any structural changes.

---

## Override step

The override step is part of Group 7 in the question protocol. The skill must:
1. State the chosen layer model with the rationale.
2. State the chosen archetype with the rationale.
3. State the computed confidence tier.
4. List the planned workspace or stage names.
5. Wait for the builder to confirm or override.
6. If the builder overrides, update the plan and show a revised plan before writing any files.

**The skill must never write a single file before the builder has explicitly confirmed the plan.** Confirmation is a "YES" or equivalent. Silence is not confirmation.

---

## Layer model: what each produces

### 3-layer produces

```
[workspace-root]/
  CLAUDE.md                    (Layer 0: identity, routing, four governed blocks)
  CONTEXT.md                   (Layer 1: workspace context)
  REFERENCES.md                (Layer 3: reference material)
  references/                  (Layer 3: extended reference files if more than three types)
  inputs/                      (always created: client files, decision notes, references)
  [workspace-folders]/
  specs/                       (spec documents from Stage B)
  setup/
    questionnaire.md
    interview.md
    architecture-brief.md
```

### 5-layer produces

```
[workspace-root]/
  CLAUDE.md                    (Layer 0: identity, routing, four governed blocks)
  CONTEXT.md                   (Layer 1: workspace routing across stages)
  01_[stage-name]/             (Layer 2+: first stage)
    CONTEXT.md
    references/
    output/
  02_[stage-name]/             (repeat per stage)
    CONTEXT.md
    references/
    output/
  references/                  (Layer 3: shared cross-stage references)
  inputs/                      (always created: client files, decision notes, references)
  _config/
  shared/
  specs/                       (spec documents from Stage B)
  setup/
    questionnaire.md
    interview.md
    architecture-brief.md
```

---

## Workspace and stage name derivation

1. If `workflow_detail` or `stage_count` names specific stages, use those names.
2. If no specific names were given, use the archetype overlay defaults with the builder's domain vocabulary substituted.
3. Present the names in the confirmation step so the builder can change them before anything is written.
