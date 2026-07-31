---
name: project-scoping
description: Use when starting a brand-new project. Runs an adversarial discovery interview (Stage A) that challenges vague answers and surfaces unstated assumptions, then authors one spec document per deliverable (Stage B). Triggered by /project-start or any request to scope a new project before scaffolding. Always read this file before running either stage.
version: 0.1.0
---

# Project Scoping

This skill runs in two modes. Read the mode selection rule and jump to the correct procedure.

---

## Mode selection

| Trigger | Mode |
|---|---|
| `/project-start` loaded this skill for Stage A | **Interview mode** |
| Stage A transcript exists and spec authoring was requested | **Spec-authoring mode** |

If ambiguous, ask: "Do you want to run the discovery interview (Stage A) or draft specs from an existing transcript (Stage B)?"

---

## Interview mode (Stage A)

### Before starting: non-empty check

Check the current folder for existing files. If a `CLAUDE.md` already exists, stop and say:

> "This folder already has a CLAUDE.md. `/project-start` is for empty projects. Run `/icm-sync` to audit an existing workspace, or start in a clean folder."

If the folder has other files but no `CLAUDE.md`, continue. Note the existing files in the transcript under "Pre-existing files".

---

### Run the interview

Read `./references/interview-protocol.md` in full before asking any questions.

The interview covers eight topic areas in order:

1. **Project type.** What are you building? Accept any type without judgement.
2. **Primary outcomes.** What does success look like for each deliverable?
3. **Non-goals and risks.** What is explicitly out of scope? What could go wrong?
4. **Tackling flow.** How do you intend to work through this (sequence, parallel tracks)?
5. **Reference material.** What background material should the workspace have access to?
6. **Integrations.** Any third-party tools, APIs, or MCP servers to wire in?
7. **English variant.** UK, US, AU, CA, or other? This fills the anti-AI block's variant field.
8. **Multi-deliverable confirmation.** If the brief names more than one deliverable, list them explicitly and ask: "One spec per deliverable, or one combined spec?"

**AskUserQuestion mode (preferred).** Use discrete choice questions for Topics 1, 4, 7, and 8 when AskUserQuestion is available. Topics 2, 3, 5, and 6 are open text.

**Free-form fallback.** When AskUserQuestion is unavailable, ask each topic as a plain text question, one at a time. The transcript shape is identical.

**Adversarial behaviour.** For every answer, apply the rule from `./references/verbatim-recording-rule.md`: record the answer verbatim AND assess whether it is specific enough to write a spec from. If an answer is vague:
- Challenge it once with a concrete clarifying question.
- If the second answer is still vague, record it as-is with the flag `[VAGUE -- review before spec]`.
- Do not challenge the same answer more than once. Move on.

Examples of vague answers to challenge:
- "I want a nice website" -> "What makes it nice for the visitor? What action do you want them to take when they arrive?"
- "Something modern and clean" -> "Modern and clean in what sense -- the visual style, the copy tone, or both? Can you name a reference that has the quality you mean?"
- "Just make it work" -> "Work how, specifically? What does a visitor do on this site successfully?"

---

### Record the transcript

After all eight topics are covered, write the full transcript verbatim to `setup/interview.md`. Use the template from `./references/interview-transcript-template.md`.

This is the only file written in Stage A.

---

### Confirm before proceeding to Stage B

Read back to the builder:
- The deliverables named (list them).
- The spec structure you plan to use (one per deliverable, or combined).
- Any answers flagged as `[VAGUE]` and how you will handle them (flag in the spec rather than guess).

Ask: "Does this look right? Reply YES to proceed to spec authoring, or describe any corrections."

Do not begin Stage B until the builder replies YES.

---

## Spec-authoring mode (Stage B)

### Step 1: Read the interview transcript

Read `setup/interview.md` in full. Identify:
- The deliverables (from Topic 8 or inferred from Topics 1 and 2).
- The spec structure (one per deliverable or combined).
- Any `[VAGUE]` flags to carry into the spec as explicit open questions.

Read `./references/spec-template.md` for the required spec structure.

---

### Step 2: Draft the specs

For each deliverable, draft a spec using the five-section structure from the template:

1. **Goal.** One or two sentences: what is this deliverable for and who is it for?
2. **Scope.** What is included. What is explicitly excluded. No ambiguity permitted.
3. **Success criteria.** How will you know this deliverable is done? State two to five testable criteria.
4. **Deliverables.** The specific files, artefacts, or decisions this spec produces.
5. **Non-goals.** What this spec explicitly does not cover, even if related. Repeat explicitly.

**Handling `[VAGUE]` flags.** Do not guess at what the builder meant. Instead, insert a clearly marked open question in the relevant section:

> **Open question:** [question text -- resolve before work begins]

---

### Step 3: Present and confirm

Show all drafts to the builder. Wait for feedback. Apply any requested changes and show the revised drafts.

When the builder replies YES, write the spec files:
- One file per deliverable: `specs/[deliverable-name]-spec.md`
- Combined spec if single-scope: `specs/project-spec.md`

Read `./references/one-or-many-specs-decision.md` if there is any ambiguity about whether to produce one file or many.

---

### Step 4: Produce the architecture brief

After writing the specs, produce a one-page architecture brief at `setup/architecture-brief.md`. The brief summarises:
- Number of deliverables and their names.
- Recommended layer model (3-layer or 5-layer) based on `./references/one-or-many-specs-decision.md`.
- Suggested archetype(s).
- Cross-deliverable concerns (shared references, shared voice, shared brand assets).

This brief is the handoff to the `icm-architect` skill. It does not replace the full questionnaire; it pre-fills the most consequential answers.

---

### Step 5: Confirm handoff

Tell the builder:
- What was written (spec files, architecture brief).
- What the `icm-architect` skill will read next.
- Next step: the skill will now run Stage C (workspace scaffold). It will propose a plan and wait for a second confirmation before writing any workspace files.

---

## References (bundled)

- `./references/interview-protocol.md` -- the eight topic areas, AskUserQuestion phrasing, free-form fallback phrasing, adversarial challenge examples.
- `./references/verbatim-recording-rule.md` -- how to record answers and when to challenge.
- `./references/spec-template.md` -- the five-section spec structure with filling instructions.
- `./references/one-or-many-specs-decision.md` -- when to produce one spec vs many, and how to recommend a layer model from spec structure.

---

## Hard rules (always apply)

- Never write any workspace files in Stage A. Only `setup/interview.md` is written.
- Never begin Stage B without builder confirmation of the transcript.
- Never guess at vague answers. Flag them and carry them forward.
- Never write spec files without showing drafts and receiving builder confirmation.
- Always record interview answers verbatim, even when they are vague or contradictory.
- UK English throughout. No em dashes.
