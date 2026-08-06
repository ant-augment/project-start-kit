# Interview transcript template

This is the template `project-scoping`'s Stage A writes to `setup/interview.md`. It has two parts: the verbatim transcript (per-topic Q/A, shape defined in `./verbatim-recording-rule.md`) and a structured summary that `icm-architect` reads to pre-fill its own questionnaire in Stage C. Both parts are required. The transcript is the audit trail; the summary is the machine-readable handoff. Neither substitutes for the other.

---

## Template

```markdown
# Interview transcript

Project: [one-line project name or description, from Topic 1]
Interviewed: [date]

---

## Pre-existing files

[List any files found in the project folder before the interview started, per
project-scoping/SKILL.md's non-empty check. If the folder was empty, write
"None -- empty folder."]

---

## Topic 1: Project type

Q: [the question asked, verbatim or paraphrased from the protocol]
A: [the builder's answer, verbatim]
[VAGUE -- review before spec] (if applicable)
[Challenge asked: ...] (if a challenge was posed)
[Challenge response: ...] (if a second answer was given)

## Topic 2: Primary outcomes

Q: ...
A: ...

## Topic 3: Non-goals and risks

Q: ...
A: ...

## Topic 4: Tackling flow

Q: ...
A: ...

## Topic 5: Reference material

Q: ...
A: ...

## Topic 6: Integrations

Q: ...
A: ...

## Topic 7: English variant

Q: ...
A: ...

## Topic 8: Multi-deliverable confirmation

[Omit this section entirely if Topic 1 named a single deliverable -- do not
write an empty heading. `interview-protocol.md` gates this topic on
`deliverables_named` containing two or more items.]

Q: ...
A: ...

---

## Contradictions

[List any contradictions noted per verbatim-recording-rule.md, each as:
**Contradiction noted:** [Topic X says ...; Topic Y says .... Resolved in spec.]
If none: write "None noted."]

---

## Structured summary

This section is what `icm-architect` reads to pre-fill Stage C's questionnaire. Every field name below matches the "Recorded as:" field named for that topic in `interview-protocol.md`. A field left blank because the topic was skipped, declined, or gated out is written as `(not answered)`, not omitted -- an omitted field and a blank one are not the same thing to a session parsing this file.

- **project_type:** [from Topic 1]
- **deliverables_named:** [array, from Topic 1 -- one entry even for a single-deliverable project]
- **primary_outcomes:** [from Topic 2, one entry per deliverable if multi-deliverable]
- **deadline:** [from Topic 2, or "(not answered)"]
- **non_goals:** [from Topic 3, or "(not answered)"]
- **risks:** [from Topic 3, or "(not answered)"]
- **tackling_flow:** [from Topic 4]
- **reference_types:** [array, from Topic 5, or "(none named)"]
- **integrations:** [from Topic 6, or "(not answered)"]
- **mcps_to_wire:** [from Topic 6, or "(none)"]
- **english_variant:** [from Topic 7 -- if the builder gave no preference or left it blank, write "(not answered)" here rather than defaulting silently; `icm-architect` Stage D defaults an unanswered variant to British English (UK) and notes that it did so, but that default belongs to Stage D, not to this summary]
- **spec_structure:** [from Topic 8: `one-per-deliverable` | `combined` | "(single deliverable, topic not asked)"]

---

## Confirmation

Builder confirmed this transcript: [YES, with date, or "pending"]
```

---

## Notes on fields with no direct topic

**Pre-existing files** has no numbered topic because it is detected before the interview starts (`project-scoping/SKILL.md`, "Before starting: non-empty check"), not asked as a question. It still needs a fixed heading so a session re-reading the transcript later does not have to infer where this information would be.

**Confirmation** is not a topic either; it is the record that Stage A's own hard rule ("Never begin Stage B without builder confirmation of the transcript") was actually satisfied, which matters if this transcript is read by a later session that was not present for the interview.

## Why the structured summary exists as a separate section

`PATTERN.md`'s Coordination section states that `setup/interview.md` "carries the verbatim transcript and a structured summary used by `icm-architect` to pre-fill questionnaire answers." Before this template existed, nothing defined what that summary contained or how it was shaped, so `icm-architect`'s Stage C ("Pre-fill answers from `setup/architecture-brief.md` and `setup/interview.md` where they exist") had no defined format to parse. The field list above is exhaustive against `interview-protocol.md`'s eight "Recorded as:" lines, so a session filling this section only has to look up each topic's own protocol entry, not invent a shape.

## Why Topic 7 keeps its exact heading text

`icm-architect/SKILL.md`'s governance-injection Step 2 locates the English variant by reading "the interview transcript (`setup/interview.md`, Topic 7)". The heading `## Topic 7: English variant` in the template above is the anchor that makes "Topic 7" a findable string rather than a positional guess that breaks if a topic is ever reordered or renamed.
