---
name: memory-dream
version: 0.5.0
description: >
  Memory consolidation pass over Claude Code memory files. Discovers and
  tidies memories across project hierarchies — merges near-duplicates,
  prunes stale entries, clusters scattered files, cross-references
  CLAUDE.md, and maintains a changelog of changes. Auto mode by default;
  first run plans and waits for approval. Use whenever the user says
  "memory dream", "tidy my memory", "clean up memory", "consolidate
  memories", "memory maintenance", "defragment memory", "prune stale
  memories", "merge duplicate memories", or asks for periodic memory
  hygiene.
---

# /memory-dream

> **Memory Dream** — Defragment your AI's memory.

> _Source: [moondrop-skills](https://github.com/moondrop-ro/moondrop-skills)._

```
/memory-dream              # Current project + ancestors, auto mode
/memory-dream --plan       # Show proposed changes before applying
/memory-dream --all        # All projects under ~/.claude/projects/
```

---

A reflective pass that synthesizes, merges, prunes, and organizes Claude Code memory files so future sessions orient quickly and accurately. Project-agnostic — discover the environment, adapt to whatever memory format is in use, leave things cleaner than you found them.

## Step 0 — Discover

Claude Code stores per-project memory in `~/.claude/projects/<project-key>/memory/`. The project key replaces path separators with `--` (e.g., `D:\projects\foo` → `D--projects-foo`).

1. Identify the current project key from the working directory.
2. Find the current project's `memory/` directory.
3. Walk up the directory hierarchy and check ancestors for `memory/` subdirs.
4. With `--all`, instead scan every directory under `~/.claude/projects/` that has a `memory/` subdir.
5. Read global `~/.claude/CLAUDE.md` and project `CLAUDE.md` (read-only references for deduplication; never modify).
6. Locate session transcripts: JSONL files in `~/.claude/projects/<project-key>/`. Grep narrowly, never read whole files.
7. Read `.dream-state.json` in the current project's memory directory if it exists.

## Step 1 — Mode

**Plan mode** (present changes, wait for approval): first run on this project (no `.dream-state.json`) or `--plan` flag. Present every proposed change as a numbered list and wait for approval before writing.

**Auto mode** (execute, write changelog): `.dream-state.json` exists and no `--plan` flag. Make changes directly, report a summary at the end.

## Step 2 — Orient

For each memory directory in scope (current project first, then ancestors):

1. List the directory.
2. Read the index file (usually `MEMORY.md`).
3. Skim existing topic files — frontmatter and first lines — to understand coverage.
4. Note format conventions (frontmatter fields, type names, naming patterns). Adapt to whatever format you find rather than imposing a different one.
5. Review recent entries in `logs/` or `sessions/` if present.

Build a mental map: topics covered, files that overlap, format conventions, modification dates.

## Step 3 — Gather signal

### 3a. Staleness
- Compare modification dates against `.dream-state.json` last-run date.
- For memories referencing specific file paths, function names, or patterns: grep the codebase to verify they exist.
- Check for memories that contradict CLAUDE.md (which is the source of truth for current project state).

### 3b. Duplication
- Within a project: files covering substantially the same topic.
- Across projects: ancestor memories superseded by more specific child-project ones.
- Memory vs CLAUDE.md: memories that merely restate CLAUDE.md content add bloat without value.

### 3c. Clustering
- Many small files on related topics that could merge into one coherent file (e.g., 5 `feedback_css_*.md` → one `feedback_css_patterns.md`).
- Only cluster when the files genuinely cover the same domain.

### 3d. Transcript search (targeted only)
- If you suspect a topic should have a memory but doesn't, grep narrowly: `grep -rn "<term>" <transcripts-dir>/ --include="*.jsonl" | tail -50`.
- Don't exhaustively read transcripts. Skip those older than the last run.

## Step 4 — Consolidate

**Merging:** combine into the most comprehensive file and delete the others. Preserve unique info from both. Update the index.

**Pruning:** delete memories that are demonstrably wrong (referenced files don't exist, facts contradict the codebase) or duplicate CLAUDE.md content. For ancestor memories superseded by child-project ones, update or annotate — don't delete cross-project memories without clear justification.

**Updating:** convert relative dates to absolute, fix factual errors verifiable from the codebase, update file paths after verifying new locations.

**Creating:** if orient + gather revealed important patterns with no memory file, create one in the existing format conventions.

**Format rules:** follow the system prompt's auto-memory section for what to save, how to structure files, what NOT to save. Match the project's existing frontmatter and naming conventions.

## Step 5 — Update the index

For each modified memory directory:

1. Reflect all changes (new files, deletions, updated descriptions).
2. Keep entries to one line each, under ~150 characters.
3. Remove pointers to deleted/merged files; add pointers to new ones.
4. Resolve contradictions between index descriptions and actual contents.
5. Keep the index concise — under 200 lines if no project limit is set.

## Step 6 — Write state and report

Update `.dream-state.json` in the current project's memory directory:

```json
{
  "last_run": "<ISO 8601 timestamp>",
  "runs": [
    {
      "date": "<ISO 8601 timestamp>",
      "mode": "auto|plan",
      "scope": "current+ancestors|all",
      "merged": <count>,
      "pruned": <count>,
      "created": <count>,
      "updated": <count>,
      "summary": "<one-line description of what changed>"
    }
  ]
}
```

Append the new run to `runs` (keep last 20, trim older). Update `last_run`.

**Report:**
- Auto mode: brief summary (e.g., "Merged 2 CSS feedback files, pruned 1 stale reference, updated 3 file paths. Memory directory: 35 → 33 files.").
- Plan mode: the numbered list was already presented in Step 4 — after approval and apply, confirm what was done.
- If nothing changed: say so. Clean memories don't need busywork.

## Flags

- `--plan` — force plan mode regardless of run history
- `--all` — scan all project memory directories under `~/.claude/projects/`
