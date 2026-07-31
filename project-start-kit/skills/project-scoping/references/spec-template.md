# Spec Template

This file defines the five-section spec structure the `project-scoping` skill uses in Stage B. Every spec produced by this skill must follow this structure.

---

## Required sections

### 1. Goal

**What it contains.** One or two sentences stating:
- What this deliverable is.
- Who it is for.
- What purpose it serves.

**Good example:**
> A brand identity system for Camellia & Co., a specialty tea brand. The system gives the brand a distinctive visual and verbal identity that works across packaging, print, and digital.

**Bad example:**
> A brand identity. It needs to be good and on-brand.

---

### 2. Scope

**What it contains.** Two sub-sections:

**Included:**
A list of the specific things this deliverable covers. Be concrete. "Logo and wordmark" is acceptable; "visual identity" is not (too broad).

**Excluded:**
A list of things explicitly not covered by this deliverable, even if related. This section prevents scope creep. It is required. If nothing comes to mind, think about what a client might reasonably expect and list what you are not doing.

---

### 3. Success criteria

**What it contains.** Two to five testable criteria. Each criterion must be testable: a reasonable person must be able to look at the deliverable and say "this passes" or "this does not pass" without guessing.

**Good example:**
> 1. The logo works at 24px and at full bleed without losing legibility.
> 2. The brand guidelines document covers colour, type, logo usage, tone, and photography style.
> 3. Three applied examples are provided (business card, social post, packaging).

**Bad example:**
> 1. The brand looks professional.
> 2. The client is happy.

---

### 4. Deliverables

**What it contains.** The specific files, artefacts, or decisions this spec produces. This is the list the builder can check against when the work is done.

**Format.** A table or bullet list.

**Example:**
- `brand/logo/camellia-logo.svg` -- primary logo, full colour
- `brand/logo/camellia-logo-mono.svg` -- monochrome variant
- `brand/guidelines/brand-guidelines.md` -- the full guidelines document
- `brand/examples/` -- three applied examples

---

### 5. Non-goals

**What it contains.** What this spec explicitly does not cover. This is different from Scope Excluded: non-goals are things a reader might expect to be in scope but are not.

**Why it is required.** Non-goals prevent a later argument about whether something was "supposed to be" included. If it is not in Non-goals, a reasonable reader might think it was implied.

**Example for a brand identity spec:**
- Website design (covered in a separate spec)
- Social media content production
- Photography or illustration work beyond the three applied examples
- Print production or file preparation for a printer

---

## Template file structure

```markdown
# Spec: [deliverable name]

**Project:** [project name]
**Deliverable:** [deliverable name]
**Drafted:** [date]

---

## Goal

[one or two sentences]

---

## Scope

**Included:**
- [item]
- [item]

**Excluded:**
- [item]
- [item]

---

## Success criteria

1. [testable criterion]
2. [testable criterion]
3. [testable criterion]

---

## Deliverables

| Artefact | Description |
|---|---|
| [file or folder] | [what it is] |

---

## Non-goals

- [thing explicitly not covered]
- [thing explicitly not covered]

---

## Open questions

<!-- Leave this section blank if no vague answers were flagged in Stage A. -->

[Open question: question text -- resolve before work begins]
```

---

## Filling instructions

- Replace `[deliverable name]` with a short kebab-case name (e.g. `brand-identity`, `marketing-website`, `launch-video`).
- Replace `[project name]` with the project name from the interview transcript.
- Fill each section from the interview transcript. Do not invent requirements.
- If the interview produced a `[VAGUE]` flag for this deliverable, insert an Open question in the most relevant section.
- Do not remove or rename any section. The five sections are fixed. The Open questions section may be left blank.
