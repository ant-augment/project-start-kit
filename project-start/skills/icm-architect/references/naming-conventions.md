# Naming Conventions

This file defines the naming rules the `icm-architect` skill enforces during init and sync modes. These rules are also written into every generated CLAUDE.md so a fresh session can enforce them without loading the skill.

---

## Default convention (ICM baseline)

When the builder selects "No preference", the following defaults apply:

- **Folders:** kebab-case. Examples: `client-intake`, `01_research`, `references`.
- **Files:** kebab-case with `.md` extension. Examples: `voice-guide.md`, `brief-2026-04-30.md`.
- **Stage folders:** zero-padded two-digit prefix followed by underscore, then kebab-case name. Examples: `01_research`, `02_scriptwriting`, `03_production`.
- **Output files with dates:** ISO date prefix: `YYYY-MM-DD-filename.md`. Example: `2026-04-30-client-brief.md`.
- **Output files without dates:** kebab-case, no prefix. Example: `commission-brief.md`.
- **Draft files:** suffix `_draft`. Example: `chapter-one_draft.md`.
- **Archived files:** moved to `archive/` folder; filename unchanged.

---

## User-selected overrides

When the builder selects a different convention in Group 5 of the question protocol, that convention is used throughout:

| User selection | Folder style | File style |
|---|---|---|
| kebab-case | kebab-case | kebab-case |
| snake_case | snake_case | snake_case |
| Sentence case | Sentence case | Sentence case |
| No preference | kebab-case (default) | kebab-case (default) |

The date prefix format follows the builder's date preference from Group 5.

---

## Text embedded into generated CLAUDE.md

The following block is copied verbatim into the "Naming conventions" section of every generated CLAUDE.md. Substitute `[STYLE]` with the chosen style, `[DATE_FORMAT]` with the chosen date format.

```markdown
## Naming conventions

- **Folders:** [STYLE]. Examples: client-intake, references.
- **Files:** [STYLE] with .md extension.
- **Stage folders (5-layer only):** Zero-padded two-digit prefix, underscore, then name. Example: 01_research.
- **Dated output files:** [DATE_FORMAT] prefix. Example: [EXAMPLE].
- **Draft files:** Suffix _draft before the extension. Example: chapter-one_draft.md.
- **Archived files:** Move to archive/ folder; keep the filename unchanged.

When adding a new file, check its name against these rules before saving. If you are unsure, ask before creating the file.
```

---

## Rules enforced by `/icm-sync` drift detection

The sync audit checks the following naming violations:
1. A file in a stage folder that does not match the workspace's chosen naming convention.
2. A stage folder that does not use the `NN_name` prefix pattern (5-layer only).
3. An archived file that still lives in an active folder rather than `archive/`.
4. A dated output file whose date format does not match the workspace's configured format.

Each violation is reported as a drift finding with severity "low" unless it is in a routing table, in which case severity is "medium".
