---
name: quality-review
description: Review code changes against distilled design principles — interface cleanliness, seam integrity, single ownership. Audits the whole repository around the diff, since seams reach files the diff never touches. Use when the user asks for a quality or design review of a diff/PR, a whole-repo quality audit, questions whether an interface is clean, or wants abstraction breakage found. Distinct from code-review (repo standards + spec compliance) and security-review (vulnerabilities).
---

# Quality review

Review a diff for structural quality: do the interfaces match the decisions that exist, do abstractions hide what they claim to hide, does every fact and capability have one owner. The diff is the anchor; the audit runs on the whole repository — a seam reaches every consumer and producer in the tree, and a diff-only read structurally cannot see where the abstraction broke.

## Steps

1. **Fix the base.** A commit the user names is the *change under review*: diff `that commit~1..that commit`. A branch or tag the user names is the *ancestor*: diff `merge-base(ancestor, HEAD)..HEAD`. With none given, use the merge-base with the upstream of the current branch; on no feature branch, use `HEAD~1`. State the chosen base and its meaning in the report header.
2. **Map seams across the repo, not the diff.** For each changed interface, resolve its full footprint in the tree: every consumer, every producer, every type that travels through it — wherever they live, inside or outside the diff. Pollution is judged at the seam, and the seam's evidence (a caller carrying a second raw shape, a fact copied in another layer, a single-consumer module in a shared package) usually sits in files the diff never touches. Unexamined footprint = unverified seam: never report a seam as clean whose consumers you did not read.
3. **Audit every changed surface against the principles below**, with the footprint from step 2 as the evidence base. Each finding needs: `file:line`, the principle violated, what is wrong with the surface, and the structural repair. Locate repairs at the seam or owner — a fix that only adjusts call sites while the seam stays leaky is an unfinished fix, and is itself a finding.
4. **Collapse repeats.** The same defect in N files is one structural finding with N sites listed, not N findings.
5. **Report grouped by principle**, most severe first. Severity: surface that hides a real decision or re-exposes a hidden dependency outranks dead residue; both outrank missing shared owners.
6. **Stay structural.** Naming, formatting, comment density, and test coverage are out of scope. A finding names a defect a reader of the interface could hit, never a taste preference. Two scope edges: (a) a pre-existing defect adjacent to the changed surface is in scope only when the diff raises its cost or load — flag it as pre-existing; (b) a comment or doc attached to a changed surface that states a mechanism no longer present is a structural finding — a false statement about the surface, not a style issue.

## Principles

**1. Surface equals live decisions.** An interface is the ledger of the decisions that exist, audited in both directions: every argument, option, field, and knob must enable a real degree of freedom someone would exercise, and every real decision must surface explicitly at the level that owns it. Defect classes: dead knobs, derivable values, ambient-context inference, optional-with-fallback, and the unledgered decision — a real constraint that lives only in prose beside one consumer instead of on the interface that owns it. Where the mismatch sits tells you where the abstraction broke.

**2. Pollution marks a broken seam.** An abstraction hides a dependency end to end: nothing downstream — argument, field, return type, name — re-exposes it. A consumer holds the projection alone, never a second raw shape beside it; a shared interface takes no host-specific parameter or single-consumer vocabulary. Pollution found downstream is evidence about placement: repair the seam, don't patch call sites.

**3. One fact, one place.** Every fact — constant, formula, ordering, derived value — has one authority; everything else derives or is held to it by a mechanism. Duplication across a real boundary (two layers, two languages) is acceptable only with a guard that fails when the copies disagree. The predicted defect is silent drift between copies.

**4. Placement is ownership.** An element lives beside its one consumer or beside the concept it configures. A shared location is earned by a real second consumer; a shared package accumulating single-consumer code is pollution that signals the owning concept was never drawn.

**5. One concept, one realization.** A recurring concept has one owned realization; every instance consumes it. Overlapping mechanisms collapse into the established one; ecosystem-standard machinery is adopted through its public surface. A deliberate variant is a defined second concept; silent divergence within one role is a defect.

**6. Decisions delete their alternatives.** The change that settles a decision also removes everything only the rejected option could reach — variant branches, shims, orphaned props, one-time scripts — even though it compiles and passes tests. Verify removal by absence (reference counts, residue grep); a green build proves nothing.

**7. Fix the model, not the patch stack.** Past a couple of special cases or patch layers around one behavior, the decomposition is the defect. Return to the last design that worked, re-derive the model from evidence, reshape the data so compensating machinery becomes unnecessary — then sweep the interfaces for fields whose only consumer was the dead mechanism.

**8. Tests go through real seams.** Tests verify at responsibility boundaries and never draw them. A split, parameter, or indirection existing only so a test can reach logic is pollution; merge it back and test the responsibility units directly. Purity inside a real boundary is fine; the boundary itself must be one a reader would draw anyway.

Full statements with rationale and verbatim session evidence: `principles.md` in this skill's directory — read it when a finding's principle is contested or the user asks why a principle exists.
