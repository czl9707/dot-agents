# Code Quality Principles

Distilled from twelve recorded code review and refactor sessions.

## The interface-cleanliness hypothesis

The hypothesis these sessions test: interface cleanliness is the primary signal of code quality — every argument a function takes should be necessary, and interface pollution indicates abstraction breakage somewhere upstream.

The evidence confirms the hypothesis and sharpens it. Half of the 222 recorded review observations are interface or boundary critiques, and literal argument-necessity checks recur in eight of the twelve sessions: a derivable argument struck from a render frame, a host-specific path thrown out of a generic loader, an optional parameter preserving a legacy calling convention collapsed to required, single-valued knobs deleted together with the machinery that served them. The sessions also read pollution diagnostically — the repair is located inside the abstraction itself, and reviews commission abstraction-breakage audits rather than spot fixes.

Two refinements carry into every principle below:

- **Necessity is bidirectional.** A real decision hidden behind autodetection or an omitted optional argument is the same defect as a dead knob. The measure of an interface is its match with the live decision set, checked in both directions.
- **"Interface" spans more than function signatures.** Type projections, config fields, shared vocabulary, module placement, and contract documents are all surfaces. Pollution at any of them is one symptom of one defect class — knowledge or decisions without a single owner — and the eight principles state that class at its different sites.

## 1. Surface equals live decisions

**Statement.** An interface is the ledger of the decisions that exist, audited in both directions. Every argument, option, field, and knob must enable a real degree of freedom — someone (a caller, or the user at runtime) who would actually set it differently. A knob nobody varies, or a value derivable from the rest, is deleted together with the machinery that existed only to serve it. Symmetrically, a decision that does exist must surface explicitly, at the level that owns it — never as inference from ambient context, never as an optional argument whose absence silently picks a behavior. Dead knobs, derivable values, hidden autodetection, optional-with-fallback, and the unledgered decision — a constraint that lives only in prose beside one consumer — are one defect class: surface that does not match the decision structure. Where the mismatch sits tells you where the abstraction broke.

**Why it matters.** Surface beyond the real decision set forces every reader and caller to carry and honor degrees of freedom nobody can exercise. Surface short of the decision set hides decisions in inference, where nobody can control them. Both directions make the interface lie about the system, and the interface is where abstractions rot first.

**Review check.** For every parameter and option, ask: which caller supplies a different value, and what breaks if this is removed? A parameter with no possible second value, or one derivable from the other arguments, is a defect. Symmetrically, for every behavior absent from the surface, ask whether it is a decision someone would want to make; if yes, it belongs on the surface at the owning level. Flag behavior keyed to ambient context the caller cannot see, and optional arguments whose absence silently selects a behavior — autodetection and optional-with-fallback are usually the later of the two to be caught by tests.

**Session evidence.**

> "Q13: render + frame good. no need for dt, only time."
>
> — mosaic__03

> "actually lets do the old way, the plane show like a "section", cut one side of the cube, but instead of we autodetect which side to hide, have a checkbox let use flip by themself."
>
> — kz__00

> "Q2: mandatory field, not optional."
>
> — mosaic__01

## 2. Pollution marks a broken seam

**Statement.** An abstraction hides a dependency, and the hiding runs end to end: nothing downstream of it — argument, field, return type, or name — re-exposes what it hides. A consumer of a projection holds the projection alone, with no lookup in a second raw shape beside it. A shared interface takes no host-specific parameter and no vocabulary only one consumer speaks. A field that serves the seam's consumers belongs on the seam — a projection may legitimately carry a hidden flag or an id when that frees consumers from the raw shape; a field that only re-exposes the hidden dependency belongs in the host layer that owns it. Pollution found downstream is evidence about placement: the seam is misplaced or incomplete, and the repair belongs in the seam — make the projection self-sufficient or move the dependency to its owner. A fix that touches only call sites while the seam stays leaky is an unfinished fix.

**Why it matters.** A leaking seam makes the abstraction a fiction: callers pay its complexity while re-carrying the very thing it existed to hide. Every consumer is silently coupled to what the abstraction was supposed to make irrelevant, so the hidden dependency's cost grows with each new consumer.

**Review check.** Trace each abstraction's hidden dependency through everything it returns and everything downstream of it; any leaked parameter or field re-exposes it. Flag generic signatures carrying host-specific parameters, shared types named in one consumer's vocabulary, callers doing lookups in a second raw shape to feed one projection, and repairs that fix call sites while the seam stays incomplete.

**Session evidence.**

> "The contract lib should not assume the tool on filesystem, thats all why we need the ToolSource interface. But LoadedTool still assume that, can we try keep this abstract clean? name is fine, but path should not be here, so LoadedToolModule can retire and replaced by LoadedTool."
>
> — mosaic__00

> "I understand we have `ResolvedControl` and `descriptor` one for json shape, one for UI shape. by why `ControlProps` need both?"
>
> — mosaic__02

> "Why PanelControl stay in tool-loading.ts? and PANEL control seems not a good name here, rethink here, we have no idea about "panel" here. so as PanelSections."
>
> — mosaic__00

## 3. One fact, one place

**Statement.** Every fact — a constant, a formula, an ordering, a derived value — has one authority; everything else derives from it or is held to it by a mechanism. The defect class this predicts is silent drift between copies: a section outline lagging the real scroll position, a pin-centering transform present in old markers and missing in new ones, the same size written in both CSS and JS, the same formula correct in TypeScript and wrong in GLSL. When a boundary genuinely forces a copy — two layers, two languages — duplication is acceptable only with a guard that fails when the copies disagree: a mirror test, generated code, a shared variable. Data structures state constraints and derive outcomes — maxW/maxH with layout doing the rest. An interface carrying per-item values it could derive is polluted, and that pollution marks where the abstraction is broken.

**Why it matters.** A fact in two places desynchronizes on the first change that touches one copy, and the divergence surfaces as a bug far from the edit. Precomputed results stored as configuration go stale the moment their inputs change.

**Review check.** For each constant, formula, ordering rule, or derived value, locate its single authority. Flag any second copy — another layer, another language, config beside code — that lacks a mechanism which fails when the copies disagree. Flag configuration that stores outcomes where it should state the constraints that produce them.

**Session evidence.**

> "especially, clena up css. reuse css var if poosble, try not having any value in both css and js. link them up."
>
> — nolli__02

> "I think the SLOTS thing, it should not carry images size for each. We can just limit max height and max width and let dom do its job?"
>
> — nolli__01

> "The section outline and sectoin real position on the screen is not synced. the real one move faster then the outline."
>
> — nolli__02

## 4. Placement is ownership

**Statement.** An element lives beside the one consumer it serves, or beside the concept it configures. Nesting an element inside a structure submits it to that structure's contract — its imports, its layout, its build scope — so misplacement surfaces as defects in the misplaced element. A shared location must be earned: code moves there only when a real second consumer exists, code serving two sibling consumers sits above both and inside neither, and vendored code stays in its vendored layer. A shared package that accumulates single-consumer code is interface pollution — a surface promising generality nothing uses — and signals the owning concept was never drawn.

**Why it matters.** Wrong placement makes the tree lie about dependencies: readers cannot locate responsibilities, single-consumer code accumulates in shared packages until the boundary stops meaning anything, and misplaced elements inherit contracts their domain never involved.

**Review check.** For each module, ask who consumes it and check the directory answers the same question. Flag single-consumer code in shared packages, controls grouped anywhere except beside the concept they modify, organizational units created to hold stray items, and elements whose placement obliges them to machinery their domain never touches.

**Session evidence.**

> "So can the control loading logic go into contract/control.ts then. THe strong type definition should live there as well? and a function taking a ToolSource and load the tool with ctonrols should also be part of contract I believe."
>
> — mosaic__02

> "omg in previous changes, so ui components got moved to ui lib? please keep vendored component there and move app ones back to app please, soas all scripts. only vendored component and shadcn helper and hooks there"
>
> — mosaic__00

> "footer currently got put inside the stats scene. can we put that outside. and footer currently is overlapping with stats, I guess this could fix that as well."
>
> — nolli__02

## 5. One concept, one realization

**Statement.** A concept that recurs — a visual treatment, an interaction convention, a named role, a utility — has one owned realization, and every instance consumes it. New occurrences reuse the existing component or mechanism. Overlapping mechanisms for one concept collapse into the established one. Machinery the ecosystem already standardizes is adopted and used through its public surface, internals untouched. Review gate: when a concept appears a second time without a shared owner, the diff is rejected until it consumes one. A deliberate variant is legitimate only as a defined second concept in its own right; silent divergence within one role is a defect.

**Why it matters.** Parallel realizations of one concept drift by construction, because each copy re-decides the details. The same concept then renders or behaves differently in different places, and every fix must be applied N times forever.

**Review check.** When a concept appears a second time, require one shared owner before accepting the diff. Flag imitations of existing components, per-scene or per-component re-derivations of shared conventions, hand-rolled versions of ecosystem-standard machinery, and the same role treated differently in different places.

**Session evidence.**

> "for the pinned style. lets use paper photo component, it already have a pin. same as the card, use the same texture and pin. fix all."
>
> — nolli__01

> "seeded random, lets pull a package instead, dont maintain our own."
>
> — mosaic__00

> "Dont touch shadcn component implementation, just use them."
>
> — kz__00

## 6. Decisions delete their alternatives

**Statement.** The same change that settles a decision also removes everything only the rejected option could reach: variant branches, exploration apparatus, compatibility shims, orphaned props and fields, one-time scripts — even though that code still compiles and passes its own tests. Such residue is interface pollution with no caller: parameters and branches no surviving decision reads. Removal is verified by absence — reference counts at zero, a residue grep over the tree — never by a green build, which the leftovers pass too.

**Why it matters.** Residue from dead alternatives is live code with no justification. Every branch, shim, and orphaned prop is a path to maintain and eventually misfire on, and tolerated old shapes mask errors a clean break would surface immediately.

**Review check.** After any decision or feature removal, sweep for machinery only the rejected option could reach — dead branches, orphaned props and fields, compatibility shims, one-time scripts. Require deletion plus a residue check by absence, and refuse to count a passing build as evidence of removal.

**Session evidence.**

> "review code in this session, please pay attention as much as you can to backward compatability related code. WE DONT NEED THAT!"
>
> — mosaic__02

> "Lets only keep the split panes B options. and I will start refinement in a new session."
>
> — mosaic__04

> "get rid of all the sound feature"
>
> — glyph__00

## 7. Fix the model, not the patch stack

**Statement.** When one behavior absorbs patch after patch, the decomposition is the defect: past a couple of special cases or patch layers around it, stop tuning mechanism and fix the model. The preferred repair returns to the last design that worked — an older version, or reference material such as the source video — re-derives the model from that evidence, and adapts it so the data shape makes the compensating machinery unnecessary. After the model changes, sweep the interfaces: any field or argument whose only consumer was the now-dead mechanism is deleted, because interface residue from dead mechanisms is what abstraction breakage looks like.

**Why it matters.** Tuning before the model is agreed perfects the wrong mechanism. Patches on a wrong model compound into machinery nobody can narrate, and abandoned mechanisms leave interface debt that outlives them and misleads the next reader.

**Review check.** Count the special cases and patch layers around any behavior that has been fixed repeatedly — past a couple, the decomposition is wrong. Require the domain model be stated and agreed before tuning changes. Flag interface fields whose only consumer is a dead mechanism. Check a perceived defect is measured in the artifact before the artifact is changed.

**Session evidence.**

> "This was never a problem in old version of spine (not the main branch version, but an earlier version where we have transition + hold and map always on screen, never fly outof screen if the next scene is pretty downbelow, no map position trakcing logic.). I sincerely ask you to copy that, and adapt. There was some interface change on scenen struct deinition, I think we no longer need them. please clean them as well."
>
> — nolli__02

> "Lets reveiw the video hard and establish the logic first."
>
> — glyph__00

> "I wanna make the control panel to support edit controls (rename, reorder, hide, change default). but this seems need to make the scheam to json,so the current design no longer stands..."
>
> — mosaic__02

## 8. Tests go through real seams

**Statement.** Tests verify at responsibility boundaries, and tests never draw boundaries. When a split, parameter, or indirection exists only so a test can reach the logic — an injected fake seam, a test-only argument — merge it back and test the responsibility units directly, even if that deletes the injected test; that pollution signals the abstraction is wrong. Purity inside a boundary for testability is fine — pure helpers, tests against temp files and a real server — the boundary itself must be one a reader would draw anyway.

**Why it matters.** Boundaries invented for tests teach every future reader a false structure and get collapsed later anyway. Tests over internals break on every refactor. Effort concentrated at real public seams keeps the structure honest and the suite durable.

**Review check.** When a split or indirection is justified by testability, check a reader would draw the boundary there anyway. Flag modules that exist only to be injected into, tests reaching past public interfaces into internals, and suites whose effort spreads across internals rather than concentrating at the seams callers actually use.

**Session evidence.**

> "They are interwined a lot. Can we Have tools resolution related in one file. and cli starting logic in one file?"
>
> — mosaic__00