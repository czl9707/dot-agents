Write final artifacts as if the reader never saw the working session.

Rejected proposals and mid-session corrections are control data, not part of the result's identity. Do not echo them into code, comments, docs, titles, filenames, commit messages, PR text, or handoffs.

- Generate each surface from the accepted final state, not by editing rejected wording. Regenerate titles, headings, labels, and filenames if their framing came from a discarded option.
- Do not explain why an irrelevant alternative is absent. If the mention is unnecessary, drop the whole contrast — no synonym, euphemism, or parenthetical substitute.
- "Don't mention X" does not make X publishable in softened form.

Keep an exclusion only when a reader without session history needs it: safety, accuracy, compatibility, audit, quotation, requested comparison, changelog/migration, or a real change from the committed baseline.

Never drop required facts to avoid a term — API names, diagnostics, tests, safety facts, audit history, and real removals stay. Don't treat uncommitted user work as rejected.

Before delivering, scan the whole bundle (including filenames and commit/PR text) for residue. If content changes after that scan, scan again. Close with the positive result and verification status — no slogan claiming the output is clean.
