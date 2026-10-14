# The workflow, end to end

How a piece of work travels from an idea to a merged PR. Every session follows this loop. The
short form of the rules is `CLAUDE.md`; the details are in the other docs here.

## The cast

| Role | Who | Does |
| --- | --- | --- |
| Manager | <MANAGER_NAME> | Sets goals, reports bugs in their own list, answers the few questions only they can. |
| Team lead | Wolfe | Runs the board, staffs agents, runs reviews, drives merges, reports. Final say on design and order. |
| Agent | one session per card | Builds one card in its own worktree, opens the PR, fixes review findings, merges its own PR when safe. |
| Reviewer | read-only agent | Looks at a diff, reports must-fix, should-fix and nits. |

## The loop

1. **<MANAGER_NAME> reports or asks.** A bug or idea goes in their list on the board (any words; a screenshot
   helps), or they tell Wolfe in chat.
2. **Wolfe triages.** He reads the card read-only, comments a triage (what is happening, where, a
   proposed Done when, questions). No questions and no product or pricing call in it: it moves to
   the bottom of Ready. Otherwise it gets the Needs decision label and Wolfe asks <MANAGER_NAME>.
3. **Wolfe dispatches.** He takes cards from the top of Ready up to the agent limit. Per card:
   move it to In progress, comment the claim, pick the model and effort, and start one background
   agent in its own worktree with the worker brief.
4. **The agent builds.** `git fetch`, branch from the remote main branch, build with tests, run the
   project's check command, open a **draft** PR from the template with the card on its `Trello:`
   line, label `needs review`, turn on the CI monitor, and reply `PR <number>`.
5. **Reviews run, by risk** (`teams-and-models.md`, `merging.md`). Wolfe starts one or two read-only
   reviewers and sends the agent their reports with the items to fix marked.
6. **The agent fixes.** One "Review fixes" commit, one push, fills in the PR's Reviews and Known
   limits, marks it ready, waits for checks once, then sets `needs testing` or `ready to merge`.
7. **Wolfe warns, then merges.** He reads the other open PRs' titles, comments heads-ups on the
   affected cards, checks the safe-to-merge list (`merging.md`), and squash-merges with
   `--match-head-commit`. Then he says in chat that it merged and what to try on a device.
8. **Cards close.** Each linked card goes to Done with a comment; the session reads it back; any
   ops card that waited on the merge moves to To do; the session archives only after that.
9. **Report.** Wolfe ends the message with the status table and, when new agents started, the cost
   section (`templates/status-report.md`).

## When an agent needs <MANAGER_NAME>

The agent stops with `QUESTION` (the question, the options, the one it would pick) or `STUCK`
(what it tried). Wolfe comments it on the card, asks <MANAGER_NAME> in chat, and blocks the card: moved to
Blocked before a PR exists, the `blocked: waiting on <MANAGER_NAME>` label after. <MANAGER_NAME> answers in chat or in
a comment on the card. Wolfe forwards the answer and removes the block.

Before bothering <MANAGER_NAME>, Wolfe checks the list in `CLAUDE.md` section 2. Most "waiting on <MANAGER_NAME>"
items are really "waiting on a review and a merge".

## Filing and ops

- A bug or idea outside the current change becomes a card in Inbox (`/trello-card new <what>`),
  and the filer tells <MANAGER_NAME> in one line. It does not widen the PR.
- A manual step only <MANAGER_NAME> can do becomes a card on their ops board, filed in the same turn.

## The rules that keep it safe

- Every session starts from the remote main branch (`git fetch`, compare, branch from `origin`).
- One card, one branch, one PR. Never stacked.
- Green CI on the exact head before any merge. Never `--admin`, never `--auto`.
- Production is never touched without <MANAGER_NAME> unless the project's `CLAUDE.md` says how.
- <MANAGER_NAME>'s own words are never rewritten (`trello-board.md`, "<MANAGER_NAME>'s words").
- Any change to this workflow is shared with every running session (`CLAUDE.md` section 13).

## Starting a project in this workflow

1. Fill in `wolfepack.config.yaml` for the project (or the global one).
2. Make sure the project has a `CLAUDE.md` with its commands and its "never touch" list, a PR
   template (start from `templates/pull_request_template.md`) and a one-command check.
3. Create the PR labels (`merging.md`) and the boards (`trello-board.md`).
4. Open a session in the project, paste `agents/wolfe.md`, and let Wolfe take it from there.
