# AGENTS.md

This repository holds the user's global agent config, shared across machines.

- Global instructions live in `rules/*.md` — read the ones relevant to the task at hand.
- Skills are mounted by each harness from `skills/<name>`; `skills/caveman` and `skills/quality-review` are plain directories, everything else is a symlink into `vendor/` submodules.
- `install.sh` links these into `~/.claude` and `~/.agents`. Do not edit skills through the symlink targets in `~/.claude` or `~/.agents` — edit this repo and push.
