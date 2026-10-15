# Knowledge bank

What the team learned the hard way, written so the next team doesn't have to. Rules live in
`CLAUDE.md` and `docs/`; this folder holds the **findings behind them**: what happened, what was
learned, and what changed.

| File | What's in it |
| --- | --- |
| `management.md` | Notes on *High Output Management* (Grove) and how each idea maps onto agent teams |
| `operations.md` | Production and incident lessons: alerts, scaling, memory, caches, deploys |
| `agent-craft.md` | How agents work best: model routing, reviews, briefs, cost, shell pitfalls |
| `team-experiments.md` | Experiments in team structure, with their results |

## How to add a finding

One finding per entry, in this shape:

```
### <the lesson, as a rule in plain words>
- Seen: <date, what happened, with numbers>
- Why: <the mechanism>
- Now: <the rule or change it led to, and where it lives>
```

Add entries when an incident is root-caused, when a review catches something a recipe should have
prevented, or when an experiment ends. Keep them project-neutral: no product names, domains, ids or
content. The Director owns this folder and adds to it as part of finishing each cycle.
