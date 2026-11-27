# Skills

Agent skills I use day to day, packaged to install in Claude Code, Codex, Copilot, Cursor and other agents.

## 📦 Install

Pick one route per agent. Installing twice gives you every skill twice.

**Claude Code**

```bash
claude plugin marketplace add adambutler/skills
claude plugin install adambutler-skills@adambutler
```

**Codex**

```bash
codex plugin marketplace add adambutler/skills
codex plugin add adambutler-skills@adambutler
```

**GitHub Copilot CLI**

```bash
copilot plugin marketplace add adambutler/skills
copilot plugin install adambutler-skills@adambutler
```

**Gemini CLI**

```bash
gemini skills install https://github.com/adambutler/skills.git --path skills
```

**Anything else (Cursor, OpenCode, Windsurf, Amp...)** - via [skills.sh](https://skills.sh)

```bash
npx skills@latest add adambutler/skills            # all skills
npx skills@latest add adambutler/skills --skill=tldr  # one skill
npx skills@latest update                           # update
```

## 🧰 Skills

| Skill | What it does |
| --- | --- |
| [`tldr`](skills/tldr/SKILL.md) | Re-explains the last answer as a one-line summary plus a few plain-language bullets. |

## 🛠️ Adding a skill

1. Create `skills/<name>/SKILL.md` with `name` and `description` frontmatter.
2. Add a row to the table above.
3. Bump `version` in `.claude-plugin/plugin.json` - plugin installs only update when it changes.

To use skills from this repo locally while editing, run `scripts/link-skills.sh`. It symlinks each skill into `~/.claude/skills` and `~/.agents/skills`.
