# moondrop-skills

Shared skill library for Claude Code. Skills install to `~/.claude/skills/` (global) or `<project>/.claude/skills/` (per-project) and are invoked as slash commands.

**Repo**: `https://github.com/moondrop-ro/moondrop-skills`
**Owner**: moondrop-ro

## Architecture

```
moondrop-skills/
├── VERSION              # Semver, single line (e.g. "0.1.0")
├── CHANGELOG.md         # Release notes, one ## heading per version
├── install.sh           # Copies skills/ to target dir
├── README.md            # Public-facing docs with skill descriptions
└── skills/
    ├── wrap-up/         # /wrap-up — end-of-session checklist
    │   └── SKILL.md
    └── memory-dream/    # /memory-dream — memory consolidation
        └── SKILL.md
```

## Skill file format

Every skill is a folder inside `skills/` containing a `SKILL.md`. The folder name becomes the slash command.

```markdown
---
name: my-skill
version: 0.1.0
description: >
  One-paragraph description. This is what Claude Code shows in the skill list
  and what determines when the skill triggers.
---

# /my-skill

> **Display Name** — Short tagline.

Description paragraph for humans reading the file.

### What it does
| Step | Action |
|------|--------|
| ... | ... |

### Usage
...

---

[Actual skill instructions for the AI agent follow after the --- separator]
```

### Required sections

1. **YAML frontmatter** — `name`, `version`, `description` (all required)
2. **Description homepage** — human-readable overview with tagline, feature table, usage examples. Separated from instructions by `---`
3. **Skill instructions** — the actual steps the AI agent follows

### install.sh behavior

- Copies each `skills/<name>/` folder to the target skills directory
- Target: `~/.claude/skills/` (default) or `<project>/.claude/skills/` (with `--project`)

## Releasing a new version

1. Make your changes to skill files
2. Update `CHANGELOG.md` — add a new `## X.Y.Z` section at the top with user-facing changes
3. Update `VERSION` to the new version number
4. Update `version:` in each skill's YAML frontmatter to match
5. Run `bash install.sh` to refresh your local install
6. Commit and push to `main`

There is no automated update prompt — pull and reinstall manually when you want the latest.

## Contributing a new skill

1. Create `skills/<skill-name>/SKILL.md`
2. Follow the skill file format above (frontmatter, description homepage, instructions)
3. Add the skill to `README.md`
4. Test with `bash install.sh` then invoke the slash command

## Rules for AI agents working on this repo

- **Never commit or push automatically** — wait for explicit instruction
- **Frontmatter version must match VERSION file** — they drift easily, keep them in sync
- **CHANGELOG entries are user-facing** — write them for the person using the skill, not the developer
- **Description homepages matter** — they're the first thing a user sees. Keep them concise, specific, and scannable with tables
