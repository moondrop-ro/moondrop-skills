# Handoff prompt — template + section rules

The next session needs a self-contained kickoff: read order, open work units, pending decisions, held items, verification gaps, and just-learned workflow lessons. Lead with topic + state-at-handoff, then sections in dependency order.

## Template

```markdown
# <Topic> — pick up from <YYYY-MM-DD HH:MM> wrap-up

## State at hand-off

<2–3 sentences: what's signed off, what's mid-flight, what's pushed vs uncommitted.>

## Read order (before any action)

1. `path/to/file` — why this matters
2. `path/to/file` — why this matters
...

## Open work units

| Lane / unit | Branch | Path / location | What's in it | Status |
|---|---|---|---|---|
| ... | ... | ... | ... | uncommitted / pushed / merged |

(Drop columns that don't apply.)

## Pending decisions (in order of dependency)

1. **<Decision name>.** <One paragraph: what's at stake, the options, what depends on it.>
2. ...

## Held items (NOT backlog — surfaced for next-wave decision)

- <Item> — <why it's held, not deferred. Estimate to fix if applicable.>

## Verification gaps

- <Gap> — <blocker that prevented verification + the fix to unblock>

## Workflow expectations (lessons from this session)

- <Lesson learned this session that next-session should carry forward. Only the new ones — durable preferences belong in memory, not here.>

## Suggested first action

<One paragraph. Concrete first command, decision, or dispatch — not a phase plan.>
```

## Section rules

- **State at hand-off** — 2–3 sentences. No fluff. Signed off / mid-flight / pushed vs uncommitted.
- **Read order** — paths with one-line "why" each. No multi-paragraph entries. Cap at ~6.
- **Open work units** — table form. Drop columns that don't apply (e.g., no "Path" column without worktrees). Generic for worktrees, in-flight PRs, dirty branches.
- **Pending decisions** — numbered, ordered by dependency (decision 2 depends on decision 1's outcome). Highest-value section; spend the most words here.
- **Held items** — explicitly tagged `(NOT backlog — surfaced for next-wave decision)` to short-circuit the "why isn't this in BACKLOG.md" question. These are decisions held mid-stream, not deferred work.
- **Verification gaps** — pair the *blocker* with the *fix*. "Untested" alone is not enough; "untested — needs `.env.local` first via `vercel env pull`" is.
- **Workflow expectations** — only lessons that surfaced *this session*. Skip the section entirely if nothing new. Durable preferences (always-true rules) belong in memory or CLAUDE.md, not here.
- **Suggested first action** — single paragraph, concrete first command or decision. Not a phase plan. Next session reads this and knows what to do in their first 5 minutes.

## Skip everything discoverable

- Don't include "current branch is X" — `git status` shows that.
- Don't include file inventories — the Open work units table covers it.
- Don't re-quote CLAUDE.md rules — link line numbers.
- Don't restate decisions already captured in `docs/decisions/...` — link them.

## Skip empty sections

Empty sections are noise. Skip any section that has nothing to put in it.
