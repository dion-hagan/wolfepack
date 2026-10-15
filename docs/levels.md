# Levels of investment

wolfepack can run at three levels. Each adds structure, coordination cost and token spend, and
each buys more parallel output. Start at the lowest level that fits the work, and move up when the
signals in "When to move up" appear. Moving back down is fine too.

| | **Individual Contributor** | **Manager** | **Director** |
| --- | --- | --- | --- |
| Shape | Wolfe alone, with short-lived helpers | Wolfe as team lead over builders and reviewers | Wolfe as Director over named teams, each with its own manager |
| Parallel streams | 1 (plus a helper at a time) | 2–4 cards at once | 3–8 teams, each with 1–4 cards |
| Board | One board | One board, the full workflow | A company board plus one board per team |
| Who merges | Wolfe | Wolfe | Team managers; Wolfe merges cross-team and production changes |
| Reviews | Wolfe reviews the diff; a top-tier reviewer for risky changes | By risk (CLAUDE.md §6) | One dual-lens top-tier reviewer per risky PR, run by the team's manager (experiment v1) |
| Planning | A to-do list | Ready list order, the night queue | OKRs per team per cycle, the weekly operation review |
| Reporting to the manager | The answer, in chat | A status table at checkpoints | Morning report, team health, weekly OKR review |
| Rough cost | Lowest: one context, few spawns | Moderate: builders and reviewers per card | Highest: manager contexts on top of builders and reviewers |
| Main limit | Your own time | Wolfe's context and review queue | Coordination: shared files, conflicts, the Director's attention |

## Individual Contributor

**What it is.** Wolfe does the work directly: reads, edits, tests, opens the PR and merges. It
spawns a helper only for a parallel chore or a second opinion on something risky. No managers and
no team boards.

**Use it when:**
- there is one stream of work, or the work is exploratory;
- the codebase is small or new to the agent;
- the budget is tight;
- the human wants to pair closely.

**Setup:**
1. `CLAUDE.md` (the global rules) and `wolfepack.config.yaml`;
2. the board, optional;
3. skills: `trello-card` for taking and filing cards.

**Rituals:** a PR per change, merged when green; memory kept current; a short answer per question.

## Manager

**What it is.** Wolfe stops building and runs a team: one background builder per card, picked from
the Ready list; reviewers by risk; merges by the safe-to-merge checklist; the board kept in step.
This is the setup `agents/wolfe.md` describes.

**Use it when:**
- there are two or more independent cards ready at once;
- the human wants to hand off a backlog;
- incidents need a responder while building continues.

**Setup:** everything in Individual Contributor, plus:
1. the full board workflow (`docs/trello-board.md`) and the PR labels (`docs/merging.md`);
2. skills: `trello-dispatch`, `incident-watch`;
3. agents: `worker-brief.md`, `reviewer-briefs.md`, `incident-responder-brief.md`;
4. docs: `teams-and-models.md`, `incident-response.md`, and `absence-mode.md` if the human travels.

**Rituals:**
- a status table at checkpoints;
- a cost section when new agents start;
- the morning report;
- every new rule mirrored to wolfepack.

## Director

**What it is.** Wolfe runs a fleet of named teams. Each mission team has a **manager agent** that
staffs builders and reviewers, runs fix rounds and merges, and reports to Wolfe at milestones.
Shared **services** (incident response, a review guild, the merge queue) work across teams. Wolfe
owns priorities, cross-team calls, production, scaling, the OKRs and the human's reporting. The
operating system is `docs/management-system.md`.

**Use it when:**
- there are several product areas in flight at once;
- Wolfe's context fills up with builder handoffs;
- conflicts between parallel streams keep forcing rebuilds;
- the human wants to see work by team at a glance.

**Setup:** everything in Manager, plus, for each new team (always, all four):
1. a clever, relevant team name;
2. a coloured `team: <Name>` PR label;
3. a board "Team <Name>" with lists Backlog, Ready, In progress, In review, Done;
4. a manager agent briefed from the manager brief (`agents/manager-brief.md`), with the team's
   OKRs for the cycle;
5. a human name for the manager that matches the team's theme (a night-watch team's manager might
   be a raven-themed name), used to sign reports and card comments.

**Rituals:**
- managers send milestone hand-backs (their "one-on-ones");
- a cross-team digest for shared files and merge order;
- the morning report with team health;
- the weekly operation review with OKR scores and paired indicators;
- team reviews at each cycle's end, with lessons added to `knowledge/`.

## When to move up, and down

- **Individual Contributor to Manager:** the Ready list grows faster than one stream can drain it,
  or you're waiting on CI or reviews while independent work sits idle.
- **Manager to Director:**
  - Wolfe's context is dominated by handoffs rather than decisions;
  - more than about 4 cards are in flight at once;
  - two streams keep touching the same files;
  - the human asks for per-team visibility.
- **Moving back down:** a team's work is finished (hold its wrap party, below, then archive its manager and keep its
  board for history); the budget tightens; or most remaining work touches one area (merge the teams).
  Structure should follow the work.

## Forming and dissolving teams

**Forming.** The Director names the team *and* its manager (a human name matching the team's
theme), creates the label and the board, sets the cycle's OKRs, and starts the manager in its
**own session**: a one-click "spin-off" task whose prompt is the full manager brief. A manager
in its own session keeps the Director's context small, and lets the human hold skip-level
one-on-ones with it.

**Skip-levels are confidential.** The Director never reads or searches a manager's conversations
with the human, and managers don't relay them. Transcripts are files on the machine, so this is
a rule the agents keep, not a technical seal; say so to the human.

**Dissolving: the wrap party 🍾.** When a team's work is done, celebrate it before archiving:
1. the manager sends a final report: PRs merged, OKR scores, wall time, cost, defects caught, and
   one lesson;
2. the Director posts a "🍾 Wrap party: Team <Name>" card in Done on the company board: a
   highlights reel (the biggest wins by PR title, the best save, the numbers) and a thank-you to the
   manager by name;
3. the lesson goes into `knowledge/`;
4. the human's next morning report opens with a short shout-out;
5. the team board is renamed "(alumni)" and kept, never deleted, and so is its label.

Teams that ship deserve a send-off; it also makes the record of what each team achieved easy to find.
