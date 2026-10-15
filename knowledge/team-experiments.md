# Team-structure experiments

### Experiment 1: parallel backend/frontend on a fixed contract, one dual-lens reviewer (in progress)
- **Before:** one builder, then two serial reviewers (security, then structure), then fixes, then a
  re-check. The frontend waited for the backend to merge. About $10–12 and 2–3 hours per feature.
- **Change:**
  - the backend (top tier) and frontend (mid tier) are built in parallel against an API contract
    written into both briefs, with the frontend testing on a stand-in;
  - one top-tier reviewer per PR covers both security and structure, starting when the PR opens;
  - a re-check happens only after a must-fix;
  - fix rounds go back to the same builder in one push.
- **Measuring:** wall time from start to merge, tokens per agent, defects caught by review vs. after
  merge, and escalations to the Director.
- **Result:** pending.

### Experiment 2: managers per team (in progress)
- **Change:** each mission team gets a manager agent (top tier, medium effort). It owns staffing,
  reviews, fix rounds and merges, and reports to the Director only at milestones. Each team has a
  clever name, a coloured label for its PRs, and its own board.
- **Hypothesis:** the Director's context is the scaling limit; managers absorb the builders' and
  reviewers' handoffs, so more teams can run in parallel.
- **Early signal:** within 10 minutes, one manager escalated a real cross-team conflict (a duplicate
  mechanism being built by another team) with a proposal and a fallback, and it was settled in one
  reply.
- **Result:** pending.
