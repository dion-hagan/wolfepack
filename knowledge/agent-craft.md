# Agent craft: what makes agents effective

### Match the model to the risk, not the size
- Seen: top-tier security reviewers caught real holes the builders and mid-tier structure reviewers
  missed:
  - a suspension that hid profiles but still served the account's media through signed links;
  - an alert guard that would silence itself during a crash loop;
  - a token that could lift legal holds.
  Mid-tier reviewers on structure-only passes rarely found anything the top-tier reviewer didn't.
- Now:
  - top tier: auth, tokens, queue claims, migrations and money;
  - mid tier: frontend and one-area builders;
  - lowest tier: purely mechanical edits only.
  Use one dual-lens top-tier reviewer per risky PR, rather than two serial reviewers.

### Rough cost per role (one evening's data)
- Builders on the top tier: 200k–330k tokens per feature.
- Builders on the mid tier: 90k–300k.
- Reviewers: 75k–170k.
- Incident responders: 90k–145k.
- A full feature with reviews and one fix round: about $10–12 on the top tier.
Coordination is the scaling limit, not tokens: conflicts in shared files added about 15% in CI
reruns, and the lead's context added 5–10k tokens per team per feature.

### Fix the seams that make parallel work collide
- Seen: four parallel ops-API builds each added routes to one huge server file and a shared route
  snapshot. They kept conflicting and kept pushing the file past its size cap. One builder raised
  the cap.
- Now: a single dispatcher registers each module's routes, so a new module never touches the
  server file. Size caps are never raised: code moves out into a new module instead.

### One mechanism, not two
- Seen: two teams each built a "run a one-off job" mechanism in the same week.
- Now: the board shows work in progress across teams. When a second mechanism appears, the
  speed-critical one merges as it is, and a follow-up card folds it into the general one and
  deletes the duplicate.

### Agents that keep reporting
- Seen: some agents with background tasks re-sent the same final report several times.
- Now: once a report is in and nothing more is needed, stop the agent.

### Shell pitfalls on Windows Git Bash
- `python -` (a script on stdin) starts a hanging interactive prompt on some Windows Python
  installs. It happened more than once, even with a written rule, so write a `.py` file instead.
- Arguments starting with `/` are rewritten into Windows paths. Set `MSYS_NO_PATHCONV=1` when
  calling an API client with URL paths.
- Unicode output (emoji) can crash a cp1252 console. Set `PYTHONIOENCODING=utf-8`.
- Bash commands over about 8 KB fail; put long scripts in a file.

### A connector can't move cards between boards
- Seen: moving a card from one board to another failed through the board connector.
- Now: team boards hold link cards pointing to the main-board card; new work is filed straight on
  the team board.

### Scrub before you commit to a public repo: a non-empty grep is a hard stop
- Seen: a project-specific brief was copied into the public setup repo, the generic rewrite failed
  (a file-state error), and `git add -A` committed and pushed the copy. It was fixed minutes later,
  but it stayed in the public history.
- Now: run the scrub grep BEFORE `git add`; any hit stops the commit. Write new generic files fresh
  rather than copying project files and editing them down.

### Most of the bill is re-read context; keep agents short-lived
- Seen: one day of about 40 merged PRs cost about $25-30 per PR at API prices. About 85% of it was cache
  reads: the average top-tier call re-read about 316k tokens of its own history. The output was
  about 3%.
- Why: every call re-reads the whole conversation. Long-running managers, directors and builders on
  their fifth fix round pay for their entire past on every step.
- Now: four rules in every brief. Hand off at about 200k tokens of context; one fresh agent per PR;
  the mid tier by default (the top tier for security, concurrency, migrations and design); no
  polling turns (one blocking CI wait, not a loop of tool calls). And pace the work to the
  subscription's weekly and 5-hour windows, so that extra usage stays near zero.

### A design question to the human is a cost; decide at the lowest competent level
- Seen: in one day the human was asked about effect tiers, defaults, phase order and a contest
  prize, and pushed back: "you're asking me too many design questions, this is your project too".
- Why: every question waits on the busiest person and stalls a team.
- Now: the owning manager recommends, the Director confirms, a decisions log records it, and the
  weekly report summarises it (`agents/manager-brief.md`, house rules).

### Messages between agents cost a wake-up, not words
- Seen: asked whether agents could talk in a denser language to save tokens. A message is cheap;
  waking an idle session to read it re-reads its whole context (100k+ tokens).
- Why: billing is dominated by re-read context, not message length.
- Now: batch messages, no acknowledgements, "no reply needed" on FYIs, plain English for auditability.

### A test that asserts the planner's choice on a tiny table is flaky
- Seen: a test expected an index-only scan on a 2-row table; CI failed unrelated PRs at random, and
  locally it failed every time.
- Why: `VACUUM` can't mark pages all-visible while another pooled connection holds an older
  snapshot, so an index-only scan pays heap fetches and ties with a plain scan of another index.
  (Turning off plain index scans doesn't help: it disables index-only scans too.)
- Now: give the index real selectivity (hundreds of older rows), or assert the index's definition
  instead of the plan. Reproduce about 20 times before merging. A test that fails an unrelated PR
  twice gets a card at the top of its owner's Ready list the same day.

### Connectors have shapes; check them before promising a format
- Seen: a file-storage connector could only create text files, so PDFs couldn't be uploaded.
- Now: upload HTML versions, and use the connector's server-side copy to avoid re-sending content.
