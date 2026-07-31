#!/bin/sh
# icm-drift-check.sh
# PostToolUse hook for ICM workspaces.
# Checks four structural drift patterns after every Write or Edit tool call.
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
# -----------------------------------------------------------------------
while IFS= read -r line; do
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
done < "$CLAUDE_MD"

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
# Scan all .md files for [text](path.md) links whose targets do not exist.
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
    printf 'Fix directive: address each finding above before continuing. Update CLAUDE.md routing, create missing files, or remove stale entries as indicated. Run /icm-sync for a full audit including semantic drift patterns.\n' >> "$TMPFILE"

    ESCAPED=$(sed 's/\\/\\\\/g' "$TMPFILE")
    ESCAPED=$(printf '%s' "$ESCAPED" | sed 's/"/\\"/g')
    ESCAPED=$(printf '%s' "$ESCAPED" | sed 's/\r/\\r/g')
    ESCAPED=$(printf '%s' "$ESCAPED" | sed 's/	/\\t/g')
    ESCAPED=$(printf '%s' "$ESCAPED" | awk 'BEGIN{ORS=""} NR>1{print "\\n"} {printf "%s", $0} END{if(NR>0) print "\\n"}')

    printf '{"hookSpecificOutput":{"hookEventName":"PostToolUse","additionalContext":"%s"}}' "$ESCAPED"
fi

rm -f "$TMPFILE"
exit 0
