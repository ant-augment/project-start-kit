# Maintenance Protocol

This is the canonical text for the "Maintenance protocol" section embedded verbatim into every generated CLAUDE.md. It must be present, unmodified, in every workspace this skill creates.

---

## Canonical protocol text

The following block is copied verbatim into every generated `CLAUDE.md`. Do not soften, summarise, or paraphrase it. The entire block must appear intact under the heading `## Maintenance protocol`.

```markdown
## Maintenance protocol

These five rules keep this workspace from decaying. They are not suggestions. A fresh session reading this file is expected to obey them without a second prompt.

**Rule 1: Read CLAUDE.md first on every task.**
Before writing, editing, or moving anything, read this file in full. If CLAUDE.md has changed since the last session, re-read it. Do not rely on memory from a previous context window.

**Rule 2: When adding a file, update routing if needed.**

**Rule 2a (top-level files).** A new file at the workspace root, or in a folder not covered by any routing entry (for example `_config/`, `shared/`, or a stage's reference folder when no reference file lived there before), must appear in the root CLAUDE.md routing table or folder-structure block in the same session you create the file. Do not defer it.

**Rule 2b (stage-internal files).** A new file inside a stage that already covers its category (for example a new working file in a stage's `output/`, a new note in `01_*/<process>/`, or a new reference next to an existing one) follows the stage's own CONTEXT.md hand-off checklist. Most stage-internal additions do not require a root routing change unless they introduce a new file type to the workspace.

When in doubt, prefer the routing update. A redundant entry is a minor irritant; a missing one breaks discoverability.

**Rule 3: When removing or renaming a file, scrub all references.**
Search for every mention of the old path across CLAUDE.md, CONTEXT.md, all stage CONTEXT.md files, and any Inputs or Outputs tables. Remove or update every occurrence before closing the session.

**Rule 4: When a Layer 3 reference file changes, flag downstream stages.**
If you edit a file in references/, check which stage CONTEXT.md files list that reference in their Inputs table. Add a "Review needed" note to each affected stage CONTEXT.md. Do not silently update the reference and move on.

**Rule 5: Archive, do not delete, superseded outputs.**
When an output is replaced or no longer active, move it to the archive/ folder (create it if needed). Do not delete it. Deleting outputs breaks the workspace's audit trail.
```

---

## Why this must be pushy

A maintenance protocol that says "you might want to" will be ignored. The phrasing above uses imperatives ("Read", "Add", "Search", "Move") and negative instructions ("Do not defer", "Do not delete", "Do not silently update"). This is deliberate. The protocol is written to a fresh Claude Code session that has not seen the workspace before; it must be self-sufficient.

---

## Embedding instructions for the icm-architect skill

When writing any `CLAUDE.md` file during init mode:

1. Include the `## Maintenance protocol` section verbatim from the canonical text above.
2. Place it as the first of the four governed blocks, after the routing table and folder structure sections.
3. Do not abbreviate the five rules. All five must be present.
4. Do not add a sixth rule during init; the builder may add to it later via `/icm-sync` if a new pattern emerges.
