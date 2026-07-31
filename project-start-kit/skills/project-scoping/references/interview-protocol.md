# Interview Protocol

This file defines the eight topic areas the `project-scoping` skill covers in Stage A, the AskUserQuestion phrasing for discrete choices, and the free-form fallback phrasing for when AskUserQuestion is unavailable.

---

## Overview

The interview has two modes:

- **AskUserQuestion mode** (preferred): discrete options are presented as a list; the builder selects one. Free-text answers are asked as short open prompts.
- **Free-form fallback mode**: questions are asked one at a time as plain text. The answer structure is identical; only the UI differs.

In both modes, every answer is recorded verbatim in `setup/interview.md`.

---

## Topic 1: Project type

**Purpose.** Understand what is being built. Accept any project type. Do not map answers to archetypes yet.

**AskUserQuestion phrasing:**
- "What are you building?" (free-text, required)
- "Which of these best describes the project?" (discrete)
  - Brand identity (logo, visual system, tone of voice, brand guidelines)
  - Marketing website (launch site, portfolio, landing page)
  - Web application (tool, product, SaaS, dashboard)
  - Launch video (promo film, explainer, social content)
  - Research or strategy project (report, deck, analysis)
  - Something else (describe below)
- If "Something else": "Describe the project in one sentence." (free-text)

**Free-form fallback phrasing:**
> "Tell me what you are building. If it is more than one thing, name each one separately -- for example, 'a brand identity, a website, and a launch video'."

**Recorded as:** `project_type`, `deliverables_named` (array)

---

## Topic 2: Primary outcomes

**Purpose.** Understand what success looks like for each deliverable. Drives spec success-criteria sections.

**AskUserQuestion phrasing:**
- "What does success look like for this project?" (free-text, required)
- "By when does it need to be done?" (free-text, optional)

**Free-form fallback phrasing:**
> "For each deliverable, tell me what a successful outcome looks like. What does 'done' mean for this project? Is there a deadline?"

**Recorded as:** `primary_outcomes` (per deliverable), `deadline`

---

## Topic 3: Non-goals and risks

**Purpose.** Surface what is out of scope and what could go wrong. Drives spec non-goals and things-to-avoid sections.

**AskUserQuestion phrasing:**
- "What is explicitly out of scope for this project?" (free-text, optional)
- "What is the biggest risk or thing most likely to go wrong?" (free-text, optional)

**Free-form fallback phrasing:**
> "Tell me what you are NOT doing in this project -- anything you want to guard against or stay out of scope. And what is the biggest risk: what is most likely to go wrong?"

**Recorded as:** `non_goals`, `risks`

---

## Topic 4: Tackling flow

**Purpose.** Understand how the builder plans to sequence the work. Informs the layer model recommendation and whether stages should be sequential or parallel.

**AskUserQuestion phrasing:**
- "How do you plan to tackle this?" (discrete)
  - One thing at a time, in sequence (brand first, then website, then video)
  - Working on multiple deliverables in parallel
  - Not sure yet; the work will emerge as I go
  - This is a single-deliverable project

**Free-form fallback phrasing:**
> "How do you plan to approach this -- one deliverable at a time, or multiple things in parallel? Or is this a single piece of work?"

**Recorded as:** `tackling_flow`

---

## Topic 5: Reference material

**Purpose.** Identify background material the workspace should always have access to. Drives reference file seeding.

**AskUserQuestion phrasing:**
- "What reference material should always be available in this workspace?" (multi-select or free-text)
  - Voice and tone guidelines
  - Brand or visual identity guidelines
  - A client brief or project specification
  - A style guide or house rules
  - Research notes or market analysis
  - Technical documentation or an API reference
  - Scripts, templates, or production formats
  - Asset library or file organisation guide
  - Something else (describe)
  - Nothing yet

**Free-form fallback phrasing:**
> "What background material should Claude always be able to refer to? For example: a voice guide, a client brief, brand guidelines, research notes, a script template. It is fine to say 'nothing yet'."

**Recorded as:** `reference_types` (array)

---

## Topic 6: Integrations

**Purpose.** Identify any external tools or MCP servers to wire in from the start.

**AskUserQuestion phrasing:**
- "Are there any tools or MCP servers to wire into this workspace from the start?" (free-text, optional)

**Free-form fallback phrasing:**
> "Are there any tools -- Claude Code skills, MCP servers, or external services -- you want connected from the start? For example, a search tool, a calendar, a code linter. Leave blank if none."

**Recorded as:** `integrations`, `mcps_to_wire`

---

## Topic 7: English variant

**Purpose.** Establish the English variant for the anti-AI writing block. This is the single place the variant is recorded; it fills the placeholder in the anti-AI block automatically.

**AskUserQuestion phrasing:**
- "Which English variant does this project use?" (discrete)
  - British English (UK)
  - American English (US)
  - Australian English (AU)
  - Canadian English (CA)
  - Another variant (describe)
  - No preference

**Free-form fallback phrasing:**
> "Which English variant should this workspace use -- UK, US, Australian, Canadian, or another? This sets the spelling and usage rules for all generated content."

**Recorded as:** `english_variant`

---

## Topic 8: Multi-deliverable confirmation

**Purpose.** When the brief names more than one deliverable, confirm whether to produce one spec per deliverable or one combined spec. Drives Stage B output structure.

**When to ask.** Ask this topic only if `deliverables_named` (from Topic 1) contains two or more items.

**AskUserQuestion phrasing:**
- "You named [N] deliverables: [list]. How should I handle the specs?" (discrete)
  - One spec per deliverable (recommended for independent deliverables with different success criteria)
  - One combined spec (recommended when the deliverables are tightly coupled)

**Free-form fallback phrasing:**
> "You named [N] deliverables. Should I write one spec for each, or one combined spec? Separate specs work better when the deliverables have different teams, deadlines, or success criteria. A combined spec works when everything is tightly coupled."

**Recorded as:** `spec_structure` (one-per-deliverable | combined)

---

## Adversarial challenge examples

Use these when an answer is vague enough to prevent spec authoring:

| Vague answer | Challenge |
|---|---|
| "A nice website" | "What makes it nice for your visitor? What do you want them to do when they land on it?" |
| "Modern and clean" | "Modern and clean in what sense -- the visual style, the copy tone, or both? Can you name an example that has the quality you mean?" |
| "Something that converts" | "Converts visitors to what action specifically? Newsletter sign-up, purchase, booking, something else?" |
| "A good brand identity" | "Good how? What is the brand for, who is it for, and what feeling should it communicate?" |
| "A short video" | "How short? For which platform -- YouTube, Instagram, TikTok? What is the video's call to action?" |
| "Just make it work" | "Work for whom, doing what? Describe one visitor arriving at the site and what they successfully accomplish." |

Challenge each answer once. If the second answer is still vague, record it with the `[VAGUE -- review before spec]` flag and move on.
