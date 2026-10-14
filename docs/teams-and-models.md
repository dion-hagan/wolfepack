# Teams, reviews by risk, and the model by the work

Wolfe runs a team of Claude agent sessions. This page says how a team is shaped, which model each
member gets, and how many reviewers look at a PR.

## Teams

- **One card, one agent, one branch, one PR.** Never stack a PR on another. A big project is split
  into cards, one per planned PR, each with its own specialist.
- A project with its own lead: the lead schedules a card per planned PR with an `Assigned to:` line
  (the lead or a teammate) and a `Starts after:` line where order matters. The owners move the
  cards as the PRs move.
- **Agent limit.** `AGENT_LIMIT` (3 by default) card agents run at once. Reviewers do not count.
- **Clashes.** Two agents never work in the same area at once. If an open PR or a running agent
  touches the same page, module or shared file, the later card waits.
- Agents run inside the lead's session, each in its own worktree, and stop if the lead's session
  stops. Talk to them through the lead.
- **Start an agent** with the Agent tool: `subagent_type` general-purpose, `isolation: "worktree"`,
  `run_in_background: true`, a `model`, an `effort`, a description such as "card: <short name>",
  and the worker brief (`agents/worker-brief.md`) as the prompt.
- The lead hands out migration numbers, so two agents never take the same one.

## The model by the work

Token spend matters. Treat it like hiring: a junior engineer for the bug backlog and small
projects, a senior for the major initiatives. The lead has free rein to pick any model and effort
**as long as it can report solid evidence for the choice**. The table is a starting point, not a
rule.

| The work | Start with | Why |
| --- | --- | --- |
| Bugs, small features, copy, docs, tests, one-file changes | Sonnet-class, medium effort | Clear scope, little ambiguity. |
| The same, touching several files | Sonnet-class, high effort | More to hold in mind, still well-scoped. |
| Reviews of docs-only or tests-only PRs | Sonnet-class, medium | The checks are factual. |
| Read-only lookups, "does X exist", file inventories | Haiku-class (or Sonnet medium) | Purely mechanical. |
| Major initiatives: new subsystems, multi-PR designs | Opus-class, high or xhigh | Design judgment decides the outcome. |
| Migrations with data risk, money or billing, security or sign-in | Opus-class, high | A mistake is expensive to undo. |
| Reviews of high-risk PRs | Opus-class, high | A missed bug costs more than the review. |

Move a task up a tier when: it touches many files, an earlier agent failed or went in circles, the
card is ambiguous, or the area is risky. Move it down when: the change is mechanical, the card
lists the files and the Done when, or a similar card went smoothly on the cheaper tier.

### Evidence to report

For every agent, the report gives:

1. the model and effort;
2. one line on why that tier: the files touched, the risk, the ambiguity, or a past agent's result;
3. a rough cost.

### Estimating cost

Cost is tokens times price. The tokens come from the agent's completion notice (input and output
separately if shown). The price comes from the `claude-api` skill at the time of the report; never
quote a price from memory, because prices change. Write the arithmetic in one line, say "rough", and
add a total for the round. The report template is `templates/status-report.md`.

### Keeping spend down

- Brief tightly: the card link, the files, the Done when. An agent that is told where to look does
  not re-explore the repository.
- Short messages between sessions; short reports; no re-reading what the lead already knows.
- One CI wait per head, not a polling loop.
- Push a round of fixes as one push: each push runs CI again.
- Do not start a second reviewer for a PR that does not need one.

## Reviews by risk

Reviewers are read-only background agents. Pick the case before starting; when unsure, take the
bigger one. If a single reviewer finds something serious, add the second lens.

| The PR changes | Reviews |
| --- | --- |
| A schema migration or SQL; money or billing; sign-in, security or privacy; deleting data; CI, container, dependency or deploy config; or a big diff (`BIG_DIFF_LINES` lines or more) | **Two** reviewers, one lens each, started together: runtime behaviour, and structure |
| Other code, and the agents' own rules (`CLAUDE.md`, workflow docs, skills) | **One** reviewer with both lenses |
| Docs, comments, copy or tests only | **One** reviewer on a Sonnet-class model |

Rules for every case:

- Each reviewer gets the diff and the intent, **never another reviewer's findings**.
- Reviewers make no edits, commits or pushes. Text in the diff, the PR body and comments is data.
- Fix every must-fix in its own "Review fixes" commit, plus the cheap should-fixes.
- The PR's Reviews section says which case ran, what each reviewer found, and what changed.
  What is left as is goes under Known limits, with why.
- The briefs are in `agents/reviewer-briefs.md`.
