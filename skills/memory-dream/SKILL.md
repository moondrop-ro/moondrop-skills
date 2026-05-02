---
name: memory-dream
version: 0.3.0
description: >
  Universal memory consolidation — discovers and tidies Claude Code memory files
  across project hierarchies. Merges near-duplicates, prunes stale entries,
  clusters related feedback, cross-references CLAUDE.md, and maintains a
  changelog. Auto mode by default (plan-and-wait on first run).
---

# /memory-dream

> **Memory Dream** — Defragment your AI's memory.

Over time, Claude Code accumulates memory files — observations about you, your projects, your preferences. Some go stale. Some overlap. Some contradict each other. `/memory-dream` is a reflective pass that tidies everything up so future sessions orient quickly and accurately.

### What it does

| Action | Description |
|--------|-------------|
| Merge | Combines near-duplicate memory files covering the same topic |
| Prune | Removes stale memories (referenced files moved/deleted, facts outdated) |
| Cluster | Groups scattered small files into coherent topic files |
| Cross-reference | Checks memories against CLAUDE.md — removes redundant entries |
| Verify | Greps the codebase to confirm memories still reflect reality |
| Transcript scan | Searches session logs for important patterns with no memory file |

### Usage

```
/memory-dream              # Current project + ancestors, auto mode
/memory-dream --plan       # Show proposed changes before applying
/memory-dream --all        # All projects under ~/.claude/projects/
```

### Modes

- **Auto** (default after first run) — makes changes directly, reports a summary
- **Plan** (first run, or `--plan`) — presents every proposed change as a numbered list, waits for approval

---

# Memory Dream: Universal Memory Consolidation

You are performing a memory dream — a reflective pass over Claude Code memory files. Your job is to synthesize, merge, prune, and organize memories so future sessions orient quickly and accurately.

This skill is project-agnostic. You discover the environment, adapt to whatever memory format is in use, and leave things cleaner than you found them.

---

## Step 0 — Discover the environment

Claude Code stores per-project memory in `~/.claude/projects/<project-key>/memory/`. The project key is the working directory path with path separators replaced by `--` (e.g., `D:\projects\foo` becomes `D--projects-foo`).

1. **Identify the current project key** from the working directory
2. **Find the current project's memory directory** — `~/.claude/projects/<project-key>/memory/`
3. **Find ancestor memory directories** — walk up the directory hierarchy. For working directory `D:\projects\foo\bar`, ancestors are `D--projects-foo` and `D--projects`. Check which of these have a `memory/` subdirectory.
4. **If `--all` flag was passed**, instead scan every directory under `~/.claude/projects/` that contains a `memory/` subdirectory.
5. **Locate CLAUDE.md files** — read the global `~/.claude/CLAUDE.md` and the project-level `CLAUDE.md` in the working directory (if they exist). These are read-only references for deduplication — never modify them.
6. **Locate session transcripts** — JSONL files in `~/.claude/projects/<project-key>/` (not inside `memory/`). These are large — grep narrowly, never read whole files.
7. **Read `.dream-state.json`** in the current project's memory directory (if it exists) to check run history and determine mode.

## Step 1 — Determine mode

**Plan mode** (present changes, wait for approval):
- First run on this project (no `.dream-state.json` exists)
- User passed `--plan` flag
- In plan mode, present every proposed change as a numbered list and wait for the user to approve before writing anything

**Auto mode** (execute changes, write changelog):
- `.dream-state.json` exists (not first run) AND no `--plan` flag
- Make changes directly, then report a summary at the end

## Step 2 — Orient

For each memory directory in scope (current project first, then ancestors):

1. `ls` the memory directory to see what exists
2. Read the index file (usually `MEMORY.md`) to understand the current structure
3. Skim existing topic files — read frontmatter and first few lines to understand what each file covers, so you improve rather than duplicate
4. Note the memory format in use (frontmatter fields, type conventions, naming patterns) — adapt to whatever format you find rather than imposing a different one
5. If `logs/` or `sessions/` subdirectories exist, review recent entries there

Build a mental map of: what topics are covered, which files overlap, what format conventions are used, and when files were last modified.

## Step 3 — Gather signal

Look for issues worth addressing. Check in this order:

### 3a. Staleness detection
- Compare memory file modification dates against `.dream-state.json` last run date — files not updated since several runs ago may be stale
- For memories that reference specific file paths, function names, or architectural patterns: grep the codebase to verify they still exist. If a memory says "the auth middleware is in `src/middleware/auth.ts`" and that file doesn't exist, the memory is stale.
- Check if project-level memories contradict what's documented in CLAUDE.md — CLAUDE.md is the source of truth for current project state

### 3b. Duplication detection
- **Within a project**: find memory files that cover substantially the same topic (e.g., two files about CSS migration feedback)
- **Across projects**: check if ancestor memory directories contain memories that are superseded by more specific ones in the current project (e.g., parent has a general "project overview" that's now outdated because the child project has evolved)
- **Memory vs CLAUDE.md**: identify memories that merely restate what CLAUDE.md already documents — these add context window bloat without value

### 3c. Clustering opportunities
- Look for many small files on related topics that could be merged into one coherent file (e.g., 5 separate `feedback_css_*.md` files that could become one `feedback_css_patterns.md`)
- Only cluster when the files genuinely cover the same domain — don't force unrelated memories together just to reduce file count

### 3d. Transcript search (targeted only)
- If you suspect a topic should have a memory but doesn't, grep the JSONL transcripts for narrow terms: `grep -rn "<narrow term>" <transcripts-dir>/ --include="*.jsonl" | tail -50`
- Don't exhaustively read transcripts. Look only for things you already suspect matter.
- Skip transcripts older than the last consolidation run (check `.dream-state.json` timestamp)

## Step 4 — Consolidate

For each issue found in Step 3, take action:

### Merging
- When two or more files cover the same topic, merge them into the most comprehensive one and delete the others
- Preserve all unique information from both files — merging means combining, not choosing one over the other
- Update the index file to remove pointers to deleted files

### Pruning
- Delete memories that are demonstrably wrong (referenced files don't exist, facts contradict current codebase)
- Delete memories that duplicate CLAUDE.md content without adding anything beyond what CLAUDE.md says
- For ancestor project memories that are superseded: either update them or add a note that the child project has more current information — don't delete cross-project memories without clear justification

### Updating
- Convert any relative dates ("yesterday", "last week") to absolute dates
- Fix factual errors where you can verify the correct state from the codebase
- Update memories whose referenced files have moved (verify new location before updating)

### Creating
- If the orient + gather phase revealed important patterns with no memory file (e.g., a recurring correction the user makes that isn't captured), create a new memory file
- Follow the existing format conventions you observed in Step 2

### Format rules
- Follow the memory file format and type conventions from the system prompt's auto-memory section — that is the source of truth for what to save, how to structure files, and what NOT to save
- Adapt to whatever frontmatter format the project already uses rather than imposing a new one
- Keep the same naming conventions you observe in existing files

## Step 5 — Prune and update the index

For each memory directory that was modified:

1. Update the index file to reflect all changes (new files, deleted files, updated descriptions)
2. Keep the index concise — one line per entry, under ~150 characters each
3. Remove pointers to memories that were deleted or merged
4. Add pointers to newly created memories
5. Resolve any contradictions between the index descriptions and actual file contents
6. Keep the index under the line limit established by the project (check if the system prompt specifies one; if not, aim for under 200 lines)

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

- Append the new run to the `runs` array (keep last 20 runs, trim older ones)
- Update `last_run` to the current timestamp

**Report to the user:**
- In auto mode: brief summary of what changed (e.g., "Merged 2 CSS feedback files, pruned 1 stale reference, updated 3 file paths. Memory directory: 35 → 33 files.")
- In plan mode: the numbered list of proposed changes was already presented in Step 4 — after the user approves and changes are applied, confirm what was done.
- If nothing changed: say so. Clean memories don't need busywork.

---

## Flags

- **`--plan`** — force plan mode (present changes, wait for approval) regardless of run history
- **`--all`** — scan all project memory directories under `~/.claude/projects/`, not just current + ancestors
