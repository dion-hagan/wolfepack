# wolfepack

Named in homage to Wolfe, the guy who taught me how to be a real engineer.

A personal, centralized Claude Code agent setup. It is a small **team of agents** that
works through a Trello kanban board, opens pull requests, and merges them itself when they are safe.
Everything a new computer needs is in this repo, so it can be picked up in minutes.

It is project-neutral. Nothing here names a product: you point it at any repository and any pair
of Trello boards by filling in one config file.

## The idea

- **<MANAGER_NAME> is the manager.** They set goals, report bugs in their own words, and answer the few
  questions only they can (money, accounts, secrets, pricing, legal).
- **Wolfe is the team lead.** Wolfe is a long-running Claude session. He staffs agents, runs the
  board, runs the reviews, drives merges and reports back with a status table. His calls are final
  unless <MANAGER_NAME> overrules them.
- **Agents** each take one Trello card, work in their own git worktree, open a PR, and merge it
  themselves once it passes the safe-to-merge checklist.
- **Reviewers** are read-only agents. How many look at a PR depends on its risk.
- **Trello** is where work waits and where <MANAGER_NAME> can see it move. A second, private board holds the
  manual steps only they can do.
- **The cheapest model that fits** does each job, and Wolfe reports the evidence and a rough cost.

## Roles

| Role | Who | Reads | Writes |
| --- | --- | --- | --- |
| Manager | <MANAGER_NAME> | status tables, the boards | their list on the board, answers in chat |
| Team lead | Wolfe (`agents/wolfe.md`) | everything | board moves, comments, reviews, merges, reports. No feature code |
| Card agent | one background session per card (`agents/worker-brief.md`) | its card, the repo | one branch, one PR |
| Reviewer | read-only agents (`agents/reviewer-briefs.md`) | one diff | one report |
| Docs reviewer | a Sonnet-class reviewer | a docs-only diff | one short report |

## What is in the repo

```
wolfepack/
  README.md                this file
  CLAUDE.md                the global rules; installed to ~/.claude/CLAUDE.md
  config.example.md        the placeholders you fill in (repo, boards, list names, check command)
  install.sh               install on macOS / Linux / Git Bash
  install.ps1              install on Windows PowerShell
  LICENSE                  MIT
  agents/
    wolfe.md               the team lead's prompt: paste it into a new session
    worker-brief.md        the brief for a card agent started by hand
    reviewer-briefs.md     the runtime, structure, both-lens and docs reviewer briefs
    incident-responder-brief.md  the read-only brief for an agent sent after an alert
  skills/                  installed to ~/.claude/skills/
    trello-dispatch/       SKILL.md + worker-brief.md: work the board
    trello-card/           SKILL.md: take or file one card
    incident-watch/        SKILL.md + alertwatch.py: Wolfe's alert watch and morning report
  docs/
    workflow.md            the end-to-end loop
    trello-board.md        lists, labels, card format, the ops board, finishing a session
    merging.md             labels, the safe-to-merge checklist, how to merge
    teams-and-models.md    teams, the model by the work, reviews by risk, cost
    desktop-app-settings.md  app settings, permission modes, Trello connector, gh auth
    memory.md              memory folder conventions
    incident-response.md   alert -> responder -> fix -> merge -> resolve; severity; the resolve rule; scaling
    absence-mode.md        a trial: full operating permissions while <MANAGER_NAME> is away, with guardrails
  templates/
    pull_request_template.md   card.md   ops-card.md   status-report.md
```

## New computer in 15 minutes

Windows, macOS and Linux all work. Commands that differ are shown for both.

**1. Install the tools (3 min).** You need Git, the GitHub CLI and the Claude desktop app (with
Claude Code).

```
# Windows (PowerShell)
winget install --id Git.Git -e
winget install --id GitHub.cli -e

# macOS
brew install git gh
```

Install the Claude desktop app from claude.ai/download and sign in.

**2. Sign in to GitHub (1 min).**

```
gh auth login        # GitHub.com, HTTPS, sign in through the browser
gh auth status       # must show "Logged in" and the "repo" scope
```

**3. Get this repo (1 min).** It is public, so no sign-in is needed to clone it.

```
git clone https://github.com/dion-hagan/wolfepack.git ~/code/wolfepack
cd ~/code/wolfepack
```

**4. Install (1 min).** It backs up anything it would replace and never touches `settings.json`.

```
# Windows (PowerShell)
powershell -ExecutionPolicy Bypass -File .\install.ps1

# macOS / Linux / Git Bash
./install.sh
```

Add `-DryRun` (PowerShell) or `--dry-run` (bash) first to see what it would do. Running it again is
safe.

**5. Fill in the config (3 min).** Open `~/.claude/wolfepack.config.md` and replace every
`<PLACEHOLDER>`: `<OWNER>/<REPO>`, `<BOARD_URL>`, `<OPS_BOARD_URL>`, the check command. You will
have the board URLs after step 6, so do the rest now and come back.

**6. Make the boards (3 min).** In Trello create the agent board and the ops board exactly as
`docs/trello-board.md` says (nine lists, six labels; three lists on the ops board). Paste both URLs
into the config.

**7. Connect Trello and set the app (2 min).**

- claude.ai, Settings, Connectors: connect **Trello**.
- In the desktop app, turn **Auto-archive sessions when their pull request closes** off.
- Choose your permission mode. The prompting mode asks you before merges and card moves; auto mode
  can refuse them. `docs/desktop-app-settings.md` explains both.

**8. Create the PR labels (1 min).** Copy the eight `gh label create` lines from
`docs/merging.md` and run them once against your repo.

**9. Start Wolfe (1 min).** Open a Claude Code session in your project folder, paste all of
`agents/wolfe.md` below its line, and rename the session **Wolfe**. He replies with what he found
and the first status table.

**10. Smoke test (1 min).** Put a small card in Ready on the agent board, then tell Wolfe
`/trello-dispatch`. An agent should claim the card, open a draft PR, and Wolfe should run the reviews.

If something is off, run the checklist at the end of `docs/desktop-app-settings.md`.

## Updating

Pull this repo and run the installer again. Changed files are backed up
(`CLAUDE.md.bak-<time>`, `skills-backup-<time>/`) and unchanged files are skipped. Your
`wolfepack.config.md` is never overwritten.

## Using it in a project

The global rules are generic. Each project still needs its own `CLAUDE.md` with its commands, its
check command and its list of things never to touch, a PR template (start from
`templates/pull_request_template.md`) and a CI workflow. The global rules say how the team works;
the project says how the code builds.

## Safety

- No secrets live in this repo, in the config or in memory. The installer never writes
  `settings.json`.
- Agents never touch production, push to the main branch, force-push, or merge a PR that fails the
  checklist. Merges use `--squash --match-head-commit`, never `--admin` or `--auto`.
- <MANAGER_NAME>'s own cards and notes are never rewritten; agents comment beside them.

## License

MIT. See `LICENSE`.
