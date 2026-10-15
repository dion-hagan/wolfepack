# Management: notes on *High Output Management* for an agent fleet

Andrew Grove, *High Output Management* (1983). These are notes in our own words, with each idea
mapped onto running teams of AI agents. The full system built from them is
`docs/management-system.md`.

## The three big ideas

1. **Manage work as production.** Every kind of work (a meal, a hire, a compiler, a PR) is a flow:
   process steps, assembly steps and test steps. Production discipline (limiting steps, inspection
   at the lowest-value stage, inventory and capacity trade-offs) applies to knowledge work too.
2. **A manager's output is the output of the teams they lead or influence.** The manager's own
   activities (gathering information, deciding, nudging, being a role model) only count through
   their effect on the teams' output. So a manager picks the activities with the highest
   *leverage*.
3. **Teams perform only as well as their players.** Players underperform for one of two reasons:
   they can't (fix it with training) or they won't (fix it through motivation). The style that
   works depends on the player's *task-relevant maturity*.

## The ideas we use, and their agent equivalents

### Limiting step
The whole flow is planned around the slowest or most critical step, and everything else is offset
from it. **For us:** the limiting step is rarely the builder. It is the Director's attention, review
capacity, CI time or the human's device tests. Plan around those, and don't start more work than
they can drain.

### Reject at the lowest-value stage
A bad egg should be caught at delivery, not on the customer's plate. **For us:** fix an idea in the
brief rather than the PR, and fix a PR in review rather than after the deploy. A contract in the
brief and a reviewer starting when the PR opens both move the inspection earlier.

### Gate vs. monitor, and variable inspection
A gate holds everything until it's checked; a monitor samples and lets work flow. Inspect more when
quality slips and less when it's steady. **For us:** gate only where an escape is expensive (auth,
money, deletes, migrations, anything a privileged token can reach). Monitor everything else, and
change how often depending on the team's track record.

### Inventory: keep raw material, but not work in progress
Raw material is cheap to hold; work in progress spoils. **For us:** keep a deep backlog of
well-specified cards so builders never wait. Keep open PRs few, because they drift and conflict.
A team with more than 3 PRs open at once is over-started.

### Indicators, paired
Measure output, not activity. Pair every indicator with one that shows what it costs, or it will
pull work in the wrong direction (more speed needs to be paired with escaped defects). Use leading
indicators as "windows into the black box": PR age, CI red rate, open must-fixes. Use a stagger
chart to track how forecasts change over time.

### Leverage
High-leverage activities:
- affect many people;
- shape someone's work for a long time from a short effort;
- supply one key piece of knowledge.
For us: the brief, the contract, a recipe, a root cause, one decisive review comment.
Negative leverage:
- meddling (doing the subordinate's job for them);
- waffling (an undecided matter stalls a team);
- arriving unprepared.

### Delegation needs monitoring
Delegating without following up amounts to abdication. Monitor by sampling, at the lowest-value
stage (read the outline, not the final polish). Delegate what you know best, because you can
monitor it best.

### Meetings are the medium of managerial work
- **Process meetings run on a cadence:**
  - the one-on-one: the subordinate's agenda, a written outline, the manager asks "one more
    question";
  - the staff meeting: only what affects more than two people;
  - the operation review: teaching across several levels.
- **Mission meetings are ad hoc,** for one decision, with an agenda and minutes.
- If more than about a quarter of time goes to ad hoc meetings, the organisation is wrong.
**For us:** milestone hand-backs, a cross-team digest, the weekly review for the CEO, and decision
threads that end in a decision record.

### Decisions
- **The process:** free discussion, then a clear decision, then full support. Supporting a
  decision doesn't require agreeing with it.
- **Who decides:** the lowest competent level.
- **Six questions up front:** what, when, who decides, who is consulted, who ratifies, who is
  informed. Settling these keeps a late veto from looking like politics.
- **Peer groups** stall without a senior "plus one" to frame the decision.
- **Timing:** decide too early and you miss the real issues; decide too late and you're waffling.

### Planning and MBO / OKRs
- **The planning loop:** what the environment will demand, minus the current state, gives the gap.
  The strategy is what you do *now* to close it.
- **Only the next period is real;** everything after it gets re-planned.
- **Few objectives.** Key results are dated and unambiguous, and objectives nest up the hierarchy.
- **Stretch goals** are set so about half are reached.
- **OKRs pace the work; they are not a legal contract.** Columbus missed his objective (a route to
  the East) and still had a great result (the New World).

### Hybrid organisations, dual reporting, multiple planes
- **Every sizeable organisation ends up a hybrid:** mission units for responsiveness, functional
  units for economies of scale and shared expertise.
- **Dual reporting makes the hybrid work:** a manager sets priorities, a peer group sets the
  professional standard.
- **One person can sit on several planes,** such as a team and a standards council.
**For us:** mission teams with managers, plus shared services (incident response, a review guild,
the merge queue). Reviewers answer to a team for priorities and to the guild for standards.

### Modes of control
- **Free market** (self-interest and price): for simple, well-priced exchanges.
- **Contract** (rules and monitoring): when value is hard to price.
- **Culture** (shared values, so the group's interest comes first): when complexity, uncertainty
  and ambiguity (CUA) are high.
High self-interest combined with high CUA produces chaos. **For us:** briefs and recipes are the
contract for low-CUA work. High-CUA work goes to managers who carry the shared rules, memory and
reasons.

### Task-relevant maturity (TRM)
- **Low TRM:** structured (what, when and how).
- **Medium TRM:** two-way, focused on the person and their reasoning.
- **High TRM:** set objectives and monitor.
TRM is specific to the task, and it drops when the environment changes. Raising it is the cheapest
leverage there is. **For us:** TRM belongs to a combination of model, team and task type, measured
by first-pass review success. Lessons go into templates, so the next agent starts at a higher level.

### Performance reviews
- **Purpose:** improving future performance is the main point.
- **Balance:** weigh output measures against internal ones.
- **Time offsets:** watch for them; this year's numbers can come from last year's work.
- **Avoid the "potential trap":** judge performance, not form.
- **Delivery:** level, listen, leave yourself out.
- **Focus:** a few messages, not a laundry list.
- **Spend the most effort on the stars,** because that's where the leverage is.
- **When someone was promoted beyond their ability,** recycle them; don't fire them.
**For us:** a short review of each team at the end of each cycle. Autonomy is the reward, and a
struggling team gets restructured.

### Span of control and interruptions
- **Span of control:** 6–8 direct reports. More means drowning; fewer means meddling.
- **Interruptions:** cut them with batching, standard answers and scheduled office hours.
**For us:** the Director keeps 4–8 direct reports, and managers absorb their builders' hand-backs.
The CEO hears from us in the morning report and the weekly review, not in a constant stream.

## Applied, cycle 1 (field notes)

### WIP limits in practice
- Seen: one team had 3 PRs in review plus 3 builders running when it proposed starting a new
  feature.
- Now: held until it's down to 3 open PRs. Grove's point that work in progress spoils held up:
  every extra open PR meant more re-syncs, CI reruns and conflicts.

### Variable inspection applied to merging
- Seen: with four teams merging, main moved during almost every 10-minute CI run, so PRs kept
  re-syncing and starved.
- Now (a trial): a PR may merge without re-syncing when CI is green on its head and the commits it's
  behind by touch none of its files, add no migration, aren't reverts, and avoid the shared seams.
  The merger watches main's post-merge CI and reverts within 15 minutes if it goes red. The gate
  stays where clashes actually happened; everything else is monitored. Measure: post-merge red
  rate, with an early stop above 5%.

### Cadence: event-driven, owned by the manager
- Humans hold daily standups because they need a clock. Agents don't: each manager picks their own
  team's cadence and posts it, and reports to the Director on events plus a self-chosen quiet-stretch
  pulse. Only the human-facing meetings (the morning report, the weekly review) run on a clock.

### Results belong on the work item, and urgent work parks something else
- Seen: a manager handing off to a fresh session had two fix rounds and a review still running. Their reports would have gone to the old session. The same night, one team reached 6 open PRs against a limit of 3, because each urgent ask arrived after the previous one had started (several came from the Director).
- Why: a sub-agent reports to whoever spawned it, so in-flight work ties a manager to its session. And "urgent" with nothing parked is just more work in progress, which Grove's limiting-step logic says slows everything.
- Now: every builder and reviewer also posts its result as a PR comment; a session hands off between pieces of work, or stays idle-alive until its agents post. The WIP limit is hard: an urgent ask, which only the human or the Director can declare, parks another item instead of adding one.
