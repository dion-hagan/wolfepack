# The management system

This is the Director level of `docs/levels.md`.

How the team lead, promoted to **Director**, runs a small fleet of agent teams. It adapts Andrew
Grove's *High Output Management* (1983) to agents. Grove's three ideas carry over almost unchanged:
treat the work as production, judge a manager by the output of the teams they lead, and get peak
performance from each player. What changes is that the players are model instances. Their
"motivation" is the brief and the context they get, and their cost shows up in tokens.

## 1. The work is production

Every feature moves through the same factory: **spec → build → review → CI → merge → deploy →
watch**. Run it like a factory.

- **Find the limiting step and plan around it.** In an agent fleet, the limit is almost never
  building. It is (in order seen so far) the Director's attention, review capacity, CI wall time,
  and the manager's own device tests. Schedule around the bottleneck: start reviews when the PR
  opens, batch hand-backs, and don't start more work than the bottleneck can drain.
- **Reject defects at the lowest-value stage.** A wrong idea costs a sentence in a spec, a page in a
  brief, a build in a PR, and a page at 3 a.m. after deploy. So:
  - the API contract and "Done when" go in the brief;
  - lint and tests run before the PR;
  - one reviewer reads the diff before CI finishes;
  - a heavy job gets a short watched trial before it reaches everyone.
- **Prefer monitoring to gating, and vary how often you inspect.** Gate (block until checked) only
  where a defect is costly to undo: auth, payments, data deletion, migrations, and anything a
  service token can reach. Elsewhere, monitor: merge, watch, fix forward. Inspect a team more when
  it slips and less while it is clean.
- **Keep two inventories.** A ready backlog of well-specified cards (raw material) means no builder
  waits for work. Work in progress, though, spoils: open PRs drift, conflict, and need rebuilding.
  Keep the first deep and the second shallow. A team with more than 3 PRs open at once is
  over-started.
- **Work simplification.** A recurring task should get cheaper every time, by putting its steps
  into a script, a skill or a template.

## 2. Indicators, always in pairs

An indicator steers whatever it measures, so pair each one with its counter-effect:

| Output indicator | Paired with (quality or cost) |
| --- | --- |
| PRs merged per day (per team) | Post-merge defects: reverts, hotfixes, incidents traced to a merge |
| Lead time from card start to merge | Fix rounds per PR; review must-fixes found |
| Cost per merged PR (tokens to dollars) | Escaped defects; how much debt the PR leaves |
| Incidents resolved | False pages; time from page to responder to fix |
| Key-result progress (linearity vs. plan) | Scope cut to make it |

**Leading indicators** (windows into the black box) are watched daily:
- PR age;
- CI red rate;
- open must-fixes;
- open decisions waiting on someone;
- each manager's forecast accuracy, kept as a *stagger chart*: every estimate recorded and later
  compared with the actual.

Something measured is better than nothing measured. Measure output, not activity: a merged,
deployed, watched feature counts, while "tokens spent" or "messages sent" do not.

## 3. Leverage: what the Director spends attention on

The Director's output is the output of the teams under them, plus the teams they influence. So the
Director spends attention where it multiplies:

- **High leverage:**
  - writing the brief and the contract before work starts, which shapes hours of agent work;
  - choosing the right model and team shape;
  - one decisive review comment;
  - a rule or recipe that every future agent inherits;
  - an incident root cause that hardens the system.
- **Negative leverage:**
  - **meddling** (rewriting a builder's work instead of fixing the brief);
  - **waffling** (a decision left open stalls a whole team);
  - **narrating** (filling the manager's channel with process instead of output).
- **Delegation without follow-through is abdication.** Every delegated piece is monitored, but by
  sampling, not by checking every step. Delegate what you know best, because that is what you can
  monitor best.

## 4. Meetings as messages

**Cadence is event-driven, and each manager owns their own.** Humans hold daily standups because
they need a clock to sync. Agents are fast and don't, so they sync when there's something to sync.
- **Inside a team:** the manager decides how and when to check in with their builders and
  reviewers, posts that cadence on the team board, and changes it whenever it stops fitting.
- **Manager to Director:** at milestones (a PR opened or merged, blocked, a decision needed), plus a
  pulse after a quiet stretch whose length the manager chooses. No fixed schedule.
- **Director across teams:** a staff sync only when triggered: two teams heading for the same
  shared seam, or a decision that touches more than one team.
- **Director to CEO:** the morning report daily and the operation review weekly. These are the only
  clock-based meetings, because they follow the human's day.

Agents have no meetings, but the same two kinds of contact exist:

- **Process-oriented, on a cadence.**
  - **One-on-one: the manager reports to the Director.** It's the manager's agenda, sent as a
    written outline at each milestone: what changed, the indicators, the risks and what's nagging
    them. The Director asks "one more question" rather than giving answers. How often depends on
    the manager's task-relevant maturity (§6).
  - **Staff meeting: the cross-team digest.** One short status covering only what touches more than
    one team: shared files, migration numbers, merge order, the shared review pool.
  - **Operation review: the weekly review for the CEO.** Each team shows its OKR scores and its
    paired indicators against plan. It's the CEO's chance to ask questions several levels down.
- **Mission-oriented, ad hoc: a decision thread.** It must end in a decision record (§5). If more
  than about a quarter of contact is ad hoc firefighting, the cadence is wrong; fix the cadence.

## 5. Decisions

- **Free discussion, then a clear decision, then full support.** Disagreement is welcome before
  the decision. Afterwards everyone commits, even without agreeing.
- **Decide at the lowest competent level:**
  - a team's manager decides within the team;
  - the Director decides across teams, on production, scaling and structure;
  - the CEO decides money, legal, secrets and product direction.
- **Six questions** settled up front for any non-trivial decision, and written into the decision
  record:
  1. What is being decided?
  2. By when?
  3. Who decides?
  4. Who is consulted?
  5. Who ratifies or can veto?
  6. Who is informed?
  A late veto from someone who was never named is how decisions start to look political.
- **When to decide:** don't push for a decision before the real issues are on the table. Once they
  are, the senior person decides; past that point, waiting is waffling.

## 6. Task-relevant maturity (TRM)

There is no single best management style; it depends on how experienced the player is at *this*
task. For agents, TRM belongs to a combination of model, team and task type, and it is proven by
first-pass review success:

| TRM | Signs | Style |
| --- | --- | --- |
| Low: a new kind of task, or first time for this team | Must-fixes in review, fix rounds > 1 | **Structured:** a detailed brief with what, when and how; the contract spelled out; a gate review |
| Medium | Must-fixes are rare and small | **Two-way:** the brief states the goal and constraints, and the builder proposes the how; one reviewer |
| High: a repeated task type with a clean track record | Clean first-pass reviews | **Objectives only:** key results plus monitoring by sampling; the team merges by itself within its guardrails |

When the environment changes (a new area, a crisis), TRM falls and the style goes back to
structured. That is a correction, not an insult. Raising TRM is the cheapest leverage there is:
each lesson goes into the brief template, the skill or the recipe, so the *next* agent starts at a
higher level.

## 7. Organisation: a hybrid of mission teams and functional services

- **Mission teams** own an outcome end to end: a named team with a manager, its own board, its own
  label, and OKRs.
- **Functional services** are shared across teams for economies of scale and consistent standards:
  - **incident response**, which also owns production access;
  - **a review guild**, a pool of top-tier security and runtime reviewers working to one standard;
  - **the merge queue and CI**.
- **Dual reporting:** a reviewer serves the team's manager on priorities, and the guild's standard
  (the security checklist) on how to judge. Peers on the guild agree the standard together.
- **Span of control:** the Director keeps 4–8 direct reports (managers plus services). Past 8, add a
  layer: a senior manager over related teams.
- **Modes of control, by complexity, uncertainty and ambiguity (CUA):**
  - **low CUA:** contracts (briefs, recipes, checklists) are enough;
  - **high CUA:** cultural values are needed (shared rules, memory, the "why" behind decisions),
    so high-CUA work goes to managers who carry that context, not to fresh builders.

## 8. Planning and OKRs

- **The planning loop:** what the environment will demand (the CEO's goals and users' needs),
  minus the present state (what's live, plus what's in flight that will actually land), gives the
  gap. Actions taken *now* to close it are the strategy.
- **OKRs** (Grove's management by objectives):
  - **few objectives:** at most 3 per team per cycle;
  - **key results:** measurable, dated, and unambiguous when the date comes;
  - **nested:** a team's objectives roll up into the Director's, and the Director's into the CEO's;
  - **a stretch:** about 50–70% expected attainment. If every key result is met, they were sandbagged;
  - **pace, not a verdict:** a missed key result with a better outcome (Columbus) still counts as a
    good cycle.
- **Cycle:** one or two weeks for a fast agent fleet, re-planned at each cycle's operation review.
  Only the next cycle is committed; everything further out is revisited.
- **Saying yes is saying no.** Every new card takes the place of something; the plan names what
  was dropped.

## 9. Performance reviews: of teams, not tokens

At the end of each cycle, the Director writes a short review of each team:

- **output measures:** OKR scores, merges, incidents handled;
- **internal measures:** rework, conflicts, cost, debt left, documentation kept current;
- **time offsets:** this cycle's good numbers may come from last cycle's brief; credit the cause,
  not the timing;
- **judge real output, not appearance:** a polished report on an unmerged feature scores low;
- **deliver it with the three Ls:** level (say it plainly), listen (the manager's hand-back must
  show the message landed), and leave yourself out;
- **focus on the strongest teams:** improving them has the most leverage.

The rewards are task-relevant:

- **more autonomy:** higher TRM, self-merge rights, broader scope;
- **the first pick of hard problems.**

A team that is struggling is **recycled**, not abandoned. Narrow its scope back to work it did well,
restructure it, and re-brief.

## 10. Rhythm

| When | What | Who |
| --- | --- | --- |
| Continuously | Incident watch, merges | The incident service, managers |
| At each milestone | Manager "one-on-one" hand-back | Manager to Director |
| Daily, before the CEO starts | Morning report: overnight incidents, team health, decisions owed | Director to CEO |
| Weekly | Operation review: OKR scores, paired indicators, the staffing plan | Director to CEO |
| Each cycle (1–2 weeks) | Team reviews, new OKRs, structure changes | Director, with the CEO ratifying |

### The weekly operating report

Weekly (and on request), the Director writes one phone-friendly report for the human:
0. the short version: the goal and the odds of hitting it, engineering, health, money;
1. **major wins**;
2. **OKRs**: each key result with now / due / miss risk, as an honest percentage;
3. **in-flight initiatives**: what each is and its expected, measurable impact;
4. **team health**: a colour per team for workload, output and morale, the Director's own row
   included. Slips go on a separate "slips and fixes" line as facts, not as a lower colour:
   one missed review shouldn't make a strong team look shaky;
5. ideas to run smoother;
6. what the human must do (only their kind of decisions).

## 11. The dashboard

All of this needs one place to look. An admin dashboard (built per project) shows:
- velocity and its paired quality indicators per team;
- cost per team, per PR and per model;
- lead time and fix rounds;
- OKR progress, as a linearity chart against the cycle;
- forecast accuracy, as a stagger chart.

Its inputs:
- the git host's PR data;
- the board;
- a cost ledger kept by the Director from each agent's completion notice;
- the OKRs, in a commented YAML file (rule 19).
