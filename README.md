# moondrop-skills

Shared skill library for [Claude Code](https://claude.ai/claude-code). Install globally or per project, then use via slash commands.

Pull and reinstall manually when you want the latest — `git pull && bash install.sh`.

---

## `/wrap-up` — Session Wrap-Up

> Never leave a session with loose ends.

Everything that should happen before you close a session, automated into one command. Commits work, checks deploys, surfaces what it learned about you, captures deferred work, writes a client decision log, generates a next-session handoff prompt for multi-session work, and presents a scannable summary.

| Step | Action |
|------|--------|
| Git | Commits uncommitted work, pushes to remote |
| Services | Checks Vercel, Sanity, Supabase deploy status |
| About you | Surfaces observations about your working style — you approve what gets remembered |
| Memory | Saves project context, feedback, and references |
| CLAUDE.md | Updates project instructions if the session revealed new patterns |
| Checklists | Marks completed items in active plans |
| Backlog | Captures deferred work, TODOs, and ideas you didn't act on |
| Decisions | Logs product/design/technical decisions in a client-readable format |
| Handoff | Writes a self-contained kickoff prompt for the next session (multi-session work only) |
| Summary | What was done, what's next, what's open |

```
/wrap-up
```

---

## `/memory-dream` — Memory Consolidation

> Defragment your AI's memory.

Over time, Claude Code accumulates memory files — observations about you, your projects, your preferences. Some go stale. Some overlap. Some contradict each other. `/memory-dream` tidies everything up so future sessions orient quickly and accurately.

| Action | Description |
|--------|-------------|
| Merge | Combines near-duplicate memory files covering the same topic |
| Prune | Removes stale memories (referenced files moved/deleted, facts outdated) |
| Cluster | Groups scattered small files into coherent topic files |
| Cross-reference | Checks memories against CLAUDE.md — removes redundant entries |
| Verify | Greps the codebase to confirm memories still reflect reality |

```
/memory-dream              # Current project, auto mode
/memory-dream --plan       # Show proposed changes before applying
/memory-dream --all        # All projects
```

---

## Install

### Global (all projects)

Skills go to `~/.claude/skills/` and are available in every Claude Code session.

```bash
git clone https://github.com/moondrop-ro/moondrop-skills.git
cd moondrop-skills
bash install.sh
```

### Per project

Skills go to `<project>/.claude/skills/` and are only available in that project.

```bash
git clone https://github.com/moondrop-ro/moondrop-skills.git
cd moondrop-skills
bash install.sh --project /path/to/your/project
```

### Manual install

Copy any skill folder into your skills directory:

```bash
cp -r skills/wrap-up ~/.claude/skills/       # Global
cp -r skills/wrap-up .claude/skills/          # Per project
```

## Updating

There is no automated update prompt. Pull and reinstall when you want the latest:

```bash
cd moondrop-skills && git pull && bash install.sh
```

## Adding Skills

Each skill is a folder inside `skills/` containing a `SKILL.md` file. Larger skills can include a `references/` subfolder for on-demand templates and format guides.

```
skills/
└── my-skill/
    ├── SKILL.md
    └── references/    # optional, loaded on demand
        └── *.md
```

The folder name becomes the slash command (`/my-skill`). Run `bash install.sh` after adding new skills. See `CLAUDE.md` for the full skill file format and authoring conventions.
