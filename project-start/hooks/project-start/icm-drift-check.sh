#!/bin/sh
# icm-drift-check.sh
# version: 0.3.0
# PostToolUse hook for ICM workspaces.
# Checks four structural drift patterns after every Write or Edit tool call.
#
# Canonical location: .claude/hooks/icm-drift-check.sh, invoked from settings.json
# via "sh \"$CLAUDE_PROJECT_DIR/.claude/hooks/icm-drift-check.sh\"". This is the
# only supported placement as of 0.3.0; see INSTALL.md "Upgrading" for prior
# placements and how to move to this one.
#
# No installed copy of this script identifies its own version to a human reading
# a drift report in the terminal; the version above is for a builder diffing two
# copies (grep "^# version:") to tell a stale install from a current one, and it
# is echoed into the emitted directive below so a report is traceable to the
# script that produced it.
# Emits hookSpecificOutput.additionalContext JSON to the session when drift is detected,
# so the model reads the directive and acts on it in the same turn.
#
# Verified contract (Claude Code PostToolUse):
#   - Claude Code sends a JSON payload on stdin containing tool_name, tool_input, cwd, etc.
#   - To surface output to the MODEL (not just the user), exit 0 and emit a single JSON
#     object on stdout of the form:
#       {"hookSpecificOutput":{"hookEventName":"PostToolUse","additionalContext":"<string>"}}
#   - Plain stdout on exit 0 (without the hookSpecificOutput envelope) is shown to the
#     USER ONLY and does not enter the model's context. This hook uses the envelope.
#   - When no drift is found, emit nothing and exit 0.
#
# Portability: POSIX sh. No bash-isms. No jq dependency. JSON is hand-constructed.
# Root resolution: $CLAUDE_PROJECT_DIR (set by Claude Code hooks) or pwd as fallback.

set -e

# -----------------------------------------------------------------------
# Read the JSON payload from stdin (sent by Claude Code).
# We do not currently use it for routing, but consuming stdin is good
# practice; some environments block if stdin is not read.
# -----------------------------------------------------------------------
_stdin=$(cat)

# -----------------------------------------------------------------------
# Resolve workspace root.
# $CLAUDE_PROJECT_DIR is set by Claude Code when a hook runs.
# If not set (e.g. manual test run), fall back to the current working directory.
# -----------------------------------------------------------------------
if [ -n "$CLAUDE_PROJECT_DIR" ]; then
    WORKSPACE_ROOT="$CLAUDE_PROJECT_DIR"
else
    WORKSPACE_ROOT="$(pwd)"
    # Degrade gracefully: if this is not an ICM workspace, exit silently.
    if [ ! -f "$WORKSPACE_ROOT/CLAUDE.md" ]; then
        exit 0
    fi
fi

CLAUDE_MD="$WORKSPACE_ROOT/CLAUDE.md"

# If CLAUDE.md does not exist, this is not an ICM workspace. Exit silently.
if [ ! -f "$CLAUDE_MD" ]; then
    exit 0
fi

# Use a temp file to accumulate findings so we can handle the
# subshell/pipeline issue with drift check 2.
TMPFILE="/tmp/icm_drift_$$"
: > "$TMPFILE"
FOUND=0

# -----------------------------------------------------------------------
# Drift check 1a: Stale routing entry.
# Look for markdown link targets in the routing table that do not exist.
# We match lines from the routing table that contain a file path (not a URL).
#
# Scope: ONLY the "## Routing table" section, not the whole file. CLAUDE.md
# prose elsewhere (Identity, Naming conventions examples, etc.) routinely
# mentions filenames like `design.md` or "Example: 2026-08-03-test-results.md"
# that are illustrative, not routing entries -- scanning the whole file
# treats those as stale paths and false-positives on every run.
# -----------------------------------------------------------------------
ROUTING_BLOCK="/tmp/icm_routing_$$"
awk '/^## Routing table/{flag=1; next} /^## /{flag=0} flag' "$CLAUDE_MD" > "$ROUTING_BLOCK"

# -----------------------------------------------------------------------
# Fail closed, not open. If no line begins exactly "## Routing table"
# (case-sensitive), the awk scope above matched nothing and the loop
# below runs zero times -- which looks identical to "checked, found no
# stale entries". A workspace whose routing section is headed anything
# else (a typo, a different convention, a hand-authored CLAUDE.md this
# hook was never generated for) would have its Critical-severity check
# silently disabled with no signal to the session or the builder. Report
# the skip explicitly instead of staying silent.
# -----------------------------------------------------------------------
# grep -c always prints a count, including 0, but exits non-zero when the
# count is 0. Two traps here, both hit during testing, both worth recording:
# (1) "|| printf '0'" is wrong -- grep's own "0" is already on stdout by the
#     time it exits non-zero, so the fallback appends a second "0" inside the
#     same command substitution, producing "0\n0" and breaking the -eq test
#     below with "integer expression expected".
# (2) A bare failing command substitution in an assignment ("X=$(cmd)") trips
#     `set -e` in this shell when cmd exits non-zero, even though the value
#     assigned is fine. "|| true" absorbs the exit status without touching
#     stdout, since true prints nothing.
HEADING_COUNT=$(grep -c "^## Routing table" "$CLAUDE_MD" || true)
if [ "$HEADING_COUNT" -eq 0 ]; then
    printf 'DRIFT-1a-SKIPPED: no '\''## Routing table'\'' heading (exact, case-sensitive) found in CLAUDE.md. The stale-routing-entry check did not run. If this workspace names its routing section something else, this check cannot see it and needs the heading text or the hook updated to match.\n' >> "$TMPFILE"
    FOUND=1
fi

while IFS= read -r line; do
    # Table rows are "| Task type | Read first | Also load | Skip |". Column 1
    # (Task type) is a prose description of the row and routinely names a file
    # in passing (e.g. "Planning the design.md format...") without that being a
    # routing path -- strip it before matching so only columns 2-4 are checked.
    case "$line" in
        \|*) line=$(printf '%s\n' "$line" | sed -E 's/^\|[^|]*\|//') ;;
    esac
    paths=$(printf '%s\n' "$line" | grep -oE '[A-Za-z0-9_./][A-Za-z0-9_./-]+\.(md|json|sh)' 2>/dev/null || true)
    for path in $paths; do
        case "$path" in
            http*) continue ;;
            *\{\{*) continue ;;
        esac
        full_path="$WORKSPACE_ROOT/$path"
        if [ ! -e "$full_path" ]; then
            printf 'DRIFT-1a: Routing entry references '\''%s'\'' in CLAUDE.md but that file does not exist. Fix: remove the entry if the file was deleted, update the path if it was moved, or create the file if it should exist.\n' "$path" >> "$TMPFILE"
            FOUND=1
        fi
    done
done < "$ROUTING_BLOCK"
rm -f "$ROUTING_BLOCK"

# -----------------------------------------------------------------------
# Drift check 1b: Undocumented new top-level file.
# Check files at the workspace root that are not mentioned in CLAUDE.md.
# Excludes hidden files, setup/, archive/, _config/, and conventional names.
# -----------------------------------------------------------------------
for f in "$WORKSPACE_ROOT"/*; do
    [ -e "$f" ] || continue
    fname=$(basename "$f")
    case "$fname" in
        .* | CLAUDE.md | CONTEXT.md | REFERENCES.md | setup | archive | _config | shared | inputs | specs) continue ;;
    esac
    if ! grep -qF "$fname" "$CLAUDE_MD" 2>/dev/null; then
        printf 'DRIFT-1b: File or folder '\''%s'\'' exists at the workspace root but is not mentioned in CLAUDE.md. Fix: add a one-line routing entry or folder-structure entry in CLAUDE.md describing its purpose.\n' "$fname" >> "$TMPFILE"
        FOUND=1
    fi
done

# -----------------------------------------------------------------------
# Drift check 2: Dead MD-to-MD links.
# Scan all .md files for markdown links pointing at another local .md
# file, and check whether the target exists.
#
# No .claude/ exclusion here. An earlier version of this check excluded
# .claude/ to hide two literal link-syntax examples inside this pattern's
# own bundled drift-rules.md, which is documentation, not the intended
# scope of this check -- and drift-rules.md's own prose still described
# the check as scanning "all .md files", so /icm-sync (which reads that
# file rather than this exclusion) kept reporting the same two false
# positives the exclusion claimed to fix. Fixed the source instead: the
# two examples in drift-rules.md no longer form a real link pattern. If a
# workspace's own .claude/ tree ever contains a genuinely dead .md link,
# this check should find it like anywhere else.
#
# Run in a subshell; write findings to the temp file directly so they are
# not lost when the subshell exits.
# -----------------------------------------------------------------------
find "$WORKSPACE_ROOT" -name "*.md" -not -path "*/archive/*" -not -path "*/.git/*" | while IFS= read -r mdfile; do
    grep -oE '\[([^]]+)\]\(([^)]+\.md)\)' "$mdfile" 2>/dev/null | while IFS= read -r match; do
        target=$(printf '%s\n' "$match" | sed 's/.*](\(.*\))/\1/')
        case "$target" in http*) continue ;; esac
        dir=$(dirname "$mdfile")
        resolved="$dir/$target"
        if [ ! -e "$resolved" ]; then
            printf 'DRIFT-2: Dead link in %s: %s points to %s which does not exist. Fix: update the link target or remove the link.\n' \
                "${mdfile#$WORKSPACE_ROOT/}" "$match" "$target" >> "$TMPFILE"
        fi
    done
done

# Check if drift 2 added anything (FOUND flag cannot cross subshell boundary,
# so we check file size instead).
if [ -s "$TMPFILE" ]; then
    FOUND=1
fi

# -----------------------------------------------------------------------
# Drift check 5: Missing stage CONTEXT.md.
# Scan for NN_* folders at the workspace root that lack a CONTEXT.md.
# -----------------------------------------------------------------------
for d in "$WORKSPACE_ROOT"/[0-9][0-9]_*/; do
    [ -d "$d" ] || continue
    if [ ! -f "${d}CONTEXT.md" ]; then
        stage=$(basename "$d")
        printf 'DRIFT-5: Stage folder '\''%s'\'' is missing a CONTEXT.md. A stage without a CONTEXT.md has no contract for a session to work from. Fix: create a CONTEXT.md from the stage template, or remove the folder if this stage is not yet ready.\n' "$stage" >> "$TMPFILE"
        FOUND=1
    fi
done

# -----------------------------------------------------------------------
# Emit findings.
# When drift is found, emit a JSON hookSpecificOutput envelope so the model
# receives the directive in its next turn, not just the user's terminal.
# When no drift is found, emit nothing and exit 0.
#
# JSON escaping of the findings string:
#   Step 1: backslashes first (must be first, or later steps double-escape).
#   Step 2: double-quotes.
#   Step 3: carriage returns.
#   Step 4: tabs (literal tab char in the sed expression).
#   Step 5: actual newlines -> \n, using awk `print` (NOT `printf`) for the
#           separator. awk `printf "\\n"` re-interprets \n as a real newline;
#           `print "\\n"` emits the literal two-character escape, which is what
#           valid JSON requires inside a string.
#
# Mental test -- finding containing a plain path (common case):
#   Input:  "DRIFT-1a: Routing entry references 'inputs/brief.md' in CLAUDE.md..."
#   After steps 1-4: unchanged (no special chars).
#   After step 5: newline at end of line -> \n. Result is valid JSON string content.
#
# Mental test -- finding containing a double-quote (unlikely but possible):
#   Input:  'path "foo.md" not found'
#   After step 2: 'path \"foo.md\" not found'. Valid inside JSON string.
# -----------------------------------------------------------------------
if [ "$FOUND" -eq 1 ]; then
    printf 'Fix directive: address each finding above before continuing. Update CLAUDE.md routing, create missing files, or remove stale entries as indicated. Run /icm-sync for a full audit including semantic drift patterns. (icm-drift-check.sh version 0.3.0)\n' >> "$TMPFILE"

    ESCAPED=$(sed 's/\\/\\\\/g' "$TMPFILE")
    ESCAPED=$(printf '%s' "$ESCAPED" | sed 's/"/\\"/g')
    ESCAPED=$(printf '%s' "$ESCAPED" | sed 's/\r/\\r/g')
    ESCAPED=$(printf '%s' "$ESCAPED" | sed 's/	/\\t/g')
    ESCAPED=$(printf '%s' "$ESCAPED" | awk 'BEGIN{ORS=""} NR>1{print "\\n"} {printf "%s", $0} END{if(NR>0) print "\\n"}')

    printf '{"hookSpecificOutput":{"hookEventName":"PostToolUse","additionalContext":"%s"}}' "$ESCAPED"
fi

rm -f "$TMPFILE"
exit 0
