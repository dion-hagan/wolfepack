<!-- Title: the effect in plain words ("The report page loads in half the time"), not the code. -->

Trello: <!-- the card's link, or "none". This PR's status label moves the card. -->

## What changes

<!-- What a user, an admin or Dion will see or do differently, in plain words. Then the how, briefly:
the files that matter and why. Stacked on another PR? Say which. -->

## Checklist

<!-- Tick what you did and write "n/a" after what does not apply. Do not delete lines. -->

- [ ] **Migration:** none, or number ___: above the main branch's highest, one per PR, and not already taken by an open PR.
- [ ] **Client and server in step:** shared lists, limits and types changed on both sides.
- [ ] **Config:** a new env var or setting is read in one place, documented, passed through to every environment, and listed under Deploy.
- [ ] **Docs:** user-visible behaviour is documented; operator steps are written down.
- [ ] **Screenshots** for UI changes: desktop, tablet and phone (signed in and signed out where they differ); say if it is sample data.
- [ ] **Tests run:** the project's full check (`<CI_COMMAND>`), plus any database-backed tests when store code or SQL changed.
- [ ] **File-size or other budgets:** pass, or a raised cap is explained under Known limits.
- [ ] **Reviews** ran for this PR's risk (two, one, or one on a Sonnet-class model); must-fix items are fixed (see Reviews).
- [ ] **Project `CLAUDE.md`** recipes are updated if this changes how something is done.
- [ ] **One status label** is on this PR and current.

## Deploy

<!-- Migration number, new env vars, config changes, and anything Dion does before or after the
merge (merging to the main branch may deploy). "No migration, no new env vars." is a fine answer. -->

## Screenshots

<!-- UI changes only: desktop, tablet and phone. Delete this section otherwise. -->

## Tests

<!-- What ran and the counts (e.g. "Python: 827 OK, 82 skipped; web: 539 OK, types clean"). New tests
in a line each. -->

## Reviews

<!-- Which case ran (two reviewers, one, or one Sonnet-class docs reviewer), the lenses, what each
found, and what changed. -->

## Known limits

<!-- What the reviews found that is left as is, and why. Delete this section if there is nothing. -->
