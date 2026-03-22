# Claude Code Skills

Shared skill library for Claude Code. Install once, use via slash commands in any session.

## Install

```bash
git clone <repo-url>
cd claude-skills
bash install.sh
```

## Skills

| Command | Description |
|---------|-------------|
| `/wrap-up` | End-of-session checklist — git status, service deployments, memory review, CLAUDE.md updates, checklist progress, backlog capture, session summary |

## Adding Skills

Each skill is a folder inside `skills/` containing a `SKILL.md` file:

```
skills/
└── my-skill/
    └── SKILL.md
```

Run `bash install.sh` again after adding new skills.
