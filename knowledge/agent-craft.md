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
