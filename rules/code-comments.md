# Code Comments

Only write a comment for something the code cannot express: intent, why a choice was made, constraints, links to specs or issues, caveats a reader would otherwise discover the hard way.

Never write a comment that restates what the code already says. If the code plus its names already convey the information, delete the comment instead of writing it. If a section of code seems to need a restating comment, rename or restructure the code so it does not.

Reason: a restating comment duplicates a fact that lives in two places, and only one of them compiles. The code changes, the comment stays, and the stale comment then misleads. Comments that carry information the code cannot hold do not have this failure mode.

Applies to inline comments, docstrings, and doc blocks alike.
