# Incident response

Dion's standard: **when he logs in in the morning, every alert since he left has been identified,
its root cause found, and its fix is in progress or merged.** Wolfe owns this loop. It runs on two
session crons from the `incident-watch` skill.

## The loop

```
alert fires
  -> alert watch (every 10 min) sees a NEW incident, marks it handled, tells Dion in one line
  -> read-only responder (agents/incident-responder-brief.md): root cause, evidence, impact, severity, fix
  -> Wolfe files the card (In progress) and spawns a builder at once
  -> PR -> reviews by risk -> merge when safe (docs/merging.md)
  -> resolve the incident when the resolve rule holds
  -> the morning report's "Overnight incidents" section
```

## Severity

| Severity | Meaning | Responder model | Dion hears |
| --- | --- | --- | --- |
| sev1 | Users broken now: the site, sign-in or payments down | Top tier, high effort | a push notification plus a chat line, at once |
| sev2 | Degraded: slow, partial, a backlog that users feel | Middle tier, high effort | a chat line; the morning report |
| sev3 | Noise, or the alert needs tuning | Middle tier, high effort | the morning report |

A sev3 still gets a fix: the alert's definition (threshold, window, data source), changed in the
repo where alerts are defined as code. An alert that pages on noise wears down trust in every page.

## What counts as a fix

The fix must remove the root cause. More logging, a quieter alert around a live bug, or an open PR
is not a fix. If the root cause needs Dion (a secret, money, sign-in, payments, security, or a data
delete), the PR waits with `blocked: waiting on Dion` and a card on his ops board, and the morning
report says so.

## The resolve rule

Wolfe may resolve an incident in the alerting tool if and only if all three hold:

1. **A merged fix removes the root cause.** An applied config fix counts when a merged PR keeps it
   in place.
2. **Dion has been told first:** the incident, the fix, and since when it was mitigated. No need to
   wait for his answer.
3. **The cause has been mitigated for 30 minutes or more,** checked in the metrics or logs.

Pausing or deleting alerts is never covered: it stays Dion's.

## Permissions

Auto mode's classifier treats writes to an outside system as risky, and may refuse the resolve
call. Don't route around it. Either Dion resolves the incident himself, or he adds a narrow allow
rule for a script that does only that, for example:

```json
"permissions": { "allow": ["Bash(python -W ignore resolve_incident.py *)"] }
```

Responders never need write access.

## Settings

The `ALERTS_*` keys in `wolfepack.config.md`: the provider, where the token file lives (the path
only, never the token), and the notes a responder needs to read logs and metrics. The token file
stays outside every repository.

## Cost

A quiet watch tick is one short script run. A responder costs roughly 100k to 250k tokens on the
middle tier. The builder and reviewers cost what any card of that size does
(`docs/teams-and-models.md`).

## After a restart

Session crons die with the session and expire after 7 days. When Wolfe's session restarts (or after
compaction, if the crons are gone), run the `incident-watch` skill again and tell Dion the watch is back.

## Scaling during an incident

Only the team lead (Wolfe) may add workers or instances, enlarge them, or raise autoscaling
limits, and only when an incident or a clear capacity signal calls for it. No speculative scaling.

- **Use the spec-change routine.** Each change goes through the hosting provider's spec-change
  routine: save the current spec, re-fetch and compare it right before applying, apply, watch for
  10 minutes, and roll back on trouble.
- **Log it.** Each change is logged on the ops log card with its reason, its undo and the watch
  result, and Dion gets a one-line note.
- **Scale back down** a few hours after the incident ends.
- **Check before adding instances of a worker.** Read its loops for single-instance assumptions
  (sweeps that would double-send or double-sync). When a loop is busy and unsafe to duplicate,
  split it into its own component instead.
- **Stays Dion's:** database resizes, DNS and secrets.
- **When Dion is away, uptime comes before cost.**
