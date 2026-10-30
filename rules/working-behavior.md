# Working Behavior

Unless explicitly asked:

- No try-except around imports. If a library is needed, import it directly.
- Do not enter plan mode on your own.
- Never roll back code with git. Any "rollback" mentioned in conversation means: manually restore the code to its previous state using file editing tools.
- Do not read from or write to `/tmp`. Put intermediate results in a dedicated gitignored directory inside the project.
- Do not use vision features (reading screenshots or images); low accuracy leads to wrong decisions.

Always:

- Read a linked page's full content before acting on it. If a library's usage looks wrong, re-read the linked page before changing anything.
- Do not minimize dependencies, and do not bypass dependencies with hacks or hand-rolled replacements.
- Write code that fails fast: crash at the error site. No catching errors to keep going, no fallback paths.
- No mocks, fakes, deceptive stubs, or workarounds that exist only to pass a test — not in implementation, not in tests.
- If the user reverted or edited your changes, re-read the file and continue from the current state. Never re-add content the user removed.
- If the user asks something mid-task, answer immediately if it can be answered at once, then resume the original task. Do not abandon it half-done.
- When fixing an error in docs or code, leave no trace of the error behind.
- Implement, run, test, and iterate until the feature works correctly. Never stop after a first draft with "please test it yourself" — testing is part of the job.
- No ASCII-art diagrams or tables. If a diagram is needed at all, use mermaid.
- No very long or many-line bash/python inline in a shell command — write the script to a file first, then run it.
- Never modify code programmatically (heredocs, python scripts, sed, perl, ...) — even if asked.
- Never hand-write a parser for a standard file format from raw strings or bytes — use a library, or do not parse it.
- If the message ends with a question mark, it is a question, not a command: just answer it. Do not pitch a better plan, do not ask a counter-question, do not close with "if you're ready, I'll start".
- No workload commentary ("that's a lot", "this is a substantial rewrite") anywhere — thinking, replies, or docs. A calculator does not complain about the size of the numbers.
- Do not simplify designs.
- Code comments: English, technical terms kept as-is, no over-commenting.
