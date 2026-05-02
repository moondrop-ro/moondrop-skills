# moondrop-skills

Shared skill library for Claude Code. Skills install to `~/.claude/skills/` (global) or `<project>/.claude/skills/` (per-project) and are invoked as slash commands.

**Repo**: `https://github.com/moondrop-ro/moondrop-skills`
**Owner**: moondrop-ro

## Architecture

```
moondrop-skills/
├── VERSION              # Semver, single line (e.g. "0.4.0")
├── CHANGELOG.md         # Release notes, one ## heading per version
├── install.sh           # Copies skills/ to target dir (cp -r handles subfolders)
├── README.md            # Public-facing docs with skill descriptions
└── skills/
    ├── wrap-up/
    │   ├── SKILL.md
    │   └── references/  # On-demand reference docs (templates, format guides)
    └── memory-dream/
        └── SKILL.md
```

## Skill file format

Every skill is a folder inside `skills/` containing a `SKILL.md`. The folder name becomes the slash command. Skills are loaded into Claude's context whenever they trigger, so SKILL.md should be optimized for *agent ingestion*, not human browsing.

```markdown
---
name: my-skill
version: 0.1.0
description: >
  Pushy, keyword-loaded description with multiple trigger phrases. This is
  the only thing always in context — it's the trigger. Use when the user
  says X, Y, Z, or otherwise signals A. Front-load synonyms.
---

# /my-skill

> **Display Name** — Short tagline.

```
/my-skill
```

---

[Agent instructions for the AI follow after the --- separator]
```

### Required sections

1. **YAML frontmatter** — `name`, `version`, `description` (all required). Description should be keyword-loaded ("pushy") with multiple trigger phrases. See Anthropic's `pdf` and `internal-comms` skills as exemplars — all "when to use" guidance lives in the description, not in the body. (Note: Anthropic's official skills omit `version:` — the harness doesn't use it. moondrop-skills keeps the field as a deliberate divergence so users have visibility into what's installed via the VERSION file ↔ frontmatter pairing. Keep them in sync; the version is for humans, not the harness.)
2. **Description homepage** — short tagline + usage example, separated from instructions by `---`. Optional: feature table for human readers browsing the repo. Keep this section minimal — the agent reads everything above and below `---`, so excess prose is token waste.
3. **Skill instructions** — the actual steps the AI agent follows. Target <500 lines. If a skill grows past that, extract heavy templates and reference docs to a `references/` subfolder beside SKILL.md and link to them. Always-loaded SKILL.md content should be the orchestration; details load on demand.

### Folder structure for larger skills

```
skills/<name>/
├── SKILL.md              # always-loaded; orchestration + critical examples
├── references/           # loaded on demand via cross-reference
│   ├── *.md              # templates, format guides, long-form rules
│   └── ...
├── scripts/              # executables called as black-box (don't read source)
└── assets/               # output templates, fixtures
```

`install.sh` already handles subfolders via `cp -r`, so no install changes are needed when introducing `references/`. Use this pattern instead of inlining 30+ line markdown templates.

### install.sh behavior

- Copies each `skills/<name>/` folder (including subfolders) to the target skills directory
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
2. Follow the skill file format above (frontmatter, minimal homepage, instructions)
3. Extract templates >30 lines to `references/`
4. Add the skill to `README.md`
5. Test with `bash install.sh` then invoke the slash command

## Rules for AI agents working on this repo

- **Never commit or push automatically** — wait for explicit instruction
- **Frontmatter version must match VERSION file** — they drift easily, keep them in sync
- **CHANGELOG entries are user-facing** — write them for the person using the skill, not the developer
- **Optimize SKILL.md for the model** — agents read instructions serially. Avoid prose redundancy, repeated framings, and inline templates. Extract anything heavy to `references/`.
- **Verify against Anthropic's skill-creator** — `github.com/anthropics/skills/tree/main/skills/skill-creator` is the canonical reference. Pull it before authoring or auditing skills.
