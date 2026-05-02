# Changelog

## 0.5.0

- `/memory-dream` — same compaction pass as 0.4.0 brought to /wrap-up. SKILL.md trimmed from 184 to ~135 lines by removing the "What it does" feature table, the "Modes" preamble, and prose redundancy across steps. Description rewritten with trigger phrases ("memory dream", "tidy my memory", "clean up memory", "consolidate memories", "memory maintenance", "defragment memory", "prune stale memories", "merge duplicate memories") for more reliable activation. Added the moondrop source-identity callout. No behavioral changes — every step, mode rule, and format rule is preserved.
- `README.md` — removed stale auto-update copy. The tagline and "Updating" section described the `~/.moondrop-skills/` state machine that was removed in 0.3.0; both now reflect the manual `git pull && bash install.sh` flow. /wrap-up feature table updated to include Handoff (added in 0.2.0) and Checklists. Added a brief note about the optional `references/` subfolder pattern.
- `CLAUDE.md` — documented the deliberate `version:` frontmatter divergence from Anthropic's spec (the field is for humans tracking what's installed, not for the harness).

## 0.4.0

- `/wrap-up` — restructured for how Claude ingests skills. SKILL.md compacted from 332 → ~150 lines by removing prose redundancy, deduplicating the `AskUserQuestion` preamble, and extracting heavy templates to `references/`. The handoff prompt template moved to `references/handoff-template.md`; client decision log format moved to `references/decision-log.md`. Description rewritten with more trigger phrases ("wrap up", "end of session", "log off", "before I close", etc.) for more reliable activation. Phase 8.5 renumbered to 9; summary is now phase 10. No behavioral changes — every gate, routing rule, and skip-if condition is preserved. Re-run `bash install.sh` to pick up the new `references/` files.

## 0.3.1

- `/wrap-up` — handoff filenames and headings now include hour and minute. Format is `docs/handoffs/YYYY-MM-DD-HHMM-<topic>.md` (e.g. `2026-05-02-1430-feature-flag-cleanup.md`); H1 reads `pick up from YYYY-MM-DD HH:MM wrap-up`. Avoids collisions when more than one wrap-up runs the same day.
- `/wrap-up` — handoff trigger now fires whenever an active plan in `docs/plans/*.md` has unchecked items, not only when the current session worked on them. Phased multi-session tasks reliably get a kickoff prompt for the next session.

## 0.3.0

- Removed the version-check preamble from all skills. Skills no longer prompt to upgrade on invocation; pull and run `bash install.sh` manually when you want the latest. Removes the `~/.moondrop-skills/` state machine and per-skill `VERSION` copies from `install.sh`.

## 0.2.0

- `/wrap-up` — added §8.5 next-session handoff prompt. Writes a self-contained kickoff doc to `docs/handoffs/YYYY-MM-DD-<topic>.md` for multi-session work (gated on uncommitted worktrees, active plans, pending decisions, or held items). Replaces ad-hoc terminal-dumped prompts with a markdown file the next session can `@`-reference.

## 0.1.0

- Initial release
- `/wrap-up` — end-of-session checklist with commit, deploy checks, memory review, backlog capture
- `/catch-up` — load context about recent changes across projects with configurable adapters
- `/memory-dream` — memory consolidation: merge duplicates, prune stale entries, cluster feedback
- `/upgrade` — self-update skill with version checking and changelog display
