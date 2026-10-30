# Git Workflow

- Always start from `main` branch at the beginning of a session and pull from remote
- If repo has only one remote `origin`, use that. Otherwise, `origin` is likely a fork - use `git remote -v` to identify upstream
- Always create a feature branch before committing: `git checkout -b <branch-name>`
