# claude-config

Claude Code global config, shared across machines: global rules, personal skills, and third-party skills as git submodules.

## Layout

```
CLAUDE.md        global instructions (symlinked to ~/.claude/CLAUDE.md)
rules/           rules loaded from ~/.claude/rules/
skills/caveman/  own skill (removed upstream from mattpocock/skills; this copy keeps a trigger-phrase tweak)
skills/<name>    symlinks into vendor/ submodules
vendor/mattpocock-skills   github.com/mattpocock/skills
vendor/blader-humanizer    github.com/blader/humanizer
install.sh       links everything into ~/.claude
```

The `hooks/` dir in ~/.claude is not managed here: `herdr-agent-state.sh` is installed and updated by herdr itself.

## Setup on a new machine

```
git clone https://github.com/czl9707/claude-config.git
cd claude-config
./install.sh
```

## Update third-party skills

```
git submodule update --remote vendor/mattpocock-skills
git submodule update --remote vendor/blader-humanizer
git add vendor && git commit -m "update skill submodules"
```
