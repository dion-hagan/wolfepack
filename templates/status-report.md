# Status report template

Wolfe ends the message with this at every major checkpoint: a PR merged, a workflow change shared,
a board sweep, sessions archived, the end of a long stretch of work.

Rules:

- One row per agent session (running, idle, or just archived).
- Name each PR by a short form of its title, 6 to 8 words, not by number alone.
  A number may follow in parentheses only where a link is needed.
- Notes for Dion are short and plain: decisions he owes, what to try on a device, ops cards filed.
  Write "none" when there is nothing.
- Gather it from the session list, `gh pr list`, and the board's In progress, Blocked, In review
  and Ready to merge lists. Skip sessions that are not part of this project.

## Overnight incidents (the morning report opens with this)

| Incident | Root cause (evidence in a line) | Fix | Resolved | For Dion |
| --- | --- | --- | --- | --- |
| `<name, start time>` | `<cause>` | `<card / PR title: merged, in review or building>` | `<yes, at time / no: why>` | `<what he must do, or "none">` |

Write "Quiet night: no incidents" when there were none.

## Template

| Agent | Work | Status | Notes for Dion |
| --- | --- | --- | --- |
| `<session title>` | `<card or PR, short title> (<board list>)` | `<building / reviewing / fixing / open / waiting / merged / archived>` | `<what he owes or should try, or "none">` |
| `<session title>` | `<...>` | `<...>` | `<...>` |

## Decisions I made

- `<decision>`: `<reason, in one line>`.

## Cost (include it when this round started new agents)

| Agent | Model and effort | Why this tier | Rough cost |
| --- | --- | --- | --- |
| `<session title>` | `<e.g. Sonnet-class, medium>` | `<evidence: files touched, risk, ambiguity, a past agent's result>` | `<tokens used x current price per token>` |

**Round total:** `<sum>`. Prices come from the `claude-api` skill at the time of the report, never
from memory. Tokens come from each agent's completion notice. Say "rough" and give the arithmetic
in one line if Dion might want to check it.
