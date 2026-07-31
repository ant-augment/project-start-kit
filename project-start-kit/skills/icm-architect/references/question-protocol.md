# Question Protocol

This file defines the seven question groups the `icm-architect` skill must ask during init mode, the AskUserQuestion phrasing for discrete decisions, and the free-form fallback phrasing for when AskUserQuestion is unavailable.

When init mode is invoked from `/project-start`, read `setup/architecture-brief.md` first. Pre-fill any groups that are already answered from the Stage A and Stage B work. Show pre-filled answers to the builder and ask only the remaining groups.

---

## Overview

The question protocol has two modes:

- **AskUserQuestion mode** (preferred): discrete options are presented as a list; the builder selects one. Free-text answers are asked as short open prompts.
- **Free-form fallback mode**: questions are asked one at a time as plain text. The answer structure is identical; only the UI differs.

In both modes, every answer is recorded verbatim in `setup/questionnaire.md` at the end of the question flow.

---

## Group 1: Project identity

**Purpose.** Establish who the builder is and what this project is for. Drives archetype selection.

**AskUserQuestion phrasing:**
- "What is this project called?" (free-text, required)
- "Which of these best describes what you do?" (discrete)
  - Content creator (videos, podcasts, newsletters, social)
  - Freelancer (client work, commissions, services)
  - Developer (code, apps, tools, APIs)
  - Designer (visual, UX, brand, print)
  - Researcher or analyst (reports, pipelines, synthesis work)
  - Something else (describe below)
- If "Something else": "Briefly describe your work in one sentence." (free-text)

**Free-form fallback phrasing:**
> "What is this project called? Then, tell me in one sentence what kind of work you do (for example: freelance illustration, software development, content production)."

**Recorded as:** `project_name`, `work_type`, `work_description`

---

## Group 2: Primary outcomes

**Purpose.** Understand what success looks like and what to avoid.

**AskUserQuestion phrasing:**
- "What is the main thing this workspace needs to help you produce?" (free-text, required)
- "Is there anything this workspace should specifically avoid or prevent?" (free-text, optional)

**Free-form fallback phrasing:**
> "What is the main output or result this project needs to produce? And is there anything you want to make sure Claude never does in this workspace, or any common mistake you want to guard against?"

**Recorded as:** `primary_outcome`, `things_to_avoid`

---

## Group 3: Workflow shape

**Purpose.** Highest-stakes question. Drives the layer model decision.

**AskUserQuestion phrasing:**
- "How would you describe your work process?" (discrete)
  - I work in a single ongoing space, not in separate stages (suggests 3-layer)
  - My work has clear sequential stages that hand off to each other (suggests 5-layer)
  - I have a mix of ongoing work and some projects with stages (ambiguous)
  - I am not sure yet

**If "sequential stages":** "How many main stages does your process have, roughly?" (free-text)
**If "a mix":** "Are the stages time-bounded projects, or ongoing parallel workstreams?" (free-text)
**If "not sure":** The skill surfaces the ambiguity and presents a recommendation.

**Free-form fallback phrasing:**
> "Describe your typical work process. Do you work in one ongoing space, or does your work move through distinct stages in order, one completing before the next begins?"

**Recorded as:** `workflow_shape`, `stage_count` (if applicable), `workflow_detail`

---

## Group 4: Reference material

**Purpose.** Identify background material this workspace needs.

**AskUserQuestion phrasing:**
- "What reference material do you want Claude to always have access to?" (multi-select or free-text)
  - Voice and tone guidelines
  - Brand or visual identity guidelines
  - A style guide or house rules
  - A client brief or specification
  - Technical documentation or an API reference
  - Research notes or a reading list
  - Script template or storyboard format
  - Production schedule or project timeline
  - Asset library or file organisation guide
  - Something else (describe)
  - None yet

**Free-form fallback phrasing:**
> "What background material should Claude always be able to refer to in this workspace? For example: a voice guide, a client brief, a style guide, design tokens, research notes, a script template. List anything that applies; it is fine to say 'nothing yet'."

**Recorded as:** `reference_types` (array)

---

## Group 5: Naming conventions

**Purpose.** Establish file naming rules to embed in the generated CLAUDE.md.

**AskUserQuestion phrasing:**
- "Do you have a preferred file naming style?" (discrete)
  - kebab-case (my-file-name.md)
  - snake_case (my_file_name.md)
  - Sentence case (My file name.md)
  - No preference (I will use the ICM default: kebab-case)
- "Do you want output files to include dates in their names?" (discrete)
  - Yes, ISO date prefix: YYYY-MM-DD-filename.md
  - Yes, short date prefix: YYYYMMDD-filename.md
  - No date in filename
  - No preference

**Free-form fallback phrasing:**
> "Do you have a preferred naming style for files? And do you want output files to include a date in the name? If no preference, I will use ICM defaults (kebab-case, no date prefix)."

**Recorded as:** `naming_style`, `date_in_filenames`

---

## Group 6: Skills and MCPs to wire in

**Purpose.** Identify any Claude Code skills or MCP servers to wire in.

**AskUserQuestion phrasing:**
- "Are there any Claude Code skills or MCP servers you want wired into this workspace?" (free-text, optional)

**Free-form fallback phrasing:**
> "Are there any Claude Code skills or MCP servers you want wired into this workspace from the start? It is fine to leave this blank; you can add them later."

**Recorded as:** `skills_to_wire`, `mcps_to_wire`

---

## Group 7: Confirmation and override

**Purpose.** Present the planned structure to the builder before writing anything.

**Script (both modes):**

> "Based on your answers, here is the plan:
>
> - **Layer model:** [3-layer / 5-layer] because [one-line rationale from decision-logic.md].
> - **Archetype:** [archetype name] because [one-line rationale].
> - **Confidence:** [high / medium / low / by-elimination].
> - **Workspace/stage names:** [list the names as they will appear in the folder structure].
> - **Reference files seeded:** [list the reference headings].
> - **Naming convention:** [state the chosen convention].
> - **inputs/ folder:** will be created and routed in CLAUDE.md.
>
> [If confidence is below high:] Note: the archetype match is [medium / low / by-elimination]. An Archetype caveat paragraph will be included in the generated CLAUDE.md identity block.
>
> Does this look right? Reply YES to proceed, or describe any changes and I will adjust before writing anything."

If the builder requests changes, update the plan and show it again. Do not write any files until the builder confirms.

**Recorded as:** `confirmed_layer_model`, `confirmed_archetype`, `confirmed_workspace_names`, `override_notes`

---

## Questionnaire template

```markdown
# Setup questionnaire

Recorded: [date]
Mode: [AskUserQuestion / free-form fallback]

## Project identity
- project_name: [answer]
- work_type: [answer]
- work_description: [answer]

## Primary outcomes
- primary_outcome: [answer]
- things_to_avoid: [answer]

## Workflow shape
- workflow_shape: [answer]
- stage_count: [answer or N/A]
- workflow_detail: [answer or N/A]

## Reference material
- reference_types: [comma-separated list or "none"]

## Naming conventions
- naming_style: [answer]
- date_in_filenames: [answer]

## Skills and MCPs
- skills_to_wire: [answer or "none"]
- mcps_to_wire: [answer or "none"]

## Confirmation
- confirmed_layer_model: [3-layer / 5-layer]
- confirmed_archetype: [archetype name]
- confirmed_workspace_names: [list]
- override_notes: [any overrides the builder made, or "none"]
```
