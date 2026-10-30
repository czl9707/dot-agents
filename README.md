# dot-agents

Claude Code global config and cross-agent skills, shared across machines.

## Layout

```
AGENTS.md        agent entry doc for this repo
rules/           global instructions, loaded from ~/.claude/rules/
skills/caveman    symlink into vendor/ submodules
skills/quality-review/  own skill
skills/<name>    symlinks into vendor/ submodules
vendor/mattpocock-skills   github.com/mattpocock/skills
vendor/blader-humanizer    github.com/blader/humanizer
vendor/juliusbrussee-caveman   github.com/JuliusBrussee/caveman (shallow clone; the skill lives at skills/caveman inside the repo)
install.sh       links everything into ~/.claude and ~/.agents
```

`install.sh` links `rules/` into `~/.claude`, and every skill into both `~/.claude/skills` (Claude Code) and `~/.agents/skills` (opencode, gemini, skills CLI). The `hooks/` dir in ~/.claude is not managed here: `herdr-agent-state.sh` is installed and updated by herdr itself.

After cutover, the skills CLI's copies under `~/.agents/skills` are replaced by symlinks into this repo — reinstalling skills through the skills CLI would fight the links, so treat this repo as the source of truth.

## Setup on a new machine

```
git clone https://github.com/czl9707/dot-agents.git
cd dot-agents
./install.sh
```

## Update third-party skills

```
git submodule update --remote vendor/mattpocock-skills
git submodule update --remote vendor/blader-humanizer
git submodule update --remote vendor/juliusbrussee-caveman
git add vendor && git commit -m "update skill submodules"
```
