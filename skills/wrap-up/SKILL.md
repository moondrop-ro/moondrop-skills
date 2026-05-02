---
name: wrap-up
version: 0.4.0
description: >
  End-of-session checklist. Commits and pushes uncommitted work, checks
  service deployments (Vercel, Sanity, Supabase), surfaces working-style
  observations for memory approval, persists project memory and CLAUDE.md
  updates, captures deferred work to BACKLOG.md, writes a client-readable
  decision log, and generates a next-session handoff prompt for multi-session
  work. Use whenever the user signals end of session — "wrap up", "wrap it
  up", "end of session", "before I close", "I'm done for today", "commit and
  push and call it", "log off", "shut down", or otherwise winds down. Also
  use proactively when the user says they're stopping after substantive work.
---

# /wrap-up

> **Session Wrap-Up** — Never leave a session with loose ends.

> _Source: [moondrop-skills](https://github.com/moondrop-ro/moondrop-skills) — distinct from any gstack-shipped skill of the same name; do not overwrite during third-party skill-pack reinstalls._

```
/wrap-up
```

---

End-of-session hygiene in one command. Run every phase, then present the report → interactive selectors → summary.

**`AskUserQuestion` pattern (used in phases 3 and 7):** call once with `multiSelect: true`, each candidate as a separate option. Each option has a `label` (5–10 word title) and a `description` (the format described in the phase). Skip the question entirely when there are no candidates.

## 1. Git

Run `git status` and `git log @{upstream}..HEAD --oneline 2>/dev/null`. Report branch, uncommitted changes, unpushed commits.

If uncommitted changes exist, ask via `AskUserQuestion`: "Commit & push" / "Commit only" / "Skip — I'll handle it". On commit, write a descriptive message summarizing the session's work.

## 2. Services

After pushing, check:

- **Vercel** — push triggers auto-deploy. If `vercel` CLI is available, run `vercel ls --limit 1`.
- **Sanity** — if schema files were modified, remind to run `npx sanity@latest schema deploy` (or offer to run it).
- **Supabase** — if migration SQL was created or modified, remind to apply.
- **Other** — note env-var or config updates needed for any other service touched this session.

Report status per service or "no changes."

## 3. What I Learned About You

The most important phase. The user should see themselves reflected back and approve what gets remembered.

Review the conversation for **insights**, not action replays. The test: would this change how I work with this person in future sessions?

**Bad** (action replay): "You picked up 3 backlog items and asked me to fix them all"
**Good** (personality insight): "You have zero tolerance for deferred cleanup — when you see tech debt, you want it gone now, not next session"

Look for: working-style shifts, new preferences or corrections, values revealed through decisions, growth or learning.

Use the `AskUserQuestion` pattern. Each insight is one option:
- **label** — concise insight (5–10 words)
- **description** — behavioral impact in this format: `**Without this:** [current behavior]. **With this:** [improved behavior].` The user should be able to read just the description and understand why this memory is worth keeping.

If nothing new this session, skip the question and report "Nothing new to report about your working style."

Save only selected insights. Never save before approval.

## 4. Project & Feedback Memory

Review the conversation for memory candidates beyond user observations:

- **project** — ongoing work, goals, deadlines, decisions not in code/git
- **reference** — external resources, dashboards, tracking systems
- **feedback** — corrections that should apply to future sessions

**Routing:** `user` and `feedback` → global (`~/.claude/memory/`). `project` and `reference` → project-scoped (`~/.claude/projects/<project>/memory/`). If unsure, ask "does this apply to just this project, or everywhere?"

For each candidate: check the relevant `MEMORY.md` index, create or update the memory file in the correct location, update its index. These save automatically (about the project, not the person). Report what was saved or "no new memories."

## 5. CLAUDE.md

Add to project or global CLAUDE.md only if **all** are true:

1. Behavioral rule, gotcha, or non-obvious convention — not a file/component description
2. Removing it would cause future sessions to make mistakes
3. Can't be derived from code, configs, or existing docs
4. Not already in DESIGN.md, docs/, or memory files

Never add: component inventories, file-path catalogs, counts that change, content from @-imported files, standard framework behavior the model already knows.

If project CLAUDE.md exceeds ~120 lines, cut something before adding. Bloat causes the model to ignore instructions.

Update automatically if changes pass the filter. Report what changed or "no updates."

## 6. Checklist Progress

If a plan or checklist was advanced (e.g. `docs/plans/*-checklist.md`), tick completed items. Report what was checked off or "no active checklists."

## 7. Backlog

Review for deferred work, rolled-back features, bugs noticed in passing, ideas discussed but not acted on, TODOs mentioned but not completed. Skip items already in `BACKLOG.md`.

Use the `AskUserQuestion` pattern. Each candidate is one option:
- **label** — short title (5–10 words)
- **description** — what needs to be done and why

Append selected items to `BACKLOG.md` at the project root with `- [ ]` checkbox format, grouped under appropriate category headings.

## 8. Client Decision Log

Skip if the session was pure implementation with no decisions, or only internal cleanup with no client-visible impact.

Write when design choices were made, scope was changed, technical tradeoffs affecting the product were discussed, features were cut or reprioritized, or strategy changed from previously planned.

Format and capture rules: see `references/decision-log.md`. Output to `docs/decisions/YYYY-MM-DD-<topic>.md`.

Tell the user: "Found N decisions from this session. Writing the log to `docs/decisions/...`. Want to review before I save?"

## 9. Next-Session Handoff Prompt

Trigger gate — generate only if at least one is true:

- `git worktree list` shows >1 worktree (parallel uncommitted work)
- An active plan in `docs/plans/*.md` has unchecked items remaining (phased multi-session work needs the kickoff regardless of whether this session ticked boxes)
- The session ended on an explicit pending decision ("stop here, regroup", "checkpoint before next wave")
- Held items or verification gaps were raised but not landed

If none are true, skip silently. The session summary covers small wraps.

Path: `docs/handoffs/YYYY-MM-DD-HHMM-<topic>.md` using local 24h time of the wrap-up (e.g. `2026-05-02-1430-feature-flag-cleanup.md`). Use the same `<topic>` slug as the related plan or decision doc when one exists.

Structure, template, and section rules: see `references/handoff-template.md`.

Tell the user: "Multi-session work in flight. Writing handoff to `docs/handoffs/...` so next session can pick up cleanly." Report the path. Do not dump contents in the terminal — the whole point is to avoid that.

## 10. Session Summary

- **Done** — 2–3 bullets of main work completed
- **Next** — logical follow-ups or items the user mentioned wanting next
- **Open** — anything started but not finished, or blocked

## Output Format

Order:

1. **Report** (text) — Git, Services, CLAUDE.md, Checklists, Project Memory, Decision Log, Handoff (if generated)
2. **Interactive selectors** — combine "What I Learned" + "Backlog" into a single `AskUserQuestion` call with two `multiSelect: true` questions. Skip either question with no candidates.
3. **Process selections** — save approved memories, append approved backlog items
4. **Summary** (text) — Done / Next / Open

```
## Wrap-Up Report

### Git
- Branch: ...
- Uncommitted: ... (or clean)
- Pushed: ... (or in sync)

### Services
- Vercel / Sanity / Supabase / other: status per service

### CLAUDE.md / Checklists / Project Memory / Decision Log / Handoff
- per-line status: updated / saved to <path> / no changes

[AskUserQuestion: Q1 header "Remember" + Q2 header "Backlog" — skip either with no candidates]

### Summary
- Done: ...
- Next: ...
- Open: ...
```

After presenting, ask "Anything else before closing?" and wait for confirmation before considering the session complete.
