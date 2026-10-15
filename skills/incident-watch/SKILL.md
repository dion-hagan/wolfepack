---
name: incident-watch
description: Wolfe's incident response loop. Start the alert watch (every 10 minutes) and the morning report, send a read-only responder after each new incident, then file a card, build the fix, review it and merge it. Use when <MANAGER_NAME> asks Wolfe to watch alerts, or after a session restart, to re-create the watch.
---

# Incident watch

<MANAGER_NAME>'s goal: **when they log in in the morning, every overnight alert has been identified and
root-caused, and its fix is in progress or merged.** Wolfe runs this; agent sessions don't.
The loop and its rules: `docs/incident-response.md` in the wolfepack repo.

## Start it

1. Check the settings: `ALERTS_TOKEN_FILE` names a file holding the alerting provider's API token
   (`wolfepack.config.yaml`, keys `ALERTS_*`). Never print the token or paste it anywhere.
2. Run `python alertwatch.py` (this skill's folder) once.
   - The first time, mark the history as handled with `--mark`, after sending a responder to
     anything still open that matters.
3. **Start the primary watch as a background task:** `bash <skill dir>/alertwait.sh` (run in the
   background). It polls every 2 minutes and exits on a NEW incident, and its completion notice
   reaches Wolfe even mid-turn. **Session crons fire only while the session is idle**, so a busy
   evening silences a cron-only watch. After handling an incident, run `alertwatch.py --mark` and
   start `alertwait.sh` again.
4. Create two crons as the backup and the report (CronCreate; both live only for the session and expire after 7 days, so
   re-create them after a restart and tell <MANAGER_NAME>):
   - **Watch** every 10 minutes, at off minutes (e.g. `4,14,24,34,44,54 * * * *`), with the
     prompt in "The watch prompt" below.
   - **Morning report** daily shortly before <MANAGER_NAME> starts (e.g. `47 7 * * *`), with the prompt
     in "The morning report" below.

## The watch prompt

> Alert watch (keep it cheap). Run `python <skill dir>/alertwatch.py`.
> - Output `quiet`, or only STILL OPEN lines already handled: one line, no action. If a STILL
>   OPEN incident now meets the resolve rule (docs/incident-response.md), tell <MANAGER_NAME>, then resolve it.
> - Output with NEW lines:
>   1. Run the script again with `--mark`.
>   2. Spawn one read-only responder per new incident (group related ones) with
>      `agents/incident-responder-brief.md`. Use the middle model tier at high effort, or the top
>      tier for sev1.
>   3. Tell <MANAGER_NAME> in one line what fired and that a responder is on it. For sev1, also send a push
>      notification.
> - When a responder reports:
>   - File a card (In progress) with the cause and evidence.
>   - Spawn a builder at once. The fix must remove the root cause; more logging is not a fix.
>   - Review it by risk and merge it when safe.
>   - Anything that needs <MANAGER_NAME> goes to their ops board, and the PR is labelled
>     `blocked: waiting on <MANAGER_NAME>`.
>   - If it's only alert noise, fix the alert's definition in the repo.
> - `ALERTWATCH READ FAILED`: retry next tick; tell <MANAGER_NAME> if it fails twice in a row.

## The morning report

> Morning report for <MANAGER_NAME>. Open with "Overnight incidents": one line each, giving the incident,
> its root cause, the evidence, the fix (card, PR title, and merged / in review / building),
> whether it was resolved, and anything they must do. Then the status table
> (`templates/status-report.md`) and the overnight cost.

## Never

- Let a responder write to production, the alerting provider, or GitHub. Responders only read.
- Pause or delete an alert, or resolve an incident outside the resolve rule.
- Route around a permission refusal. Tell <MANAGER_NAME> the incident is eligible and let them act, or have
  them add a narrow allow rule (docs/incident-response.md, "Permissions").
