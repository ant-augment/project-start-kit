# Verbatim Recording Rule

This file defines how the `project-scoping` skill records interview answers and when to challenge them.

---

## The rule

Record every answer verbatim. Do not paraphrase, summarise, or improve what the builder said. Even if the answer is vague, contradictory, or poorly expressed, write it down as spoken.

Verbatim recording serves two purposes:

1. **Traceability.** The spec author (Stage B) reads the raw answers, not a cleaned-up version. Any interpretation happens in the spec, not in the recording.
2. **Accountability.** If a spec later turns out to be based on a mistaken assumption, the interview transcript is the audit trail.

---

## When to challenge

Challenge an answer when it is specific enough to be recorded but not specific enough to write a testable success criterion from.

**Challenge once.** Ask one clarifying question and record the response. If the second answer is also vague, add the flag `[VAGUE -- review before spec]` to the transcript entry and move on. Never challenge the same answer twice.

**Do not challenge:**
- Answers that are specific enough to write a spec section from, even if brief.
- Answers to Topics 6 (integrations) and 7 (English variant) -- these are optional and vague answers are acceptable.
- Answers where the vagueness is intentional ("I do not know yet" is a valid, specific answer).

---

## Vagueness threshold

An answer is vague enough to challenge when you cannot answer this question from it:

> "If I wrote a success criterion for this deliverable right now, would a reasonable person agree or disagree with whether it had been met?"

If the answer is "I could not write a testable criterion from this", challenge the answer once.

---

## The `[VAGUE]` flag

When an answer is flagged `[VAGUE -- review before spec]`, the Stage B spec author handles it by inserting an open question in the spec rather than guessing:

> **Open question:** [question text -- resolve before work begins]

The open question is placed in the most relevant section of the spec (usually Scope or Success criteria). The builder sees it and resolves it before work begins.

---

## Contradictions

If two answers contradict each other (for example, "we want a minimal single-page site" in Topic 1 and "we need a five-section site with a blog" in Topic 2), record both answers verbatim and note the contradiction:

> **Contradiction noted:** [Topic 1 says X; Topic 2 says Y. Resolved in spec.]

The spec author flags the contradiction in the spec and proposes a resolution for the builder to confirm.

---

## Transcript format

Each recorded answer uses this shape:

```
## Topic N: [topic name]

Q: [the question asked, verbatim or paraphrased from the protocol]
A: [the builder's answer, verbatim]
[VAGUE -- review before spec] (if applicable)
[Contradiction noted: ...] (if applicable)
[Challenge asked: ...] (if a challenge was posed)
[Challenge response: ...] (if a second answer was given)
```
