# Merging

Every finished piece of work ends in a PR, and its session merges it once it is safe, without
waiting to be asked. Nothing on GitHub enforces the list below unless you turn on branch
protection, so each session checks it itself right before merging.

## Create the labels

Once per repository. `gh label create` fails if a label exists; that is harmless.

```
gh label create "work in progress"        --repo <GITHUB_REPO> --color FBCA04 --description "Branch is being updated right now"
gh label create "needs review"            --repo <GITHUB_REPO> --color D93F0B --description "Reviews have not run, or findings are not fixed"
gh label create "needs update"            --repo <GITHUB_REPO> --color E99695 --description "Conflicts with its base; nobody is updating it yet"
gh label create "stacked"                 --repo <GITHUB_REPO> --color C5DEF5 --description "Built on another open PR"
gh label create "blocked: waiting on Dion" --repo <GITHUB_REPO> --color B60205 --description "Waits on Dion's account, key or decision"
gh label create "blocked: external"       --repo <GITHUB_REPO> --color 5319E7 --description "Waits on a third party or a date"
gh label create "needs testing"           --repo <GITHUB_REPO> --color 1D76DB --description "Still to try by hand on a device"
gh label create "ready to merge"          --repo <GITHUB_REPO> --color 0E8A16 --description "Reviewed, up to date, nothing waiting"
```

## The labels

One per PR, always current, relabelled whenever the state changes.

| Label | Meaning |
| --- | --- |
| `work in progress` | The branch is being updated right now (a conflict or a base change). Add it BEFORE starting the merge or rebase. Remove it once pushed and green, and say so. |
| `needs review` | The reviews have not run, or their findings are not fixed. |
| `needs update` | Conflicts with its base, or the PR it was stacked on has merged, and nobody is updating it yet. When someone starts, swap it for `work in progress`. |
| `stacked` | Built on another open PR. GitHub retargets the base only if the parent's branch is deleted, and a squash merge leaves the child conflicting, so swap this for `needs update` when the parent merges. |
| `blocked: waiting on Dion` | Waits on his account, key or decision. |
| `blocked: external` | Waits on a third party or a date. |
| `needs testing` | Still to try by hand on a device. |
| `ready to merge` | Reviewed, up to date, nothing waiting. |

A blocked PR that also conflicts carries both labels. Do not change the labels of another session's
PR that is mid-update; tell Dion or the session in chat. Label a PR when you open it.

## Safe to merge

All of these, checked right before the merge, on the exact head:

1. **Base.** Its base is the main branch. Rebase a stacked PR onto it first.
2. **Current.** After `git fetch`, `git rev-list --count HEAD..origin/<MAIN_BRANCH>` prints `0`. If
   main moved, update the branch and let CI run again.
3. **Green.** `gh pr checks <n> --repo <GITHUB_REPO>` shows every check passed on that head. Pending,
   or no checks, is not green.
4. **Reviewed.** The reviews the PR's risk calls for ran (`teams-and-models.md`, "Reviews by risk")
   and their must-fixes are fixed.
5. **Labelled.** `ready to merge`, or `needs testing` when all that is left is a device test.
6. **Nothing needs Dion.** None of these is in the PR:
   - an open question;
   - a secret, an env var, a console or DNS step;
   - a production data step;
   - a config change that switches something on for live users, or touches admin, plan or billing
     settings;
   - a change to CI, the container build or dependencies, or to these rules beyond what he asked;
   - a migration or job that deletes or rewrites users' data or files, or locks a big table for long;
   - a money, sign-in or security change.
7. **The migration number is free** (if there is a migration): above the main branch's highest and
   above every open PR's. Two PRs that both add migration N merge cleanly in git and each one's CI
   was green; the clash shows only on a run made after the first merged. So update the branch from
   main and let CI run again right before merging, and the PR that merges second renumbers.

A device test does not hold a merge: merge, then tell Dion what to try after the deploy.

## How to merge

```
git fetch origin
gh pr view <n> --repo <GITHUB_REPO> --json headRefOid,state,labels
gh pr checks <n> --repo <GITHUB_REPO>
gh pr merge <n> --repo <GITHUB_REPO> --squash --match-head-commit <sha>
```

`<sha>` is the `headRefOid` CI passed on. If the head moved, `--match-head-commit` refuses; check
again instead of forcing. **Never `--admin`** (it skips checks) and **never `--auto`**.

To wait for CI: the desktop app's PR status, or `gh pr checks <n> --watch --fail-fast` once. Do not
poll in a loop.

Then say in chat that it merged and what to try on a device. Dion watches the deploys.

## Etiquette

- Merge only your own PRs. Wolfe also merges PRs of agents he started, and a safe PR from an idle or
  gone session when Dion has told him to drive merges. Never anyone else's.
- **Warn the PRs you will hit**, on their Trello cards, before the merge (`trello-board.md`, "Fewer
  rebuilds and CI runs").
- A merged PR takes no more pushes: `gh pr view <n> --json state` before every push; if MERGED,
  cut a new branch from the remote main branch for the follow-up.
- A change that needs Dion: leave the PR open with `blocked: waiting on Dion` and one line saying
  why, tell him, and file any manual step on his ops board.
- Order: merge the PR that others are waiting behind first, then the ones that touch shared files,
  then the rest. Update each remaining branch from main once.
- If CI is red for a reason unrelated to the PR, say so in the PR. Do not re-run until it passes.
- When the permission system refuses `gh pr merge` (auto mode's classifier can), do not retry or
  route around it. Finish the prep, then offer Dion three ways: switch the session to a mode that
  asks him, add an allow rule for `gh pr merge` to his settings (only if he asks), or merge by hand
  in the order you give him (`desktop-app-settings.md`).

## Optional: branch protection

To make "green before merge" a setting and not just a habit, require the CI check in the main
branch's protection rules (GitHub, Settings, Branches). Agents still check the list above.
